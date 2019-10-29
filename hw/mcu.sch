EESchema Schematic File Version 4
LIBS:emfi-cache
EELAYER 26 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 2 6
Title "Electromagnetic Fault Injector"
Date "2019-10-29"
Rev "0.1"
Comp "Ledger"
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L MCU_ST_STM32F2:STM32F205RETx U1
U 1 1 5D965CD7
P 5100 3700
F 0 "U1" H 4500 5450 50  0000 C CNN
F 1 "STM32F205RETx" H 5800 5450 50  0000 C CNN
F 2 "Package_QFP:LQFP-64_10x10mm_P0.5mm" H 4500 2000 50  0001 R CNN
F 3 "http://www.st.com/st-web-ui/static/active/en/resource/technical/document/datasheet/CD00237391.pdf" H 5100 3700 50  0001 C CNN
F 4 "STMicroelectronics" H 0   0   50  0001 C CNN "Manufacturer"
F 5 "STM32F205RET6" H 0   0   50  0001 C CNN "ManufacturerRef"
F 6 "Farnell" H 0   0   50  0001 C CNN "Vendor"
F 7 "2060897" H 0   0   50  0001 C CNN "VendorRef"
F 8 "10.21" H 0   0   50  0001 C CNN "Price"
	1    5100 3700
	1    0    0    -1  
$EndComp
Text Label 5900 4000 0    50   ~ 0
BOOT1
$Comp
L power:GND #PWR017
U 1 1 5D965FBF
P 6150 4000
F 0 "#PWR017" H 6150 3750 50  0001 C CNN
F 1 "GND" H 6155 3827 50  0000 C CNN
F 2 "" H 6150 4000 50  0001 C CNN
F 3 "" H 6150 4000 50  0001 C CNN
	1    6150 4000
	1    0    0    -1  
$EndComp
Wire Wire Line
	5800 4000 6150 4000
$Comp
L Connector_Generic:Conn_01x02 J4
U 1 1 5D94950A
P 2500 2300
F 0 "J4" H 2420 1975 50  0000 C CNN
F 1 "Conn_01x02" H 2420 2066 50  0000 C CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x02_P2.54mm_Vertical" H 2500 2300 50  0001 C CNN
F 3 "~" H 2500 2300 50  0001 C CNN
	1    2500 2300
	-1   0    0    1   
$EndComp
Wire Wire Line
	4400 2300 2800 2300
$Comp
L power:+3V3 #PWR010
U 1 1 5D949772
P 2800 2200
F 0 "#PWR010" H 2800 2050 50  0001 C CNN
F 1 "+3V3" V 2815 2328 50  0000 L CNN
F 2 "" H 2800 2200 50  0001 C CNN
F 3 "" H 2800 2200 50  0001 C CNN
	1    2800 2200
	0    1    1    0   
$EndComp
Wire Wire Line
	2800 2200 2700 2200
$Comp
L Device:R_Small R4
U 1 1 5D94996B
P 2800 2500
F 0 "R4" H 2741 2454 50  0000 R CNN
F 1 "10k" H 2741 2545 50  0000 R CNN
F 2 "Resistor_SMD:R_0603_1608Metric" H 2800 2500 50  0001 C CNN
F 3 "~" H 2800 2500 50  0001 C CNN
F 4 "TE Connectivity" H 0   0   50  0001 C CNN "Manufacturer"
F 5 "CRGH0603J10K" H 0   0   50  0001 C CNN "ManufacturerRef"
F 6 "0.038" H 0   0   50  0001 C CNN "Price"
F 7 "Farnell" H 0   0   50  0001 C CNN "Vendor"
F 8 "2331740" H 0   0   50  0001 C CNN "VendorRef"
	1    2800 2500
	-1   0    0    1   
$EndComp
$Comp
L power:GND #PWR011
U 1 1 5D949A4D
P 2800 2700
F 0 "#PWR011" H 2800 2450 50  0001 C CNN
F 1 "GND" H 2805 2527 50  0000 C CNN
F 2 "" H 2800 2700 50  0001 C CNN
F 3 "" H 2800 2700 50  0001 C CNN
	1    2800 2700
	1    0    0    -1  
