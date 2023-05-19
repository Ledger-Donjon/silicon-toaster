//! This module is used to manage the STM32F2 SysTick to get a system tick counter.

use stm32f2::stm32f215;

pub struct SystemTimer<'a> {
    stk: &'a stm32f215::STK,
    reload_counts: u32,
}

impl<'a> SystemTimer<'a> {
    pub const FREQ: u64 = 8047640;

    pub fn new(stk: &'a stm32f215::STK) -> SystemTimer {
        let sys_timer = SystemTimer {
            stk,
            reload_counts: 0,
        };
        unsafe {
            // Initialize the Reload Value Register to the max.
            stk.load_.write(|w| w.bits(0x00FF_FFFF));
            // Enable the timer, by setting the ENABLE bit (bit 0) in Control and Status register
            stk.ctrl.modify(|_, w| w.enable().set_bit());
        };
        sys_timer
    }

    // This function must be called regularly to count the reloads operation
    // by evaluating the COUNTFLAG bit of Control and Status Register.
    fn check_reloads(&mut self) {
        // The Control and Status Register's COUNTFLAG (bit 16)
        // Returns 1 if timer counted to 0 since last time this was read.
        // Meaning that a reload has been done in the Current Value Register.
        if self.stk.ctrl.read().countflag().bit() {
            self.reload_counts += 1;
        }
    }

    pub fn get_ticks(&mut self) -> u64 {
        // Get the time as number of ticks, considering the counts of the reloads.
        self.check_reloads();
        let reload = self.stk.load_.read().reload().bits() as u64;
        let remained_ticks = reload - (self.stk.val.read().bits() as u64);
        remained_ticks + reload * (self.reload_counts as u64)
    }
}
