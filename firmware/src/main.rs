#![no_std]
#![no_main]

mod adc_control;
mod flash;
mod system_timer;
mod txrx_utils;

use adc_control::ADCControl;
use core::panic::PanicInfo;
use cortex_m;
use flash::Flash;
use stm32f2::stm32f215;
use system_timer::SystemTimer;
use txrx_utils::{handler_usart1, usart1_has_data, TxRx};

#[panic_handler]
fn panic(_: &PanicInfo) -> ! {
    unsafe {
        // In case of panic, the peripherals may have already been taken, and we
        // cannot take it again... But this is panic, we can do dirty things and
        // call steal to use peripherals anyway!
        // Here we just blink the red LED forever to indicate there is a
        // problem.
        let peripherals = stm32f215::Peripherals::steal();
        set_high_voltage_generator(&peripherals, false);
        set_led_green(&peripherals.GPIOC, false);
        loop {
            set_led_red(&peripherals.GPIOC, true);
            delay_ms(250);
            set_led_red(&peripherals.GPIOC, false);
            delay_ms(250);
        }
    }
}

pub extern "C" fn handler_default() {
    loop {}
}

#[link_section = ".isr_vectors.reset"]
#[no_mangle]
pub static RESET_VECTOR: unsafe extern "C" fn() -> ! = _start;

#[link_section = ".isr_vectors"]
#[no_mangle]
pub static INTERRUPT_VECTORS: [unsafe extern "C" fn(); 95] = {
    let mut v: [unsafe extern "C" fn(); 95] = [handler_default; 95];
    v[51] = handler_usart1;
    v
};

/// Toggle the red LED on or off.
/// # Arguments
/// * `gpio` - This method needs to borrow the GPIO-C.
/// * `state` - true to turn on the LED, false to turn off.
fn set_led_red(gpio: &stm32f215::GPIOC, state: bool) {
    gpio.odr.modify(|_, w| w.odr13().bit(state));
}

/// Toggle the red LED on or off.
/// # Arguments
/// * `gpio` - This method needs to borrow the GPIO-C.
/// * `state` - true to turn on the LED, false to turn off.
fn set_led_green(gpio: &stm32f215::GPIOC, state: bool) {
    gpio.odr.modify(|_, w| w.odr14().bit(state));
}

/// Enable or disable on-board 15 V regulator.
/// # Arguments
/// * `gpio` - This method needs to borrow the GPIO-B.
/// * `state` - true to turn on the regulator, false to turn off.
fn set_15v_regulator(gpio: &stm32f215::GPIOB, state: bool) {
    gpio.odr.modify(|_, w| w.odr11().bit(state));
}

/// Approximated delay function. Precise enough for what we need to do...
/// # Arguments
/// * `duration` - The number of loops to wait for delaying.
#[inline(never)]
fn delay_ms(duration: u32) {
    // Estimated duration for each loop: 7 clock cycles.
    assert!(duration <= 0xffffffff / 64000);
    let count: u32 = (duration * 64000) / 7;
    for _ in 0..count {
        cortex_m::asm::nop();
    }
}

/// Enable or disable very-high voltage generation by enabling or disabling the
/// PWM output and the on-board 15 V generator.
/// # Arguments
/// * `peripherals` - This method needs to borrow the peripherals.
/// * `state` - true to enable, false to disable.
fn set_high_voltage_generator(peripherals: &stm32f215::Peripherals, state: bool) {
    // When PWM if off, it seems the output pin is left floating. This is not
    // good because charges will accumulate on the gate of the charge pump
    // transistor, making it always conductive after a while and creating a
    // permanent shortcut. To solve this issue, we force output to zero when
    // high voltage generation if off.
    if state {
        peripherals.TIM1.bdtr.write(|w| w.moe().set_bit());
        peripherals
            .GPIOA
            .moder
            .modify(|_, w| w.moder8().alternate());
    } else {
        peripherals.GPIOA.odr.modify(|_, w| w.odr8().clear_bit());
        peripherals.GPIOA.moder.modify(|_, w| w.moder8().output());
        peripherals.TIM1.bdtr.write(|w| w.moe().clear_bit());
    }
}

