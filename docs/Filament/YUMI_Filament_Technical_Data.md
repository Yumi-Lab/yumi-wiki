# YUMI Filaments — Technical Data & Print Settings

Print temperatures, tolerances and mechanical properties for the YUMI filament range, extracted from the official Technical Data Sheets and independent lab test reports. Use this page to set up a slicer profile or compare materials — for the certificates themselves (TDS/SDS/REACH/FDA/CE/RoHS), see the [Compliance & Certifications](YUMI_Filament_Compliance.md) page.

!!! note "Typical values vs. measured values"
    Sections 1–2 report **typical values** from the manufacturer's specification sheets — a starting point for slicer profiles, not a guaranteed minimum. Section 3 reports **actual measured values** from independent lab test reports (sample count, date and standard given for each), which is why they read as precise averages rather than round "typical" numbers.

---

## 1. Print Settings Quick Reference

Nozzle/bed/chamber temperatures, print speed, density and tolerance for the current YUMI catalog (TDS 2022).

| Material | Nozzle temp | Bed temp | Chamber temp | Print speed | Density (g/cm³) | Diameter tolerance | Nozzle Ø | Glass transition temp |
|---|---|---|---|---|---|---|---|---|
| PLA | 190–220°C | 40–60°C | 0–40°C | 60–80 mm/s | 1.23 | ±0.02 mm | 0.4 mm | 60–65°C |
| Silk | 195–205°C | 40–60°C | 0–40°C | 60–80 mm/s | 1.23 | ±0.02 mm | 0.4 mm | 60–65°C |
| Soft Material | 195–220°C | 40–60°C | 0–40°C | 60–80 mm/s | 1.20 | ±0.03 mm | 0.6 mm | 60–65°C |
| Gradient Silk | 195–205°C | 40–60°C | 0–40°C | 60–80 mm/s | 1.23 | ±0.02 mm | 0.4 mm | 60–65°C |
| Rapid Discoloration | 195–205°C | 40–60°C | 0–40°C | 60–80 mm/s | 1.23 | ±0.02 mm | 0.4 mm | 60–65°C |
| Wood | 195–205°C | 40–60°C | 0–40°C | 60–80 mm/s | 1.15 | ±0.02 mm | 0.5 mm | 60–65°C |
| Glitter PLA | 190–220°C | 40–60°C | 0–40°C | 60–80 mm/s | 1.23 | ±0.02 mm | 0.5 mm | 60–65°C |
| Luminous PLA | 195–220°C | 40–60°C | 0–40°C | 60–80 mm/s | 1.23 | ±0.02 mm | 0.4 mm | 60–65°C |
| Luminous Starry Sky | 195–220°C | 40–60°C | 0–40°C | 60–80 mm/s | 1.23 | ±0.02 mm | 0.5 mm | 60–65°C |
| Marble PLA | 195–220°C | 40–60°C | 0–40°C | 60–80 mm/s | 1.23 | ±0.02 mm | 0.4 mm | 60–65°C |
| Carbon Fiber PLA | 195–220°C | 40–60°C | 0–40°C | 60–80 mm/s | 1.21 | ±0.02 mm | 0.4 mm | 60–65°C |
| Water Soluble | 225–240°C | 30–60°C | 0–40°C | 60–80 mm/s | 1.23 | ±0.02 mm | 0.4 mm | 60–65°C |
| PVB | 205–225°C | 40–60°C | 0–40°C | 60–80 mm/s | 1.18 | ±0.02 mm | 0.4 mm | 50–55°C |
| ABS | 225–245°C | 80–90°C | 0–40°C | 60–80 mm/s | 1.10 | ±0.03 mm | 0.4 mm | 90–100°C |
| PETG | 210–245°C | 40–60°C | 0–40°C | 60–80 mm/s | 1.30 | ±0.02 mm | 0.4 mm | 88–90°C |
| PTFE | 240–260°C | 60–80°C | 0–40°C | 60–80 mm/s | 1.40 | ±0.02 mm | 0.4 mm | 60–65°C |
| PEEK / PEEK+CF | 400–450°C | ≥90°C | ≥90°C | 60–80 mm/s | 1.34 | ±0.05 mm | 0.5 mm | 240–260°C |
| Gradient PLA | 190–220°C | 40–60°C | 0–40°C | 60–80 mm/s | 1.23 | ±0.02 mm | 0.4 mm | 60–65°C |
| TPU 64D | 220–240°C | 40–60°C | 0–40°C | 60–80 mm/s | 1.18 | ±0.03 mm | 0.6 mm | −40°C |
| Orange Stick PLA | 190–220°C | 40–60°C | 0–40°C | 60–80 mm/s | 1.23 | ±0.03 mm | 0.6 mm | 60–65°C |
| Orange Stick PVB | 190–220°C | 40–60°C | 0–40°C | 60–80 mm/s | 1.18 | ±0.03 mm | 0.6 mm | 50–55°C |

