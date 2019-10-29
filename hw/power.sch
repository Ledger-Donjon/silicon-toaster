EESchema Schematic File Version 4
LIBS:emfi-cache
EELAYER 26 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 4 6
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
L power:GND #PWR024
U 1 1 5D9AE184
P 3500 5800
F 0 "#PWR024" H 3500 5550 50  0001 C CNN
F 1 "GND" H 3505 5627 50  0000 C CNN
F 2 "" H 3500 5800 50  0001 C CNN
F 3 "" H 3500 5800 50  0001 C CNN
	1    3500 5800
	1    0    0    -1  
$EndComp
Wire Wire Line
	3500 5800 3500 5700
$Comp
L Device:C_Small C?
U 1 1 5D9AE18B
P 4000 5500
AR Path="/5D965B6B/5D9AE18B" Ref="C?"  Part="1" 
AR Path="/5D9AE18B" Ref="C?"  Part="1" 
AR Path="/5D9AC0BF/5D9AE18B" Ref="C14"  Part="1" 
F 0 "C14" H 4092 5546 50  0000 L CNN
F 1 "2.2µ" H 4092 5455 50  0000 L CNN
F 2 "Capacitor_SMD:C_0603_1608Metric" H 4000 5500 50  0001 C CNN
F 3 "~" H 4000 5500 50  0001 C CNN
F 4 "Murata" H 0   0   50  0001 C CNN "Manufacturer"
F 5 "GRM188R61E225KA12D" H 0   0   50  0001 C CNN "ManufacturerRef"
F 6 "0.154" H 0   0   50  0001 C CNN "Price"
F 7 "Farnell" H 0   0   50  0001 C CNN "Vendor"
F 8 "1845734" H 0   0   50  0001 C CNN "VendorRef"
F 9 "25" H 0   0   50  0001 C CNN "Voltage"
	1    4000 5500
	1    0    0    -1  
$EndComp
Wire Wire Line
	4000 5700 4000 5600
$Comp
L Device:C_Small C?
U 1 1 5D9AE193
P 3000 5500
AR Path="/5D965B6B/5D9AE193" Ref="C?"  Part="1" 
AR Path="/5D9AE193" Ref="C?"  Part="1" 
AR Path="/5D9AC0BF/5D9AE193" Ref="C12"  Part="1" 
F 0 "C12" H 3092 5546 50  0000 L CNN
F 1 "2.2µ" H 3092 5455 50  0000 L CNN
F 2 "Capacitor_SMD:C_0603_1608Metric" H 3000 5500 50  0001 C CNN
F 3 "~" H 3000 5500 50  0001 C CNN
F 4 "Murata" H 0   0   50  0001 C CNN "Manufacturer"
F 5 "GRM188R61E225KA12D" H 0   0   50  0001 C CNN "ManufacturerRef"
F 6 "0.154" H 0   0   50  0001 C CNN "Price"
F 7 "Farnell" H 0   0   50  0001 C CNN "Vendor"
F 8 "1845734" H 0   0   50  0001 C CNN "VendorRef"
F 9 "25" H 0   0   50  0001 C CNN "Voltage"
	1    3000 5500
	1    0    0    -1  
$EndComp
Wire Wire Line
	4000 5700 3500 5700
Connection ~ 3500 5700
Wire Wire Line
	3500 5700 3500 5600
Wire Wire Line
	3500 5700 3000 5700
Wire Wire Line
	3000 5700 3000 5600
Wire Wire Line
	4000 5400 4000 5300
Wire Wire Line
	4000 5300 3800 5300
Wire Wire Line
	3200 5300 3000 5300
Wire Wire Line
	3000 5300 3000 5400
Connection ~ 3000 5300
Wire Wire Line
	4300 5300 4000 5300
Connection ~ 4000 5300
$Comp
L power:GND #PWR023
U 1 1 5D9AE1B3
P 3500 4700
F 0 "#PWR023" H 3500 4450 50  0001 C CNN
F 1 "GND" H 3505 4527 50  0000 C CNN
F 2 "" H 3500 4700 50  0001 C CNN
F 3 "" H 3500 4700 50  0001 C CNN
	1    3500 4700
	1    0    0    -1  
$EndComp
Wire Wire Line
	3500 4700 3500 4600
