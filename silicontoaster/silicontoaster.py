#!/usr/bin/python3

from typing import Optional
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
        self.calibration = [
            -4.02294398e-11,
            1.53492378e-07,
            -2.71166328e-04,
            7.66927146e-01,
            -1.12729564e00,
        ]
        self._software_limit = None
        self.get_voltage_mapping()

    def read_voltage_raw(self):
        """
        Retrieve raw ADC voltage measurement from the device.
        :return: ADC measurement.
        :rtype: int
        """
        self.ser.write(b"\x02")
        return int.from_bytes(self.ser.read(2), "big")

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
        command += period.to_bytes(2, "big")
        command += width.to_bytes(2, "big")
        self.ser.write(command)
        assert self.ser.read(1) == b"\x03"

    def get_pwm_settings(self) -> tuple[int, int]:
        """
        Retrieve the last values set for PWM.
        :return: A tuple containing the period and the width.
        """
        self.ser.write(b"\x08")
        period = int.from_bytes(self.ser.read(2), "big")
        width = int.from_bytes(self.ser.read(2), "big")
        return period, width

    def software_shoot(self, duration: int):
        """
        Generate a pulse with the device to discharge de capacitors.
        """
        assert duration in range(0x10000)
        command = bytearray(b"\x04")
        command += duration.to_bytes(2, "big")
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

    def get_adc_control_param(self) -> tuple[bool, int, int, int, int]:
        self.ser.write(b"\x07")
        adc_control_enabled = self.ser.read(1) != b"\x00"
        adc_destination = int.from_bytes(self.ser.read(2), "big")
        adc_hysteresis = int.from_bytes(self.ser.read(2), "big")
        adc_control_time = int.from_bytes(self.ser.read(8), "big")
        adc_last_control = int.from_bytes(self.ser.read(8), "big")
        print(
            "ADC Control Params:",
            adc_control_enabled,
            adc_destination,
            adc_hysteresis,
            adc_control_time,
            adc_last_control,
        )
        return adc_control_enabled, adc_destination, adc_hysteresis, adc_control_time, adc_last_control

    def set_adc_control_param(self, enabled: bool, destination: int, hysteresis: int, control_time: int):
        command = bytearray(b"\x06")
        command += b"\x01" if enabled else b"\x00"
        command += destination.to_bytes(2, "big")
        command += hysteresis.to_bytes(2, "big")
        command += control_time.to_bytes(8, "big")
        self.ser.write(command)

    def get_time(self) -> float:
        self.ser.write(b"\x05")
        return struct.unpack(">d", self.ser.read(8))[0]

    def get_ticks(self) -> int:
        self.ser.write(b"\x09")
        return struct.unpack(">Q", self.ser.read(8))[0]

    def read_PID(self, from_flash=False):
        command = b"\x0A"
        command += struct.pack(">?", from_flash)
        self.ser.write(command)
        return struct.unpack(">3fQ", self.ser.read(3 * 4 + 8))

    def write_PID(
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
    def __del__(self):
        self.off()
