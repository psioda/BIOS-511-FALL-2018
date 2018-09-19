/*****************************************************************************
* Project           : BIOS 511 Course
*
* Program name      : 02-conditional-logic.sas
*
* Author            : Matthew A. Psioda
*
* Date created      : 2018-09-19
*
* Purpose           : This program is designed to help students
*                     understand the difference between subsetting IF
*                     statements and WHERE statements;
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



** to begin this lab, we will read in a subset of the observations from the ECHO
   trail DM dataset;

data work.DM;
 set echo.DM(  where=(age<45)  ); ** example of using a WHERE dataset option;
 drop studyid ageu vis: arm rficdtc dmdtc;
run; 
 title "Print out of work.DM";
proc print data = work.DM; run;
** Note: using vis: in the drop statement drops all variables whose name starts with the "vis" prefix;


/************************************** Task 1 ****************************************
 [1] Create a temporary dataset WORK.DM2x.
 [2] Create a variable aCAT  that has values "White:age<40","White:age>=40","Non-white:age<40","Non-white:age>=40"
 [3] Create a variable aCATN that has values 1             ,2              ,3                 ,4  
 *************************************************************************************/

 ** attempt 1;
 data work.DM2a;
  set work.DM;
   
  label aCat  = 'Race/Age Category'
        aCatn = 'Race/Age Category (Numeric)';
     ** code not perfect, need to correct and/or clean up.;

       if age < 40 and upcase(RACE)  = 'WHITE' then aCat = "White:age<40";
  else if              upcase(RACE)  = 'WHITE' then aCat = "White:age>=40";
  else if age < 40 and upcase(RACE) ^= 'WHITE' then aCat = "Non-White:age<40";
  else if              upcase(RACE) ^= 'WHITE' then aCat = "Non-White:age>=40";

       if age < 40 and upcase(RACE)  = 'WHITE' then aCatn = 1;
  else if              upcase(RACE)  = 'WHITE' then aCatn = 2;
  else if age < 40 and upcase(RACE) ^= 'WHITE' then aCatn = 3;
  else if              upcase(RACE) ^= 'WHITE' then aCatn = 4;


 run;
 ** Note: the symbol ^= in SAS means not equal to. Other languages use !=.;

 title "Print out of work.DM2a";
 proc print data = work.DM2a; run;
 ** Question: How do I make the labels for aCat and aCatn (and other variables
    show up?;

