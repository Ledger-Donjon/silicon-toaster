EESchema Schematic File Version 4
LIBS:emfi-cache
EELAYER 26 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 3 6
Title "Electromagnetic Fault Injector"
Date "2019-10-29"
Rev "0.1"
Comp "Ledger"
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
Wire Wire Line
	5350 3150 5350 3050
$Comp
L Device:C_Small C?
U 1 1 5D9558F8
P 4550 3450
AR Path="/5D9558F8" Ref="C?"  Part="1" 
AR Path="/5D954DF1/5D9558F8" Ref="C9"  Part="1" 
F 0 "C9" V 4321 3450 50  0000 C CNN
F 1 "100n" V 4412 3450 50  0000 C CNN
F 2 "Capacitor_SMD:C_0603_1608Metric" H 4550 3450 50  0001 C CNN
F 3 "~" H 4550 3450 50  0001 C CNN
F 4 "Multicomp" H 2150 -1250 50  0001 C CNN "Manufacturer"
F 5 "Farnell" H 2150 -1250 50  0001 C CNN "Vendor"
F 6 "MC0603B104K250CT" H 2150 -1250 50  0001 C CNN "ManufacturerRef"
F 7 "1759037" H 2150 -1250 50  0001 C CNN "VendorRef"
F 8 "0.0477" H 2150 -1250 50  0001 C CNN "Price"
F 9 "25" H 0   0   50  0001 C CNN "Voltage"
	1    4550 3450
	0    1    1    0   
$EndComp
$Comp
L power:GND #PWR?
U 1 1 5D9558FF
P 4450 3450
AR Path="/5D9558FF" Ref="#PWR?"  Part="1" 
AR Path="/5D954DF1/5D9558FF" Ref="#PWR019"  Part="1" 
F 0 "#PWR019" H 4450 3200 50  0001 C CNN
F 1 "GND" V 4455 3322 50  0000 R CNN
F 2 "" H 4450 3450 50  0001 C CNN
F 3 "" H 4450 3450 50  0001 C CNN
	1    4450 3450
	0    1    1    0   
$EndComp
$Comp
L power:GND #PWR?
U 1 1 5D955905
P 5250 5350
AR Path="/5D955905" Ref="#PWR?"  Part="1" 
AR Path="/5D954DF1/5D955905" Ref="#PWR020"  Part="1" 
F 0 "#PWR020" H 5250 5100 50  0001 C CNN
F 1 "GND" H 5255 5177 50  0000 C CNN
F 2 "" H 5250 5350 50  0001 C CNN
F 3 "" H 5250 5350 50  0001 C CNN
	1    5250 5350
	1    0    0    -1  
$EndComp
Wire Wire Line
	6250 3450 7700 3450
Wire Wire Line
	6250 3550 7700 3550
NoConn ~ 4650 4150
NoConn ~ 4650 4350
NoConn ~ 4650 4550
NoConn ~ 6250 4450
NoConn ~ 6250 4550
NoConn ~ 6250 4650
NoConn ~ 6250 4750
NoConn ~ 6250 4850
NoConn ~ 6250 4150
NoConn ~ 6250 4050
NoConn ~ 6250 3950
NoConn ~ 6250 3850
NoConn ~ 6250 3750
NoConn ~ 6250 3650
Wire Wire Line
	3700 3850 4650 3850
Wire Wire Line
	3700 3750 4650 3750
$Comp
L Interface_USB:FT232RL U?
U 1 1 5D955925
P 5450 4150
AR Path="/5D955925" Ref="U?"  Part="1" 
AR Path="/5D954DF1/5D955925" Ref="U2"  Part="1" 
F 0 "U2" H 4850 5050 50  0000 C CNN
F 1 "FT232RL" H 5950 5050 50  0000 C CNN
F 2 "Package_SO:SSOP-28_5.3x10.2mm_P0.65mm" H 5450 4150 50  0001 C CNN
F 3 "http://www.ftdichip.com/Products/ICs/FT232RL.htm" H 5450 4150 50  0001 C CNN
F 4 "FTDI" H 0   0   50  0001 C CNN "Manufacturer"
F 5 "FT232RL" H 0   0   50  0001 C CNN "ManufacturerRef"
F 6 "Farnell" H 0   0   50  0001 C CNN "Vendor"
F 7 "1146032" H 0   0   50  0001 C CNN "VendorRef"
F 8 "4.05" H 0   0   50  0001 C CNN "Price"
	1    5450 4150
	1    0    0    -1  
$EndComp
Text HLabel 7700 3450 2    50   Output ~ 0
TX
Text HLabel 7700 3550 2    50   Input ~ 0
RX
$Comp
L power:+3V3 #PWR021
U 1 1 5D955BE4
P 5350 2950
F 0 "#PWR021" H 5350 2800 50  0001 C CNN
F 1 "+3V3" H 5365 3123 50  0000 C CNN
F 2 "" H 5350 2950 50  0001 C CNN
F 3 "" H 5350 2950 50  0001 C CNN
	1    5350 2950
	1    0    0    -1  
$EndComp
Wire Wire Line
	5550 3150 5550 3050
Wire Wire Line
	5550 3050 5350 3050
Wire Wire Line
	5350 2950 5350 3050
Connection ~ 5350 3050
Text HLabel 3700 3750 0    50   BiDi ~ 0
USBD+
Text HLabel 3700 3850 0    50   BiDi ~ 0
USBD-
Wire Wire Line
	5650 5150 5650 5250
Wire Wire Line
	5650 5250 5550 5250
Wire Wire Line
	4650 4850 4650 5250
Wire Wire Line
	5250 5150 5250 5250
Wire Wire Line
	5450 5150 5450 5250
Connection ~ 5450 5250
Wire Wire Line
	5450 5250 5250 5250
Wire Wire Line
	5550 5150 5550 5250
Connection ~ 5550 5250
Wire Wire Line
	5550 5250 5450 5250
Connection ~ 5250 5250
Wire Wire Line
	5250 5250 5250 5350
Wire Wire Line
	5250 5250 4650 5250
$EndSCHEMATC
