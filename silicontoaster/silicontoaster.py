#!/usr/bin/python3

from typing import Optional
import serial
import serial.tools.list_ports


class SiliconToaster:
    def __init__(self, dev = None, sn = None):
        if dev is not None and sn is not None:
            raise ValueError("dev and sn cannot be set together")

        if dev is None:
            # Try to find automatically the device
            possible_ports = []
            for port in serial.tools.list_ports.comports():
                # USB description string can be 'Scaffold', with uppercase 'S'.
                if (port.product is not None) and ((sn is None) or (port.serial_number == sn)):
                    possible_ports.append(port)
            if len(possible_ports) > 1:
                raise RuntimeError("Multiple Silicon Toaster devices found! I don't know which one to use.")
            elif len(possible_ports) == 1:
                dev = possible_ports[0].device
            else:
                raise RuntimeError("No Silicon Toaster device found")

        self.ser = serial.Serial(dev, 9600)
        self.calibration = [
            -4.02294398e-11,
            1.53492378e-07,
            -2.71166328e-04,
            7.66927146e-01,
            -1.12729564e+00
        ]
        self._software_limit = None

    def read_voltage_raw(self):
        """
        Retrieve raw ADC voltage measurement from the device.
        :return: ADC measurement.
        :rtype: int
        """
        self.ser.write(b'\x02')
        return int.from_bytes(self.ser.read(2), 'big')

    def read_voltage(self) -> float:
        """
        Retrieve voltage measurement from the device.
        :return: Voltage measurement.
        :rtype: float
        """
        raw = self.read_voltage_raw()
        v = 0
        for i, c in enumerate(self.calibration):
            v += c * raw ** (len(self.calibration) - i - 1)
        # Checks the software limitation
        if self._software_limit is not None and v > self._software_limit:
            self.off()
            raise RuntimeWarning(f"VOLTAGE IS TOO HIGH {v}V > {self._software_limit}V. Turning off.")
        return v

    def on(self):
        """
        Turn on high-voltage generation.
        """
        self.ser.write(b'\x01\x01')
        assert self.ser.read(1) == b'\x01'

    def off(self):
        """
        Turn off high-voltage generation.
        """
        self.ser.write(b'\x01\x00')
        assert self.ser.read(1) == b'\x01'

    def set_pwm_settings(self, period: int, width: int):
        """
        Reconfigure PWM settings.
        :param period: Timer max counter value for PWM generation. Defines the
            period.
        :param width: Timer comparator value for PWM generation. Defines the
            pulse width.
        """
        if period < 1:
            raise ValueError('Invalid PWM period')
        if (width < 0) or (width > period):
            raise ValueError('Invalid PWM width')
        command = bytearray(b'\x03')
        command += period.to_bytes(2, 'big')
        command += width.to_bytes(2, 'big')
        self.ser.write(command)
        assert self.ser.read(1) == b'\x03'

    def software_shoot(self, duration: int):
        """
        Generate a pulse with the device to discharge de capacitors.
        """
        assert duration in range(0x10000)
        command = bytearray(b'\x04')
        command += duration.to_bytes(2, 'big')
        self.ser.write(command)
        assert self.ser.read(1) == b'\x04'

    @property
    def software_limit(self) -> Optional[float]:
        return self._software_limit

    @software_limit.setter
    def software_limit(self, value: Optional[float]):
        self._software_limit = value

    def __del__(self):
        self.off()
