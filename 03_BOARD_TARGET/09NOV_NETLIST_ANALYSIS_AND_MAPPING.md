# SWORT-X8-02 Rev-B — 9-Nov Netlist Analysis and Proposed Firmware Mapping

**Status: PRELIMINARY ENGINEERING MAPPING — NOT A FLASHABLE RELEASE**  
**Input files:** `SCH_09NOV.net` and `PCB_09NOV.net` supplied 13-Nov-2026.

## 1. Netlist integrity check
Both exports contain 99 net blocks. Net names and parsed component-pin membership match across all 99 nets. The files therefore cross-check the same connectivity at the extracted-netlist level. This is not an electrical rule check, PCB copper inspection or assembled-board test.

## 2. Processor and clock/storage interfaces
- U1: STM32H743VIT6, LQFP-100.
- X2: external 25 MHz crystal on PH0/PH1.
- X1: 32.768 kHz crystal on PC14/PC15.
- U6: W25Q128JVSIQ QSPI memory; CS PB6, CLK PB2, IO0 PD11, IO1 PD12, IO2 PE2, IO3 PD13.
- U9 SWD connector: SWDIO PA13, SWCLK PA14, NRST.
- BOOT0: U1 BOOT0 pin, switch SW6 and resistor network.

## 3. Dual IMU connection map
| Device | SPI | CS | SCK | MISO | MOSI | INT1 | INT2 |
|---|---|---|---|---|---|---|---|
| U2 / IMU1 | SPI1 | PA4 | PA5 | PA6 | PA7 | PC12 | PC11 |
| U3 / IMU2 | SPI2 | PB12 | PB13 | PB14 | PB15 | PC10 | PA15 |

**Part note:** the netlist component descriptions still say ICM-42688-P. The user's selected stock part is ICM-42670-P. Firmware must target the component actually populated; update/approve the BOM designation separately. Do not treat netlist device labels as proof of the new MPN.

## 4. Serial port proposal
| Connector / bridge | MCU UART | MCU RX | MCU TX | Netlist purpose | Proposed ArduPilot index |
|---|---|---|---|---|---|
| CP2102N U8 / USB-C | UART7 | PE7 | PE8 | USB virtual COM, custom bootloader update | SERIAL1 |
| CN2 | USART1 | PA10 | PA9 | GPS1 candidate in flight; STM32 ROM recovery with GPS disconnected | SERIAL2 |
| CN4 | USART3 | PD9 | PD8 | Companion / telemetry | SERIAL3 |
| CN5 | UART4 | PD0 | PD1 | CRSF RC receiver | SERIAL4 |

Candidate order: `SERIAL_ORDER EMPTY UART7 USART1 USART3 UART4`. SERIAL0 is reserved as EMPTY because the USB-C D+/D- lines connect to the CP2102N, not the STM32 native OTG_FS pins. Confirm the CN2 dual-use GPS/recovery arrangement and CN4 telemetry role before committing the order. The netlist has no connector explicitly labelled GPS.

## 5. ESC and AUX physical output map
| Channel | MCU pin | U1 pin | Connector | Connector signal pin | Series resistor | Timer candidate |
|---|---|---:|---|---:|---|---|
| ESC1 | PB1 | 35 | CN3 | 3 | R20 | TIM3_CH4 |
| ESC2 | PE11 | 41 | CN6 | 3 | R21 | TIM1_CH2 |
| ESC3 | PE13 | 43 | CN7 | 3 | R22 | TIM1_CH3 |
| ESC4 | PE14 | 44 | CN8 | 3 | R23 | TIM1_CH4 |
| ESC5 | PA8 | 67 | CN9 | 3 | R24 | TIM1_CH1 |
| ESC6 | PB0 | 34 | CN10 | 3 | R25 | TIM3_CH3 |
| ESC7 | PD14 | 61 | CN11 | 3 | R26 | TIM4_CH3 |
| ESC8 | PD15 | 62 | CN12 | 3 | R27 | TIM4_CH4 |
| AUX1 | PC6 | 63 | CN13 | 3 | R28 | TIM8_CH1 candidate |
| AUX2 | PC7 | 64 | CN14 | 3 | R29 | TIM8_CH2 candidate |
| AUX3 | PC8 | 65 | CN15 | 3 | R30 | TIM8_CH3 candidate |
| AUX4 | PC9 | 66 | CN16 | 3 | R31 | TIM8_CH4 candidate |

The proposed alternate-function selection keeps ESC1/ESC6 on TIM3_CH4/CH3 and AUX1-AUX4 on TIM8_CH1-CH4 to avoid assigning two pins to the same timer channel. PWM timer muxes are plausible from the STM32H743 pin alternate-function data. DShot is not yet certified: DMA stream/request assignment and ArduPilot output-group generation must be checked by the exact source build.

**Connector warning:** for CN3 and CN6-CN16, pin 1 is GND and pin 3 is signal. Pin 2 has no net assignment in either 9-Nov export. Do not assume it provides +5V.

## 6. Programming paths
- Initial programming: U9 SWD with ST-LINK (PA13/PA14/NRST).
- Normal application updates: CP2102N -> UART7 (PE7/PE8) -> custom ArduPilot AP_Bootloader compiled from `hwdef-bl.dat`.
- Recovery: CN2 USART1 PA9/PA10 with STM32 BOOT0/system-memory ROM bootloader, or SWD.

UART7 is not the STM32 ROM bootloader interface in the arrangement described here; it is the project AP_Bootloader path. This must be confirmed with the final `hwdef-bl.dat` and assembled-board update test.

## 7. Remaining work before the actual firmware package
1. Run ArduPilot's ChibiOS hwdef/DMA resolver and resolve all timer/DMA conflicts.
2. Assign a unique APJ board ID and approved flash reservation/layout.
3. Confirm U2/U3 are actually populated with ICM-42670-P; update BOM as required.
4. Confirm IMU rotations from PCB component orientation/layout.
5. Confirm CN2 GPS1 plus ROM recovery dual-use, and CN4 telemetry protocol.
6. Decide how/if the external W25Q128 QSPI flash is used for logging/storage.
7. Generate and validate `hwdef.dat` and `hwdef-bl.dat`; then compile the Copter and bootloader artifacts on the selected ArduPilot build environment.
8. Test both IMUs, all eight ESC outputs, AUX outputs, GPS, RC, telemetry, UART7 update and USART1 recovery on the assembled board.

No `.apj`, `.bin`, or bootloader image is included because no SWORT target has yet passed the source-level resolver/build. This is intentional; guessed binaries would be unsafe.
