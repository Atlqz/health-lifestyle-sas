/* ============================================================
   FILE: 04_data_reduction.sas
   PURPOSE: Remove redundant variables and check for
            multicollinearity among numeric features.
   Run AFTER 03_data_transformation.sas.
   ============================================================ */

/* ── STEP 1: Drop the ID variable ──────────────────────────────
   The id column is a unique row identifier with no statistical
   distribution or predictive power. It is dropped to reduce
   noise in any downstream modelling. */

DATA assign.assignment_reduced;
    SET assign.assignment_transformed;
    DROP id;
RUN;

/* ── STEP 2: Multicollinearity check ───────────────────────────
   A Pearson correlation matrix is produced for all continuous
   lifestyle variables to identify any strongly correlated pairs
   that could bias predictive models.

   Variables tested:
   - daily_steps
   - calories_consumed
   - sleep_hours
   - water_intake_l

   Finding: All correlation coefficients were very low
   (range: -0.017 to 0.017), with no statistically significant
   pairs (all p-values >> 0.05). No variables were eliminated
   on the basis of multicollinearity. */

PROC CORR data=assign.assignment_transformed plots=matrix;
    VAR daily_steps calories_consumed sleep_hours water_intake_l;
    TITLE "Correlation Analysis for Data Reduction";
RUN;

/* ── FINAL VERIFICATION ─────────────────────────────────────────
   Confirm the reduced dataset has the correct number of columns
   and no remaining issues. */

proc contents data=assign.assignment_reduced;
run;

proc print data=assign.assignment_reduced (obs=5);
run;