$EndComp
Wire Wire Line
	2800 2600 2800 2700
Wire Wire Line
	2800 2400 2800 2300
Connection ~ 2800 2300
Wire Wire Line
	2800 2300 2700 2300
Text Notes 2050 1900 0    50   ~ 0
Short to enable ST bootloader
Text HLabel 6300 3000 2    50   Output ~ 0
TX
Text HLabel 6300 3100 2    50   Input ~ 0
RX
Wire Wire Line
	6300 3100 5800 3100
Wire Wire Line
	6300 3000 5800 3000
$Comp
L Device:C_Small C6
U 1 1 5D94E17E
P 3400 2900
F 0 "C6" H 3492 2946 50  0000 L CNN
F 1 "2.2µ" H 3492 2855 50  0000 L CNN
F 2 "Capacitor_SMD:C_0603_1608Metric" H 3400 2900 50  0001 C CNN
F 3 "~" H 3400 2900 50  0001 C CNN
F 4 "Murata" H 0   0   50  0001 C CNN "Manufacturer"
F 5 "GRM188R61E225KA12D" H 0   0   50  0001 C CNN "ManufacturerRef"
F 6 "0.154" H 0   0   50  0001 C CNN "Price"
F 7 "Farnell" H 0   0   50  0001 C CNN "Vendor"
F 8 "1845734" H 0   0   50  0001 C CNN "VendorRef"
F 9 "25" H 0   0   50  0001 C CNN "Voltage"
	1    3400 2900
	1    0    0    -1  
$EndComp
$Comp
L Device:C_Small C7
U 1 1 5D94E1F8
P 3950 2900
F 0 "C7" H 4042 2946 50  0000 L CNN
F 1 "2.2µ" H 4042 2855 50  0000 L CNN
F 2 "Capacitor_SMD:C_0603_1608Metric" H 3950 2900 50  0001 C CNN
F 3 "~" H 3950 2900 50  0001 C CNN
F 4 "Murata" H 0   0   50  0001 C CNN "Manufacturer"
F 5 "GRM188R61E225KA12D" H 0   0   50  0001 C CNN "ManufacturerRef"
F 6 "0.154" H 0   0   50  0001 C CNN "Price"
F 7 "Farnell" H 0   0   50  0001 C CNN "Vendor"
F 8 "1845734" H 0   0   50  0001 C CNN "VendorRef"
F 9 "25" H 0   0   50  0001 C CNN "Voltage"
	1    3950 2900
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR012
U 1 1 5D94E2D6
P 3400 3100
F 0 "#PWR012" H 3400 2850 50  0001 C CNN
F 1 "GND" H 3405 2927 50  0000 C CNN
F 2 "" H 3400 3100 50  0001 C CNN
F 3 "" H 3400 3100 50  0001 C CNN
	1    3400 3100
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR013
U 1 1 5D94E2F2
P 3950 3100
F 0 "#PWR013" H 3950 2850 50  0001 C CNN
F 1 "GND" H 3955 2927 50  0000 C CNN
F 2 "" H 3950 3100 50  0001 C CNN
F 3 "" H 3950 3100 50  0001 C CNN
	1    3950 3100
	1    0    0    -1  
$EndComp
Wire Wire Line
	3950 3100 3950 3000
Wire Wire Line
	3400 3100 3400 3000
Wire Wire Line
	3400 2800 3400 2700
Wire Wire Line
	3400 2500 4400 2500
Wire Wire Line
	4400 2600 3950 2600
Wire Wire Line
	3950 2600 3950 2700
$Comp
L power:GND #PWR015
U 1 1 5D94EB57
P 5000 5700
F 0 "#PWR015" H 5000 5450 50  0001 C CNN
F 1 "GND" H 5005 5527 50  0000 C CNN
F 2 "" H 5000 5700 50  0001 C CNN
F 3 "" H 5000 5700 50  0001 C CNN
	1    5000 5700
	1    0    0    -1  
