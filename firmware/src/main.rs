#![no_std]
#![no_main]

use core::panic::PanicInfo;
use stm32f2::stm32f215;

#[panic_handler]
fn panic(_: &PanicInfo) -> ! {
    loop {}
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

const RCC_AHB1ENR: u32 = 0x40023830;
const GPIOC_BASE: u32 = 0x40020800;
const GPIOC_MODER: u32 = GPIOC_BASE + 0x00;
const GPIOC_OSPEEDR: u32 = GPIOC_BASE + 0x08;
const GPIOC_ODR: u32 = GPIOC_BASE + 0x14;


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
    /*unsafe {
        peripherals.RCC.ahb1enr.write(|w| { w.bits(1 << 2) });
        peripherals.GPIOC.moder.write(|w| { w.bits(1 << 26) });
        peripherals.GPIOC.ospeedr.write(|w| { w.bits(3 << 26) });
        loop {
            for i in 0..200000 {
                peripherals.GPIOC.odr.write(|w| { w.bits(0) });
            }
            for i in 0..200000 {
                peripherals.GPIOC.odr.write(|w| { w.bits(1 << 13) });
            }
        }
    }*/

    peripherals.RCC.apb2enr.write(|w| { w.usart1en().set_bit() });
    // USART1 uses PA9 for TX and PA10 for RX.
    // LEDs are connected to PC13 and PC14.
    // Enable clock for PORT A and PORT C peripherals.
    peripherals.RCC.ahb1enr.write(
        |w| { w.gpioaen().set_bit().gpiocen().set_bit() } );

    peripherals.GPIOC.moder.write(|w| { w.moder13().bits(1).moder14().bits(1) });
    peripherals.GPIOC.odr.write(|w| { w.odr13().set_bit().odr14().set_bit() });

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

    loop {
        unsafe { peripherals.USART1.dr.write(|w| { w.bits('b' as u32) }); }
        //USART.tx_str("Hello world!\nI'm a Rustacean!\n");
    }
}
