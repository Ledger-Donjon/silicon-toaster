# FTDI EEPROM programming

Disconnect all USB-to-serial devices but the SiliconToaster.

Install the package `ftdi_eeprom` and execute the `flash.sh` script as root to
program the EEPROM memory of the SiliconToaster FT232H device. This will
configure the vendor and description strings to respectively "Ledger" and
"SiliconToaster".

Configuring the EEPROM is optional, but when programmed, the software is able
to recognize automatically which serial port corresponds to the SiliconToaster.
