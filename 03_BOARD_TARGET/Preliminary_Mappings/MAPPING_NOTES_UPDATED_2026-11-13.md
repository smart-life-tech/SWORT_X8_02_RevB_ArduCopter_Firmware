# Mapping notes — updated using the 9-Nov exports

## Input cross-check
- `SCH_09NOV.net` and `PCB_09NOV.net` each contain 99 net blocks.
- All 99 net names are present in both files, and the parsed component-reference/pin membership for each net matches exactly between the schematic and PCB exports.
- These 9-Nov exports now supersede the 4-Nov exports for pin-level firmware mapping. The original 4-Nov exports remain in this package for history.

## Proposed serial order
Candidate ArduPilot `SERIAL_ORDER` for owner review:

```text
SERIAL_ORDER EMPTY UART7 USART1 USART3 UART4
```

This yields the proposed logical mapping:
- SERIAL0: EMPTY. There is no native STM32 OTG_FS USB connection in the netlist; USB-C D+/D- terminate at the CP2102N USB-to-UART bridge.
- SERIAL1: UART7 on PE7/PE8, through CP2102N. Custom AP_Bootloader update path and runtime serial service.
- SERIAL2: USART1 on CN2 (PA9/PA10). Candidate GPS1 in normal operation; the same port remains available for STM32 ROM recovery when the GPS cable is disconnected and BOOT0 is asserted. It cannot serve GPS and a recovery adapter simultaneously.
- SERIAL3: USART3 on CN4 (PD8/PD9), connector nets explicitly named COMPANION_TX_EXT / COMPANION_RX_EXT. Proposed companion/telemetry port.
- SERIAL4: UART4 on CN5 (PD0/PD1), connector nets explicitly named CRSF_TX / CRSF_RX. Proposed CRSF RC receiver port.

The proposed order is not committed to `hwdef.dat` until owner confirms the CN2 dual-use GPS/recovery interpretation and CN4 protocol.

## ESC/AUX timer candidates
- ESC1 PB1 -> TIM3_CH4; ESC6 PB0 -> TIM3_CH3.
- ESC2 PE11 -> TIM1_CH2; ESC3 PE13 -> TIM1_CH3; ESC4 PE14 -> TIM1_CH4; ESC5 PA8 -> TIM1_CH1.
- ESC7 PD14 -> TIM4_CH3; ESC8 PD15 -> TIM4_CH4.
- AUX1..AUX4 on PC6..PC9 can be assigned TIM8_CH1..CH4 as a collision-avoiding candidate, keeping them off the TIM3_CH3/CH4 alternate-function channels used by ESC1/ESC6.
- This is a timer-mux candidate, not proof of DShot. The ArduPilot hwdef/DMA resolver must validate timer DMA requests, streams, conflicts and output groups on the exact Copter-4.7.2 source before the final protocol or DShot rate is selected.
- Conventional PWM is the recommended first assembled-board bench configuration, subject to compiled target validation.

## Connector details and limitations
- ESC/AUX signal connectors: CN3 and CN6-CN16 use pin 1 GND and pin 3 signal through R20-R31. Pin 2 does not appear in any net in either 9-Nov export; do not assume it carries +5V.
- CN2: pin 1 +5V, pin 2 PA9/USART1_TX, pin 3 PA10/USART1_RX, pin 4 GND.
- CN4: pin 1 GND, pin 2 companion TX, pin 3 companion RX, pin 4 GND.
- CN5: pin 1 +5V, pin 2 CRSF_TX, pin 3 CRSF_RX, pin 4 GND.
- No connector/net is explicitly labelled GPS in the 9-Nov exports. CN2 is the only additional exposed full-duplex UART connector candidate with +5V/GND, so GPS1 is proposed there only as a dual-use option with ROM recovery.

## IMU part-number discrepancy
- Both 9-Nov netlists still describe U2/U3 component parts as ICM-42688-P.
- The user's direction is to use the available stock ICM-42670-P devices. The alternative-IMU assessment indicates package/pin compatibility, but the released BOM/schematic designation must be formally updated/approved outside the firmware task. Firmware will be configured for ICM-42670-P only if that is the physically populated part.

## Other target items
- MCU: STM32H743VIT6 (2 MB internal flash); 25 MHz HSE crystal X2 at PH0/PH1; 32.768 kHz LSE X1 at PC14/PC15.
- Dual IMU SPI/CS/interrupt nets are explicit in the 9-Nov exports.
- QSPI flash U6 is W25Q128JVSIQ: QSPI CS PB6, CLK PB2, IO0 PD11, IO1 PD12, IO2 PE2, IO3 PD13. This documents the connection, but a suitable ArduPilot external-flash/logging backend still must be selected or implemented; the presence of QSPI pins alone does not enable DataFlash logging.
- I2C sensor bus is PB10/PB11 (SCL/SDA), which map to STM32H743 I2C2, with MS5611 and RM3100 devices. The candidate hwdef selects I2C2; bus/address detection still needs confirmation from the actual component strapping/datasheets and assembled board.
- SWD tag-connect U9: PA13 SWDIO, PA14 SWCLK, NRST.
- CN2 PA9/PA10 are USART1 pins and are the proposed STM32 ROM-recovery UART; recovery requires correct BOOT0/reset entry sequence and an assembled-board test.

## Still not ready for flashing
The netlists remove the missing-input blocker, but the following remain before a verified release: run the DMA/timer resolver on the exact source; settle board ID and flash reservation; confirm sensor rotations and IMU populations; define QSPI logging/storage behaviour; agree GPS dual-use at CN2 and CN4 role; write the actual hwdef files; compile both images and test on assembled hardware.