$Comp
L Device:C_Small C?
U 1 1 5D9AE1BA
P 4000 4400
AR Path="/5D965B6B/5D9AE1BA" Ref="C?"  Part="1" 
AR Path="/5D9AE1BA" Ref="C?"  Part="1" 
AR Path="/5D9AC0BF/5D9AE1BA" Ref="C13"  Part="1" 
F 0 "C13" H 4092 4446 50  0000 L CNN
F 1 "2.2µ" H 4092 4355 50  0000 L CNN
F 2 "Capacitor_SMD:C_0603_1608Metric" H 4000 4400 50  0001 C CNN
F 3 "~" H 4000 4400 50  0001 C CNN
F 4 "Murata" H 0   0   50  0001 C CNN "Manufacturer"
F 5 "GRM188R61E225KA12D" H 0   0   50  0001 C CNN "ManufacturerRef"
F 6 "0.154" H 0   0   50  0001 C CNN "Price"
F 7 "Farnell" H 0   0   50  0001 C CNN "Vendor"
F 8 "1845734" H 0   0   50  0001 C CNN "VendorRef"
F 9 "25" H 0   0   50  0001 C CNN "Voltage"
	1    4000 4400
	1    0    0    -1  
$EndComp
Wire Wire Line
	4000 4600 4000 4500
$Comp
L Device:C_Small C?
U 1 1 5D9AE1C2
P 3000 4400
AR Path="/5D965B6B/5D9AE1C2" Ref="C?"  Part="1" 
AR Path="/5D9AE1C2" Ref="C?"  Part="1" 
AR Path="/5D9AC0BF/5D9AE1C2" Ref="C11"  Part="1" 
F 0 "C11" H 3092 4446 50  0000 L CNN
F 1 "2.2µ" H 3092 4355 50  0000 L CNN
F 2 "Capacitor_SMD:C_0603_1608Metric" H 3000 4400 50  0001 C CNN
F 3 "~" H 3000 4400 50  0001 C CNN
F 4 "Murata" H 0   0   50  0001 C CNN "Manufacturer"
F 5 "GRM188R61E225KA12D" H 0   0   50  0001 C CNN "ManufacturerRef"
F 6 "0.154" H 0   0   50  0001 C CNN "Price"
F 7 "Farnell" H 0   0   50  0001 C CNN "Vendor"
F 8 "1845734" H 0   0   50  0001 C CNN "VendorRef"
F 9 "25" H 0   0   50  0001 C CNN "Voltage"
	1    3000 4400
	1    0    0    -1  
$EndComp
Wire Wire Line
	4000 4600 3500 4600
Connection ~ 3500 4600
Wire Wire Line
	3500 4600 3500 4500
Wire Wire Line
	3500 4600 3000 4600
Wire Wire Line
	3000 4600 3000 4500
Wire Wire Line
	4000 4300 4000 4200
Wire Wire Line
	4000 4200 3800 4200
Wire Wire Line
	3200 4200 3000 4200
Wire Wire Line
	3000 4200 3000 4300
Connection ~ 3000 4200
Wire Wire Line
	4300 4200 4000 4200
Connection ~ 4000 4200
Wire Wire Line
	2000 5300 3000 5300
Wire Wire Line
	2000 4200 3000 4200
Connection ~ 2000 4200
Wire Wire Line
	2000 4200 2000 5300
Text HLabel 1650 2500 0    50   Input ~ 0
5V
Text HLabel 4300 4200 2    50   Output ~ 0
3V3A
Text HLabel 4300 5300 2    50   Output ~ 0
3V3
Text HLabel 6050 2500 2    50   Output ~ 0
15V
$Comp
L mylib:MIC2288 U3
U 1 1 5D9C779C
P 3500 3050
F 0 "U3" H 3500 3415 50  0000 C CNN
F 1 "MIC2288" H 3500 3324 50  0000 C CNN
F 2 "Package_TO_SOT_SMD:SOT-23-5" H 3300 2750 50  0001 C CNN
F 3 "http://ww1.microchip.com/downloads/en/DeviceDoc/MIC2288-1A-1-point-2MHz-PWM-Boost-Converter-DS20006034B.pdf" H 3300 2750 50  0001 C CNN
F 4 "On Semiconductor" H 3500 3050 50  0001 C CNN "Manufacturer"
F 5 "MBRM140T3G" H 3500 3050 50  0001 C CNN "ManufacturerRef"
F 6 "Farnell" H 3500 3050 50  0001 C CNN "Vendor"
F 7 "1459068" H 3500 3050 50  0001 C CNN "VendorRef"
F 8 "0.329" H 0   0   50  0001 C CNN "Price"
	1    3500 3050
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR022
U 1 1 5D9C7DC7
P 3500 3550
F 0 "#PWR022" H 3500 3300 50  0001 C CNN
F 1 "GND" H 3505 3377 50  0000 C CNN
F 2 "" H 3500 3550 50  0001 C CNN
F 3 "" H 3500 3550 50  0001 C CNN
	1    3500 3550
	1    0    0    -1  
