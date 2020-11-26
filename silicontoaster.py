#!/usr/bin/python3

import serial
import math


class SiliconToaster:
    def __init__(self, dev):
        self.ser = serial.Serial(dev, 9600)
        self.calibration = [
            -4.02294398e-11,
            1.53492378e-07,
            -2.71166328e-04,
            7.66927146e-01,
            -1.12729564e+00
        ]

    def read_voltage_raw(self):
        """
        Retrieve raw ADC voltage measurement from the device.
        :return: ADC measurement.
        :rtype: int
        """
        self.ser.write(b'\x02')
        return int.from_bytes(self.ser.read(2), 'big')

    def read_voltage(self):
        """
        Retrieve voltage measurement from the device.
        :return: Voltage measurement.
        :rtype: float
        """
        raw = self.read_voltage_raw()
        v = 0
        for i, c in enumerate(self.calibration):
            v += c * raw ** (len(self.calibration) - i - 1)
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
