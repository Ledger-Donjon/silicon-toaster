#!/usr/bin/python3
"""
This script is to perform measures on the obtained value of "read_voltage()" after a certain
time, according to 'period' and 'width' parameters.
"""
import numpy
from silicontoaster import SiliconToaster
import datetime
from time import sleep
import quicklog

toaster = SiliconToaster("/dev/ttyUSB3")
toaster.on()

avg_count = 100

log = quicklog.Log(f"calibration_voltage.log")
already_done = []
for record in quicklog.read_log(f"calibration_voltage.log"):
    already_done.append((float(record["width"]), float(record["period"])))

for period in list(range(100, 1600, 50))[::-1]:
    for width in range(1, 25):
        print(f"Measuring for period {period}, width {width}...")
        if (width, period) in already_done:
            print(f"Already done, skipping.")
            continue
        toaster.set_pwm_settings(period=period, width=width)

        # The array containing the read values.
        voltages = []
        # For tracking time.
        last_print_time = start = datetime.datetime.now()
        # To compute the standard deviation
        stddev = 0.0
        # We prevent the measurement to last indefinitely
        while (now := datetime.datetime.now()) - start < datetime.timedelta(minutes=2):
            # Read the voltage and append it
            voltages.append(toaster.read_voltage())
            # We keep only the last values
            voltages = voltages[-avg_count:]
            if len(voltages) == avg_count:
                stddev = numpy.std(voltages)
                if stddev < 1.5:
                    # The standard deviation of the last measurements is low:
                    # We consider that the reading of the voltage is stable enough
                    break
                if last_print_time - now > datetime.timedelta(seconds=20):
                    print(stddev)
                    last_print_time = now
            # Each measurement is delayed
            sleep(0.05)

        record = {
            "width": width,
            "voltage": numpy.average(voltages),
            "period": period,
            "std": stddev,
            "time": int((now - start).total_seconds()),
        }
        print(record)
        log.append(record)
        log.flush()
        if numpy.average(voltages) > 950:
            break
