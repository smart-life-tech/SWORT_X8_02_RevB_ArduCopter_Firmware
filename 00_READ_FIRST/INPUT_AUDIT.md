# Uploaded source audit — updated 13-Nov-2026

| Input | Content / date | Firmware relevance |
|---|---|---|
| `SCH_09NOV.net` | Standalone schematic netlist, 9-Nov-2026 | Primary pin-level mapping evidence |
| `PCB_09NOV.net` | Standalone PCB netlist, 9-Nov-2026 | Cross-checks the schematic netlist connectivity |
| `SWORT_M2.zip` | M2 delivery with native EasyEDA project, Gerber, BOM/CPL, assembly notes, drawings and engineering reports | Manufacturing / component reference |
| `SWORT_M2_Delivery(1).zip` | Earlier/smaller M2 snapshot | Traceability only; superseded by fuller M2 archive |
| `DELIVRABLES.zip` | M1 handoff, 4-Nov netlists, schematic PDF, native project and engineering records | Historical design baseline |
| `SWORT_X8_RevB_ICM42670P_Alternative_IMU_Assessment_2026-11-12.docx` | ICM-42670-P alternative assessment | Confirms package/pin compatibility claimed by report; firmware still must match fitted MPN |
| `SWORT_X8_RevB_VT47_Stackup_Review_Report_2026-11-12.docx` | VT-47 manufacturing stackup review | Manufacturing-only context |

## 9-Nov netlist comparison
Both 9-Nov exports contain 99 net blocks. The net-name sets match, and the parsed component-reference/pin membership matches for all 99 nets. The new files replace the 4-Nov netlists as primary firmware pin-mapping evidence. This comparison is a connectivity cross-check only, not an ERC/DRC, CAM, electrical analysis, or physical validation.

## Firmware-source status
No SWORT ArduPilot repository, board-specific `hwdef.dat`, `hwdef-bl.dat`, compiled Copter image, or compiled bootloader was included in the uploaded source archives. This package therefore remains a preliminary engineering handoff, not a flashable firmware release.
