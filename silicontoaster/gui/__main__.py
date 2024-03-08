from PyQt6.QtWidgets import QApplication, QStyleFactory
import sys
from PyQt6.QtGui import QIcon, QPalette, QColor
from .util import resource_path
from .tool import SiliconToasterWindow

app = QApplication(sys.argv)

app.setApplicationName("Silicon Toaster")
app.setWindowIcon(QIcon(resource_path(":/icons/logo.png")))
app.setStyle(QStyleFactory.create("Fusion"))
palette = QPalette()
palette.setColor(QPalette.ColorRole.Window, QColor(25, 25, 25))
palette.setColor(QPalette.ColorRole.WindowText, QColor(240, 240, 240))
palette.setColor(QPalette.ColorRole.Base, QColor(40, 40, 40))
palette.setColor(QPalette.ColorRole.AlternateBase, QColor(255, 0, 0))
palette.setColor(QPalette.ColorRole.ToolTipBase, QColor(25, 25, 25))
palette.setColor(QPalette.ColorRole.ToolTipText, QColor(255, 255, 255))
palette.setColor(QPalette.ColorRole.Text, QColor(200, 200, 200))
palette.setColor(QPalette.ColorRole.Button, QColor(40, 40, 40))
palette.setColor(
    QPalette.ColorGroup.Disabled, QPalette.ColorRole.Button, QColor(30, 30, 30)
)
palette.setColor(QPalette.ColorRole.ButtonText, QColor(200, 200, 200))
palette.setColor(
    QPalette.ColorGroup.Disabled, QPalette.ColorRole.ButtonText, QColor(100, 100, 100)
)
palette.setColor(QPalette.ColorRole.BrightText, QColor(255, 0, 0))
palette.setColor(QPalette.ColorRole.Link, QColor(255, 0, 0))
palette.setColor(QPalette.ColorRole.Highlight, QColor(40, 120, 233))
palette.setColor(QPalette.ColorRole.HighlightedText, QColor(255, 255, 255))
app.setPalette(palette)

win = SiliconToasterWindow()
win.show()
sys.exit(app.exec())
