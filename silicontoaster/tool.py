#!/usr/bin/python3
from PyQt5.QtCore import *
from PyQt5.QtGui import *
from PyQt5.QtWidgets import *
from silicontoaster import SiliconToaster
import sys
import math


class VoltageViewer(QWidget):
    def __init__(self):
        super().__init__()
        self.setMinimumHeight(200)
        self.setMinimumWidth(200)
        self.data = []
        self.hist_size = 400
        self.vmax = 1500
        self.vsafe = 1000
        self.vdest = 0.0
        self.avg_samples = self.hist_size

    def paintEvent(self, event):
        """Draw the widget."""
        painter = QPainter()
        painter.begin(self)
        painter.setRenderHint(QPainter.Antialiasing)
        painter.fillRect(self.rect(), QBrush(Qt.black))

        width = self.width()
        height = self.height()

        y0 = self.w2sy(self.vsafe)
        y1 = self.w2sy(self.vmax)
        painter.fillRect(
            0, int(y0), width, int(y1 - y0), QBrush(QColor(70, 20, 0), Qt.BDiagPattern)
        )

        for i in range(0, self.vmax, 100):
            if i < self.vsafe:
                painter.setPen(QPen(QColor(50, 50, 50)))
            else:
                painter.setPen(QPen(QColor(70, 20, 0)))
            y = round(self.w2sy(i)) - 0.5
            painter.drawLine(QLineF(0, y, width, y))

        painter.setPen(QPen(Qt.darkYellow))
        y = round(self.w2sy(int(self.vdest))) - 0.5
        painter.drawLine(QLineF(0, y, width, y))

        painter.setPen(QPen(Qt.yellow))
        for i in range(len(self.data) - 1):
            v0 = self.data[i]
            v1 = self.data[i + 1]
            x0 = self.w2sx(i)
            x1 = self.w2sx(i + 1)
            y0 = self.w2sy(v0)
            y1 = self.w2sy(v1)
            painter.drawLine(QLineF(x0, y0, x1, y1))

        # Calculate average and standard deviation
        if len(self.data):
            samples = self.data[-self.avg_samples :]
            avg = sum(samples) / len(samples)
            std_dev = 0
            for value in self.data:
                std_dev += (value - avg) ** 2
            std_dev = math.sqrt(std_dev / len(samples))

            text_rect = self.rect()
            text = f"{self.data[-1]:.0f} V\n{avg:.0f} V\n{std_dev:.3f}"
            font = painter.font()
            font.setPixelSize(20)
            painter.setFont(font)
            painter.drawText(text_rect, Qt.AlignHCenter | Qt.AlignTop, text)

        painter.end()

    def add_data(self, value):
        self.data.append(value)
        while len(self.data) > self.hist_size:
            self.data.pop(0)

    def w2sy(self, y: float) -> float:
        """
        World-to-screen ordinate conversion.
        :param y: Ordinate in world.
        :return: Ordinate on screen.
        """
        h = self.height()
        return h - (y / self.vmax) * h

    def w2sx(self, x: float) -> float:
        """
        World-to-screen abscissa conversion.
        :param x: Abscissa in world.
        :return: Abscissa on screen.
        """
        return (x / (self.hist_size - 1)) * self.width()


