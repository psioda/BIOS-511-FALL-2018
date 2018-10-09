/*****************************************************************************
* Project           : BIOS 511 Course
*
* Program name      : 01-midterm-review-p2.sas
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


 data AE;
  set echo.AE;
  
  lenDate = length(AESTDTC);

  /** defensive programming to make sure only day is ever unknown **/
  if length(AESTDTC) not  in (7,10) then do;
   put 'ER' 'ROR: Unexpected length ' usubjid= aeterm= aestdtc=;
  end;

  /** if date is not completely known, fill in the day **/
  if lenDate = 7 then do; 
       aestdtn = input(catx('-',aestdtc,'15'),yymmdd10.); 
       imputed = 'Y'; 
  end;
  else aestdtn = input(aestdtc,yymmdd10.); 


  keep usubjid aestdtc aestdtn imputed;
 run;

 proc sort data = AE out = AE2;
  by usubjid;
 run;

 proc sort data = echo.DM out = firstDose(keep=usubjid rfxstdtc arm armcd);
  by usubjid;
 run;

 /** merge on DM data and compute binary "in window" variable for each observation **/
 data AE3;
  merge AE2(in=a) firstDose(in=b);
  by usubjid;

   trtstdtn = input(rfxstdtc,yymmdd10.); 
   timeToAE = aestdtn - trtstdtn + 1;

   inWindowAE = ( 1 <= timeToAE <= 21 );

   drop rfxstdtc;
 run;

 /** sort the data so that "in window" observations are first, if they occur **/
 proc sort data = AE3 out = AE4;
  by usubjid descending inWindowAE;
 run;

 /** take the first row for each subject (it will be "in window" if such an event occurred) **/
 data AE5;
  set AE4;
  by usubjid;
   if first.usubjid;
 run;

title "Percentage of Subjects with Adverse events within 21 days of dosing by Treatment Group";
proc freq data = AE5;
 label inWindowAE = 'AE within 21 days';
 table inWindowAE*armcd / nopercent norow;
run;
 
