markdown
# Hepatitis A in Maine: Epidemiological Analysis (2016-2023)

**Author:** Shreya Dhamanse

---

## Project Overview

This repository contains the complete analysis for my capstone project on the Hepatitis A outbreak in Maine. The project includes data cleaning, statistical modeling (SAS and R), spatial analysis, and an interactive Tableau dashboard.

---

## Key Research Questions & Findings

### 1. Did Maine experience a significant increase in Hepatitis A cases from 2016 to 2023?

**Finding:** Yes. Cases increased by 32% from 2016 to 2023.
- **IRR = 1.32** (95% CI: 1.19–1.47)
- **p < 0.0001** (statistically significant)

### 2. Was Maine's incidence rate higher than the national average?

**Finding:** Yes. Maine's rate was 2.3 times higher than the U.S. rate during the outbreak period (2019-2023).
- **IRR = 2.30** (95% CI: 1.01–5.23)
- **p = 0.047** (statistically significant)

### 3. Is there a relationship between social vulnerability (SVI) and Hepatitis A rates?

**Finding:** Yes. Counties with higher SVI had significantly higher rates.
- **IRR = 5.45** (95% CI: 2.32–12.82)
- **p = 0.0001** (statistically significant)

### 4. Was the outbreak geographically clustered?

**Finding:** Yes. Piscataquis and Aroostook counties were identified as statistically significant 95% hot spots using Getis-Ord Gi* analysis.

### 5. Did the severity of the outbreak change over time?

**Finding:** Yes. Deaths per 1,000 cases rose from 11.9 in 2019 to 51.6 in 2023, indicating the outbreak became more severe over time.

---

## Repository Structure
hepatitis-a-maine-analysis/
├── README.md # Project overview
├── data/
│ └── Maine_panel.csv # Cleaned panel data (16 counties × 8 years)
├── scripts/
│ ├── hepatitis_a_analysis.R # Complete R analysis code
│ └── Hepatitis_A_analysis.sas # SAS analysis code
└── outputs/
├── figure1_svi_scatter.png # SVI vs Rate scatter plot
├── hotspot_map_publication.png # Getis-Ord Gi* hotspot map
├── Rplot02.jpeg # Severity plot
└── Rplot11.jpeg # SVI map

text

---

## Interactive Tableau Dashboard

Explore the data interactively:

🔗 **[View Dashboard on Tableau Public](https://public.tableau.com/views/HepatitisAinMaineComprehensiveAnalysis/HepatitisADashboard)**

The dashboard includes:
- **County Map** – Rate by county with year slider
- **Trend Line** – Cases over time (2016-2023)
- **Bar Chart** – Cases by county (sorted)
- **Heatmap** – County × Year matrix
- **SVI Scatter** – SVI vs Rate relationship
- **Severity Chart** – Deaths per 1,000 cases (US, 2019-2023)

---

## Data Sources

| Source | Data | Years |
|--------|------|-------|
| CDC WONDER / NNDSS | National case counts | 2016-2023 |
| Maine CDC | County-level case counts | 2016-2023 |
| CDC/ATSDR SVI | Social Vulnerability Index | 2020 |
| US Census Bureau | Population estimates | 2016-2023 |

---

## Methods

| Tool | Purpose |
|------|---------|
| **SAS** | Poisson regression with overdispersion correction (SCALE=DEVIANCE) |
| **R** | Data cleaning, panel regression, spatial analysis (Getis-Ord Gi*) |
| **Tableau Public** | Interactive dashboard |

---

## How to Reproduce This Analysis

### Run the R Script
```r
# Open R and set working directory
setwd("path/to/project")

# Run the complete analysis
source("scripts/hepatitis_a_analysis.R")
Run the SAS Code
sas
/* Open SAS and run */
%include "scripts/Hepatitis_A_analysis.sas";
Author
Shreya Dhamanse
MPH Candidate | Infectious Disease Epidemiology
GitHub

Acknowledgments
Dr. Noele P. Nelson (Project guidance)

Maine CDC for surveillance data

CDC/ATSDR for SVI data