*Source: [YUMI Filament TDS 2022 (EN)](pdf/YUMI_Filament_TDS_2022_EN.pdf){ target=_blank }.*

---

## 2. Material Properties — Core Range

Physical, mechanical and thermal properties for the eight most-used materials, as tested by the manufacturer. Diameter (all materials): nominal **1.75 mm ± 0.05 mm** or **3.00 mm ± 0.05 mm**, roundness ± 0.05 mm. Standard spool: 200 mm outer Ø, 32 mm inner Ø, 60 mm width, vacuum-sealed PE bag with desiccant. Package sizes: **M** 300 g / **XM** 500 g / **L** 1000 g net weight, all diameters, `SmartBag` security seal — except where noted.

### PLA (standard)

| Property | Value | Test method |
|---|---|---|
| Relative density | 1.24–1.25 g/cm³ | — |
| Tensile strength | 17–18 g (25 µm film) / >50 MPa | ASTM D1992 / GB/T 3682-2000 |
| Elongation at break | 4.6–5.3% | — |
| Bending strength | 230–240 kg/cm² | ASTM D790 / ISO 178 |
| Vicat softening point | 60–61°C | — |
| Melting index | 5–8 g/10min (200°C/5kg) | — |
| Melting point | 178°C | — |

### PLA PRO+ / PLA Silky / Color Mixed PLA

Same base formulation (lower-viscosity PLA blend, easier support removal), sold under different color/finish lines.

| Property | Value | Test method |
|---|---|---|
| Material density | 1.21–1.30 g/cm³ | GB/T 1033.1-1986 |
| Tensile strength | 17–18 g (25 µm) / ≥50 MPa | ASTM D1992 / GB/T 1040-1992 |
| Elongation at break | 4.6–5.3% | GB/T 1040.1-1992 |
| Impact intensity | 1–3 kJ/m² (Izod) | GB/T 1043-1992 |
| Vicat softening point | 61.5°C | GB/T 19466.2-2004 |
| Melting index | 4–6 g/10min (190°C/2.15kg) | GB/T 3682-2000 |
| Melting point | 178.5°C | GB/T 19466-2004 |
| Print temperature | 190–220°C, bed 0–40°C, fan off (max 20%) | — |

### PLA Wood

PLA with 10–15% bamboo powder filler — natural wood texture and scent, low blockage risk. Print below 200°C for best results.

| Property | Value | Test method |
|---|---|---|
| Material density | 1.02–1.1 g/cm³ | GB/T 1033.1-2008 |
| Tensile strength | 25–30 g (25 µm) | ASTM D1992 |
| Bending strength | 210–230 kg/cm² | ASTM D790 / ISO 178 |
| Elongation at break | 14% | GB/T 1040.1-2006 |
| Vicat softening point | 60–61.5°C | GB/T 19466.2-2004 |
| Melting index | 6–8 g/10min (200°C/5kg) | GB/T 3682-2000 |
| Melting point | 168°C | GB/T 19466-2004 |
| Print temperature | 180–200°C, bed 0–40°C, fan off (max 20%) | — |

### Water-Soluble (PVA-ester blend)

Supports material, compatible with PLA/ABS/PC. Dissolves faster in warmer water; stir and replace water as it saturates.

