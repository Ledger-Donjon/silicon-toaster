from typing import Optional, Literal

import hug
import silicontoasterapi
from PyQt5.QtCore import (
    QObject,
    QThread,
    QVariant,
    QMetaObject,
    Q_ARG,
    Qt,
    Q_RETURN_ARG, pyqtSlot,
)


class RestProxy(QObject):
    """
    Class to execute the requests from REST object lying the RestThread, in the same thread that
    Silicon Toaster.
    """

    def __init__(self, silicontoaster: "SiliconToaster"):
        super().__init__()
        self.silicontoaster = silicontoaster
        self.rest_object = RestServer(self)
        self.thread = RestThread()
        self.rest_object.moveToThread(self.thread)
        self.thread.start()

    @pyqtSlot(result=QVariant)
    def handle_read_voltage(self):
        """
        Handler to retrieve the current actual voltage of the Silicon Toaster
        :return: Current voltage read from the Silicon Toaster
        """
        return self.silicontoaster.read_voltage()

    @pyqtSlot(result=QVariant)
    def handle_voltage(self):
        """
        Handler to retrieve the last read voltage value from the Silicon Toaster
        :return: Last voltage value read from the Silicon Toaster
        """
        return self.silicontoaster.read_voltage()

    @pyqtSlot(QVariant, QVariant, result=QVariant)
    def handle_voltage_set_point(self, active: Literal["on", "off", "none"], destination: float):
        """
        Handler for the voltage set-point parameter configuration of the Toaster, and activation.
        :param active: To activate or deactivate the Silicon Toaster
        :param destination: Desired value for voltage-set point. Any value lesser than 0 is ignored.
        :return: The current value of voltage set-point.
        """
        if destination >= 0.0:
            self.silicontoaster.set_voltage_setpoint(destination)
        if active != "none":
            self.silicontoaster.on_off(active == "on")

        return self.silicontoaster.get_voltage_setpoint()

    @pyqtSlot(QVariant)
    def software_shoot(self, duration: float):
        """
        Software triggering of a discharge of the Silicon Toaster, in number a for-loop
        containing a NOP instruction.
        :param duration: The number of for-loop containing a NOP used for duration of the
        discharge of the capacitors
        """
        return self.silicontoaster.software_shoot(duration)

class RestThread(QThread):
    """
    Subclass of QThread where to launch the Rest server.
    """

    def run(self):
        RestServer.shared.serve(silicontoasterapi.SiliconToasterAPI.PORT)
        super(RestThread, self).run()


class RestServer(QObject):
    """
    Object that is moved in the REST-dedicated thread.
    Follows the singleton pattern
    """

    _shared: Optional["RestServer"] = None

    @staticmethod
    def shared(proxy: Optional[RestProxy] = None) -> "RestServer":
        if RestServer._shared is None:
            RestServer._shared = RestServer(proxy)
        return RestServer._shared

    def __init__(self, proxy: RestProxy, parent: QObject = None):
        super(RestServer, self).__init__(parent)
        self.proxy = proxy
        RestServer.shared = self

    def serve(self, port: int):
        """
        Launch hug's REST server on the given port
        :param port: The HTTP port to listen
        """
        hug.API(__name__).http.serve(host="localhost", port=port, display_intro=False)

    def invoke(self, member: str, *args) -> QVariant:
        """
        Invoke a given method name to the Proxy, with given arguments.
        The Proxy lies in the same thread that the main application.
        The method call is blocking until execution is done.
        :param member: The string value of the method to call
        :param args: The list of arguments to pass to the method invoked.
        :return: a QVariant (which can be None) returned by the invoked method.
        """
        l_args = [Q_ARG(type(arg), arg) for arg in args]
        retval = QMetaObject.invokeMethod(
            self.proxy,
            member,
            Qt.BlockingQueuedConnection,
            Q_RETURN_ARG(QVariant),
            *l_args,
        )
        return retval


@hug.get(examples=["active=on", "active=off", "active=on&voltage=50"])
def voltage_set_point(
    active: hug.types.one_of(["on", "off", "none"]) = "none",
    voltage: hug.types.in_range(
        lower=-1.1, upper=800.0, convert=hug.types.float_number
    ) = -1.0,
):
    return RestServer.shared.invoke(
        "handle_voltage_set_point",
        QVariant(active),
        QVariant(voltage),
    )


@hug.get()
def read_voltage():
    return RestServer.shared.invoke("handle_read_voltage")

@hug.get()
def voltage():
    return RestServer.shared.invoke("handle_voltage")


@hug.get()
def software_shoot(
        duration: hug.types.in_range(
        lower=0, upper=100, convert=hug.types.number
    )):
    return RestServer.shared.invoke("handle_software_shoot", duration)
