#!/usr/bin/python3

from silicontoaster import SiliconToaster
from time import sleep
import quicklog

log = quicklog.Log()
toaster = SiliconToaster("/dev/ttyUSB0")
toaster.on()
avg_count = 100

for width in range(1, 40):
    toaster.set_pwm_settings(1600, width)
    input('Waiting...')
    print('Measuring...')
    acc = 0
    for i in range(avg_count):
        acc += toaster.read_voltage_raw()
        sleep(0.05)
    avg = acc / avg_count
    v = float(input("Voltage: "))
    record = {"value": avg, "voltage": v}
    log.append(record)
    log.flush()

