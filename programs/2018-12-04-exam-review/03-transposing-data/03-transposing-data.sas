/*****************************************************************************
* Project           : BIOS 511 Course
*
* Program name      : 03-transposing-data.sas
*
* Author            : Matthew A. Psioda
*
* Date created      : 2018-12-04
*
* Purpose           : This program illustrates transposing data;
*
* Revision History  :
*
* Date          Author   Ref (#)  Revision
* 
*
*
* searchable reference phrase: *** [#] ***;
******************************************************************************/
option mergenoby=nowarn nodate nonumber nobyline;
ods noproctitle;
title;
footnote;

%let root      = C:/Users/psioda/Documents/GitHub/BIOS-511-FALL-2018; 
%let dataPath  = &root./data/echo;                                    
%let outPath   = &root./programs/2018-12-04-exam-review/03-transposing-data;        

libname echo "&dataPath";                                             


/*ods html close;*/
/*ods html newfile=none;*/


** Example 1 ****************************************************;
title "Example 1";
proc freq data = echo.DM noprint;
 table country*armcd / out = DS2 outpct;
run;
proc print data = DS2; run;

** not needed but as a reminder;
proc sort data = DS2 out = DS3;
 by country;
run;


** Example 2 ****************************************************;
title "Example 2";
** How does one transform the DS3 dataset into a datset with:
 [1] One row per country				-- BY statement
 [2] One column per treatment arm		-- ID statement
 [3] Count of the value of each column 	-- VAR statement
 [4] Using PROC TRANSPOSE;

proc transpose data = DS3 out = DS3_TRANS prefix=COUNT_;
 by country;
 id armcd;
 var count;
run;
proc print data = DS3_TRANS/*(drop=_:)*/; run;
proc print data = DS3_TRANS(drop=_:); run;





** Example 3 ****************************************************;
title "Example 3";
** How does one transform the DS3 dataset into a datset with:
 [1] One row per country x treatment group -- ID statement
 [2] Count of the value of each column 	 -- VAR statement
 [3] Using PROC TRANSPOSE;

proc transpose data = DS3 out = DS4_TRANS prefix=COUNT_ delimiter=_;
 id country armcd;
 var count;
run;
proc print data = DS4_TRANS(drop=_:); run;





** Example 4 ****************************************************;
title "Example 4";
** How does one transform DS3_TRANS into a datset with:
 [1] One row per country x treatment group -- ID statement
 [2] Count of the value of each column 	 -- VAR statement
 [3] Using PROC TRANSPOSE;

proc transpose data = DS3_TRANS out = DS5_VERT;
 by country;
 var count_echomax count_placebo;
run;
proc print data = DS5_VERT; run;

data DS5_VERT2;
 set DS5_VERT;
  ARMCD = scan(_name_,2,"_");
  drop _name_;
run;
proc print data = DS5_VERT2; run;


data DS5_VERT3;
 format country armcd count;
 set DS5_VERT2;
run;
proc print data = DS5_VERT3; run;




** Example 5 ****************************************************;
title "Example 5";
** How does one transform the DS3 dataset into a datset with:
 [1] One row per country 
 [2] Count/percent as columns for each treatment group
 [3] Using a DATA step;


data DS6;
 set DS3;
 by country;


 retain count_echomax pct_echomax count_placebo pct_placebo;
 array x[2,2] count_echomax pct_echomax count_placebo pct_placebo;

 if armcd = "ECHOMAX" then do; x[1,1] = count; x[1,2] = percent; end;
 else                      do; x[2,1] = count; x[2,2] = percent; end;

 if last.country;
 keep country count_echomax count_placebo pct_echomax pct_placebo;
run;
proc print data = DS6; run;
