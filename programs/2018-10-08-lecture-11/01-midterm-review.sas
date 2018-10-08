/*****************************************************************************
* Project           : BIOS 511 Course
*
* Program name      : 01-midterm-review.sas
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
 proc print data = echo.vs(obs=12 where=(vstestcd='HR') drop=STUDYID VSTEST VSSTAT VSREASND) noobs; run;




/*********** practice question #1 ******************************
   Of the subjects who experienced at least one adverse event, 
   what was the average duration of time from the start
   of treatment to their first post-treatment adverse event?
 ***************************************************************/
 proc print data = echo.dm(where=(usubjid='ECHO-011-005') drop=STUDYID DMDTC VIS: RFIC: SEX RACE COUNTRY AGE) noobs label; run;
 proc print data = echo.ae(where=(usubjid='ECHO-011-005') drop=STUDYID AESOC AESEV AESER) noobs label; run;
