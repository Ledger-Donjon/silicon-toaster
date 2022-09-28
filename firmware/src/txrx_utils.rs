use stm32f2::stm32f215::{Peripherals, USART1};

// USART1 Queue
static mut USART1_QUEUE: heapless::spsc::Queue<u8, heapless::consts::U128> =
    heapless::spsc::Queue(heapless::i::Queue::new());

// Trait for transmitting and receiving data.
pub trait TxRx<T> {
    fn rx(&self) -> T;
    fn tx(&self, value: T);
}

// u8 data transmission via USART1 implementation
impl TxRx<u8> for USART1 {
    // Receives a byte from USART1. Blocks until data is available.
    fn rx(&self) -> u8 {
        unsafe {
            let mut producer = USART1_QUEUE.split().1;
            loop {
                match producer.dequeue() {
                    Some(byte) => {
                        return byte;
                    }
                    None => {}
                }
            }
        }
    }
    /// Transmit a byte over USART1.
    /// `value` - Byte to be transmitted.
    fn tx(&self, value: u8) {
        self.dr.write(|w| w.dr().bits(value as u16));
        // Wait until byte is transferred into the shift-register.
        while !self.sr.read().txe().bit() {}
    }
}

// bool data transmission via USART1 implementation
impl TxRx<bool> for USART1 {
    // Receive a byte and interpret it as a boolean
    fn rx(&self) -> bool {
        let h: u8 = self.rx();
        h != 0
    }
    // Transmit a byte over USART1.
    /// `value` - Boolean to be transmitted.
    fn tx(&self, value: bool) {
        self.tx(if value { 1u8 } else { 0u8 });
    }
}

// u16 data transmission via USART1 implementation
impl TxRx<u16> for USART1 {
    /// Receive a 16-bits unsigned int from USART1. Blocks until all data is
    /// available.
    fn rx(&self) -> u16 {
        let h: u8 = self.rx();
        let l: u8 = self.rx();
        ((h as u16) << 8) + l as u16
    }
    /// Transmit a 16-bits word over USART1.
    /// `value` - Half Word to be transmitted.
    fn tx(&self, value: u16) {
        self.tx((value >> 8) as u8);
        self.tx((value & 0xff) as u8);
    }
}

// u32 data transmission via USART1 implementation
impl TxRx<u32> for USART1 {
    /// Receive a 32-bits unsigned int from USART1. Blocks until all data is
    /// available.
    fn rx(&self) -> u32 {
        let h: u16 = self.rx();
        let l: u16 = self.rx();
        ((h as u32) << 16) + l as u32
    }
    /// Transmit a 32-bits word over USART1.
    /// `value` - Word to be transmitted.
    fn tx(&self, value: u32) {
        self.tx(((value >> 16) & 0xffff) as u16);
        self.tx(((value >> 0) & 0xffff) as u16);
    }
}

// u64 data transmission via USART1 implementation
impl TxRx<u64> for USART1 {
    /// Receive a 64-bits unsigned int from USART1. Blocks until all data is
    /// available.
    fn rx(&self) -> u64 {
        let h: u32 = self.rx();
        let l: u32 = self.rx();
        (h as u64) << 32 + l as u64
    }
    /// Transmit a 64-bits word from USART1.
    /// `value` - Double Word to be transmitted.
    fn tx(&self, value: u64) {
        self.tx(((value >> 32) & 0xffffffff) as u32);
        self.tx(((value >> 0) & 0xffffffff) as u32);
    }
}

// f32 data transmission via USART1 implementation
impl TxRx<f32> for USART1 {
    /// Receive a 32-bits float over USART1. Blocks until all data is
    /// available.
    fn rx(&self) -> f32 {
        let h: u32 = self.rx();
        f32::from_bits(h)
    }
    /// Transmit a 32-bits float over USART1.
    /// `value` - Float to be transmitted.
    fn tx(&self, value: f32) {
        self.tx(value.to_bits());
    }
}

// f64 data transmission via USART1 implementation
impl TxRx<f64> for USART1 {
    /// Receive a 64-bits float over USART1. Blocks until all data is
    /// available.
    fn rx(&self) -> f64 {
        let h: u64 = self.rx();
        f64::from_bits(h)
    }
    /// Transmit a 32-bits float over USART1.
    /// `value` - Float to be transmitted.
    fn tx(&self, value: f64) {
        self.tx(value.to_bits());
    }
}

/// Return true if USART1 has data.
pub fn usart1_has_data() -> bool {
    unsafe { !USART1_QUEUE.is_empty() }
}

/// USART interrupt handler. Called in case of data byte reception or overrun.
/// When a byte is received, it is pushed in the USART queue. If the queue is
/// full, the program will panic.
pub extern "C" fn handler_usart1() {
    unsafe {
        let mut producer = USART1_QUEUE.split().0;
        let peripherals = Peripherals::steal();
        if peripherals.USART1.sr.read().rxne().bit() {
            // If queue is full, panic!
            producer
                .enqueue(peripherals.USART1.dr.read().bits() as u8)
                .unwrap();
        } else {
            // This is probably an overrun error.
            panic!();
        }
    }
}
