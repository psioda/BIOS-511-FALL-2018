/*****************************************************************************
* Project           : BIOS 511 Course
*
* Program name      : 01-style-templates.sas
*
* Author            : Matthew A. Psioda
*
* Date created      : 2018-10-23
*
* Purpose           : This program is designed to provide examples
*                     of using ODS style templates to controll
*                     attributes for graphs
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

%let outPath  = &root./programs/2018-10-24-lecture-15/output;


*******************************************************************;
** Example 1;
ods pdf file = "&outPath./default.pdf" style=default nogtitle;
 title "Number of ECHO Trial Subjects by Treatment Group";
 proc sgplot data = echo.dm;
  vbar armcd;
 run;
ods pdf close;


*******************************************************************;
** Example 2;
ods pdf file = "&outPath./sasweb.pdf" style=sasweb nogtitle;
 title "Number of ECHO Trial Subjects by Treatment Group";
 proc sgplot data = echo.dm;
  vbar armcd;
 run;
ods pdf close;


*******************************************************************;
** Example 3;
ods pdf file = "&outPath./journal.pdf" style=journal nogtitle;
 title "Number of ECHO Trial Subjects by Treatment Group";
 proc sgplot data = echo.dm;
  vbar armcd;
 run;
ods pdf close;