$EndComp
Wire Wire Line
	3500 3550 3500 3450
$Comp
L Device:L L2
U 1 1 5D9C9D5E
P 3500 2500
F 0 "L2" V 3690 2500 50  0000 C CNN
F 1 "10µ" V 3599 2500 50  0000 C CNN
F 2 "Inductor_SMD:L_1812_4532Metric" H 3500 2500 50  0001 C CNN
F 3 "https://psearch.en.murata.com/inductor/product/LQH43CN100K03%23.pdf" H 3500 2500 50  0001 C CNN
F 4 "Murata" V 3500 2500 50  0001 C CNN "Manufacturer"
F 5 "LQH43CN100K03L" V 3500 2500 50  0001 C CNN "ManufacturerRef"
F 6 "Farnell" V 3500 2500 50  0001 C CNN "Vendor"
F 7 "1515459" V 3500 2500 50  0001 C CNN "VendorRef"
F 8 "0.543" H 0   0   50  0001 C CNN "Price"
	1    3500 2500
	0    -1   -1   0   
$EndComp
Wire Wire Line
	3650 2500 4000 2500
Wire Wire Line
	4000 2950 3900 2950
Wire Wire Line
	3350 2500 3000 2500
Wire Wire Line
	3100 2950 3000 2950
Wire Wire Line
	3000 2950 3000 2500
Connection ~ 3000 2500
Wire Wire Line
	3000 2500 2600 2500
Text HLabel 1200 3050 0    50   Input ~ 0
20V_EN
Wire Wire Line
	1200 3050 3100 3050
Wire Wire Line
	4000 2950 4000 2500
$Comp
L Device:R_Small R5
U 1 1 5D9CD9C7
P 4650 2850
F 0 "R5" H 4709 2896 50  0000 L CNN
F 1 "22.1k" H 4709 2805 50  0000 L CNN
F 2 "Resistor_SMD:R_0603_1608Metric" H 4650 2850 50  0001 C CNN
F 3 "~" H 4650 2850 50  0001 C CNN
F 4 "" H 4650 2850 50  0001 C CNN "ValueIdeal"
F 5 "Multicomp" H 0   0   50  0001 C CNN "Manufacturer"
F 6 "MCWR06X2212FTL" H 0   0   50  0001 C CNN "ManufacturerRef"
F 7 "0.0038" H 0   0   50  0001 C CNN "Price"
F 8 "Farnell" H 0   0   50  0001 C CNN "Vendor"
F 9 "2694776" H 0   0   50  0001 C CNN "VendorRef"
	1    4650 2850
	1    0    0    -1  
$EndComp
$Comp
L Device:R_Small R6
U 1 1 5D9CDA45
P 4650 3250
F 0 "R6" H 4709 3296 50  0000 L CNN
F 1 "2k" H 4709 3205 50  0000 L CNN
F 2 "Resistor_SMD:R_0603_1608Metric" H 4650 3250 50  0001 C CNN
F 3 "~" H 4650 3250 50  0001 C CNN
F 4 "Multicomp" H 0   0   50  0001 C CNN "Manufacturer"
F 5 "MCWR06X2001FTL" H 0   0   50  0001 C CNN "ManufacturerRef"
F 6 "0.0038" H 0   0   50  0001 C CNN "Price"
F 7 "Farnell" H 0   0   50  0001 C CNN "Vendor"
F 8 "2447319" H 0   0   50  0001 C CNN "VendorRef"
	1    4650 3250
	1    0    0    -1  
$EndComp
Wire Wire Line
	6050 2500 5900 2500
Wire Wire Line
	4650 2500 4650 2750
Wire Wire Line
	4650 2950 4650 3050
Wire Wire Line
	4650 3050 3900 3050
Connection ~ 4650 3050
Wire Wire Line
	4650 3050 4650 3150
Wire Wire Line
	4650 3350 4650 3450
