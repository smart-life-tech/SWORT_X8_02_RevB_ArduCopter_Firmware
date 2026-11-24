# Board target files — candidate pending review

The 9-Nov-2026 schematic and PCB netlists have been cross-checked. Their 99 net groups match exactly at the parsed component-pin level. Candidate `hwdef.dat`, `hwdef-bl.dat`, and `defaults.parm` files now exist in `ardupilot/libraries/AP_HAL_ChibiOS/hwdef/SWORT_X8_REV_B/`, based on documented mappings and owner confirmations. These are review drafts, not release-ready target files.

The candidate selects ICM-42670-P for both IMUs, provides provisional OctaQuad X defaults with both IMUs enabled and EKF3 selected, uses conventional PWM, and maps the confirmed serial roles. The I2C2 bus has an explicit MS5611 declaration at `0x77`; compass probing is enabled on that internal bus. Hardware detection still requires assembled-board validation. QSPI is configured as 16 MB external firmware storage, not as a DataFlash logger. The owner approved APJ board ID 7150 and the STM32H743 internal-flash layout reserving the first 128 KB for the bootloader. These approvals do not certify the target or its flashability.

## Provisional X8 defaults

| Parameter | Value | Purpose |
|---|---:|---|
| `AHRS_ORIENTATION` | 6 | Overall board mounting rotation, Yaw270 |
| `FRAME_CLASS` | 4 | OctaQuad |
| `FRAME_TYPE` | 1 | X configuration |
| `MOT_PWM_TYPE` | 0 | Normal PWM |
| `INS_USE` | 1 | Enable IMU1 |
| `INS_USE2` | 1 | Enable IMU2 |
| `EK3_ENABLE` | 1 | Enable EKF3 |
| `AHRS_EKF_TYPE` | 3 | Select EKF3 |
| `EK3_IMU_MASK` | 3 | Run EKF3 lanes for both IMUs |
| `EK3_PRIMARY` | 0 | Select the first EKF3 lane as primary |

Both IMUs are declared `ROTATION_NONE`, so no individual rotation is applied relative to the PCB axes. `AHRS_ORIENTATION 6` separately applies the board mounting rotation and must be retained only if it matches the installed flight-controller orientation. Confirm the IMU package orientations and successful startup of both EKF3 lanes, including processor and memory headroom, during bring-up.

## Provisional X8 motor/output assignment

The motor numbering follows the ArduCopter 4.7.2 OctaQuad X motor matrix, interleaving upper and lower motors at each corner. The harness must be wired to this assignment and verified on the assembled aircraft.

| Motor | Aircraft position | Rotation | Board connector | PWM output |
|---:|---|---|---|---:|
| 1 | Front right, upper | CCW | ESC1 / CN3 | 1 |
| 2 | Front right, lower | CW | ESC2 / CN6 | 2 |
| 3 | Rear right, upper | CW | ESC3 / CN7 | 3 |
| 4 | Rear right, lower | CCW | ESC4 / CN8 | 4 |
| 5 | Rear left, upper | CCW | ESC5 / CN9 | 5 |
| 6 | Rear left, lower | CW | ESC6 / CN10 | 6 |
| 7 | Front left, upper | CW | ESC7 / CN11 | 7 |
| 8 | Front left, lower | CCW | ESC8 / CN12 | 8 |

The auxiliary PWM outputs are:

| Output | Connector | MCU pin | PWM channel |
|---|---|---|---:|
| AUX1 | CN13 | PC6 | 9 |
| AUX2 | CN14 | PC7 | 10 |
| AUX3 | CN15 | PC8 | 11 |
| AUX4 | CN16 | PC9 | 12 |

DShot validation is outside this configuration and commissioning scope. Verify motor order and direction with ArduPilot motor testing and all propellers removed before any propeller-on test.

## Sensor initialization and I2C probing

### MS5611 barometer

The schematic identifies U7 as an MS5611-01BA03 on I2C2 (PB10 SCL, PB11 SDA), strapped for address `0x77`. Since I2C2 is the only bus in `I2C_ORDER`, it is logical bus 0. The HWDEF declares `BARO MS5611 I2C:0:0x77`; a new build is required for this declaration to appear in the generated `hwdef.h` barometer probe list. Inspect that generated list after building. Physical detection and valid pressure/temperature readings remain subject to assembled-board validation.

### PNI RM3100 compass

The PNI 13104 XY coils, 13156 MagI2C ASIC, and 13101 Z coil form the three-axis RM3100 sensor suite. The ASIC is connected to I2C2/logical bus 0, with address `0x20` expected from the low address straps. `HAL_I2C_INTERNAL_MASK 1` marks bus 0 internal, and `AP_COMPASS_PROBING_ENABLED 1` enables generic compass probing, including internal-bus probing. The generic RM3100 path scans `0x20` through `0x23`; no explicit `COMPASS RM3100` declaration is required for this path. This configures probing but does not prove detection. Confirm compass orientation, detection, calibration, and magnetic-interference behavior on the assembled board.

Before a build or flash, complete these checks:

1. Review APJ board ID 7150 and the 128 KB bootloader reservation/application layout.
2. Complete source-level application configuration and verify timer/output-group behavior. The bootloader hwdef generator passed; application hwdef generation parsed the target and wrote its DMA map, then stopped because the expected bootloader binary is absent while `AP_BOOTLOADER_FLASHING_ENABLED` is enabled. No firmware build was run. After a successful build, inspect `processed_defaults.parm` and the generated `hwdef.h` probe list.
3. Confirm the fitted U2/U3 parts against the production BOM; the 9-Nov netlists still label ICM-42688-P.
4. Confirm I2C device detection/addressing for the MS5611 and RM3100 on an assembled board.
5. Confirm both IMUs and both EKF3 lanes start successfully; verify motor order, direction, and PWM outputs with all propellers removed.
6. Test SWD, USART1 ROM recovery, UART7 custom-bootloader updates, and QSPI external-flash access on the assembled board.

The current source snapshot lacks its own Git metadata and the Waf submodule, so use a clean Copter-4.7.2 checkout for source-level configuration and builds. No firmware or bootloader image has been built.