/// Configure PWM parameters for high voltage generation. If the parameters are
/// invalid, this method may panic.
/// # Arguments
/// * `tim1` - This method needs to borrow the timer.
/// * `period` - Maximum counter value to the timer. Defines the period of the
///     PWM.
/// * `width` - Comparator value for the counter. Defines the PWM positive pulse
///     width.
fn set_pwm_parameters(tim1: &stm32f215::TIM1, period: u16, width: u16) -> Result<(), ()> {
    if width > period {
        return Err(());
    }
    if period == 0 {
        return Err(());
    }
    tim1.arr.write(|w| w.arr().bits(period - 1));
    tim1.ccr1().write(|w| w.ccr().bits(width));
    Ok(())
}

/// Perform software shoot.
/// # Arguments
/// * `gpio` - This method needs to borrow the GPIO-A.
/// * `duration` - Pulse duration, in number of program loop.
fn software_shoot(gpio: &stm32f215::GPIOA, duration: u16) {
    gpio.odr.modify(|_, w| w.odr13().set_bit());
    for _ in 0..duration {
        cortex_m::asm::nop();
    }
    gpio.odr.modify(|_, w| w.odr13().clear_bit());
}

/// Configure internal Flash memory interface.
/// This changes the Flash latency to be compatible with PLL settings.
/// # Arguments
/// * `flash` - This method needs to borrow the flash register
fn setup_flash(flash: &stm32f215::FLASH) {
    unsafe {
        flash.acr.modify(|_, w| w.latency().bits(2));
    }
}

/// Configure PLL
/// # Arguments
/// * `rcc` - This method needs to borrow the Reset and clock control register
fn setup_pll(rcc: &stm32f215::RCC) {
    // Disable PLL
    rcc.cr.modify(|_, w| w.pllon().clear_bit());
    // HSI = 16 MHz
    // F = ((HSI (N / M) / P
    // Constraints to be respected:
    // 50 <= N <= 432
    // 2 <= M <= 63
    // Here the target frequency is 64 MHz
    unsafe {
        rcc.pllcfgr
            .modify(|_, w| w.plln().bits(64).pllm().bits(8).pllp().div2());
    }
    // Enable PLL and wait it to be locked.
    rcc.cr.modify(|_, w| w.pllon().set_bit());
    while !rcc.cr.read().pllrdy().bit() {}
    // Switch to PLL clock
    rcc.cfgr.modify(|_, w| w.sw().pll());
}

