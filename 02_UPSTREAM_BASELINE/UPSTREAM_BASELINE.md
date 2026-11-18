# ArduPilot source baseline and driver check

## Selected source revision

- Project: ArduCopter
- Upstream repository: `https://github.com/ArduPilot/ardupilot.git`
- Release tag: `Copter-4.7.2`
- Release date: 11 October 2026
- Upstream release listing identifies abbreviated commit: `fb77356`
- Tag URL: `https://github.com/ArduPilot/ardupilot/tree/Copter-4.7.2`

The release date and tag/commit were checked against the upstream ArduPilot release listing. The release is a valid baseline candidate; this does not mean a SWORT target already exists.

## ICM-42670-P source check against the selected tag

Checked in `Copter-4.7.2`:

- `libraries/AP_InertialSensor/AP_InertialSensor_Invensensev3.h`
  - declares `Invensensev3_Type::ICM42670`;
  - declares `set_filter_and_scaling_icm42670()`.
- `libraries/AP_InertialSensor/AP_InertialSensor_Invensensev3.cpp`
  - maps the ICM42670 to `DEVTYPE_INS_ICM42670`;
  - excludes ICM42670 from the `highres_sampling` activation switch; the comment explicitly labels its 19-bit high-resolution mode as not working;
  - routes the ICM42670 through `set_filter_and_scaling_icm42670()`;
  - that function configures `backend_rate_hz = 1600`, `sampling_rate_hz = 1600`, gyro ODR 1.6 kHz / ±2000 dps, accelerometer ODR 1.6 kHz / ±16 g, gyro AAF configuration with gyro LPF disabled, and accelerometer LPF at 180 Hz.

Therefore, the 4.7.2 upstream driver has a dedicated ICM-42670 path. A new driver from scratch is not indicated by this source check. The board-specific SPI device declarations, CS/interrupt setup, sensor enumeration and two-instance behavior still require SWORT `hwdef.dat` work and hardware validation.

## Exact source links

- Release list: `https://github.com/ArduPilot/ardupilot/releases`
- Release notes: `https://github.com/ArduPilot/ardupilot/blob/Copter-4.7.2/ArduCopter/ReleaseNotes.txt`
- Invensense v3 header: `https://github.com/ArduPilot/ardupilot/blob/Copter-4.7.2/libraries/AP_InertialSensor/AP_InertialSensor_Invensensev3.h`
- Invensense v3 implementation: `https://github.com/ArduPilot/ardupilot/blob/Copter-4.7.2/libraries/AP_InertialSensor/AP_InertialSensor_Invensensev3.cpp`

## Important distinction

The upstream driver supports a 1.6 kHz ICM-42670 configuration in this release. The 400 Hz control-loop choice is a separate ArduPilot board/vehicle configuration decision and must be checked against CPU budget, scheduler behavior and the intended frame/ESC setup. Do not claim the full 400 Hz X8 flight-control profile is validated by merely confirming the sensor driver path.
