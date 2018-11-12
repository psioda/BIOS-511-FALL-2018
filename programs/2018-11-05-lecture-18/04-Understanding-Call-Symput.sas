/*****************************************************************************
* Project           : BIOS 511 Course
*
* Program name      : 04-Understanding-Call-Symput.sas
*
* Author            : Matthew A. Psioda
*
* Date created      : 2018-11-12
*
* Purpose           : This program is designed to teach students how
*                     to use the CALL SYMPUT routine to create macro variables;
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
ods html;



%let root      = C:/Users/psioda/Documents/GitHub/BIOS-511-FALL-2018; ** define the ROOT macro variable;
%let dataPath  = &root./data/echo;                                    ** use TEXT SUBSTITUTION to define the DATAPATH macro variable;
%let macroPath = &root./programs/2018-11-05-lecture-18/macros;        ** use TEXT SUBSTITUTION to define the MACROPATH macro variable;
%let outPath   = &root./programs/2018-11-05-lecture-18/output;        ** use TEXT SUBSTITUTION to define the OUTPATH macro variable;


libname echo "&dataPath";                                             ** use TEXT SUBSTITUION to define the ECHO libref;

data dm;
 set echo.dm(obs=10);
 drop visit: dmdtc rf:;
proc print data = dm; run;









*** What is the NAME of the created macro variable??;
*** What is the VALUE of the created macro variable??;
data _null_;
 set dm;
 call symput(studyid,usubjid);
run;
%put /* TBD */;







*** What is the NAME of the created macro variable??;
*** What is the VALUE of the created macro variable??;
data _null_;
 set dm;
 call symput('age',age);
run;
%put /* TBD */ &=age;






*** Trick Questions:
*** What is the NAME of the created macro variable??
*** What is the VALUE of the created macro variable??;
data _null_;
 set dm;
 mVar = tranwrd(usubjid,'-','_');
 call symput(mVar,age);
run;
%put /* TBD */;







*** Will this code work correctly?;
data _null_;
 set dm;
  call symput('SID',studyid);
  studyid2 = "&SID.";
run;









** A MORE COMPLEX (FUN) EXAMPLE;
ods select Position;
proc contents data = dm out = contents varnum; run;

data _null_;
 set contents end=last;
 put _n_= last=;
  
 length typec $4;
 if type = 1 then typec = 'Num';
 else             typec = 'Char';


 
 call symput(  'var'||strip(put(_n_,best.)), name);
 call symput(  'label'||strip(put(_n_,best.)), label);
 call symput(  'type'||strip(put(_n_,best.)), typec);
 
    if last;

 call symput('numVars',strip(put(_n_,best.)));
 
run;

%put &=var1;
%put &=label1;
%put &=type1;






%macro print;
  %do i = 1 %to &numVars.;

   %put &=i;
   
   %* How do I print out the macro variables I just created;

  %end;
%mend;
%print;









%macro summary;
  %do i = 1 %to &numVars.;

   %put &=i;
   
   %* How do summarize the variables in the dataset one at a time using
      the macro variables I just created;


     /** Character Variables -- Use PROC FREQ **/


     /** Numeric Variables -- Use PROC MEANS **/


  %end;
%mend;
%summary;
