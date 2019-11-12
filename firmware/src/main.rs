#![no_std]
#![no_main]

use core::panic::PanicInfo;
use stm32f2::stm32f215;
use cortex_m;
use heapless;

static mut USART1_QUEUE: heapless::spsc::Queue<u8, heapless::consts::U128> =
    heapless::spsc::Queue(heapless::i::Queue::new());

#[panic_handler]
fn panic(_: &PanicInfo) -> ! {
    unsafe {
        // In case of panic, the peripherals may have already been taken, and we
        // cannot take it again... But this is panic, we can do dirty things and
        // call steal to use peripherals anyway!
        // Here we just blink the red LED forever to indicate there is a
        // problem.
        let peripherals = stm32f215::Peripherals::steal();
        set_led_green(&peripherals, false);
        loop {
            for _ in 0..50000 {
                set_led_red(&peripherals, true);
            }
            for _ in 0..50000 {
                set_led_red(&peripherals, false);
            }
        }
    }
}

pub extern "C" fn handler_default() {
    loop {};
}

/// USART interrupt handler. Called in case of data byte reception or overrun.
/// When a byte is received, it is pushed in the USART queue. If the queue is
/// full, the program will panic.
pub extern "C" fn handler_usart1() {
    unsafe {
        let mut producer = USART1_QUEUE.split().0;
        let peripherals = stm32f215::Peripherals::steal();
        if peripherals.USART1.sr.read().rxne().bit() {
            // If queue is full, panic!
            producer.enqueue(peripherals.USART1.dr.read().bits() as u8).unwrap();
        } else {
            // This is probably an overrun error.
            panic!();
        }
    }
}

#[link_section=".isr_vectors.reset"]
#[no_mangle]
pub static reset_vector: unsafe extern "C" fn() -> ! = _start;

#[link_section=".isr_vectors"]
#[no_mangle]
pub static interrupt_vectors: [unsafe extern "C" fn(); 95] = {
    let mut v: [unsafe extern "C" fn(); 95] = [handler_default; 95];
    v[51] = handler_usart1;
    v
};

/// Toggle the red LED on or off.
/// `peripherals` - This method needs to borrow the peripherals.
/// `state` - true to turn on the LED, false to turn off.
fn set_led_red(peripherals: &stm32f215::Peripherals, state: bool) {
    peripherals.GPIOC.odr.modify(|_, w| { w.odr13().bit(state) });
}

/// Toggle the red LED on or off.
/// `peripherals` - This method needs to borrow the peripherals.
/// `state` - true to turn on the LED, false to turn off.
fn set_led_green(peripherals: &stm32f215::Peripherals, state: bool) {
    peripherals.GPIOC.odr.modify(|_, w| { w.odr14().bit(state) });
}

/// Enable or disable on-board 15 V regulator.
/// `peripherals` - This method needs to borrow the peripherals.
/// `state` - true to turn on the regulator, false to turn off.
fn set_15v_regulator(peripherals: &stm32f215::Peripherals, state: bool) {
    peripherals.GPIOB.odr.modify(|_, w| { w.odr11().bit(state) });
}

/// Approximated delay function. Precise enought for what we need to do...
#[inline(never)]
fn delay_ms(duration: u32) {
    // Estimated duration for each loop: 7 clock cycles.
    let count: u32 = (duration * 16000) / 7;
    for _ in 0..count {
        cortex_m::asm::nop();
    }
}

/// Receives a byte from USART1. Blocks until data is available.
fn usart1_rx() -> u8 {
    unsafe {
        let mut producer = USART1_QUEUE.split().1;
        loop {
            match producer.dequeue() {
                Some(byte) => { return byte; }
                None => {}
            }
        }
    }
}

/// Transmits a byte over USART1.
/// `peripherals` - This method needs to borrow the peripherals.
/// `value` - Byte to be transmitted.
fn usart1_tx(peripherals: &stm32f215::Peripherals, value: u8) {
    peripherals.USART1.dr.write(|w| { w.dr().bits(value as u16) });
}

