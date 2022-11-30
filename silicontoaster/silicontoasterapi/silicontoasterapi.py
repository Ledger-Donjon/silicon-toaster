# Client API library to interact with Silicon Toaster via a REST API.
from typing import Optional, Union, Tuple
import requests


class SiliconToasterAPI:
    # Default server and client port. There is no particular need for this value
    # to be changed.
    PORT = 4446

    def __init__(self, host="localhost"):
        """
        :param host: Network host. Default is localhost.
        """
        # Creates a session for the connection to the REST server.
        self.host = host
        self.session = requests.Session()

    def __del__(self):
        """
        Called when SiliconToasterAPI object is deleted. Closes the connection to the server.
        """
        pass

    def send(self, command: str, params: Optional[dict] = None):
        """
        Sends a command an optional parameters to the REST server.

        :param command: Command name.
        :param params: Optional dictionary of parameters to the command.
        """
        if params is None:
            params = {}
        # TODO: Perform URL escapes of parameters.
        params_str = "&".join([f"{k}={v}" for k, v in params.items()])
        return self.session.get(
            f"http://{self.host}:{SiliconToasterAPI.PORT}/{command}?{params_str}"
        )

    def voltage_set_point(self, value=Optional[float]) -> float:
        """
        Send to the REST API the value of the voltage-setpoint of the Silicon Toaster
        :param value: The Set-Point value of voltage, in Volts. If nothing given no value is
        applied.
        :return: The Set-Point voltage configured to the Silicon Toaster
        """

    def voltage(self) -> float:
        """
        Get from the REST API the current value of the voltage of the Silicon Toaster
        :return: The current voltage measured, in Volts.
        """