Wire Wire Line
	4650 3450 3500 3450
Connection ~ 3500 3450
Wire Wire Line
	3500 3450 3500 3350
$Comp
L Device:D_Schottky_Small D5
U 1 1 5D9CF949
P 4350 2500
F 0 "D5" H 4350 2295 50  0000 C CNN
F 1 "MBRM140T3" H 4350 2386 50  0000 C CNN
F 2 "Diode_SMD:D_Powermite_AK" V 4350 2500 50  0001 C CNN
F 3 "~" V 4350 2500 50  0001 C CNN
F 4 "On Semiconductor" H 4350 2500 50  0001 C CNN "Manufacturer"
F 5 "MBRM140T3" H 4350 2500 50  0001 C CNN "ManufacturerRef"
F 6 "Farnell" H 4350 2500 50  0001 C CNN "Vendor"
F 7 "1459068" H 4350 2500 50  0001 C CNN "VendorRef"
F 8 "0.329" H 0   0   50  0001 C CNN "Price"
	1    4350 2500
	-1   0    0    1   
$EndComp
Wire Wire Line
	4000 2500 4250 2500
Connection ~ 4000 2500
Wire Wire Line
	4650 2500 4450 2500
Connection ~ 4650 2500
$Comp
L Device:C_Small C?
U 1 1 5D9D0DAE
P 2600 2850
AR Path="/5D965B6B/5D9D0DAE" Ref="C?"  Part="1" 
AR Path="/5D9D0DAE" Ref="C?"  Part="1" 
AR Path="/5D9AC0BF/5D9D0DAE" Ref="C10"  Part="1" 
F 0 "C10" H 2692 2896 50  0000 L CNN
F 1 "2.2µ" H 2692 2805 50  0000 L CNN
F 2 "Capacitor_SMD:C_0603_1608Metric" H 2600 2850 50  0001 C CNN
F 3 "~" H 2600 2850 50  0001 C CNN
F 4 "Murata" H 0   0   50  0001 C CNN "Manufacturer"
F 5 "GRM188R61E225KA12D" H 0   0   50  0001 C CNN "ManufacturerRef"
F 6 "0.154" H 0   0   50  0001 C CNN "Price"
F 7 "Farnell" H 0   0   50  0001 C CNN "Vendor"
F 8 "1845734" H 0   0   50  0001 C CNN "VendorRef"
F 9 "25" H 0   0   50  0001 C CNN "Voltage"
	1    2600 2850
	1    0    0    -1  
$EndComp
Wire Wire Line
	3500 3450 2600 3450
Wire Wire Line
	2600 3450 2600 2950
Wire Wire Line
	2600 2750 2600 2500
Connection ~ 2600 2500
Wire Wire Line
	2000 2500 2000 4200
Wire Wire Line
	2000 2500 2600 2500
Wire Wire Line
	2000 2500 1650 2500
Connection ~ 2000 2500
Wire Wire Line
	5200 2850 5200 2500
Connection ~ 5200 2500
Wire Wire Line
	5200 2500 4650 2500
Wire Wire Line
	5200 3050 5200 3450
Wire Wire Line
	5200 3450 4650 3450
Connection ~ 4650 3450
$Comp
L Device:C_Small C?
U 1 1 5D9F0C97
P 5200 2950
AR Path="/5D965B6B/5D9F0C97" Ref="C?"  Part="1" 
AR Path="/5D9F0C97" Ref="C?"  Part="1" 
AR Path="/5D9AC0BF/5D9F0C97" Ref="C15"  Part="1" 
F 0 "C15" H 5292 2996 50  0000 L CNN
F 1 "22u" H 5292 2905 50  0000 L CNN
F 2 "Capacitor_SMD:C_0805_2012Metric" H 5200 2950 50  0001 C CNN
F 3 "~" H 5200 2950 50  0001 C CNN
F 4 "25" H 5200 2950 50  0001 C CNN "Voltage"
F 5 "Murata" H 5200 2950 50  0001 C CNN "Manufacturer"
F 6 "GRM21BR61E226ME44L" H 5200 2950 50  0001 C CNN "ManufacturerRef"
F 7 "Farnell" H 5200 2950 50  0001 C CNN "Vendor"
F 8 "1907510" H 5200 2950 50  0001 C CNN "VendorRef"
F 9 "0.436" H 5200 2950 50  0001 C CNN "Price"
	1    5200 2950
	1    0    0    -1  
