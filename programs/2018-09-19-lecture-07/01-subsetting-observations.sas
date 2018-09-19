/*****************************************************************************
* Project           : BIOS 511 Course
*
* Program name      : 01-subsetting-observations.sas
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
 set echo.DM(obs=10);
 drop studyid ageu vis: arm rf: dmdtc;
run; 
 title "Print out of work.DM";
proc print data = work.DM; run;
** Note: using vis: in the drop statement drops all variables whose name starts with the "vis" prefix;


/************************************** Task 1 ****************************************
 [1] Create a temporary dataset WORK.DM2x.
 [2] Remove all observations where age <= 50 and race is not equal to white.
 [3] Compare approaches based on subsetting IF and WHERE statements;
 *************************************************************************************/

 ** attempt 1;
 data work.DM2a;
  set work.DM;
  where age <= 50 and upcase(RACE) ^= 'WHITE';
  ** The WHERE statement can only use variables that exist in all
     input data sets listed on the SET statement;
 run;
 title "Print out of work.DM2a";
 proc print data = work.DM2a; run;


 ** attempt 2 - more definsive programming;
 data work.DM2b;
  set work.DM;
  where . < age <= 50 and upcase(RACE) ^= 'WHITE';
  ** using a compound inequality to exclude missing age values;
 run;
 title "Print out of work.DM2b";
 proc print data = work.DM2b; run;


 ** attempt 3 - subsetting IF approach (for pedigocial purposes);
 data work.DM2c;
  set work.DM;
    if (. < age <= 50 and upcase(RACE) ^= 'WHITE');
 run;
 title "Print out of work.DM2c";
 proc print data = work.DM2c; run;

 ** attempt 4 - subsetting IF approach (for pedigocial purposes);
 data work.DM2d;
  set work.DM;
    
    ageCat      = ( . < age <= 50);

    include_obs = ( ageCat and upcase(RACE) ^= 'WHITE');
	** does this look odd?;

    if include_obs;
	
    ** QUESTION: How do I get ride of the ageCat varible and in the include_obs variable 
	which were only created to facilitate subsetting the observations for the new work.DM2d dataset?;

 run;
 title "Print out of work.DM2d";
 proc print data = work.DM2d; run;


 /************************************** Task 1 ****************************************
 [1] Analyze the echo.DM dataset to compute the mean age for whites.
 *************************************************************************************/
 title1 "Summary of Age for Echo Trial Subjects";
 title2 "Race = White";
 proc means data = echo.DM;
  where RACE = 'WHITE';
  var age;
 run;


 title1 "Summary of Age for Echo Trial Subjects";
 title2 "Race = White";
 proc means data = echo.DM;
  if RACE = 'WHITE'; ** note the color -- this code does not work;
  var age;
 run;