$EndComp
Wire Wire Line
	5200 5500 5200 5600
Wire Wire Line
	5200 5600 5100 5600
Wire Wire Line
	5000 5600 5000 5700
Wire Wire Line
	5000 5500 5000 5600
Connection ~ 5000 5600
Wire Wire Line
	5100 5500 5100 5600
Connection ~ 5100 5600
Wire Wire Line
	5100 5600 5000 5600
$Comp
L Device:C_Small C8
U 1 1 5D94F425
P 7100 1750
F 0 "C8" H 7192 1796 50  0000 L CNN
F 1 "100n" H 7192 1705 50  0000 L CNN
F 2 "Capacitor_SMD:C_0603_1608Metric" H 7100 1750 50  0001 C CNN
F 3 "~" H 7100 1750 50  0001 C CNN
F 4 "Multicomp" H 0   0   50  0001 C CNN "Manufacturer"
F 5 "MC0603B104K250CT" H 0   0   50  0001 C CNN "ManufacturerRef"
F 6 "0.0477" H 0   0   50  0001 C CNN "Price"
F 7 "Farnell" H 0   0   50  0001 C CNN "Vendor"
F 8 "1759037" H 0   0   50  0001 C CNN "VendorRef"
F 9 "25" H 0   0   50  0001 C CNN "Voltage"
	1    7100 1750
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR018
U 1 1 5D94F486
P 7100 2000
F 0 "#PWR018" H 7100 1750 50  0001 C CNN
F 1 "GND" H 7105 1827 50  0000 C CNN
F 2 "" H 7100 2000 50  0001 C CNN
F 3 "" H 7100 2000 50  0001 C CNN
	1    7100 2000
	1    0    0    -1  
$EndComp
Wire Wire Line
	7100 2000 7100 1950
Wire Wire Line
	7100 1650 7100 1550
Wire Wire Line
	7100 1550 5400 1550
Wire Wire Line
	5400 1550 5400 1800
$Comp
L power:+3V3 #PWR016
U 1 1 5D94FA67
P 5400 1450
F 0 "#PWR016" H 5400 1300 50  0001 C CNN
F 1 "+3V3" H 5415 1623 50  0000 C CNN
F 2 "" H 5400 1450 50  0001 C CNN
F 3 "" H 5400 1450 50  0001 C CNN
	1    5400 1450
	1    0    0    -1  
$EndComp
Connection ~ 5400 1550
Wire Wire Line
	5000 1900 5000 1800
Wire Wire Line
	5000 1800 4900 1800
Wire Wire Line
	4900 1800 4900 1900
Wire Wire Line
	5100 1900 5100 1800
Wire Wire Line
	5100 1800 5000 1800
Connection ~ 5000 1800
Wire Wire Line
	5200 1900 5200 1800
Wire Wire Line
	5200 1800 5100 1800
Connection ~ 5100 1800
Wire Wire Line
	5300 1900 5300 1800
Wire Wire Line
	5300 1800 5200 1800
Connection ~ 5200 1800
Wire Wire Line
	5400 1800 5300 1800
Connection ~ 5400 1800
Wire Wire Line
	5400 1800 5400 1900
Connection ~ 5300 1800
Wire Wire Line
	5400 1450 5400 1550
Text Label 5900 2900 0    50   ~ 0
TIM1_CH1
Wire Wire Line
	5800 2900 6300 2900
Text HLabel 6300 2900 2    50   Output ~ 0
PWM
Text Label 5900 2100 0    50   ~ 0
ADC123_IN0
Text HLabel 6450 2100 2    50   Input ~ 0
ADC
Wire Wire Line
	6450 2100 5800 2100
$Comp
L power:+3V3 #PWR014
U 1 1 5D98CBB8
P 4300 2000
F 0 "#PWR014" H 4300 1850 50  0001 C CNN
F 1 "+3V3" H 4315 2173 50  0000 C CNN
F 2 "" H 4300 2000 50  0001 C CNN
F 3 "" H 4300 2000 50  0001 C CNN
	1    4300 2000
	1    0    0    -1  
