#!/usr/bin/python3

import matplotlib.pyplot as plt
import quicklog
import numpy as np

x = []
y = []

plt.figure()
for record in quicklog.read_log("calibration-800.log"):
    x.append(float(record["value"]))
    y.append(float(record["voltage"]))

plt.plot(x, y)

coefs = np.polyfit(x, y, 4)
poly = np.poly1d(coefs)
print("Raw->Volt", coefs)

coefs_inv = np.polyfit(y, x, 4)
poly_inv = np.poly1d(coefs_inv)
print("Volt->Raw", coefs_inv)

plt.figure()
x = np.linspace(0, max(x), 100)
y = []
for xx in x:
    v = 0
    for i, c in enumerate(coefs):
        v += c * xx ** (len(coefs) - i - 1)
    y.append(v)

plt.plot(x, y)
# plt.plot(x, poly(x))


y = np.linspace(0, max(y), 100)
x = []
for yy in y:
    v = 0
    for i, c in enumerate(coefs_inv):
        v += c * yy ** (len(coefs_inv) - i - 1)
    x.append(v)

plt.figure()
plt.plot(x, y)
# plt.plot(x, poly_inv(x))
plt.show()
