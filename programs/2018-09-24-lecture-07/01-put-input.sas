/*****************************************************************************
* Project           : BIOS 511 Course
*
* Program name      : 01-put-input.sas
*
* Author            : Matthew A. Psioda
*
* Date created      : 2018-09-24
*
* Purpose           : This program is designed to teach students using the PUT
*                      and input functions.
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

%let root     = C:/Users/psioda/Documents/GitHub/BIOS-511-FALL-2018; 
%let dataPath = &root./data/echo;
libname echo "&dataPath";

data work.DM;
 set echo.DM(obs=50);
 drop studyid ageu vis: race country  rficdtc rfxendtc dmdtc arm:;
run; 


/************************************** Task 1 ******************************************************
 [1] Create a temporary dataset WORK.DM2[x].
 [2] Create a variable aCAT  that has values "<40", "40-<50", "50-<60", "60-<70", ">=70" based on AGE.
 [3] Create a varoab;e aCATN that has values  1        2         3         4        5.
 [3] Create a variable TRTSTDTN to be the numeric version of RFXSTDTC.
 [4] Create a variable SEXN that is 1 for males and 2 for females;
 (***************************************************************************************************/

data work.DM2a;
 set work.DM;
   
  ** Question #1: why put aCatn in a LENGTH statement?;
  length aCat $20 aCatn 8 year $4 month day $2;
  format trtstdtn date9.;


  ** code to create aCAT with conditional logic: IF/THEN/ELSE;
  if not missing(age) then do;
         if age < 40 then do; aCat = '<40';    aCatn = 1; end;
	else if age < 50 then do; aCat = '40-<50'; aCatn = 2; end;
	else if age < 60 then do; aCat = '50-<60'; aCatn = 3; end;
	else if age < 70 then do; aCat = '60-<70'; aCatn = 4; end;
	else                  do; aCat = '>=70';   aCatn = 5; end;
  end;
     
  ** code to create the TRTSTDTN variable;
  year  = scan(rfxstdtc,1,'-');
  month = scan(rfxstdtc,2,'-');
  day   = scan(rfxstdtc,3,'-');
  trtstdtn = mdy(month,day,year);


  ** code to create SEX variable;
  if sex > ' ' then sexn = 1 + (sex='F');
run; 


** Question #2: How can we quickly check to see if the derivation for aCat(n) is correct?;


/************************************** Task 2 ******************************************************
 [1] Repeat Task 1 using the PUT and INPUT functions.
 (***************************************************************************************************/


proc format;
 value aCatF    /* create a mapping from numeric (or character) to character values */
  low-<40   = '<40'   
  40 -<50   = '40-<50'
  50 -<60   = '50-<60'
  60 -<70   = '60-<70'
  70 -HIGH  = '>=70'
   other    = ' '; 
 invalue aCatnIF /* create a mapping from character to numeric values */
  '<40'     = 1
  '40-<50'  = 2
  '50-<60'  = 3
  '60-<70'  = 4
  '>=70'    = 5
  other     = .;
 invalue SEXIF /* create a mapping from character to numeric values */
  'M'     = 1
  'F'     = 2;
run;

data work.DM2b;
 set work.DM;
   
  length aCat $20 aCatn 8;
  format trtstdtn date9.;


  ** code to create aCAT with conditional logic: IF/THEN/ELSE;
  aCat   = put(age,aCatF.);
  aCatn  = input(aCat,acatnIF.);
     

  ** code to create the TRTSTDTN variable;
  trtstdtn = input(rfxstdtc,yymmdd10.);

  ** code to create the SEX variable;
  sexn = input(sex,sexIF.);

run; 

proc print data = work.DM2a(obs=10); var usubjid age aCat aCatn sex sexn rfxstdtc trtstdtn; run;
proc print data = work.DM2b(obs=10); var usubjid age aCat aCatn sex sexn rfxstdtc trtstdtn; run;
