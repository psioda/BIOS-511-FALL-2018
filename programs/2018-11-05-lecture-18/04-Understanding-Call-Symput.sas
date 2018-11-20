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
 call symput(sex,usubjid);
run;
%put  &=M &=F;







*** What is the NAME of the created macro variable??;
*** What is the VALUE of the created macro variable??;
data _null_;
 set dm;
 call symput('age',strip(put(age,12.)));
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
%put &=ECHO_031_009;







*** Will this code work correctly?;
data _null_;
 set dm;
  call symput('SID',studyid);
  studyid2 = "&SID.";
run;









** A MORE COMPLEX (FUN) EXAMPLE;
ods select Position;
proc contents data = dm out = contents varnum; run;
proc print data = contents; run;

data _null_;
 set contents end=last;
 
 put _n_ last;
  
 
 length typec $4;
 if type = 1 then typec = 'Num';
 else             typec = 'Char';
 
 call symput(  'var'||strip(put(_n_,best.)), strip(name));
 call symput(  'label'||strip(put(_n_,best.)), strip(label));
 call symput(  'type'||strip(put(_n_,best.)), strip(typec));
 
    if last = 1;

 call symput(   'numVars'  ,   strip(put(_n_,best.))     );

run;

%put &=var7;
%put &=label7;
%put &=type7;


option nomprint nomlogic nomfile nosymbolgen;
%macro print;
  %do i = 1 %to &numVars.;

   %put &&var&i;
   %put &&label&i;
   %put &&type&i;
   %* How do I print out the macro variables I just created;
   

  
  %end;
%mend;
%print;








 filename mprint "&outPath.\macro_print_out.sas";
 option mlogic symbolgen mprint mfile; 

%macro summary;
  %do i = 1 %to &numVars.;

   %put &=i;
   %put &&var&i;
   %put &&label&i;
   %put &&type&i;  
   %* How do summarize the variables in the dataset one at a time using
      the macro variables I just created;
      
      %if %upcase(&&type&i) = CHAR  %then %do;
       title "Frequency Analysis of Variable = &&var&i (&&label&i)";
       proc freq data = DM;
        table &&var&i;
       run;
      %end;
      %else %do;
       title "Analysis of Variable = &&var&i (&&label&i)";
       proc means data = DM;
        var &&var&i;
       run;
      %end;
      
  %end;
%mend;
%summary;