$EndComp
Wire Wire Line
	4400 2100 4300 2100
Wire Wire Line
	4300 2100 4300 2000
Text HLabel 6550 4900 2    50   Output ~ 0
20V_EN
Wire Wire Line
	5800 4900 6300 4900
$Comp
L Device:C_Small C2
U 1 1 5DA1D129
P 7500 1750
F 0 "C2" H 7592 1796 50  0000 L CNN
F 1 "100n" H 7592 1705 50  0000 L CNN
F 2 "Capacitor_SMD:C_0603_1608Metric" H 7500 1750 50  0001 C CNN
F 3 "~" H 7500 1750 50  0001 C CNN
F 4 "Multicomp" H 0   0   50  0001 C CNN "Manufacturer"
F 5 "MC0603B104K250CT" H 0   0   50  0001 C CNN "ManufacturerRef"
F 6 "0.0477" H 0   0   50  0001 C CNN "Price"
F 7 "Farnell" H 0   0   50  0001 C CNN "Vendor"
F 8 "1759037" H 0   0   50  0001 C CNN "VendorRef"
F 9 "25" H 0   0   50  0001 C CNN "Voltage"
	1    7500 1750
	1    0    0    -1  
$EndComp
$Comp
L Device:C_Small C3
U 1 1 5DA1D16D
P 7900 1750
F 0 "C3" H 7992 1796 50  0000 L CNN
F 1 "100n" H 7992 1705 50  0000 L CNN
F 2 "Capacitor_SMD:C_0603_1608Metric" H 7900 1750 50  0001 C CNN
F 3 "~" H 7900 1750 50  0001 C CNN
F 4 "Multicomp" H 0   0   50  0001 C CNN "Manufacturer"
F 5 "MC0603B104K250CT" H 0   0   50  0001 C CNN "ManufacturerRef"
F 6 "0.0477" H 0   0   50  0001 C CNN "Price"
F 7 "Farnell" H 0   0   50  0001 C CNN "Vendor"
F 8 "1759037" H 0   0   50  0001 C CNN "VendorRef"
F 9 "25" H 0   0   50  0001 C CNN "Voltage"
	1    7900 1750
	1    0    0    -1  
$EndComp
$Comp
L Device:C_Small C4
U 1 1 5DA1D19D
P 8300 1750
F 0 "C4" H 8392 1796 50  0000 L CNN
F 1 "100n" H 8392 1705 50  0000 L CNN
F 2 "Capacitor_SMD:C_0603_1608Metric" H 8300 1750 50  0001 C CNN
F 3 "~" H 8300 1750 50  0001 C CNN
F 4 "Multicomp" H 0   0   50  0001 C CNN "Manufacturer"
F 5 "MC0603B104K250CT" H 0   0   50  0001 C CNN "ManufacturerRef"
F 6 "0.0477" H 0   0   50  0001 C CNN "Price"
F 7 "Farnell" H 0   0   50  0001 C CNN "Vendor"
F 8 "1759037" H 0   0   50  0001 C CNN "VendorRef"
F 9 "25" H 0   0   50  0001 C CNN "Voltage"
	1    8300 1750
	1    0    0    -1  
$EndComp
$Comp
L Device:C_Small C5
U 1 1 5DA1D1CB
P 8700 1750
F 0 "C5" H 8792 1796 50  0000 L CNN
F 1 "100n" H 8792 1705 50  0000 L CNN
F 2 "Capacitor_SMD:C_0603_1608Metric" H 8700 1750 50  0001 C CNN
F 3 "~" H 8700 1750 50  0001 C CNN
F 4 "Multicomp" H 0   0   50  0001 C CNN "Manufacturer"
F 5 "MC0603B104K250CT" H 0   0   50  0001 C CNN "ManufacturerRef"
F 6 "0.0477" H 0   0   50  0001 C CNN "Price"
F 7 "Farnell" H 0   0   50  0001 C CNN "Vendor"
F 8 "1759037" H 0   0   50  0001 C CNN "VendorRef"
F 9 "25" H 0   0   50  0001 C CNN "Voltage"
	1    8700 1750
	1    0    0    -1  
