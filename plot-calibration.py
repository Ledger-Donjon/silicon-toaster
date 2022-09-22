#!/usr/bin/python3

import matplotlib.pyplot as plt
import quicklog
import numpy as np

x = []
y = []

for record in quicklog.read_log('calibration-800.log'):
    x.append(float(record['value']))
    y.append(float(record['voltage']))

plt.plot(x, y)
#plt.show()

coefs = np.polyfit(x, y, 4)
poly = np.poly1d(coefs)
print(coefs)

x = np.linspace(0, max(x), 100)
y = []
for xx in x:
    v = 0
    for i, c in enumerate(coefs):
        v += c * xx**(len(coefs)-i-1)
    y.append(v)

plt.plot(x, y)
#plt.plot(x, poly(x))
plt.show()
