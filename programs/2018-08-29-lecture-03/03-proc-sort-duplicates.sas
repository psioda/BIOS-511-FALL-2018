/*****************************************************************************
* Project           : BIOS 511 Course
*
* Program name      : 03-proc-sort-duplicates.sas
*
* Author            : Matthew A. Psioda
*
* Date created      : 2018-08-29
*
* Purpose           : This program is designed to help students understand
*                     how to use PROC SORT to identify and remove duplicate
*                     observations from a dataset.
*
* Revision History  :
*
* Date          Author   Ref (#)  Revision
* 
*
*
* searchable reference phrase: *** [#] ***;
* 
******************************************************************************/

** commonly used statements that go just be program header;
option mergenoby=nowarn ;*nodate nonumber nocenter orientation=landscape;

libname orion "C:/Users/psioda/Documents/GitHub/BIOS-511-FALL-2018/data/orion";

%let root = C:/Users/psioda/Documents/GitHub/BIOS-511-FALL-2018/programs/2018-08-29-lecture-03;



** simple code to generate a dataset;
data clinic_visits;

 ID = 1; visit_number = 1; visit_date = '01Jan2018'd; output;
 ID = 1; visit_number = 2; visit_date = '05Jan2018'd; output; 
 ID = 1; visit_number = 3; visit_date = '10Jan2018'd; output;
 ID = 1; visit_number = 4; visit_date = '21Jan2018'd; output;  

 ID = 3; visit_number = 1; visit_date = '01Aug2018'd; output;
 ID = 3; visit_number = 2; visit_date = '03Aug2018'd; output; 
 ID = 3; visit_number = 2; visit_date = '04Aug2018'd; output;
 ID = 3; visit_number = 3; visit_date = '08Aug2018'd; output;  


 ID = 2; visit_number = 1; visit_date = '01Feb2018'd; output;
 ID = 2; visit_number = 2; visit_date = '02Mar2018'd; output; 
 ID = 2; visit_number = 3; visit_date = '03Apr2018'd; output;
 ID = 2; visit_number = 4; visit_date = '06May2018'd; output;  
 
 format visit_date date9.;
run;
proc print data = clinic_visits; run;


** sort the data by ID and then visit_number;
proc sort data = clinic_visits out = clinic_visits_sorted; 
 by ID visit_number;
run;
proc print data = clinic_visits_sorted; run;

** check for duplicate ID;
proc sort data = clinic_visits out = clinic_visits_sorted_dups nodupkey; 
 by ID visit_number;
run;
proc print data = clinic_visits_sorted_dups; run;

** check for duplicate IDs and output duplicates;
proc sort data = clinic_visits out = clinic_visits_sorted_dups dupout=dup_recs nodupkey; 
 by ID visit_number;
run;
proc print data = clinic_visits_sorted_dups; run;
proc print data = dup_recs; run;