class Window(QWidget):
    def __init__(self, dev):
        super().__init__()

        shortcut = QShortcut(Qt.CTRL + Qt.Key_S, self)
        shortcut.activated.connect(self.shoot)

        if isinstance(dev, SiliconToaster):
            self.silicon_toaster = dev
        else:
            self.silicon_toaster = SiliconToaster(dev)
            self.silicon_toaster.on_off(False)
            self.silicon_toaster.set_pwm_settings(800, 5)

        vbox = QVBoxLayout()
        vbox.setContentsMargins(4, 4, 4, 4)
        vbox.setSpacing(4)
        self.setLayout(vbox)
        hbox = QHBoxLayout()
        hbox.setContentsMargins(0, 0, 0, 0)
        hbox.setSpacing(2)
        vbox.addLayout(hbox)

        self.on_off_button = w = QPushButton("Activate")
        w.setCheckable(True)
        hbox.addWidget(w)
        w.toggled.connect(self.on_off)

        hbox.addStretch()

        hbox.addWidget(QLabel("Set Point"))
        w = self.voltage_destination = QDoubleSpinBox()
        w.setValue(0.0)
        w.setMinimum(0.0)
        w.setMaximum(1500.0)
        w.setDecimals(0)
        w.setSingleStep(5)
        w.setAlignment(Qt.AlignTrailing)
        w.setToolTip("Target")
        w.setMaximumWidth(100)
        w.valueChanged.connect(self.set_voltage_destination)
        w.setSuffix(" V")
        hbox.addWidget(w)

        hbox.addStretch()

        w = self.shoot_edit = QSpinBox()
        w.setValue(10)
        w.setMaximum(0x10000)
        w.setMinimum(1)
        w.setToolTip("Shoot duration (in number of NOP-loop)")
        w.setMaximumWidth(50)
        hbox.addWidget(w)
        w = QPushButton("Shoot")
        hbox.addWidget(w)
        w.clicked.connect(self.shoot)

        self.advanced = QWidget()
        vbox.addWidget(self.advanced)
        self.advanced.setSizePolicy(QSizePolicy.Expanding, QSizePolicy.Fixed)

        w = QPushButton("...")
        w.setCheckable(True)
        w.toggled.connect(self.advanced.setVisible)
        hbox.addStretch()
        hbox.addWidget(w)

        self.advanced_PWM = QWidget()
        vbox.addWidget(self.advanced_PWM)
        self.advanced_PWM.setSizePolicy(QSizePolicy.Expanding, QSizePolicy.Fixed)

        w = QPushButton("...")
        w.setCheckable(True)
        w.toggled.connect(self.advanced_PWM.setVisible)
        hbox.addStretch()
        hbox.addWidget(w)

        vboxa = QVBoxLayout()
        vboxa.setContentsMargins(0, 0, 0, 0)
        self.advanced.setLayout(vboxa)
        hbox = QHBoxLayout()
        hbox.setContentsMargins(0, 0, 0, 0)
        vboxa.addLayout(hbox)

        hbox2 = QHBoxLayout()
        hbox.addLayout(hbox2)
        hbox2.setContentsMargins(0, 0, 0, 0)
        w = self.period_label = QLabel("")
        w.setToolTip("PWM: Period")
        w.setMinimumWidth(75)
        hbox2.addWidget(w)
        w = self.width_label = QLabel("")
        w.setToolTip("PWM: Width")
        w.setMinimumWidth(75)
        hbox2.addWidget(w)

        hbox2 = QHBoxLayout()
        hbox.addLayout(hbox2)
        w = QLabel("Kp")
        hbox2.addWidget(w)
        w = self.pid_kp = QDoubleSpinBox()
        w.setMaximum(1000.0)
        hbox2.addWidget(w)

        w = QLabel("Ki")
        hbox2.addWidget(w)
        w = self.pid_ki = QDoubleSpinBox()
        w.setMaximum(1000.0)
        hbox2.addWidget(w)

        w = QLabel("Kd")
        hbox2.addWidget(w)
        w = self.pid_kd = QDoubleSpinBox()
        w.setMaximum(1000.0)
        hbox2.addWidget(w)

        hbox2 = QHBoxLayout()
        hbox.addLayout(hbox2)
        hbox2.addWidget(QLabel("Control ticks"))
        w = self.timetick = QSpinBox()
        w.setToolTip(
            "Number of ticks between two samplings"
            "(Frequency is 8047640 ticks per second)"
        )
        hbox2.addWidget(w)
        w.setMinimum(1)
        w.setMaximum(8047640)

        w = self.flash = QCheckBox("In Flash")
        hbox.addWidget(w)

        hbox = QHBoxLayout()
        hbox.setContentsMargins(0, 0, 0, 0)
        vboxa.addLayout(hbox)
        vboxa.setContentsMargins(0, 0, 0, 0)
        vboxa.setSpacing(0)

        hbox2 = QHBoxLayout()
        hbox.addLayout(hbox2)
        hbox2.setContentsMargins(0, 0, 0, 0)
        w = self.p_limit = QLabel("")
        w.setToolTip("P Limit")
        w.setMinimumWidth(75)
        hbox2.addWidget(w)
        w = self.i_limit = QLabel("")
        w.setToolTip("I Limit")
        w.setMinimumWidth(75)
        hbox2.addWidget(w)
        w = self.d_limit = QLabel("")
        w.setToolTip("D Limit")
        w.setMinimumWidth(75)
        hbox2.addWidget(w)
        w = self.output_limit = QLabel("")
        w.setToolTip("Output Limit")
        w.setMinimumWidth(75)
        hbox2.addWidget(w)
        w = self.setpoint_label = QLabel("")
        w.setToolTip("RAW Setpoint value")
        w.setMinimumWidth(75)
        hbox.addWidget(w)
        w = self.lastcontrol_label = QLabel("")
        w.setToolTip("Last control timestamp tick")
        w.setMinimumWidth(75)
        hbox.addWidget(w)
        w = QPushButton("Refresh")
        w.clicked.connect(self.refresh_pid_ex)
        hbox.addWidget(w)
        w = self.adc_control_on_off_button = QPushButton("Activate ADCControl")
        w.setCheckable(True)
        hbox.addWidget(w)
        w.setChecked(self.silicon_toaster.adc_control_on_off())
        w.toggled.connect(self.adc_control_on_off)

        self.advanced.setVisible(False)
        self.advanced_PWM.setVisible(False)

        vboxa = QVBoxLayout()
        vboxa.setContentsMargins(0, 0, 0, 0)
        self.advanced_PWM.setLayout(vboxa)
        hbox = QHBoxLayout()
        hbox.setContentsMargins(0, 0, 0, 0)
        vboxa.addLayout(hbox)

        hbox2 = QHBoxLayout()
        hbox.addLayout(hbox2)
        w = QLabel("Period")
        hbox2.addWidget(w)
        w = self.pwd_period_edit = QSpinBox()
        w.setMinimum(1)
        w.setMaximum(800)
        w.setEnabled(False)
        hbox2.addWidget(w)
        w = QLabel("Width")
        hbox2.addWidget(w)
        w = self.pwd_width_edit = QSpinBox()
        w.setMaximum(150)
        hbox2.addWidget(w)

        self.pwd_period_edit.valueChanged.connect(self.set_pwm_settings)
        self.pwd_width_edit.valueChanged.connect(self.set_pwm_settings)

        self.refresh_pid()
        self.refresh_pid_ex()
        self.pid_kp.valueChanged.connect(self.pid_changed)
        self.pid_ki.valueChanged.connect(self.pid_changed)
        self.pid_kd.valueChanged.connect(self.pid_changed)
        self.timetick.valueChanged.connect(self.pid_changed)

        w = self.viewer = VoltageViewer()
        vbox.addWidget(w)

        self.get_voltage_destination()
        self.get_pwm_settings()

        timer = self.timer = QTimer()
        timer.setInterval(50)
        timer.timeout.connect(self.refresh_voltage)
        timer.start()

    def adc_control_on_off(self, value: bool):
        """Turn-on or off ADC Control."""
        self.silicon_toaster.set_adc_control_on_off(value)
        print("ADC Control is now", is_on := self.silicon_toaster.adc_control_on_off())
        self.adc_control_on_off_button.setChecked(is_on)

    def refresh_pid(self):
        kp, ki, kd, timetick = self.silicon_toaster.get_adc_control_pid(
            self.flash.isChecked()
        )
        self.pid_kp.setValue(kp)
        self.pid_ki.setValue(ki)
        self.pid_kd.setValue(kd)
        self.timetick.setValue(timetick)

    def pid_changed(self):
        self.silicon_toaster.set_adc_control_pid(
            self.pid_kp.value(),
            self.pid_ki.value(),
            self.pid_kd.value(),
            self.timetick.value(),
            self.flash.isChecked(),
        )

    def refresh_pid_ex(self):
        r = self.silicon_toaster.get_adc_control_pid_ex()
        kp_limit, ki_limit, kd_limit, output_limit, set_point, last_control = r
        self.p_limit.setText(f"{kp_limit}")
        self.i_limit.setText(f"{ki_limit}")
        self.d_limit.setText(f"{kd_limit}")
        self.output_limit.setText(f"{output_limit}")
        self.setpoint_label.setText(f"{set_point}")
        self.lastcontrol_label.setText(f"{last_control}")

    def refresh_voltage(self):
        """Get the current value of the voltage and refresh"""
        v = self.silicon_toaster.read_voltage()
        self.viewer.add_data(v)
        self.viewer.repaint()
        self.get_pwm_settings()

    def on_off(self, value: bool):
        """Turn-on or off high voltage generation."""
        self.silicon_toaster.on_off(value)

    def set_pwm_settings(self):
        """Reconfigure device PWM settings from UX input."""
        # period, ok1 = QLocale().toInt(self.period_label.text())
        # width, ok2 = QLocale().toInt(self.width_label.text())
        # if ok1 and ok2:
        #     self.silicon_toaster.set_pwm_settings(period, width)
        period = self.pwd_period_edit.value()
        self.pwd_width_edit.setMaximum(period)
        width = self.pwd_width_edit.value()
        self.silicon_toaster.set_pwm_settings(period=period, width=width)

    def get_pwm_settings(self):
        """Get PWM settings from device and update UX."""
        period, width = self.silicon_toaster.get_pwm_settings()
        self.period_label.setText(QLocale().toString(period))
        self.width_label.setText(QLocale().toString(width))
        self.pwd_period_edit.setValue(period)
        self.pwd_width_edit.setValue(width)
        return period, width

    def set_voltage_destination(self):
        """Set the main ADC control parameters according to the value of the UI"""
        destination = float(self.voltage_destination.value())
        self.viewer.vdest = destination
        self.viewer.repaint()
        self.silicon_toaster.set_voltage_setpoint(destination)

    def get_voltage_destination(self):
        """Get the main ADC control parameters from Silicon toaster and updates the UI"""
        destination = self.silicon_toaster.get_voltage_setpoint()
        self.voltage_destination.valueChanged.disconnect()
        self.viewer.vdest = destination
        self.viewer.repaint()
        self.voltage_destination.setValue(destination)
        self.voltage_destination.valueChanged.connect(self.set_voltage_destination)

    def shoot(self):
        """Software shoot with duration from UI."""
        duration, ok = QLocale().toInt(self.shoot_edit.text())
        if ok:
            self.silicon_toaster.software_shoot(duration)

    def closeEvent(self, event):
        self.silicon_toaster.on_off(False)


if __name__ == "__main__":
    app = QApplication(sys.argv)
    if len(sys.argv) < 2:
        dev = None
    else:
        dev = sys.argv[1]
    window = Window(dev)
    window.setWindowTitle("SiliconToaster")
    window.show()
    sys.exit(app.exec_())