$EndComp
$Comp
L Device:C_Small C?
U 1 1 5D9F2DBB
P 5900 2950
AR Path="/5D9F2DBB" Ref="C?"  Part="1" 
AR Path="/5D9AC0BF/5D9F2DBB" Ref="C16"  Part="1" 
F 0 "C16" H 5808 2904 50  0000 R CNN
F 1 "100n" H 5808 2995 50  0000 R CNN
F 2 "Capacitor_SMD:C_0603_1608Metric" H 5900 2950 50  0001 C CNN
F 3 "~" H 5900 2950 50  0001 C CNN
F 4 "Multicomp" H 3950 -2400 50  0001 C CNN "Manufacturer"
F 5 "Farnell" H 3950 -2400 50  0001 C CNN "Vendor"
F 6 "MC0603B104K250CT" H 3950 -2400 50  0001 C CNN "ManufacturerRef"
F 7 "1759037" H 3950 -2400 50  0001 C CNN "VendorRef"
F 8 "0.0477" H 3950 -2400 50  0001 C CNN "Price"
F 9 "25" H 5900 2950 50  0001 C CNN "Voltage"
	1    5900 2950
	-1   0    0    1   
$EndComp
Wire Wire Line
	5900 2850 5900 2500
Connection ~ 5900 2500
Wire Wire Line
	5900 2500 5200 2500
Wire Wire Line
	5900 3050 5900 3450
Wire Wire Line
	5900 3450 5200 3450
Connection ~ 5200 3450
Text Notes 4500 2250 0    50   ~ 0
Vout = 1.24 x (R5/R6 + 1)\nR6 <= 5k
Text Notes 5250 3150 0    50   ~ 0
330 µC
$Comp
L power:PWR_FLAG #FLG0103
U 1 1 5DC69FD7
P 5900 2500
F 0 "#FLG0103" H 5900 2575 50  0001 C CNN
F 1 "PWR_FLAG" H 5900 2674 50  0000 C CNN
F 2 "" H 5900 2500 50  0001 C CNN
F 3 "~" H 5900 2500 50  0001 C CNN
	1    5900 2500
	1    0    0    -1  
$EndComp
$Comp
L Regulator_Linear:LD1117S33TR_SOT223 U4
U 1 1 5DB84A7E
P 3500 4200
F 0 "U4" H 3500 4442 50  0000 C CNN
F 1 "LD1117S33TR_SOT223" H 3500 4351 50  0000 C CNN
F 2 "Package_TO_SOT_SMD:SOT-223-3_TabPin2" H 3500 4400 50  0001 C CNN
F 3 "http://www.st.com/st-web-ui/static/active/en/resource/technical/document/datasheet/CD00000544.pdf" H 3600 3950 50  0001 C CNN
F 4 "STMicroelectronics" H 0   0   50  0001 C CNN "Manufacturer"
F 5 "LD1117S33TR" H 0   0   50  0001 C CNN "ManufacturerRef"
F 6 "Farnell" H 0   0   50  0001 C CNN "Vendor"
F 7 "1202826" H 0   0   50  0001 C CNN "VendorRef"
F 8 "0.368" H 0   0   50  0001 C CNN "Price"
	1    3500 4200
	1    0    0    -1  
$EndComp
$Comp
L Regulator_Linear:LD1117S33TR_SOT223 U5
U 1 1 5DB84FCA
P 3500 5300
F 0 "U5" H 3500 5542 50  0000 C CNN
F 1 "LD1117S33TR_SOT223" H 3500 5451 50  0000 C CNN
F 2 "Package_TO_SOT_SMD:SOT-223-3_TabPin2" H 3500 5500 50  0001 C CNN
F 3 "http://www.st.com/st-web-ui/static/active/en/resource/technical/document/datasheet/CD00000544.pdf" H 3600 5050 50  0001 C CNN
F 4 "STMicroelectronics" H 0   0   50  0001 C CNN "Manufacturer"
F 5 "LD1117S33TR" H 0   0   50  0001 C CNN "ManufacturerRef"
F 6 "Farnell" H 0   0   50  0001 C CNN "Vendor"
F 7 "1202826" H 0   0   50  0001 C CNN "VendorRef"
F 8 "0.368" H 0   0   50  0001 C CNN "Price"
	1    3500 5300
	1    0    0    -1  
$EndComp
$EndSCHEMATC
