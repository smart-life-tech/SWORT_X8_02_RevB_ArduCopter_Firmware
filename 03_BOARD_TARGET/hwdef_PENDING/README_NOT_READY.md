# Board target files — candidate pending review

The 9-Nov-2026 schematic and PCB netlists have been cross-checked. Their 99 net groups match exactly at the parsed component-pin level. Candidate `hwdef.dat`, `hwdef-bl.dat`, and `defaults.parm` files now exist in `ardupilot/libraries/AP_HAL_ChibiOS/hwdef/SWORT_X8_REV_B/`, based on documented mappings and owner confirmations. These are review drafts, not release-ready target files.

The candidate selects ICM-42670-P for both IMUs, sets the whole-board default orientation to 90 degrees counterclockwise through the runtime-adjustable `AHRS_ORIENTATION` parameter, and supplies provisional OctaQuad X defaults with both IMUs enabled for EKF3. It uses conventional PWM and maps the confirmed serial roles. The I2C2 bus has an explicit MS5611 declaration at `0x77`; sensor detection still requires assembled-board validation. QSPI is configured as 16 MB external firmware storage, not as a DataFlash logger. The owner approved APJ board ID 7150 and the STM32H743 internal-flash layout reserving the first 128 KB for the bootloader. These approvals do not certify the target or its flashability.

Before a build or flash, complete these checks:

1. Review APJ board ID 7150 and the 128 KB bootloader reservation/application layout.
2. Complete source-level application configuration and verify timer/output-group behavior. The bootloader hwdef generator passed; application hwdef generation parsed the target and wrote its DMA map, then stopped because the expected bootloader binary is absent while `AP_BOOTLOADER_FLASHING_ENABLED` is enabled. No build was run.
3. Confirm the fitted U2/U3 parts against the production BOM; the 9-Nov netlists still label ICM-42688-P.
4. Confirm I2C device detection/addressing for the MS5611 and RM3100 on an assembled board.
5. Test SWD, USART1 ROM recovery, UART7 custom-bootloader updates, both IMUs, PWM outputs, and QSPI external-flash access on the assembled board.

The current source snapshot lacks its own Git metadata and the Waf submodule, so use a clean Copter-4.7.2 checkout for source-level configuration and builds. No firmware or bootloader image has been built.
