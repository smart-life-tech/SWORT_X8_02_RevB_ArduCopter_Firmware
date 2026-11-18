SWORT-X8-02 REV-B - MILESTONE 2 DELIVERY
Revision: 08-Nov-2026

MILESTONE SEPARATION
This archive contains Milestone 2 files only. The certified Milestone 1 DELIVRABLES.zip is a separate delivery and is not included, changed, or duplicated here.

FOLDER CONTENTS
01_CAD/Board.eprj2                    Editable EasyEDA Pro project.
02_FAB/Gerber.zip                    Single fabrication Gerber and NC drill archive.
03_ASM/BOM.xlsx                      One workbook with exactly two worksheets:
                                      1) BOM - the production BOM table (132 fitted references).
                                      2) Notes - 46 unique MPN sourcing records, origin evidence, procurement status,
                                         NDAA / ASDA / Section 889 screening scope, and assembly notes.
03_ASM/CPL.xlsx                      Single production pick-and-place/CPL file (132 fitted placements; U9 DNP).
03_ASM/Assembly_Notes.pdf            USB1 mixed-technology process, U9 DNP and L2 cleared disposition.
03_ASM/DRAWINGS/PCB_Drawings.pdf     Three-page EasyEDA PCB drawing export supplied 07-Nov-2026.
04_ENG/M2_Report.pdf                 Milestone 2 technical verification and manufacturing handoff report.
04_ENG/Source.pdf                   08-Nov-2026 sourcing / NDAA-oriented procurement supplement; this supplement updates
                                      and supersedes earlier sourcing-status interpretation where it differs.
04_ENG/ERC.txt                      Owner-provided schematic-side ERC/check log.
04_ENG/DRC.png                      PCB DRC screenshot.
04_ENG/Stackup.pdf                  Sierra preliminary FR408HR stackup printout.
04_ENG/USB90.png                    Valid 90-ohm differential impedance calculator result.
05_HASH/SHA256.txt                  Checksums for the delivered files (manifest excludes itself).

SOURCING / COMPLIANCE POLICY
The owner confirmed that the project follows applicable NDAA, American Security Drone Act / FASC, and Section 889 / covered-entity procurement restrictions; it does not impose a blanket prohibition on every PRC-manufactured electronic component. Catalogue country-of-origin entries are indicative only and are not lot-specific certificates. The BOM Notes sheet distinguishes public-origin flags, conflicting data, unknown origins, supply holds and design dispositions. Unknown origins remain pending and must not be represented as certified.

The sourcing review makes no design substitutions. All 46 unique manufacturer part numbers are retained in the approved BOM. ICM-42688-P at U2/U3 is identified as a P0 procurement hold due to current availability; secure the exact MPN through TDK / authorized distribution. USB1 GCT USB4215-03-A is retained; its catalogue-reported China origin is documented but is not an automatic redesign trigger under the clarified policy. L2 Coilcraft XGL5020-152MEC remains engineering-cleared and unchanged.

FORMAL SCREENING / PROCUREMENT GATES
The workbook and supplement record the preliminary public-name and legal-scope review. A complete dated exact/fuzzy CSL/FASC/SAM screen of every manufacturer, intended supplier, relevant aliases, ultimate parents, affiliates and final UAS manufacturer/assembler is still required before PO/contract award. Obtain actual shipment-lot CoO/CoC, date/lot codes and authorized-source traceability. DigiKey's general authorized-distributor and traceability statements are not lot-specific evidence; Marketplace items require seller/authorization validation. Obtain PNI direct OEM documentation for PNI parts.

Confirm the project-specific Sierra quotation/PO identifies the U.S. fabrication and assembly facility, assembly location and any subcontractors. Public Sierra product/terms pages are company-level evidence, not an order-specific manufacturing certificate.

PCB_DRAWINGS.PDF PAGE GUIDE
Page 1: top-side PCB drawing view.
Page 2: bottom-side PCB drawing view.
Page 3: additional PCB drawing view included exactly as exported by EasyEDA.
The PDF is retained in its original three-page order. The top/bottom CPL-derived placement maps are separate assembly reference documents. The native EasyEDA PCB and Gerber/NC drill archive remain authoritative for manufacturing geometry.

BOM / ASSEMBLY CONTROL
The BOM workbook has one production BOM worksheet and one Notes worksheet. The Notes worksheet contains one row per unique manufacturer part number, including supplier, catalogue COO evidence, regulatory screening context, sourcing status and procurement action. It also retains assembly-specific instructions. U9 remains DNP/no-pick and is excluded from production BOM/CPL.

USB1 (GCT USB4215-03-A) is a mixed-technology connector with 16 SMT electrical contacts and four through-hole shell retention stakes. CPL SMD=No is intentional for manual/secondary placement; paste/reflow the SMT contacts and separately solder the shell stakes using Sierra's validated process.

L2 purchasing MPN: Coilcraft XGL5020-152MEC. YSMC0320H-1R5MB is retained only as the legacy CAD library/device alias. L2 geometric fit is CLEARED and is not reopened by this sourcing review.

No component substitutions are authorized without written owner approval. Sierra Circuits retains final CAM, DFM, fabrication and assembly acceptance. This package is a manufacturing-review handoff, not a legal certification or lot-specific compliance certificate.
