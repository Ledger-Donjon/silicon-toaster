#!/usr/bin/python3

import matplotlib.pyplot as plt
import quicklog
import numpy as np

x = []
y = []
z = []

for record in quicklog.read_log(f"calibration_voltage.log"):
    x.append(float(record["period"]))
    y.append(float(record["width"]))
    z.append(float(record["voltage"]))
X, Y, Z = [np.array(i) for i in [x, y, z]]
ax = plt.axes(projection="3d")
surf = ax.plot_trisurf(x, y, z, cmap="cool", edgecolor="black")
surf.set_linewidth(0.1)
ax.set_title("Voltage obtained according PDM width/period")
ax.set_xlabel("Period")
ax.set_ylabel("Width")
ax.set_zlabel("Voltage (V)")
plt.colorbar(surf)
plt.show()
