/* ============================================================
   COMPLETE HEPATITIS A ANALYSIS - SAS CODE
   Author: Shreya Dhamanse
   ============================================================ */

/* STEP 1: IMPORT MAINE DATA */
PROC IMPORT DATAFILE="/home/u64543945/Hepatitis A Project/maine_clean.csv"
            OUT=maine_import
            DBMS=CSV
            REPLACE;
            GETNAMES=YES;
RUN;

/* STEP 2: CLEAN POPULATION COLUMN AND CALCULATE RATE */
DATA maine_clean;
    SET maine_import;
    
    /* Convert Population from text to number */
    Population = INPUT(COMPRESS(Population, ','), BEST12.);
    
    /* Calculate Rate */
    Rate = (Case_Count / Population) * 100000;
    
    /* Center year for statistics */
    Year_Centered = Year - 2019;
    
    /* Create log population for offset */
    Log_Pop = LOG(Population);
RUN;

/* STEP 3: RUN TREND ANALYSIS (2016-2023) */
PROC GENMOD DATA=maine_clean;
    MODEL Case_Count = Year_Centered / DIST=POISSON 
                                         LINK=LOG 
                                         OFFSET=Log_Pop
                                         SCALE=DEVIANCE;
    ESTIMATE "Annual Trend" Year_Centered 1 / EXP;
    ODS OUTPUT ESTIMATES=trend_results;
RUN;

/* STEP 4: COMPARE 2016 vs 2023 */
DATA maine_compare;
    SET maine_clean;
    IF Year = 2016 OR Year = 2023;
RUN;

PROC GENMOD DATA=maine_compare;
    MODEL Case_Count = Year / DIST=POISSON 
                                    LINK=LOG 
                                    OFFSET=Log_Pop
                                    SCALE=DEVIANCE;
    ESTIMATE "2016 vs 2023" Year 1 / EXP;
RUN;

/* STEP 5: PRINT RESULTS */
PROC PRINT DATA=trend_results NOOBS;
    TITLE "MAINE TREND RESULTS (2016-2023)";
RUN;

/* ============================================================
   MAINE VS USA COMPARISON
   ============================================================ */

/* STEP 6: ENTER US DATA */
DATA us_data;
    INPUT Year Cases Population;
    Log_Pop = LOG(Population);
    Year_Centered = Year - 2019;
    DATALINES;
2019 18846 328000000
2020 9952 328000000
2021 5728 329000000
2022 2265 330000000
2023 1648 331000000
;
RUN;

/* STEP 7: COMBINE MAINE AND US DATA */
DATA combined;
    SET maine_clean (IN=a) us_data (IN=b);
    IF a THEN Group = "Maine";
    ELSE Group = "USA";
    IF Year >= 2019;
RUN;

/* STEP 8: COMPARE MAINE VS USA */
PROC GENMOD DATA=combined;
    CLASS Group (REF="USA") / PARAM=REF;
    MODEL Case_Count = Group Year_Centered / DIST=POISSON 
                                             LINK=LOG 
                                             OFFSET=Log_Pop
                                             SCALE=DEVIANCE;
    ESTIMATE "Maine vs USA Rate Ratio" Group 1 -1 / EXP;
RUN;