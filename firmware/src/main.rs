#![no_std]
#![no_main]

use core::panic::PanicInfo;
use stm32f2::stm32f215;

#[panic_handler]
fn panic(_: &PanicInfo) -> ! {
    unsafe {
        // In case of panic, the peripherals may have already been taken, and we
        // cannot take it again... But this is panic, we can do dirty things and
        // call steal to use peripherals anyway!
        // Here we just blink the red LED forever to indicate there is a
        // problem.
        let peripherals = stm32f215::Peripherals::steal();
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

pub extern "C" fn default_handler() {
    loop {}; 
}

#[link_section=".isr_vectors.reset"]
#[no_mangle]
pub static reset_vector: unsafe extern "C" fn() -> ! = _start;

#[link_section=".isr_vectors"]
#[no_mangle]
pub static interrupt_vectors: [unsafe extern "C" fn(); 79] = [default_handler; 79];

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
    // Enable clock for PORT A and PORT C peripherals.
    peripherals.RCC.ahb1enr.write(
        |w| { w.gpioaen().set_bit().gpiocen().set_bit() } );
    peripherals.GPIOC.moder.write(|w| { w.moder13().bits(1).moder14().bits(1) });

    // Configure UART1
    // UART Enable, Transmitter Enable, Receiver Enable
    peripherals.USART1.cr1.write(
        |w| { w.ue().set_bit().te().set_bit().re().set_bit() });
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
    peripherals.GPIOA.afrh.write(|w| { w.afrh10().bits(7).afrh9().bits(7) } );
    peripherals.GPIOA.moder.write(
        |w| { w.moder10().bits(2).moder9().bits(2) } );
    // Configure PA9 and PA10 GPIOs in high frequency
    peripherals.GPIOA.ospeedr.write(
        |w| { w.ospeedr10().bits(3).ospeedr9().bits(3) });

    set_led_green(&peripherals, true);

    loop {
        unsafe { peripherals.USART1.dr.write(|w| { w.bits('b' as u32) }); }
        //USART.tx_str("Hello world!\nI'm a Rustacean!\n");
    }
}
