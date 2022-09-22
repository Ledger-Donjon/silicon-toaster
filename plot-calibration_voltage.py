#!/usr/bin/python3

import matplotlib.pyplot as plt
import quicklog
import numpy as np
from scipy.interpolate import LinearNDInterpolator

x = []
y = []
z = []

for record in quicklog.read_log(f"calibration_voltage.log"):
    x.append(float(record["period"]))
    y.append(float(record["width"]))
    z.append(float(record["voltage"]))
X, Y, Z = [np.array(i) for i in [x, y, z]]
plt.figure()
ax = plt.axes(projection="3d")
surf = ax.plot_trisurf(x, y, z, cmap="cool", edgecolor="black")
surf.set_linewidth(0.1)
ax.set_title("Voltage obtained according PDM width/period")
ax.set_xlabel("Period")
ax.set_ylabel("Width")
ax.set_zlabel("Voltage (V)")
plt.colorbar(surf)
plt.figure()
ax = plt.axes(projection="3d")
s = LinearNDInterpolator(np.dstack((x, y))[0], z)

X = np.linspace(np.min(x),np.max(x), 70)
Y = np.linspace(np.min(y),np.max(y), 70)
grid = np.mgrid[np.min(x):np.max(x):70j,
                np.min(y):np.max(y):70j]
Z = s(grid.reshape(2, -1).T)
X = grid[0].flatten()
Y = grid[1].flatten()
surf = ax.plot_trisurf(X, Y, Z, cmap="cool")
plt.show()

