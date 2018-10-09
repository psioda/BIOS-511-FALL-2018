/*****************************************************************************
* Project           : BIOS 511 Course
*
* Program name      : 01-midterm-review-p1.sas
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

 ** order adverse event data so that earlier events appear first for each subject;
 proc sort data = AE out = AE2;
  by usubjid aestdtn;
 run;

 proc sort data = echo.DM out = firstDose(keep=usubjid rfxstdtc);
  by usubjid;
 run;

 /** merge on DM data and compute AE duration **/
 /** Only keep durations for post-treatment AEs **/
 data AE3;
  merge AE2(in=a) firstDose(in=b);
  by usubjid;
   if a and b;
   trtstdtn = input(rfxstdtc,yymmdd10.); 
   timeToAE = aestdtn - trtstdtn + 1;

   if timeToAE >= 1;
   drop rfxstdtc;
 run;

 /** take the earliest AE for each subject **/
 data AE4;
  set AE3;
   by usubjid;
   if first.usubjid;
 run;

 /** take the earliest AE for each subject **/
 proc sort data = AE3 out = AE4_Alternative nodupkey;
  by usubjid;
 run;

 title "Summary of Time to First Adverse Event";
 proc means data = AE4 fw=8 maxdec=3 n Mean Std Min Median Max;
  label timeToAE = 'Time to First Post-Treatment Adverse Event';
  var timeToAE;
 run;