$EndComp
$Comp
L Device:C_Small C17
U 1 1 5DA1D1FD
P 9100 1750
F 0 "C17" H 9192 1796 50  0000 L CNN
F 1 "100n" H 9192 1705 50  0000 L CNN
F 2 "Capacitor_SMD:C_0603_1608Metric" H 9100 1750 50  0001 C CNN
F 3 "~" H 9100 1750 50  0001 C CNN
F 4 "Multicomp" H 0   0   50  0001 C CNN "Manufacturer"
F 5 "MC0603B104K250CT" H 0   0   50  0001 C CNN "ManufacturerRef"
F 6 "0.0477" H 0   0   50  0001 C CNN "Price"
F 7 "Farnell" H 0   0   50  0001 C CNN "Vendor"
F 8 "1759037" H 0   0   50  0001 C CNN "VendorRef"
F 9 "25" H 0   0   50  0001 C CNN "Voltage"
	1    9100 1750
	1    0    0    -1  
$EndComp
Wire Wire Line
	7100 1950 7500 1950
Wire Wire Line
	9100 1950 9100 1850
Connection ~ 7100 1950
Wire Wire Line
	7100 1950 7100 1850
Wire Wire Line
	8700 1850 8700 1950
Connection ~ 8700 1950
Wire Wire Line
	8700 1950 9100 1950
Wire Wire Line
	8300 1850 8300 1950
Connection ~ 8300 1950
Wire Wire Line
	8300 1950 8700 1950
Wire Wire Line
	7900 1850 7900 1950
Connection ~ 7900 1950
Wire Wire Line
	7900 1950 8300 1950
Wire Wire Line
	7500 1850 7500 1950
Connection ~ 7500 1950
Wire Wire Line
	7500 1950 7900 1950
Wire Wire Line
	9100 1650 9100 1550
Wire Wire Line
	9100 1550 8700 1550
Connection ~ 7100 1550
Wire Wire Line
	7500 1650 7500 1550
Connection ~ 7500 1550
Wire Wire Line
	7500 1550 7100 1550
Wire Wire Line
	7900 1650 7900 1550
Connection ~ 7900 1550
Wire Wire Line
	7900 1550 7500 1550
Wire Wire Line
	8300 1650 8300 1550
Connection ~ 8300 1550
Wire Wire Line
	8300 1550 7900 1550
Wire Wire Line
	8700 1650 8700 1550
Connection ~ 8700 1550
Wire Wire Line
	8700 1550 8300 1550
$Comp
L Device:R_Small R1
U 1 1 5DA25B21
P 6300 5100
F 0 "R1" H 6241 5054 50  0000 R CNN
F 1 "10k" H 6241 5145 50  0000 R CNN
F 2 "Resistor_SMD:R_0603_1608Metric" H 6300 5100 50  0001 C CNN
F 3 "~" H 6300 5100 50  0001 C CNN
F 4 "TE Connectivity" H 0   0   50  0001 C CNN "Manufacturer"
F 5 "CRGH0603J10K" H 0   0   50  0001 C CNN "ManufacturerRef"
F 6 "0.038" H 0   0   50  0001 C CNN "Price"
F 7 "Farnell" H 0   0   50  0001 C CNN "Vendor"
F 8 "2331740" H 0   0   50  0001 C CNN "VendorRef"
	1    6300 5100
	1    0    0    1   
$EndComp
$Comp
L power:GND #PWR0103
U 1 1 5DA25B89
P 6300 5300
F 0 "#PWR0103" H 6300 5050 50  0001 C CNN
F 1 "GND" H 6305 5127 50  0000 C CNN
F 2 "" H 6300 5300 50  0001 C CNN
F 3 "" H 6300 5300 50  0001 C CNN
	1    6300 5300
	-1   0    0    -1  
