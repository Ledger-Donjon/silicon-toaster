#!/usr/bin/python3
import struct
from typing import Optional, Union
import serial
import serial.tools.list_ports
import os
import numpy
from scipy.interpolate import LinearNDInterpolator


class SiliconToaster:
    def __init__(self, dev=None, sn=None):
        if dev is not None and sn is not None:
            raise ValueError("dev and sn cannot be set together")

        if dev is None:
            # Try to find automatically the device
            possible_ports = []
            for port in serial.tools.list_ports.comports():
                # USB description string can be 'Scaffold', with uppercase 'S'.
                if (port.product is not None) and (
                    (sn is None) or (port.serial_number == sn)
                ):
                    possible_ports.append(port)
            if len(possible_ports) > 1:
                raise RuntimeError(
                    "Multiple Silicon Toaster devices found! I don't know which one to use."
                )
            elif len(possible_ports) == 1:
                dev = possible_ports[0].device
            else:
                raise RuntimeError("No Silicon Toaster device found")

        self.ser = serial.Serial(dev, 9600)
        self.calibration_raw_to_v = [
            -4.02294398e-11,
            1.53492378e-07,
            -2.71166328e-04,
            7.66927146e-01,
            -1.12729564e00,
        ]
        self.calibration_v_to_raw = [
            5.59972560e-10,
            -1.02408301e-06,
            1.06453179e-03,
            1.24457162e00,
            2.57379247e00,
        ]
        self._software_limit = None
        self.get_voltage_mapping()

    @staticmethod
    def convert(value: Union[float, int], calibration: list[float]) -> float:
        """Converts a value to another according to the calibration coefficients"""
        v = 0.0
        value = float(value)
        for i, c in enumerate(calibration):
            v += c * value ** (len(calibration) - i - 1)
        return v

    def to_raw(self, value: float) -> int:
        return int(round(self.convert(value, self.calibration_v_to_raw)))

    def to_volt(self, value: int) -> float:
        return self.convert(value, self.calibration_raw_to_v)

    def read_voltage_raw(self) -> int:
        """
        Retrieve raw ADC voltage measurement from the device.
        :return: ADC measurement.
        :rtype: int
        """
        self.ser.write(b"\x02")
        return int.from_bytes(self.ser.read(2), "big", signed=False)

    def read_voltage(self) -> float:
        """
        Retrieve voltage measurement from the device.
        :return: Voltage measurement.
        :rtype: float
        """
        raw = self.read_voltage_raw()
        v = self.to_volt(raw)
        # Checks the software limitation
        if self._software_limit is not None and v > self._software_limit:
            self.off()
            raise RuntimeWarning(
                f"VOLTAGE IS TOO HIGH {v}V > {self._software_limit}V. Turning off."
            )
        return v

    def on(self):
        """
        Turn on high-voltage generation.
        """
        self.ser.write(b"\x01\x01")
        assert self.ser.read(1) == b"\x01"

    def off(self):
        """
        Turn off high-voltage generation.
        """
        self.ser.write(b"\x01\x00")
        assert self.ser.read(1) == b"\x01"

    def set_pwm_settings(self, period: int, width: int):
        """
        Reconfigure PWM settings.
        :param period: Timer max counter value for PWM generation. Defines the
            period.
        :param width: Timer comparator value for PWM generation. Defines the
            pulse width.
        """
        if period < 1:
            raise ValueError("Invalid PWM period")
        if (width < 0) or (width > period):
            raise ValueError("Invalid PWM width")
        command = bytearray(b"\x03")
        command += period.to_bytes(2, "big", signed=False)
        command += width.to_bytes(2, "big", signed=False)
        self.ser.write(command)
        assert self.ser.read(1) == b"\x03"

    def get_pwm_settings(self) -> tuple[int, int]:
        """
        Retrieve the last values set for PWM.
        :return: A tuple containing the period and the width.
        """
        self.ser.write(b"\x08")
        period = int.from_bytes(self.ser.read(2), "big", signed=False)
        width = int.from_bytes(self.ser.read(2), "big", signed=False)
        return period, width

    def software_shoot(self, duration: int):
        """
        Generate a pulse with the device to discharge de capacitors.
        """
        assert duration in range(0x10000)
        command = bytearray(b"\x04")
        command += duration.to_bytes(2, "big", signed=False)
        self.ser.write(command)
        assert self.ser.read(1) == b"\x04"

    @property
    def software_limit(self) -> Optional[float]:
        return self._software_limit

    @software_limit.setter
    def software_limit(self, value: Optional[float]):
        self._software_limit = value

    def get_voltage_mapping(self):
        file_dir = os.path.dirname(os.path.realpath(__file__))
        try:
            f = open(os.path.join(file_dir, "calibration_voltage.log"))
        except OSError:
            file_dir = os.path.dirname(file_dir)
            f = open(os.path.join(file_dir, "calibration_voltage.log"))
        periods = []
        widths = []
        voltages = []
        for line in f.readlines():
            record = eval(line)
            periods.append(int(record["period"]))
            widths.append(int(record["width"]))
            voltages.append(float(record["voltage"]))
        self.voltage_mapping = LinearNDInterpolator(
            numpy.dstack((periods, widths))[0], voltages
        )

    def get_adc_control_param(self) -> tuple[bool, float]:
        self.ser.write(b"\x06")
        enabled, destination = struct.unpack(">?H", self.ser.read(1 + 2))
        return enabled, self.to_volt(destination)

    def set_adc_control_param(self, enabled: bool, destination: float):
        command = b"\x07"
        command += struct.pack(">?H", enabled, self.to_raw(destination))
        self.ser.write(command)

    def get_time(self) -> float:
        self.ser.write(b"\x05")
        return struct.unpack(">d", self.ser.read(8))[0]

    def get_ticks(self) -> int:
        self.ser.write(b"\x09")
        return struct.unpack(">Q", self.ser.read(8))[0]

    def get_adc_control_PID(self, from_flash=False):
        command = b"\x0A"
        command += struct.pack(">?", from_flash)
        self.ser.write(command)
        return struct.unpack(">3fQ", self.ser.read(3 * 4 + 8))

    def set_adc_control_PID(
        self,
        kp: float,
        ki: float,
        kd: float,
        control_ticks: int,
        to_flash=False,
    ):
        command = b"\x0B"
        command += struct.pack(">?3fQ", to_flash, kp, ki, kd, control_ticks)
        self.ser.write(command)

    def get_adc_control_PID_ex(self):
        """
        Retrieve supplementary values of configuration and information of the ADC Control.
        Those values are transient.

        :return: A tuple containing the configuration of the PID:
            The PID limitations of value contributed by Kp, Ki and Kd.
            The PID's output limit. The PID setpoint (float). The timestamp (
            in ticks) of last PID sampling.
        """
        command = b"\x0D"
        self.ser.write(command)
        return struct.unpack(">5fQ", self.ser.read(3 * 4 + 8))

    def set_adc_control_PID_ex(
        self, p_limit: float, i_limit: float, d_limit: float, output_limit: float
    ):
        """
        Set supplementary values of configuration of the ADC Control.
        Those values are transient and are reset to their default values on startup.
        :param p_limit: PID limitation of value contributed by Kp. Default is 200.0.
        :param i_limit: PID limitation of value contributed by Ki. Default is 200.0.
        :param d_limit: PID limitation of value contributed by Kd. Default is 200.0.
        :param output_limit: PID limitation of output value. Default is 200.0.
        """
        command = b"\x0B"
        command += struct.pack(">4f", p_limit, i_limit, d_limit, output_limit)
        self.ser.write(command)

    def __del__(self):
        self.off()