#[no_mangle]
pub extern "C" fn _start() -> ! {
    // Get .bss segment position for .bss initialization performed in _start.
    extern "C" {
        static _bss: u32;
        static _ebss: u32;
    }
    // Clear RAM of .bss section before doing anything!
    unsafe {
        for i in ((&_bss as *const u32) as u32..(&_ebss as *const u32) as u32).step_by(4) {
            core::ptr::write_volatile(i as *mut u32, 0u32);
        }
    }

    let peripherals = stm32f215::Peripherals::take().unwrap();
    setup_flash(&peripherals.FLASH);
    let rcc = &peripherals.RCC;
    setup_pll(rcc);

    rcc.apb2enr.write(|w| w.usart1en().set_bit());
    // USART1 uses PA9 for TX and PA10 for RX.
    // LEDs are connected to PC13 and PC14.
    // Enable clock for PORT A, PORT B and PORT C peripherals.
    rcc.ahb1enr.write(|w| {
        w.gpioaen()
            .set_bit()
            .gpioben()
            .set_bit()
            .gpiocen()
            .set_bit()
    });
    peripherals
        .GPIOC
        .moder
        .modify(|_, w| w.moder13().output().moder14().output());
    set_15v_regulator(&peripherals.GPIOB, true);
    peripherals.GPIOB.moder.write(|w| w.moder11().output());

    // Configure UART1
    // UART Enable, Transmitter Enable, Receiver Enable
    let usart1 = &peripherals.USART1;
    usart1
        .cr1
        .write(|w| w.ue().set_bit().te().set_bit().re().set_bit());
    usart1.cr2.write(|w| w.stop().bits(2));
    // Baudrate is Fck/(8*(2-OVER8)*DIV)
    // Fck = 64 MHz
    // OVER8 = 0
    // DIV = BRR / 16
    // Here we set 9600 bps
    let brr_value = 6666;
    usart1.brr.write(|w| {
        w.div_mantissa()
            .bits(brr_value >> 4)
            .div_fraction()
            .bits((brr_value & 0x0f) as u8)
    });
    // Select Alternate Function 7 (USART1) for PA9 and PA10.
    let gpioa = &peripherals.GPIOA;
    gpioa.afrh.write(|w| w.afrh10().af7().afrh9().af7());
    gpioa
        .moder
        .write(|w| w.moder10().alternate().moder9().alternate());
    // Configure PA9 and PA10 GPIOs in high frequency
    gpioa
        .ospeedr
        .write(|w| w.ospeedr10().very_high_speed().ospeedr9().very_high_speed());
    // Enable interrupt for USART1
    usart1.cr1.modify(|_, w| w.rxneie().set_bit());
    unsafe {
        cortex_m::peripheral::NVIC::unmask(stm32f215::Interrupt::USART1);
    }

    // Configure SW_SHOOT signal on pin PA13.
    gpioa.ospeedr.modify(|_, w| w.ospeedr13().very_high_speed());
    gpioa.moder.modify(|_, w| w.moder13().output());

    // Give some time for the FT232 to boot-up.
    set_led_green(&peripherals.GPIOC, false);
    set_led_red(&peripherals.GPIOC, true);
    delay_ms(500);

    // System timer to track time between two controls.
    let mut sys_timer = SystemTimer::new(&peripherals.STK);

    // Variable to track last applied PWM parameters.
    let mut current_period: u16 = 800;
    let mut current_width: u16 = 5;

    // Object to perform flash operations.
    let flash = Flash {
        flash: &peripherals.FLASH,
    };

    // ADC's output Control, containing a PID.
    // The constructor reads the value from flash if it exists, otherwise
    // get generic values.
    let mut adc_ctrl = ADCControl::new();

    // Configure PWM using TIM1.
    // PWM output on PA8. Alternate Function 1.
    peripherals.RCC.apb2enr.modify(|_, w| w.tim1en().set_bit());
    let tim1 = &peripherals.TIM1;
    tim1.cr1.write(|w| w.cen().set_bit());
    set_pwm_parameters(tim1, current_period, current_width).unwrap();
    tim1.ccmr1_output().write(|w| w.oc1m().pwm_mode1());
    tim1.ccer.write(|w| w.cc1e().set_bit());
    gpioa.ospeedr.modify(|_, w| w.ospeedr8().very_high_speed());
    gpioa.afrh.modify(|_, w| w.afrh8().af1());
    gpioa.moder.modify(|_, w| w.moder8().alternate());

    // Configure ADC.
    // Input is PA0.
    peripherals.RCC.apb2enr.modify(|_, w| w.adc1en().set_bit());
    gpioa.moder.modify(|_, w| w.moder0().analog());
    let adc1 = &peripherals.ADC1;
    adc1.cr2.write(|w| w.cont().set_bit().adon().set_bit());
    adc1.cr2.modify(|_, w| w.swstart().set_bit()); // Start the conversion
    adc1.smpr2.write(|w| w.smp0().bits(7));

    let mut high_voltage_enabled = false;
    set_high_voltage_generator(&peripherals, high_voltage_enabled);

    loop {
        // ADC Control. Get current value and timestamp.
        let adc_result: u16 = adc1.dr.read().data().bits();
        let now = sys_timer.get_ticks();

        if adc_ctrl.needs_control(now) {
            current_width = adc_ctrl.next_control_output(adc_result, now);
            if current_width < current_period {
                set_pwm_parameters(tim1, current_period, current_width).unwrap();
            }
        }
        if usart1_has_data() {
            let command_byte: u8 = usart1.rx();
            match command_byte {
                0x01 => {
                    // Command to activate/deactivate the voltage generator.
                    let value: u8 = usart1.rx();
                    assert!(value <= 1);
                    high_voltage_enabled = value != 0;
                    set_high_voltage_generator(&peripherals, high_voltage_enabled);
                    usart1.tx(command_byte);
                }
                0x02 => {
                    // Command to get the raw value obtained by the ADC.
                    usart1.tx(adc_result);
                }
                0x03 => {
                    // Command to set the values of PWM (period and width).
                    current_period = usart1.rx();
                    current_width = usart1.rx();
                    usart1.tx(
                        match set_pwm_parameters(tim1, current_period, current_width) {
                            Ok(_) => command_byte,
                            Err(_) => !command_byte,
                        },
                    );
                }
                0x04 => {
                    // Command to perform a software shoot.
                    let duration: u16 = usart1.rx();
                    software_shoot(&peripherals.GPIOA, duration);
                    usart1.tx(command_byte);
                }
                0x05 => {
                    // Command to get the current time from SystemTimer.
                    usart1.tx(sys_timer.get_ticks());
                }
                0x06 => {
                    // Command to get the ADC Control set point.
                    usart1.tx(adc_ctrl.setpoint());
                }
                0x07 => {
                    // Command to set the ADC Control set point
                    // Force to use 800 as PWM period.
                    current_period = 800;
                    adc_ctrl.set_setpoint(usart1.rx());
                }
                0x08 => {
                    // Command to get the values of PWM (period and width).
                    usart1.tx(current_period);
                    usart1.tx(current_width);
                }
                0x0A => {
                    // Command to retrieve the values of the
                    // Kp, Ki, Kd coefficients of the ADC Control
                    // Optionally restore those values from Flash.
                    let read_from_flash: bool = usart1.rx();
                    if read_from_flash {
                        adc_ctrl.read_from_flash();
                    }
                    usart1.tx(adc_ctrl.pid.kp);
                    usart1.tx(adc_ctrl.pid.ki);
                    usart1.tx(adc_ctrl.pid.kd);
                    usart1.tx(adc_ctrl.control_ticks);
                }
                0x0B => {
                    // Command to set the values of the
                    // Kp, Ki, Kd coefficients of the ADC Control
                    // Optionally store those values in Flash.
                    let store_in_flash: bool = usart1.rx();
                    adc_ctrl.pid.kp = usart1.rx();
                    adc_ctrl.pid.ki = usart1.rx();
                    adc_ctrl.pid.kd = usart1.rx();
                    adc_ctrl.control_ticks = usart1.rx();
                    if store_in_flash {
                        adc_ctrl.store_in_flash(&flash);
                    }
                }
                0x0C => {
                    // Command to set more values of the configuration of the ADC Control
                    adc_ctrl.pid.p_limit = usart1.rx();
                    adc_ctrl.pid.i_limit = usart1.rx();
                    adc_ctrl.pid.d_limit = usart1.rx();
                    adc_ctrl.pid.output_limit = usart1.rx();
                }
                0x0D => {
                    // Command to retrieve more values of the configuration of the ADC Control
                    usart1.tx(adc_ctrl.pid.p_limit);
                    usart1.tx(adc_ctrl.pid.i_limit);
                    usart1.tx(adc_ctrl.pid.d_limit);
                    usart1.tx(adc_ctrl.pid.output_limit);
                    usart1.tx(adc_ctrl.pid.setpoint);
                    usart1.tx(adc_ctrl.last_control);
                }
                _ => {
                    // Unknown command. Panic!
                    panic!();
                }
            }
        }
        let danger: bool = (adc_result >= 67) || high_voltage_enabled;
        set_led_red(&peripherals.GPIOC, danger);
        set_led_green(&peripherals.GPIOC, !danger);
    }
}