$EndComp
Wire Wire Line
	6300 5200 6300 5300
Wire Wire Line
	6300 5000 6300 4900
Connection ~ 6300 4900
Wire Wire Line
	6300 4900 6550 4900
$Comp
L Device:R_Small R8
U 1 1 5DBEFA84
P 3950 5100
F 0 "R8" V 3754 5100 50  0000 C CNN
F 1 "64.9" V 3845 5100 50  0000 C CNN
F 2 "Resistor_SMD:R_0603_1608Metric" H 3950 5100 50  0001 C CNN
F 3 "~" H 3950 5100 50  0001 C CNN
F 4 "Vishay" H 0   0   50  0001 C CNN "Manufacturer"
F 5 "CRCW060364R9FKEA" H 0   0   50  0001 C CNN "ManufacturerRef"
F 6 "0.0214" H 0   0   50  0001 C CNN "Price"
F 7 "65" H 0   0   50  0001 C CNN "ValueIdeal"
F 8 "Farnell" H 0   0   50  0001 C CNN "Vendor"
F 9 "2141257" H 0   0   50  0001 C CNN "VendorRef"
	1    3950 5100
	0    -1   1    0   
$EndComp
$Comp
L Device:LED_Small D7
U 1 1 5DBEFC25
P 3550 5100
F 0 "D7" H 3550 4895 50  0000 C CNN
F 1 "red" H 3550 4986 50  0000 C CNN
F 2 "Diode_SMD:D_0603_1608Metric" V 3550 5100 50  0001 C CNN
F 3 "~" V 3550 5100 50  0001 C CNN
F 4 "Kingbright" H 0   0   50  0001 C CNN "Manufacturer"
F 5 "KPT-1608EC" H 0   0   50  0001 C CNN "ManufacturerRef"
F 6 "0.114" H 0   0   50  0001 C CNN "Price"
F 7 "Farnell" H 0   0   50  0001 C CNN "Vendor"
F 8 "2099221" H 0   0   50  0001 C CNN "VendorRef"
	1    3550 5100
	1    0    0    1   
$EndComp
$Comp
L power:GND #PWR0116
U 1 1 5DBEFD71
P 3250 5100
F 0 "#PWR0116" H 3250 4850 50  0001 C CNN
F 1 "GND" V 3255 4972 50  0000 R CNN
F 2 "" H 3250 5100 50  0001 C CNN
F 3 "" H 3250 5100 50  0001 C CNN
	1    3250 5100
	0    1    -1   0   
$EndComp
Wire Wire Line
	3250 5100 3450 5100
Wire Wire Line
	3650 5100 3850 5100
$Comp
L Device:R_Small R10
U 1 1 5DBF88FC
P 3950 5450
F 0 "R10" V 3754 5450 50  0000 C CNN
F 1 "64.9" V 3845 5450 50  0000 C CNN
F 2 "Resistor_SMD:R_0603_1608Metric" H 3950 5450 50  0001 C CNN
F 3 "~" H 3950 5450 50  0001 C CNN
F 4 "Vishay" H 0   0   50  0001 C CNN "Manufacturer"
F 5 "CRCW060364R9FKEA" H 0   0   50  0001 C CNN "ManufacturerRef"
F 6 "0.0214" H 0   0   50  0001 C CNN "Price"
F 7 "65" H 0   0   50  0001 C CNN "ValueIdeal"
F 8 "Farnell" H 0   0   50  0001 C CNN "Vendor"
F 9 "2141257" H 0   0   50  0001 C CNN "VendorRef"
	1    3950 5450
	0    -1   1    0   
