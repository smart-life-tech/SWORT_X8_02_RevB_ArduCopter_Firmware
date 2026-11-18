# SWORT-X8-02 Rev-B — ArduCopter firmware work package

**Package status: PRELIMINARY ENGINEERING HANDOFF — NOT A FLASHABLE FIRMWARE RELEASE.**

This package consolidates the supplied Rev-B hardware/manufacturing evidence and firmware-target preparation artifacts. The original delivery archives did not contain an SWORT ArduPilot repository, board definitions, a bootloader binary, or a compiled `.apj`/`.bin` image. A Copter-4.7.2 source snapshot and candidate SWORT target definitions have since been added to this working copy. The owner approved the proposed APJ board ID 7150 and 128 KB bootloader reservation; the target has not been built or hardware-validated.

## Contents

- `01_BOARD_REFERENCE/`: extracted M1/M2 records for convenient review. The original archives remain unmodified in `08_ORIGINAL_INPUT_ARCHIVES/`.
- `02_UPSTREAM_BASELINE/`: exact ArduPilot baseline and upstream source checks.
- `03_BOARD_TARGET/Preliminary_Mappings/`: provisional ESC/AUX, dual-IMU and serial-port tables.
- `03_BOARD_TARGET/hwdef_PENDING/`: target review status and remaining validation requirements.
- `04_BOOTLOADER/`: SWD, ROM bootloader and custom ArduPilot bootloader path separation.
- `05_BUILD/`: upstream fetch/build procedure to use after target files are completed.
- `06_VALIDATION/`: pre-assembly and assembled-board validation checklist.
- `07_ENGINEERING_REVIEWS/`: 12-Nov stackup and alternative-IMU reports.
- `08_ORIGINAL_INPUT_ARCHIVES/`: original uploaded ZIPs, preserved unchanged.
- `09_MANIFEST/`: SHA-256 manifest for this package.

## Input-file audit

1. The standalone `SCH_09NOV.net` and `PCB_09NOV.net` files were subsequently supplied on 13-Nov-2026 and added to `01_BOARD_REFERENCE/Netlists_and_Schematic/`. Both exports contain 99 net groups and their parsed per-net component-pin membership matches exactly. They are now the primary pin-level evidence for the mapping tables.
2. `DELIVRABLES.zip` is the M1 handoff. Its extracted schematic and PCB netlists are dated **4 November 2026**.
3. `SWORT_M2.zip` is the fuller M2 package dated **8 November 2026**. It contains the native EasyEDA project, Gerber, BOM/CPL, assembly notes, reports and manufacturing evidence. The standalone 9-Nov exports were supplied separately and are now included in this package; no ArduPilot firmware source was supplied.
4. `SWORT_M2_Delivery(1).zip` is an earlier/smaller M2 snapshot. It is preserved for traceability, but the 8-Nov archive is the fuller M2 package.
5. The 12-Nov ICM-42670-P assessment also references the 9-Nov netlists; its MPN recommendation remains a proposed alternative. The 9-Nov netlists themselves still label U2/U3 as ICM-42688-P, while the user has selected the stock ICM-42670-P for firmware configuration.

The working-copy source snapshot was fetched from ArduPilot `Copter-4.7.2` (`fb7735678960`). Its own Git metadata and Waf submodule are not present; use a clean upstream checkout for source-level validation and builds.

## Confirmed/provisional technical baseline

- MCU: STM32H743VIT6.
- External high-speed crystal: X2, 25 MHz, to PH0/PH1; RTC crystal X1, 32.768 kHz, to PC14/PC15 (confirmed in the 9-Nov schematic netlist).
- QSPI flash: W25Q128JV; GPIO/net signals in the 4-Nov netlist include PB2 clock, PB6 CS, PD11/PD12/PD13 data IO0/IO1/IO3 and PE2 IO2. The netlist confirms the physical connection, but does not itself select an ArduPilot QSPI logging backend.
- Dual IMU pin map confirmed by the 9-Nov netlists and cross-referenced against the 12-Nov alternative-IMU assessment: IMU1 SPI1 PA4–PA7, INT1 PC12, INT2 PC11; IMU2 SPI2 PB12–PB15, INT1 PC10, INT2 PA15.
- The user has confirmed ICM-42670-P is fitted at both U2 and U3 and selected it for firmware. The 9-Nov netlists/BOM-era component labels still say ICM-42688-P, so the production BOM and component designation must be reconciled. The parts are not performance-equivalent.
- ArduCopter upstream baseline: `Copter-4.7.2`, abbreviated commit shown by the upstream release listing as `fb77356`, released 11-Oct-2026.
- The exact Copter-4.7.2 Invensense v3 source contains the `ICM42670` device type, its dedicated configuration path, and explicit code that excludes ICM-42670 from high-resolution FIFO mode because that mode is marked not working. That same function sets 1,600 Hz backend/sample rates, gyro ±2,000 dps, accel ±16 g, gyro AAF/LPF configuration, and accel LPF at 180 Hz.

## Current target and remaining checks

1. Complete clean-source application configuration and verify timer/output-group behavior for the eight PWM and four AUX outputs.
2. Reconcile the production BOM labels with the user's confirmation that U2/U3 are ICM-42670-P.
3. Verify MS5611/RM3100 I2C discovery and QSPI external-firmware-flash access on assembled hardware.
4. Test SWD, USART1 ROM recovery, UART7 custom-bootloader updates, both IMUs, and all PWM outputs on an assembled board.
5. If a compiled release is later requested, build from a clean pinned checkout, then inspect and hash the actual outputs.

Candidate files are in `ardupilot/libraries/AP_HAL_ChibiOS/hwdef/SWORT_X8_REV_B/`. The bootloader hwdef generator passed; application hwdef generation reached the bootloader-embedding check but stopped because no bootloader binary has been built. Neither image has been built or hardware-validated, so do not treat these files as a flashable release. No schematic, PCB, BOM, CPL or Gerber changes are made by this work package.
