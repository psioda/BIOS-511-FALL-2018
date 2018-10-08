/*****************************************************************************
* Project           : BIOS 511 Course
*
* Program name      : 01-midterm-review-solution-p1
*.sas
*
* Author            : Matthew A. Psioda
*
* Date created      : 2018-10-08
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


/*********** practice question #1 ********************
   What was the mean change from baseline in heart rate
   at week 32 for each of the two echo trial treatment groups?
 *****************************************************/

/********** Approach A ***********/
proc sort data = echo.vs out = VS_BL(keep = usubjid vsstresn rename=(vsstresn=BASE));
 by usubjid;
 where vstestcd = 'HR' and vsblfl = 'Y' and vsstresn > .;
run;

proc sort data = echo.vs out = VS_32(keep = usubjid vsstresn rename=(vsstresn=WK32));
 by usubjid;
 where vstestcd = 'HR' and visit = 'Week 32' and vsstresn > .;
run;

proc sort data = echo.dm out = dm(keep = usubjid armcd);
 by usubjid;
run;

data WK32_A;
 merge VS_BL(in=a) VS_32(in=b) dm;
 by usubjid;
  if a and b;
   changeA = wk32 - base;
 keep usubjid armcd changeA base;
run;


/********** Approach B ***********/
proc sort data = echo.vs out = VS;
 by usubjid visitnum;
 where vstestcd = 'HR' and (vsblfl = 'Y' or visit='Week 32') and  vsstresn > .;
run;

proc sort data = echo.dm out = dm(keep = usubjid armcd);
 by usubjid;
run;

data VS2;
 set VS;
 by usubjid;

 retain base;
 if first.usubjid then base = .;
 if vsblfl = 'Y' then base = vsstresn;


 if last.usubjid and visit = 'Week 32';
 changeB = vsstresn - base;

run;

data WK32_B;
 merge vs2(in=a) dm(in=b);
 by usubjid;
  if a and b;

   keep usubjid armcd changeB base;
run;

/********** Approach C ***********/
proc sort data = echo.vs out = VS1;
 by usubjid visitnum;
 where vstestcd = 'HR' and vsstresn > .;
run;

** code necessary for SS/SUE;
data VS1;
 set VS1;
  if visitnum = -1 then visitnum = 0;
run;


proc transpose data = VS1 out = VS2(drop = _name_ _label_) prefix=vis;
 by usubjid;
 id visitnum;
 var vsstresn;
run;

proc sort data = echo.dm out = dm(keep = usubjid armcd);
 by usubjid;
run;

data WK32_C;
 merge VS2(in=a) dm(in=b);
 by usubjid;
  if a and b;

  if vis1 > . then base = vis1;
  else if vis0 > . then base = vis_1;

  changeC = vis5-base;
 keep usubjid armcd changeC base;
run;


proc means data = WK32_A n mean std median min max fw=10 maxdec=2;
 class armcd;
 var changeA;
run;

proc means data = WK32_B n mean std median min max fw=10 maxdec=2;
 class armcd;
 var changeB;
run;

proc means data = WK32_C n mean std median min max fw=10 maxdec=2;
 class armcd;
 var changeC;
run;