#[no_mangle]
pub extern "C" fn _start() -> ! {
    // Get .bss segment position for .bss initialization performed in _start.
    extern {
        static _bss: u32;
        static _ebss: u32;
    }
    // Clear RAM of .bss section before doing anything!
    unsafe {
        for i in ((&_bss as *const u32) as u32 .. (&_ebss as *const u32) as u32)
            .step_by(4) {
            core::ptr::write_volatile(i as *mut u32, 0u32);
        }
    }

    let peripherals = stm32f215::Peripherals::take().unwrap();

    peripherals.RCC.apb2enr.write(|w| { w.usart1en().set_bit() });
    // USART1 uses PA9 for TX and PA10 for RX.
    // LEDs are connected to PC13 and PC14.
    // Enable clock for PORT A, PORT B and PORT C peripherals.
    peripherals.RCC.ahb1enr.write(
        |w| { w.gpioaen().set_bit().gpioben().set_bit().gpiocen().set_bit() } );
    peripherals.GPIOC.moder.write(|w| { w.moder13().bits(1).moder14().bits(1) });
    set_15v_regulator(&peripherals, false);
    peripherals.GPIOB.moder.write(|w| { w.moder11().bits(1) });

    // Configure UART1
    // UART Enable, Transmitter Enable, Receiver Enable
    peripherals.USART1.cr1.write(
        |w| { w.ue().set_bit().te().set_bit().re().set_bit() });
    peripherals.USART1.cr2.write(|w|{ w.stop().bits(2) });
    // Baudrate is Fck/(8*(2-OVER8)*DIV)
    // Fck = 16 MHz (High Speed Internal oscillator)
    // OVER8 = 0
    // DIV = BRR / 16
    // Here we set 9600 bps
    let brr_value = 1666;
    peripherals.USART1.brr.write(
        |w| { w.div_mantissa().bits(brr_value >> 4)
        .div_fraction().bits((brr_value & 0x0f) as u8) });
    // Select Alternate Function 7 (USART1) for PA9 and PA10.
    let gpioa = &peripherals.GPIOA;
    gpioa.afrh.write(|w| { w.afrh10().af7().afrh9().af7() });
    gpioa.moder.write(|w| { w.moder10().bits(2).moder9().bits(2) });
    // Configure PA9 and PA10 GPIOs in high frequency
    gpioa.ospeedr.write(|w| { w.ospeedr10().bits(3).ospeedr9().bits(3) });
    // Enable interrupt for USART1
    peripherals.USART1.cr1.modify(|_, w| { w.rxneie().set_bit() });
    unsafe {
        cortex_m::peripheral::NVIC::unmask(stm32f215::Interrupt::USART1);
    }

    // Configure PWM using TIM1.
    // PWM output on PA8. Alternate Function 1.
    peripherals.RCC.apb2enr.modify(|_, w| { w.tim1en().set_bit() });
    let tim1 = &peripherals.TIM1;
    tim1.cr1.write(|w| { w.cen().set_bit() });
    tim1.arr.write(|w| { w.arr().bits(100) });
    tim1.ccr1.write(|w| { w.ccr().bits(50) });
    tim1.ccmr1_output().write(|w| { w.oc1m().bits(7) });
    tim1.ccer.write(|w| { w.cc1e().set_bit() });
    tim1.bdtr.write(|w| { w.moe().set_bit() });
    gpioa.ospeedr.modify(|_, w| { w.ospeedr8().bits(3) });
    gpioa.afrh.modify(|_, w| { w.afrh8().af1() });
    gpioa.moder.modify(|_, w| { w.moder8().bits(2) });

    // Give some time for the FT232 to boot-up.
    delay_ms(500);
    set_led_green(&peripherals, true);

    loop
    {
        let command_byte = usart1_rx();
        match command_byte {
            0x01 => {
                let value = usart1_rx();
                assert!(value <= 1);
                set_15v_regulator(&peripherals, value != 0);
                usart1_tx(&peripherals, command_byte);
            }
            _ => {
                // Unknown command. Panic!
                panic!();
            }
        }
    }
}
