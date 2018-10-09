/*****************************************************************************
* Project           : BIOS 511 Course
*
* Program name      : 01-midterm-review-p3.sas
*
* Author            : Matthew A. Psioda
*
* Date created      : 2018-10-09
*
* Purpose           : This program is designed to provide practice for the midterm
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

%let root     = C:/Users/psioda/Documents/GitHub/BIOS-511-FALL-2018; 
%let dataPath = &root./data/echo;
libname echo "&dataPath";

/** order data by subject and select relevant visits/tests **/
proc sort data = echo.vs out = vs1;
 where vstestcd in ("DIABP" "SYSBP") and visitnum in (1,5);
 by usubjid visitnum visit;
run;

/** transpose data to one row per subject and visit **/
proc transpose data = vs1 out = vs2(drop=_name_ _label_);
 by usubjid visitnum visit;
 id vstestcd;
 var vsstresn;
run;

/** Identify subjects meeting week 0 criteria **/
data WK00_CRIT;
 set vs2;
 where visit = 'Week 0';

 if SYSBP > 130 and DIABP > 90;

 keep usubjid;
run;

/** Identify subjects meeting week 32 criteria **/
data WK32_CRIT;
 set vs2;
 where visit = 'Week 32';

 /** defensive programming, check to see if only one vital sign is ever measured **/
 if nMiss(SYSBP,DIABP) = 1 then do;
  putlog 'ER' 'ROR: Only one BP measurement, check code validity ' usubjid= visit= sysbp= diabp=; 
 end;

 if . < SYSBP <= 130 or . < DIABP <= 90 then WK32Crit = 1;
 else if SYSBP > . and DIABP > . then WK32Crit = 0;

 keep usubjid WK32Crit;
run;
 
proc sort data = echo.DM out = DM(keep=usubjid armcd);
 by usubjid;
run;

data Comb;
 merge WK00_CRIT(in=a) WK32_CRIT(in=b) DM(in=c keep=usubjid armcd);
 by usubjid;
  if a and b and c;
run;

proc format;
 value yn
  0 = 'No'
  1 = 'Yes';
run;

title "Percentage of Subjects Meeting Week 32 BP Milestone";
proc freq data = Comb;
 label WK32CRIT = 'Week 32 Criteria Met';
 format WK32CRIT yn.;
 table WK32CRIT*armcd / nopercent norow missprint;
run;
