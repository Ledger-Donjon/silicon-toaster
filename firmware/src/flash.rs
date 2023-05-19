//! This module is used to manage the STM32F2 Flash for permanent storage of configuration.
//! It is based on [`Flash programming manual`]
//!
//!
//! [`Flash programming manual`]: https://www.st.com/resource/en/programming_manual/pm0059-stm32f205215-stm32f207217-flash-programming-manual-stmicroelectronics.pdf

use stm32f2::stm32f215;

pub trait PSIZE {
    fn psize(&self) -> u8 {
        panic!()
    }
}
impl PSIZE for u8 {
    fn psize(&self) -> u8 {
        Flash::PSIZE_8
    }
}
impl PSIZE for u16 {
    fn psize(&self) -> u8 {
        Flash::PSIZE_16
    }
}
impl PSIZE for u32 {
    fn psize(&self) -> u8 {
        Flash::PSIZE_32
    }
}
impl PSIZE for u64 {
    fn psize(&self) -> u8 {
        Flash::PSIZE_64
    }
}

pub struct Flash<'a> {
    pub flash: &'a stm32f215::FLASH,
}
impl<'a> Flash<'a> {
    pub fn flash_lock(&self) {
        self.flash.cr.write(|w| w.lock().set_bit());
    }
    pub fn flash_unlock(&self) {
        if self.flash.cr.read().lock().bit_is_set() {
            unsafe {
                self.flash.keyr.write(|w| w.bits(0x45670123));
                self.flash.keyr.write(|w| w.bits(0xCDEF89AB));
            }
        }
        assert!(self.flash.cr.read().lock().bit_is_clear());
    }
    pub fn wait_for_last_operation(&self) {
        /* Wait for the FLASH operation to complete by polling on BUSY flag to be reset.
        Even if the FLASH operation fails, the BUSY flag will be reset and an error
        flag will be set */
        while self.flash.sr.read().bsy().bit_is_set() {}
    }

    pub fn flash_erase_sector(&self, sector: u8) {
        assert!(sector < 12);
        // Unlock the flash.
        self.flash_unlock();
        // 1, Check that no Flash operation is ongoing
        self.wait_for_last_operation();
        unsafe {
            // 2. Set the SER bit and select the sector (out of the 12 sectors in the main memory block)
            // you wish to erase (SNB) in the FLASH_CR register
            self.flash.cr.modify(|_, w| w.ser().set_bit());
            self.flash.cr.modify(|_, w| w.snb().bits(sector));
            // 3.Set the STRT bit in the FLASH_CR register
            self.flash.cr.modify(|_, w| w.strt().set_bit());
        }
        // 4.Wait for the BSY bit to be cleared
        self.wait_for_last_operation();
        // Lock the flash
        self.flash_lock();
    }

    pub fn base_address_for_sector<T>(sector: u8) -> *mut T {
        (match sector {
            0..=3 => 0x08000000 + 0x4000 * sector as u32,
            4 => 0x08010000,
            5..=11 => 0x08020000 + 0x20000 * (sector - 5) as u32,
            _ => panic!(),
        }) as *mut T
    }
    pub fn is_flash_address<T>(paddress: *const T) -> bool {
        // IS_FLASH_ADDRESS(ADDRESS) ((((ADDRESS) >= FLASH_BASE) && ((ADDRESS) <= FLASH_END)) || \
        //                                    (((ADDRESS) >= FLASH_OTP_BASE) && ((ADDRESS) <= FLASH_OTP_END)))
        // FLASH_BASE            0x08000000UL
        // FLASH_END             0x080FFFFFUL
        // FLASH_OTP_BASE        0x1FFF7800UL
        // FLASH_OTP_END         0x1FFF7A0FUL
        let address = paddress as u32;
        (0x08000000u32..=0x080FFFFF).contains(&address)
            | (0x1FFF7800..=0x1FFF7A0F).contains(&address)
    }

    const PSIZE_8: u8 = 0b00;
    const PSIZE_16: u8 = 0b01;
    const PSIZE_32: u8 = 0b10;
    const PSIZE_64: u8 = 0b11;

    pub fn flash_program<T: PSIZE>(&self, address: *mut T, data: *const T, count: isize) {
        // Unlock the flash.
        self.flash_unlock();
        // 1. Check that no main Flash memory operation is ongoing by checking the BSY bit in the
        // FLASH_SR register.
        self.wait_for_last_operation();
        unsafe {
            // 2. Set the PSIZE field and PG bit in the FLASH_CR register
            self.flash.cr.modify(|_, w| w.psize().bits((*data).psize()));
            self.flash.cr.modify(|_, w| w.pg().set_bit());

            // 3. Perform the data write operation(s) to the desired memory address
            // (inside main memory block or OTP area)
            for i in 0..count {
                let address_cur = address.offset(i);
                assert!(Self::is_flash_address(address_cur));
                *address_cur = data.offset(i).read();

                // 4. Wait for the BSY bit to be cleared
                self.wait_for_last_operation();
            }

            // When the program operation is completed, disable the PG Bit
            self.flash.cr.modify(|_, w| w.pg().clear_bit());
        }
        // Lock the flash.
        self.flash_lock();
    }
}
