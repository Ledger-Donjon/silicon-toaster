use crate::Flash;
use crate::SystemTimer;
use pid::Pid;

pub struct ADCControl {
    pub enabled: bool,
    // Time interval between two controls (in ticks: 1 second corresponds to 8047640 ticks).
    pub control_ticks: u64,
    pub last_control: u64,
    pub pid: Pid<f32>,
}

impl ADCControl {
    pub fn new() -> ADCControl {
        let mut adc = ADCControl {
            enabled: true,
            control_ticks: SystemTimer::FREQ / 1000, // ~1milliseconds
            last_control: 0,
            pid: Pid::new(100.0, 0.0, 0.0, 200.0, 200.0, 200.0, 200.0, 0.0),
        };
        adc.read_from_flash();
        adc
    }

    pub fn next_control_output(&mut self, adc_result: u16, ticks: u64) -> u16 {
        // Updates the last control time and requests for next control value from PID
        self.last_control = ticks;
        // The PID object will give a value between -output_limit and output_limit
        return (self.pid.next_control_output(adc_result as f32).output + self.pid.output_limit)
            as u16;
    }

    pub fn needs_control(&self, ticks: u64) -> bool {
        // The control must be enabled and
        // the last control has been executed long time enough
        self.enabled && (ticks.abs_diff(self.last_control) > self.control_ticks)
    }

    // Getter for setpoint for the Controller.
    pub fn setpoint(&self) -> u16 {
        self.pid.setpoint as u16
    }

    // Setter for setpoint for the Controller.
    pub fn set_setpoint(&mut self, setpoint: u16) {
        self.pid.setpoint = setpoint as f32;
        self.pid.reset_integral_term();
    }

    // Magic value in flash to indicate that it contains data.
    const IS_SET: u32 = 0x444E4A4E;
    // The sector where the data will be serialized.
    const FLASH_SECTOR: u8 = 3;

    pub fn read_from_flash(&mut self) {
        let address: *const u32 = Flash::base_address_for_sector(Self::FLASH_SECTOR);
        unsafe {
            if address.read() != Self::IS_SET {
                // The memory does not contain the expected data.
                return;
            }
            self.pid.kp = f32::from_bits(address.offset(1).read());
            self.pid.ki = f32::from_bits(address.offset(2).read());
            self.pid.kd = f32::from_bits(address.offset(3).read());
            let h = address.offset(4).read() as u64;
            let l = address.offset(5).read() as u64;
            self.control_ticks = (h << 32) + l;
        }
    }

    pub fn store_in_flash(&self, flash: &Flash) {
        flash.flash_erase_sector(Self::FLASH_SECTOR);
        let base: *mut u32 = Flash::base_address_for_sector(Self::FLASH_SECTOR);
        let values = [
            Self::IS_SET, // Marker to indicate that flash contains data.
            self.pid.kp.to_bits(),
            self.pid.ki.to_bits(),
            self.pid.kd.to_bits(),
            (self.control_ticks >> 32) as u32,
            (self.control_ticks & 0xffffffff) as u32,
        ];
        flash.flash_program(base, values.as_ptr(), values.len() as isize);
    }
}
