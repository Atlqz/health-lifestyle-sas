# Health & Lifestyle Data Analysis | SAS

![SAS](https://img.shields.io/badge/SAS-Studio-003299?style=flat-square)
![Status](https://img.shields.io/badge/Status-Complete-brightgreen?style=flat-square)
![Type](https://img.shields.io/badge/Type-Academic%20Project-lightgrey?style=flat-square)

## Project Overview

Exploratory Data Analysis and preprocessing pipeline applied to a **Health & Lifestyle dataset of 5,010 individuals**, performed entirely in SAS Studio as part of a university Data Management module.

The dataset contains 16 variables covering demographic, behavioural, physiological, and lifestyle characteristics — including BMI, daily steps, sleep hours, blood pressure, cholesterol, smoking status, and a binary disease risk indicator.

**Three-stage pipeline:**
Raw data → Cleaning (missing values, outliers, standardisation) → Transformation (binning, variable creation) → Reduction (multicollinearity check, redundant variable removal)

---

## Key Findings

### Descriptive statistics
- Sample mean age of **45.2 years** (SD ≈ 12), with near-normal distribution centred on mid-adulthood.
- Mean BMI of **28.7** places the average participant in the overweight category; right-skewed distribution indicates a subset with extreme values.
- Average resting heart rate of **~72 bpm** and blood pressure centred around **124/79 mmHg** — broadly normal, but with hypertension-range outliers on the high end.
- **~80% of participants are non-smokers**, with roughly 20% reporting active smoking.
- **15–20% of participants classified as high disease risk** based on the `disease_risk` indicator.

### Data quality issues identified and resolved

| Issue | Rows affected | Resolution |
|-------|--------------|------------|
| Missing gender | 1 row | Imputed as Female based on caloric intake (~2,000 kcal/day matches NHS female average) and column mode |
| Negative / missing age | 2 rows | Replaced with column mean (49 years) |
| Negative / missing BMI | 2 rows | Replaced with column mean (29.1) |
| Missing daily_steps | 1 row | Replaced with column mean (10,432 steps) |
| Invalid sleep_hours (-4, 22) | 2 rows | Replaced with column mean (6.5 hours) |
| Missing water_intake_l | 1 row | Replaced with column mean (2.8 L) |

### Transformation outcomes
- BMI binned into 4 clinical classes: Underweight / Healthy / Overweight / Obese (WHO cut-offs)
- Sleep hours binned into 5 categories: Very Low / Low / Normal / High / Very High
- Systolic and diastolic blood pressure combined into a formatted `blood_pressure` string for quick reference (original numeric columns retained for analysis)
- Binary variables (smoker, alcohol, family_history, disease_risk) standardised from 0/1 integers to readable labels

### Multicollinearity check
All Pearson correlation coefficients between continuous lifestyle variables (daily steps, calories consumed, sleep hours, water intake) ranged from **-0.017 to 0.017** with no statistical significance — confirming no multicollinearity. No variables were eliminated on this basis.

---

## SAS Techniques Demonstrated

| Technique | Purpose |
|-----------|---------|
| `PROC FREQ` with `missing` option | Surface all missing and invalid values across all columns |
| `PROC PRINT` with `WHERE` clause | Locate specific rows containing errors |
| `DATA` step with `IF` conditions | Impute missing values, fix outliers, recode variables |
| `LENGTH` and `RENAME` statements | Create and rename standardised categorical columns |
| `CATX()` function | Combine systolic and diastolic BP into a formatted string |
| Binning with `IF/THEN` blocks | Convert continuous BMI and sleep hours into ordinal classes |
| `DROP` statement | Remove non-informative ID column |
| `PROC CORR` with `plots=matrix` | Pearson correlation matrix for multicollinearity detection |
| `PROC SGPLOT` — histogram | Visualise continuous variable distributions |
| `PROC SGPLOT` — vbox | Visualise BMI distribution split by gender |
| `PROC SGPLOT` — vbar | Visualise categorical variable frequency (smoking status) |

---

## Repository Structure

```
health-lifestyle-sas/
│
├── sas/
│   ├── 01_eda_visualisations.sas    # Histograms, boxplot, bar chart
│   ├── 02_data_cleaning.sas         # Missing value detection and imputation
│   ├── 03_data_transformation.sas   # BMI and sleep binning, BP combination
│   └── 04_data_reduction.sas        # ID removal, multicollinearity check
│
├── outputs/
│   ├── histogram_bmi.png
│   ├── histogram_age.png
│   ├── boxplot_bmi_by_gender.png
│   └── barchart_smoking_status.png
│
└── README.md
```

---

## Data Source

Synthetic Health & Lifestyle dataset of 5,010 individuals — used for academic purposes as part of the CT075-3-2 Data Management module at Asia Pacific University (APU). Dataset is not publicly distributed.


## What I Would Do Next

- **Extend the analysis to data mining:** the cleaned dataset is ready for K-means clustering (segment patients into lifestyle risk groups) or classification (predict `disease_risk` using BMI, cholesterol, blood pressure).
- **Automate the cleaning pipeline:** wrap the imputation logic into a reusable SAS macro that can be applied to any similarly structured health dataset.
- **Add statistical testing:** compare disease risk rates across BMI classes using `PROC FREQ` chi-square tests to determine whether the relationship is statistically significant.