$EndComp
$Comp
L Device:LED_Small D8
U 1 1 5DBF8902
P 3550 5450
F 0 "D8" H 3550 5245 50  0000 C CNN
F 1 "green" H 3550 5336 50  0000 C CNN
F 2 "Diode_SMD:D_0603_1608Metric" V 3550 5450 50  0001 C CNN
F 3 "~" V 3550 5450 50  0001 C CNN
F 4 "Kingbright" H 0   0   50  0001 C CNN "Manufacturer"
F 5 "KPT-1608CGCK" H 0   0   50  0001 C CNN "ManufacturerRef"
F 6 "0.181" H 0   0   50  0001 C CNN "Price"
F 7 "Farnell" H 0   0   50  0001 C CNN "Vendor"
F 8 "2099220" H 0   0   50  0001 C CNN "VendorRef"
	1    3550 5450
	1    0    0    1   
$EndComp
$Comp
L power:GND #PWR0117
U 1 1 5DBF8908
P 3250 5450
F 0 "#PWR0117" H 3250 5200 50  0001 C CNN
F 1 "GND" V 3255 5322 50  0000 R CNN
F 2 "" H 3250 5450 50  0001 C CNN
F 3 "" H 3250 5450 50  0001 C CNN
	1    3250 5450
	0    1    -1   0   
$EndComp
Wire Wire Line
	3250 5450 3450 5450
Wire Wire Line
	3650 5450 3850 5450
Wire Wire Line
	4050 5100 4400 5100
Wire Wire Line
	4400 5200 4300 5200
Wire Wire Line
	4300 5200 4300 5450
Wire Wire Line
	4300 5450 4050 5450
Text HLabel 6300 3400 2    50   Output ~ 0
SW_SHOOT
Wire Wire Line
	6300 3400 5800 3400
NoConn ~ 4400 3300
NoConn ~ 4400 3400
NoConn ~ 4400 3600
NoConn ~ 4400 3800
NoConn ~ 4400 3900
NoConn ~ 4400 4000
NoConn ~ 4400 4100
NoConn ~ 4400 4200
NoConn ~ 4400 4300
NoConn ~ 4400 4400
NoConn ~ 4400 4500
NoConn ~ 4400 4600
NoConn ~ 4400 4700
NoConn ~ 4400 4800
NoConn ~ 4400 4900
NoConn ~ 4400 5000
NoConn ~ 5800 5300
NoConn ~ 5800 5200
NoConn ~ 5800 5100
NoConn ~ 5800 5000
NoConn ~ 5800 4800
NoConn ~ 5800 4700
NoConn ~ 5800 4600
NoConn ~ 5800 4500
NoConn ~ 5800 4400
NoConn ~ 5800 4300
NoConn ~ 5800 4200
NoConn ~ 5800 4100
NoConn ~ 5800 3900
NoConn ~ 5800 3800
NoConn ~ 5800 3600
NoConn ~ 5800 3500
NoConn ~ 5800 3300
NoConn ~ 5800 3200
NoConn ~ 5800 2800
NoConn ~ 5800 2700
NoConn ~ 5800 2600
NoConn ~ 5800 2500
NoConn ~ 5800 2400
NoConn ~ 5800 2300
NoConn ~ 5800 2200
$Comp
L power:PWR_FLAG #FLG0101
U 1 1 5DC67772
P 3950 2700
F 0 "#FLG0101" H 3950 2775 50  0001 C CNN
F 1 "PWR_FLAG" V 3950 2828 50  0000 L CNN
F 2 "" H 3950 2700 50  0001 C CNN
F 3 "~" H 3950 2700 50  0001 C CNN
	1    3950 2700
	0    1    1    0   
$EndComp
Connection ~ 3950 2700
Wire Wire Line
	3950 2700 3950 2800
$Comp
L power:PWR_FLAG #FLG0102
U 1 1 5DC677B6
P 3400 2700
F 0 "#FLG0102" H 3400 2775 50  0001 C CNN
F 1 "PWR_FLAG" V 3400 2828 50  0000 L CNN
F 2 "" H 3400 2700 50  0001 C CNN
F 3 "~" H 3400 2700 50  0001 C CNN
	1    3400 2700
	0    1    1    0   
$EndComp
Connection ~ 3400 2700
Wire Wire Line
	3400 2700 3400 2500
NoConn ~ 4400 5300
$EndSCHEMATC