| Property | Value | Test method |
|---|---|---|
| Relative density | 1.25 g/cm³ | GB/T 1033.1-2008 |
| Tensile strength | 23.5 MPa | ISO 527 |
| Bending strength | 213–230 kg/cm² (45.5 MPa) | ASTM D790 / ISO 178 |
| Elongation at break | 19% | ISO 527 |
| Bond strength | 1.08 GPa | ASTM D790 / ISO 178 |
| Glass transition temp | 57.3°C | GB/T 19466.2-2004 |
| Vicat softening point | 59°C | GB/T 19466.2-2004 |
| Melting point | 168°C | GB/T 19466-2004 |
| Print temperature | 200–300°C, bed 0–40°C, fan off (max 20%) | — |

### PETG

Developed jointly with Sinopec Group. High transparency, high toughness, easy to print.

| Property | Value | Test method |
|---|---|---|
| Material density | 1.27 g/cm³ | ASTM D1505 |
| Tensile strength (yield / break) | 53 MPa / 26 MPa | ASTM D638 |
| Elongation at break | 70% | ASTM D638 |
| Flexural strength | 80 MPa | ASTM D790 |
| Flexural modulus | 2150 MPa | ASTM D790 |
| Izod impact strength | 90 J/m | ASTM D256 |
| Heat distortion temperature | 74°C | ASTM D648 |
| Vicat softening temperature | 83°C | ASTM D1525 |
| Transmittance | 89% | ASTM D1003 |
| Print temperature | 190–220°C, bed 0–40°C, fan off (max 20%) | — |

### TPU 64D

Produced by Wanhua Chemical, Shore hardness 64D. Diameter accuracy ±0.03 mm.

| Property | Value | Test method |
|---|---|---|
| Material density | 1.23 g/cm³ | ISO 1183 |
| Hardness | 64D | ISO 868 |
| 100% elongation modulus | 15 MPa | ISO 037 |
| 300% elongation modulus | 30 MPa | ISO 037 |
| Tensile strength | 45 MPa | ISO 037 |
| Ultimate elongation | 350% | ISO 037 |
| Tear strength | 160 kN/m | ISO 034 |
| Heat deformation temperature | 114°C | ASTM D648 |
| Print temperature | 220–240°C, bed 0–40°C, fan off (max 20%) | — |

### ABS

Co-developed with Sinopec, formulated for 3D printing: low warpage, glossy finish.

| Property | Value | Test method |
|---|---|---|
| Material density | 1.057 g/cm³ | GB/T 1033.1-2008 |
| Melt flow rate | 2.6 g/10min (200°C/2.16kg) | GB/T 3682-2000 |
| Glass transition temp | 106.7°C | GB/T 19466.3-2004 / ISO 11357-3 |
| Tensile strength at break | 33.2 MPa | GB/T 1040.2-2006 |
| Heat distortion temperature | 106°C | ASTM D648 |
| Load deformation temperature | 87°C | GB/T 1634.2-2004 |
| Rockwell hardness | R108 | GB/T 3398.2-2008 / ISO 2039-2 |
| Bending modulus | 2260 MPa | GB/T 9341-2008 / ISO 178 |
| Bending stress | 66.9 MPa | GB/T 9341-2008 / ISO 178 |
| Molding shrinkage | 0.5% | GB/T 17037.4-2003 / ISO 294-4 |
| Print temperature | 230–250°C, bed 80–120°C, fan off (max 20%) | — |

### PC (Polycarbonate)

Amorphous thermoplastic — high strength, heat and cold resistance (125°C to −40°C service range).

| Property | Value | Test method |
|---|---|---|
| Relative density | 1.41 g/cm³ | ASTM D792 |
| Melting index | 70 g/10min (10kg, 250°C) | ASTM D1238 |
| Shrink rate (MD / TD) | 0.43% / 0.47% | ASTM D955 |
| Fracture strength (yield) | 560 kgf/cm² | ASTM D638 (50 mm/min) |
| Fracture elongation | 45% | ASTM D638 (50 mm/min) |
| Izod notched impact (1/4 in, 23°C) | 16 kgf·cm/cm | ASTM D256 |
| Hardness | 118 (R-scale) | ASTM D785 |
| Thermal deformation temperature | 114°C (18.56 kgf/cm², 6.4 mm) | ASTM D648 |
| Vicat softening temperature | 140°C | ISO R306 |
| Flame retardancy | V-2 | UL94 |
| Print temperature | 280–300°C, bed 120–160°C, fan off | — |

