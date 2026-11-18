# Build guide — after board target completion

The original delivery archives did not include ArduPilot source code or a SWORT board target. This working copy now contains a source snapshot and candidate SWORT target definitions, but the snapshot has no independent Git metadata or Waf submodule. The owner approved board ID 7150 and a 128 KB bootloader reservation; target validation remains incomplete. Use a clean, supported ArduPilot checkout for configuration and builds, and do not treat approval of those two settings as approval to flash.

## 1. Fetch exact upstream source

```bash
git clone https://github.com/ArduPilot/ardupilot.git
cd ardupilot
git checkout Copter-4.7.2
git rev-parse --short HEAD
```

The checked-out short hash should resolve to the upstream release commit noted in `../02_UPSTREAM_BASELINE/UPSTREAM_BASELINE.md` (`fb77356`). If it does not, stop and resolve the source revision before building.

## 2. Add the completed SWORT target

Copy the completed board folder into:

`libraries/AP_HAL_ChibiOS/hwdef/SWORT_X8_REV_B/`

It must contain at least the finalized `hwdef.dat`; add `hwdef-bl.dat` for the bootloader target. Do not copy incomplete mappings from this work package as build-ready hardware definitions.

## 3. Configure and build ArduCopter

```bash
./waf configure --board SWORT_X8_REV_B
./waf copter
```

Review the complete compiler output and build directory. Save the build log and exact source hash with the release artifacts.

## 4. Configure and build the custom bootloader

```bash
./waf configure --board SWORT_X8_REV_B --bootloader
./waf bootloader
```

The `hwdef-bl.dat` must define the flash/reserved layout and approved UART/USB loader interfaces. For UART7 updates, make sure UART7 is explicitly represented in the bootloader `SERIAL_ORDER` configuration and then test it on the board.

## 5. Release outputs

Only after successful builds and review, package the outputs actually produced by the selected Waf target, typically including the application `.apj` and/or `.bin`, plus the AP_Bootloader `.bin`/`.hex` where generated. Record SHA-256 for every released image. Do not invent file names or include zero-byte placeholders.

## Current working-copy status

**No build has been run.** Candidate target files are in the vendored `ardupilot/libraries/AP_HAL_ChibiOS/hwdef/SWORT_X8_REV_B/` directory, with owner-approved board ID 7150 and a 128 KB H743 bootloader reservation. The bootloader hwdef generator passed; application hwdef generation stopped at the missing bootloader-binary check, so a clean-checkout application configuration and timer/output validation remain required. No `.apj`, `.bin`, `.hex`, or `.elf` is included.
