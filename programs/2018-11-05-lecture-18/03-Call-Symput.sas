/*****************************************************************************
* Project           : BIOS 511 Course
*
* Program name      : 03-Call-Symput.sas
*
* Author            : Matthew A. Psioda
*
* Date created      : 2018-11-05
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


%macro freqTab5(libref=WORK,ds=DM,var=armcd);

** create a macro variable storing the label of the analysis variable;
proc contents data = &libref..&ds. out = contents noprint; run;

data _null_;
 set contents;
 where upcase(name) = "%upcase(&var.)";
 call symput("label",strip(label));
run;

** create a macro variable storing the number of observations in the dataset.;
data _null_;
 set &libref..&ds. end=last;
 if last=1 then call symput('N',strip(put(_n_,best.)));
run;



proc freq data = &libref..&ds. noprint order=freq;
 table &var. / out = &var.Dist;
run;


title1 "Number and Percent of ECHO Trial subjects by &label.";
title2 "(N=&N.)";
proc print data = &var.Dist label noobs ;
 label count   = "n";
 label percent = "%";
 format percent 6.2;
 var &var. count percent;
run;

%mend freqTab5;

/*%freqTab5;*/

%freqTab5(libref=ECHO,ds=DM,var=ARMCD);
%freqTab5(libref=ECHO,ds=DM,var=RACE);
%freqTab5(libref=ECHO,ds=DM,var=SEX);