*Source: [YUMI Filament TDS 2022 (EN)](pdf/YUMI_Filament_TDS_2022_EN.pdf){ target=_blank }.*

---

## 3. Lab-Measured Performance Data

Unlike the typical values above, these numbers come from independent, dated lab test reports on named YUMI products — sample counts and standards included. Full certificates are in the [compliance file bank](YUMI_Filament_Compliance.md#6-independent-test-reports).

### FPLA+ (Flexible PLA)

Two CNAS/CMA-accredited reports from the National Additive Manufacturing Product Quality Inspection Center (Jiangsu).

| Property | Measured value | Standard | Report |
|---|---|---|---|
| Hardness, Shore A | 89 (average) | GB/T 2411-2008 | No. 2021PZWA00260, 2021-05-21 |
| Hardness, Shore D | 34 (average) | — | No. 2021PZWA00051, 2021-05-19 |
| Tensile strength (5 mm/min, n=5) | 9.2 MPa average (8.97–9.52 range) | — | No. 2021PZWA00051 |
| Elongation at break (5 mm/min, n=5) | 582% average (560–607 range) | — | No. 2021PZWA00051 |
| Density (immersion, 23°C water) | 1.237 g/cm³ | — | No. 2021PZWA00051 |
| Melting peak temperature | 123°C | — | No. 2021PZWA00051 |
| Melt mass flow rate | 6.38 g/10min (170°C, 2.16 kg) | — | No. 2021PZWA00051 |

[![Download Shore A report](/img/Filament/badge-report.svg)](pdf/YUMI_Filament_FPLA_Plus_Shore_A_Hardness_Report.pdf){ target=_blank } [![Download tensile/density report](/img/Filament/badge-report.svg)](pdf/YUMI_Filament_FPLA_Plus_Test_Report.pdf){ target=_blank }

### PLA HYPER

Tested by the Wuxi Testing & Certification Institute, report No. 2023PZWA20731 (2023-08-11 to 2023-08-14).

| Property | Measured value (n=5) | Standard |
|---|---|---|
| Tensile strength (50 mm/min) | 34.3 MPa average (33.1–35.6 range) | GB/T 1040.1-2018 (ISO 527-1:2012) |
| Elongation at break | 1.2% average (0.88–1.5 range) | GB/T 1040.2-2022 (ISO 527-2:2012) |
| Flexural strength (2 mm/min) | 55.8 MPa average (54.1–57.1 range) | GB/T 9341-2008 (ISO 178:2001) |
| Flexural modulus (2 mm/min) | 2275 MPa average (2163–2370 range) | GB/T 9341-2008 (ISO 178:2001) |

[![Download report](/img/Filament/badge-report.svg)](pdf/YUMI_Filament_PLA_HYPER_Mechanical_Test_Report_2023.pdf){ target=_blank }

### Nylon 25GF (25% glass-fiber reinforced)

Tested by the National Additive Manufacturing Product Quality Inspection Center (Jiangsu), report No. 2021PZWA20322 (2021-10-14 to 2021-10-15).

| Property | Measured value | Standard |
|---|---|---|
| Tensile strength (5 mm/min, n=3) | 50.0 MPa average (49.0–51.3 range) | GB/T 1040.1-2018 |
| Elongation at break (5 mm/min, n=3) | 10.1% average (9.2–11 range) | GB/T 1040.1-2018 |
| Tensile modulus (1 mm/min, n=3) | 1885 MPa average (1848–1914 range) | GB/T 1040.2-2006 |

[![Download report](/img/Filament/badge-report.svg)](pdf/YUMI_Filament_Nylon_25GF_Test_Report_2021.pdf){ target=_blank }

### PLA Antibacterial

Tested by the Guangdong Detection Center of Microbiology, report No. 2021FM25161R01D (2021-12-23).

| Property | Measured value | Standard |
|---|---|---|
| Test organism | *Staphylococcus aureus* ATCC 6538P | ISO 22196:2011 |
| Antibacterial activity value | 3.6 | ISO 22196:2011 |
| **Antibacterial rate** | **99.9%** | ISO 22196:2011 |

[![Download report](/img/Filament/badge-report.svg)](pdf/YUMI_Filament_PLA_Antibacterial_Report.pdf){ target=_blank }

---

## 4. Specialty & Extended Range (legacy 2020 catalog)

Materials from the 2020 spec sheet not carried in the current TDS — still useful as a reference for older batches or when sourcing a specialty grade. Diameter 1.75 mm unless noted; values are manufacturer "typical", not independently measured.

| Material | Density (g/cm³) | Nozzle temp | Bed temp | Print speed | Notes |
|---|---|---|---|---|---|
| PLA HYPER | 1.24–1.25 | 190–220°C | 50–60°C | 80–100 mm/s (max 180) | 0.4 mm nozzle, cooling required |
| Color Mixed PLA | 1.24–1.25 | 190–220°C | 50–60°C | 80–100 mm/s (max 180) | 0.4 mm nozzle, cooling required |
| PLA Marble | 1.24–1.25 | 190–220°C | 50–60°C | 80–100 mm/s (max 180) | 0.4 mm nozzle, cooling required |
| PLA Copper / Aulim | 1.6–1.7 | 190–220°C | 50–60°C | 80–100 mm/s (max 180) | 0.6 mm nozzle, metal-filled |
| PLA Carbon Fiber | 1.21–1.22 | 190–220°C | 50–60°C | 80–100 mm/s (max 180) | ±0.03mm tolerance |
| Water-Soluble PVA | 1.25–1.30 | 220–240°C | 50–60°C | 80–100 mm/s (max 180) | ±0.05mm tolerance |
| FLX-TPU | 1.11–1.20 | 230–250°C | 50–60°C | 30–40 mm/s (max 80) | ±0.05mm tolerance, slow print |
| PETG Glitter | 1.27–1.29 | 200–220°C | 50–60°C | 80–100 mm/s (max 180) | — |
| PLA HS (PLA+PTFE) | 1.47–1.49 | 240–290°C | 80–120°C | 80–100 mm/s (max 180) | high-speed PTFE-modified PLA |
| P73 (PVDF) | 1.70–1.76 | 270–290°C | 110–140°C | 60–80 mm/s (max 100) | flame-retardant UL94 V-0, chemical-resistant |
| PEEK | 1.22–1.26 | 400–450°C | 110–160°C | 60–80 mm/s (max 100) | high-performance engineering polymer |
| PEEK Carbon Fiber | 1.18–1.22 | 400–450°C | 110–160°C | 60–80 mm/s (max 100) | carbon-fiber reinforced PEEK |

**Selected mechanical/thermal properties (2020 catalog):**

| Material | Tensile strength | Elongation at break | Melting / softening point | Test method |
|---|---|---|---|---|
| TPE | Shore D 72, tear 150 kN/m | 15% | Service range −50 to 125°C | ISO 868 / ISO 34-1 / ISO 2781 |
| PEEK | 100 MPa | 40% | Melt 343°C, HDT 152°C (1.8 MPa) | ISO 527 / ISO 178 / ISO 11357 |
| PEEK Carbon Fiber | 100 MPa | 55% | Melt 343°C, HDT 158°C (1.8 MPa) | ISO 527 / ISO 178 / ISO 11357 |
| PLA 55 | 58 MPa | — | Melt 185°C, Tg 66–68°C | ISO 527 / ISO 11357 |
| P73 (PVDF) | 65 MPa | — | Melt 178°C, HDT 140°C (1.8 MPa) | ISO 527 / ISO 11357 |
| PETG / PET | 54 MPa | 70% | HDT 74°C | ASTM D638 / D648 |
| PLA 260 (low-melt PLA) | 12–15 MPa | 80–100% | Service range 70–100°C | GB/T 1040-2008 |

*Source: [YUMI Filament Tech Specs 2020](pdf/YUMI_Filament_Tech_Specs_2020.pdf){ target=_blank }.*

---

Need a property that isn't listed here, or data for a specific batch? Contact YUMI-LAB support with the reference of your order.
