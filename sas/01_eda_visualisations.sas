/* ============================================================
   FILE: 01_eda_visualisations.sas
   PURPOSE: Exploratory Data Analysis — descriptive charts
   Dataset: Health & Lifestyle (5,010 individuals, 16 variables)
   ============================================================ */

/* Histogram of BMI
   Shows distribution of Body Mass Index across the sample.
   Finding: Most values fall between 28-35, indicating the
   population is generally overweight to obese. Mild right skew
   suggests a subset with extremely high BMI. */

proc sgplot data=project.assignment_dataset;
    histogram bmi;
    density bmi;
    title "Histogram of BMI";
run;

/* Histogram of Age
   Shows age distribution across the sample.
   Finding: Near-normal distribution centred around 45 years,
   with moderate spread — representative of mid-adulthood. */

proc sgplot data=project.assignment_dataset;
    histogram age;
    density age;
    title "Histogram of Age";
run;

/* Boxplot — BMI by Gender
   Shows whether BMI distributions differ between male and female.
   Finding: Both genders show almost identical median and
   interquartile range — gender does not explain BMI variation
   in this sample. */

proc sgplot data=project.assignment_dataset;
    vbox bmi / category=gender;
    title "BMI by Gender (Boxplot)";
run;

/* Bar Chart — Smoking Status Distribution
   Shows the proportion of smokers vs. non-smokers.
   Finding: ~80% of the sample are non-smokers (category 0),
   ~20% are smokers (category 1). */

proc sgplot data=project.assignment_dataset;
    vbar smoker;
    title "Smoking Status Distribution";
run;
