/* ============================================================
   FILE: 03_data_transformation.sas
   PURPOSE: Bin continuous variables into interpretable categories
            and combine related variables where appropriate.
   Run AFTER 02_data_cleaning.sas.
   ============================================================ */

/* ── TRANSFORMATION 1: BMI classification ──────────────────────
   BMI is clinically measured in ranges. We introduce a bmi_class
   ordinal variable using standard WHO cut-offs:
   < 18.5        = Underweight
   18.5 to <25   = Healthy
   25 to 30      = Overweight
   > 30          = Obese

   Finding from clean data: most records fall in Overweight or
   Obese, consistent with the mean BMI of ~29.1. */

data lab.assignment_transformed;
    set lab.assignment_clean;
    if bmi < 18.5                      then bmi_class = 'Underweight';
    if bmi >= 18.5 and bmi < 25        then bmi_class = 'Healthy';
    if bmi >= 25   and bmi <= 30       then bmi_class = 'Overweight';
    if bmi > 30                        then bmi_class = 'Obese';
run;

/* ── TRANSFORMATION 2: Sleep hours classification ───────────────
   Sleep quantity is divided into five clinical categories based
   on sleep research guidelines.
   < 6 hours          = Very Low
   6 to <7 hours      = Low
   7 to <9 hours      = Normal
   9 to <10 hours     = High
   >= 10 hours        = Very High */

data lab.assignment_transformed;
    set lab.assignment_transformed;
    if sleep_hours < 6                          then sleep_class = 'Very Low';
    if sleep_hours >= 6 and sleep_hours < 7     then sleep_class = 'Low';
    if sleep_hours >= 7 and sleep_hours < 9     then sleep_class = 'Normal';
    if sleep_hours >= 9 and sleep_hours < 10    then sleep_class = 'High';
    if sleep_hours >= 10                        then sleep_class = 'Very High';
run;

/* ── TRANSFORMATION 3: Combine blood pressure values ────────────
   Systolic and diastolic blood pressure are combined into a single
   formatted string (e.g. "124/79") for quick clinical reference.

   NOTE: This combined variable is STRING type and cannot be used
   in mathematical operations or most data mining algorithms.
   The original systolic_bp and diastolic_bp columns are kept
   for all analytical purposes (see 04_data_reduction.sas). */

data lab.assignment_transformed;
    set lab.assignment_transformed;
    length blood_pressure $10;
    blood_pressure = catx('/', systolic_bp, diastolic_bp);
run;

/* ── VERIFICATION: view sample of transformed records ───────────*/

proc print data=lab.assignment_transformed (obs=10);
    var bmi bmi_class sleep_hours sleep_class
        systolic_bp diastolic_bp blood_pressure;
run;
