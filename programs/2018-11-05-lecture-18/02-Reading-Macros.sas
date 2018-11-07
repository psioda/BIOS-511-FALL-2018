/*****************************************************************************
* Project           : BIOS 511 Course
*
* Program name      : 02-Reading-Macros.sas
*
* Author            : Matthew A. Psioda
*
* Date created      : 2018-11-05
*
* Purpose           : This program is designed to help students understand
*                     how SAS Macro's can be defined elsewhere and used
*                     within a program.
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


** SAS code to import SAS code from another program.;
%include "&macroPath./freqTab4.sas" / source;

** Q: how could we assign the file name with a macro variable;
ods html close;
ods pdf file = "&outpath./ECHO-Trial-Tabulations.pdf" style=journal;
	%freqTab4;
	%freqTab4(var4=Country);
	%freqTab4(var4=Sex);
	%freqTab4(var4=Race);
ods pdf close;
