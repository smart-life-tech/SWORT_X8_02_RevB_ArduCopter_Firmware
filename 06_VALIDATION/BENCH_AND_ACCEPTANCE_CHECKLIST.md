# SWORT-X8-02 Rev-B firmware validation checklist

## A. Before assembly / static checks

- [ ] Obtain final 9-Nov schematic and PCB netlists; confirm they are the intended production Rev 7 source.
- [ ] Compare every MCU net in `hwdef.dat` against the final schematic and PCB netlists.
- [ ] Verify all eight ESC and four AUX pin alternate functions on STM32H743VIT6.
- [ ] Map timer instance/channel, complementary channel use, timer clock, DMA stream/request and channel conflicts.
- [ ] Confirm PWM support per output. Confirm DShot capability per output only after the timer/DMA audit and ArduPilot/ChibiOS backend review.
- [ ] Verify SPI1/SPI2 device definitions, CS polarity, SPI mode/clock and EXTI interrupt lines for both IMUs.
- [ ] Confirm QSPI flash topology and whether it is used for logging/storage in this target.
- [ ] Confirm serial peripheral/pin assignments and approve `SERIAL_ORDER`; identify GPS port.
- [ ] Validate MCU clock sources and PLL tree against 25 MHz HSE / 32.768 kHz LSE design.
- [ ] Validate flash size, bootloader reservation, firmware flash layout, board ID and storage choices.
- [ ] Build ArduCopter and AP_Bootloader from one pinned source commit; archive logs and hashes.

## B. First power-up — props removed

- [ ] Current-limited supply; verify rails, reset, boot0 default and absence of abnormal current.
- [ ] ST-LINK connects on U9 and can erase/program/read back.
- [ ] CN2 BOOT0 + USART1 route enters STM32 ROM bootloader and successfully performs a controlled flash operation.
- [ ] CP2102N enumerates and UART7 TX/RX loopback/console is clean.
- [ ] AP_Bootloader is reachable over UART7 and a test firmware update succeeds.
- [ ] Verify QSPI flash JEDEC ID, erase/write/readback and logging path.

## C. Dual IMU bench tests

- [ ] Enumerate U2/IMU1 on SPI1 and U3/IMU2 on SPI2 independently.
- [ ] Confirm each WHO_AM_I/device ID identifies ICM-42670-P if that alternative is owner-approved and fitted.
- [ ] Confirm INT1/INT2 polarity and interrupt activity on the intended MCU EXTI lines.
- [ ] Confirm FIFO data integrity and 1.6 kHz sensor ODR/backend behavior.
- [ ] Confirm no ICM-42670 high-resolution FIFO mode is enabled; upstream Copter-4.7.2 code marks that path not working.
- [ ] Check axes, orientation, offsets, temperature readout, calibration, independent health status and failover.
- [ ] Record gyro/accel noise, clipping, CPU load, bus errors and temperature.

## D. ESC / output bench tests

**Initial conservative bench configuration (not final protocol selection):** conventional PWM, begin at 50 Hz with nominal 1000–2000 microsecond command range, propellers removed, ESCs tested individually, current-limited bench supply and independent emergency power cutoff. Increase update rate only after ESC documentation and timer output behavior are verified.

- [ ] Verify each of the eight outputs independently at the connector pin and MCU pin.
- [ ] Verify output numbering/channel ordering and disarmed/failsafe levels.
- [ ] Verify timer group conflicts and PWM waveform quality across all outputs simultaneously.
- [ ] Verify DMA allocation and interrupt load if DShot is later selected.
- [ ] Test DShot rates only after capability is proven per channel and the ESC supports the chosen rate.
- [ ] Test four AUX outputs separately from the eight motor outputs.

## E. Serial / navigation tests

- [ ] UART7 through CP2102N: bidirectional traffic and custom bootloader update.
- [ ] USART1 on CN2: BOOT0 + ROM bootloader recovery.
- [ ] UART4 on CN5: CRSF receiver bidirectional signal and failsafe behavior.
- [ ] USART3 on CN4: companion/telemetry operation after protocol confirmation.
- [ ] GPS connector and peripheral mapping: pending final 9-Nov netlist; verify baud, protocol, power and PPS if applicable.

## F. Post-assembly / operational qualification

- [ ] Static IMU calibration and dual-sensor health.
- [ ] Motor-off vibration/noise baseline.
- [ ] Motor-on tethered vibration tests and per-motor correlation.
- [ ] Harmonic notch configuration from measured motor RPM/vibration data, not guessed values.
- [ ] Thermal and long-duration logging tests.
- [ ] Controlled flight test with conservative limits, then incremental envelope expansion.

**This checklist is not evidence of tests having passed. Check boxes only after collecting test results.**
