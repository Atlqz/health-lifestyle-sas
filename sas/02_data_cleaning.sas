/* ============================================================
   FILE: 02_data_cleaning.sas
   PURPOSE: Identify and fix missing values, outliers, and
            inconsistent categorical variables.
   ============================================================ */

/* ── STEP 1: Identify missing and invalid values ───────────────
   Using PROC FREQ with the missing option surfaces all variables
   including those with missing entries. This revealed:
   - 1 missing BMI value and 1 negative BMI (-31.2)
   - 1 missing age value and 1 negative age (-25)
   - 1 missing gender value
   - 1 missing daily_steps value
   - Invalid sleep_hours values (-4 and 22)
   - 1 missing water_intake_l value */

PROC freq DATA=lab.assignment_dataset;
    tables _all_ / missing;
RUN;

/* ── STEP 2: Identify the specific rows containing issues ──────
   Using PROC PRINT with WHERE clause to locate exact rows. */

proc print data=lab.assignment_dataset;
where nmiss(age) or age < 0
or nmiss(bmi) or bmi < 0
or gender = ""
or nmiss(daily_steps) or daily_steps < 0
or nmiss(sleep_hours) or sleep_hours < 0 or sleep_hours > 12
or nmiss(water_intake_l) or water_intake_l < 0;
run;

/* ── STEP 3: Fix missing gender ────────────────────────────────
   Row 47 (id=1002) has missing gender and 2000 calories consumed.
   Per NHS UK guidance, average female intake ~2000 kcal/day vs
   ~2500 kcal/day for males. Mode of gender variable is also Female.
   Conclusion: imputed as Female. */

data lab.assignment_clean;
    set lab.assignment_dataset;
    if gender = '' then gender = 'Female';
run;

/* ── STEP 4: Fix remaining missing/invalid numeric values ───────
   Strategy: replace with column means (distributions are
   near-symmetrical, so mean imputation is within reason).
   Age and daily_steps rounded to nearest integer. */

data lab.assignment_clean;
    set lab.assignment_clean;
    if age = . or age = -25    then age          = 49;
    if bmi = . or bmi = -31.2  then bmi          = 29.1;
    if daily_steps = .         then daily_steps   = 10432;
    if sleep_hours = -4
    or sleep_hours = 22        then sleep_hours   = 6.5;
    if water_intake_l = .      then water_intake_l = 2.8;
run;

/* ── STEP 5: Standardise binary categorical variables ───────────
   smoker, alcohol, family_history and disease_risk are stored as
   0/1 integers. Converting to readable labels for clarity.
   disease_risk uses High/Low rather than Yes/No to reflect
   the clinical meaning of the variable. */

data lab.assignment_clean;
    set lab.assignment_clean;
    length smoker2 $5 alcohol2 $5 family_history2 $5 disease_risk2 $5;

    if smoker = 1          then smoker2         = 'Yes';
    if smoker = 0          then smoker2         = 'No';
    if alcohol = 1         then alcohol2        = 'Yes';
    if alcohol = 0         then alcohol2        = 'No';
    if family_history = 1  then family_history2 = 'Yes';
    if family_history = 0  then family_history2 = 'No';
    if disease_risk = 1    then disease_risk2   = 'High';
    if disease_risk = 0    then disease_risk2   = 'Low';

    drop smoker alcohol family_history disease_risk;
    rename smoker2         = smoker;
    rename alcohol2        = alcohol;
    rename family_history2 = family_history;
    rename disease_risk2   = disease_risk;
run;

/* ── VERIFICATION: confirm clean dataset ───────────────────────
   Re-run PROC FREQ to confirm no missing or invalid values remain. */

PROC freq DATA=lab.assignment_clean;
    tables _all_ / missing;
RUN;
