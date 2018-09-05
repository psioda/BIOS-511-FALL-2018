/*****************************************************************************
* Project           : BIOS 511 Course
*
* Program name      : 01-output-datasets.sas
*
* Author            : Matthew A. Psioda
*
* Date created      : 2018-09-05
*
* Purpose           : This program is designed to help students understand
*                     how to create datasets storing summary results from
*                     PROC MEANS, PROC UNIVARIATE, and PROC FREQ (without
*                     using ODS);
*
* Revision History  :
*
* Date          Author   Ref (#)  Revision
* 
*
*
* searchable reference phrase: *** [#] ***;
******************************************************************************/
option mergenoby=nowarn nodate nonumber;
ods noproctitle;

%let root     = C:/Users/psioda/Documents/GitHub/BIOS-511-FALL-2018; 
%let dataPath = &root./data/echo;

libname echo "&dataPath";

** Notes:
   [1] Any ODS object can be turned into a SAS dataset by delivering it to the ODS OUTPUT 
       destination
   [2] Most SAS procedures also allow certain results to be written to a more user-friendly
       SAS dataset using PROC-specific options/statements
   [3] Most of the time, if you want basic summary results, option [2] is better than [1]
       
       
*********************************************************************************************;
** write the two-way frequency table ODS object into a SAS dataset;
ods output CrossTabFreqs = work.frequencyTable;
proc freq data = echo.DM;
 table country*armcd / nopercent norow;
run;
proc print data = work.frequencyTable noobs label;
run;

** write the two-way frequency into a SAS dataset with the OUT= option on the TABLE statement;
proc freq data = echo.DM noprint;
 table country*armcd / outpct out = work.FrequencyTable2;
run;
proc print data = work.FrequencyTable2 noobs label;
run;

*********************************************************************************************;
** write the five number summary ODS object from PROC MEANS to an output dataset;
ods output summary=work.fiveNumberSummary;
proc means data = echo.DM n nMiss mean std min max fw=2;
 class armcd;
 var age;
run;
proc print data = work.fiveNumberSummary noobs label;
run;

** write the five number summary from PROC MEANS to an output dataset using the OUTPUT statement;
** this code works verbatim in PROC UNIVARIATE;
proc means data = echo.DM noprint;
 class armcd;
 var age;
 output out = work.fiveNumberSummary2 n=ageN nMiss=ageMiss mean=ageMean std=ageSD min=ageMin max=ageMax ;
run;
proc print data = work.fiveNumberSummary2 noobs ;
run;

** using the AUTO_NAME option on the OUTPUT statement to name variables;
** PROC UNIVARIATE does not support AUTO_NAME;
proc means data = echo.DM noprint;
 class armcd;
 var age;
 output out = work.fiveNumberSummary3 n= nMiss= mean= std= min= max= / autoname;
run;
proc print data = work.fiveNumberSummary3 noobs ;
run;
*********************************************************************************************;


** Analysis with multiple classification varaibles;
proc means data = echo.DM;
 class armcd country;
 var age;
 output out = work.fiveNumberSummary3 n=ageN nMiss=ageMiss mean=ageMean std=ageSD min=ageMin max=ageMax ;
run;
proc print data = work.fiveNumberSummary3 noobs ;
run;

** The NWAY option of the PROC MEANS statement modifies the output dataset to only include the summary
   for each level of the variables in the CLASS statement;
proc means data = echo.DM nway;
 class armcd country;
 var age;
 output out = work.fiveNumberSummary4 n=ageN nMiss=ageMiss mean=ageMean std=ageSD min=ageMin max=ageMax ;
run;
proc print data = work.fiveNumberSummary4 noobs ;
run;

** The WAYS option on the PROC MEANS statement modifies the output dataset to restrict whether 
   data are analyzed using combinations of the class variable;
proc means data = echo.DM;
 class armcd country;
 var age;
 ways 1;
 output out = work.fiveNumberSummary5 n=ageN nMiss=ageMiss mean=ageMean std=ageSD min=ageMin max=ageMax ;
run;
proc print data = work.fiveNumberSummary5 noobs ;
run;

proc means data = echo.DM;
 class armcd country race;
 var age;
 types armcd*(country race);
 output out = work.fiveNumberSummary6 n=ageN nMiss=ageMiss mean=ageMean std=ageSD min=ageMin max=ageMax ;
run;
proc print data = work.fiveNumberSummary6 noobs ;
run;


