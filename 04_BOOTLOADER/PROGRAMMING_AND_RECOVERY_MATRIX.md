# Programming and recovery architecture — updated from 9-Nov netlists

| Path | Physical route | Firmware component | Current disposition |
|---|---|---|---|
| Initial programming | U9 Tag-Connect SWD: SWDIO PA13, SWCLK PA14, NRST | ST-LINK / SWD; no ArduPilot bootloader required for first flash | 9-Nov netlist confirms route; assembled-board test required |
| Normal updates | CP2102N U8 bridge: PE7 is MCU RX, PE8 is MCU TX; these pins are the UART7 pin pair | Custom ArduPilot AP_Bootloader with UART7 enabled in `hwdef-bl.dat` | Source configuration and compiled update test still required |
| Recovery | CN2: PA9 USART1_TX, PA10 USART1_RX; BOOT0 selection through SW6 | STM32H743 system-memory ROM bootloader via USART1 | GPS must be disconnected if CN2 is also used as the normal GPS port; assembled-board ROM boot test required |
| Alternate recovery | U9 SWD | ST-LINK / SWD | Retain as independent recovery path; test after assembly |

## Important distinction
- UART7 normal updates are intended to use the custom ArduPilot AP_Bootloader, not the STM32 factory ROM bootloader.
- USART1 on CN2 is intended for STM32 factory ROM recovery when BOOT0 is asserted and the MCU is reset. It is proposed as the runtime GPS1 port only when not being used by a recovery adapter.
- SWD remains available independently of both serial boot paths.

## Required assembled-board tests
1. ST-LINK connect, erase/program/verify, NRST and readback on U9.
2. Verify BOOT0 switch state and ROM boot entry; confirm USART1 PA9/PA10 polarity/logic levels and tool connection.
3. Confirm CP2102N enumerates on host, UART7 RX/TX direction, custom AP_Bootloader discovery and successful update.
4. Verify power interruption during update and recovery via USART1 or SWD.
5. Verify application runtime `SERIAL1` via CP2102N and selected SERIAL_ORDER.
