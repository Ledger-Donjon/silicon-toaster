#!/bin/bash
# Run this script as root to grant access to the raw USB device.
# Disconnect all FT232H devices but the SiliconToaster!
ftdi_eeprom --flash-eeprom silicon-toaster.conf
