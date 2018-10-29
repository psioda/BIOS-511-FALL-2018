/*****************************************************************************
* Project           : BIOS 511 Course
*
* Program name      : 01-SGPANEL.sas
*
* Author            : Matthew A. Psioda
*
* Date created      : 2018-10-28
*
* Purpose           : This program is designed to provide examples
*                     of using the SGPANEL procedure
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
** Supporting Code;
*******************************************************************;

proc format;
 value agefmt
 low - <65 =  "<65 years"
 65 - high = ">=65 years";
 value $sexfmt
  "M" = "Male"
  "F" = "Female";
run;


proc sort data = echo.vs out = vs;
 by usubjid;
run;

proc sort data = echo.dm out = dm;
 by usubjid;
run;

data vsdm1;
 merge dm(in=a) vs(in=b);
 by usubjid;
  if a and b;
run;

proc sort data = vsdm1 out = vsdm2;
 by vstestcd vstest visitnum visit;
run;



*******************************************************************;
** Example 1;
*******************************************************************;

title "Example 1A: Distribution of Diastolic Blood Pressure by Visit and Age Category";
 proc sgplot data =vsdm2;
  where age>. and vstestcd ='DIABP';
  format age agefmt.;

  vbox vsstresn / category=visit group=age;

  yaxis label = "Diastolic Blood Pressure (mmHg)";
  xaxis label = 'Visit' type=discrete values=('Screening' 'Week 0' 'Week 8' 'Week 16' 'Week 24' 'Week 32');
run;


title "Example 1B: Distribution of Diastolic Blood Pressure by Visit and Age Category";
 proc sgpanel data =vsdm2;
  where age>. and vstestcd ='DIABP';
  format age agefmt.;

  panelby age / /*novarname*/;
  vbox vsstresn / category=visit ;

  rowaxis label = "Diastolic Blood Pressure (mmHg)";
  colaxis label = 'Visit' type=discrete values=('Screening' 'Week 0' 'Week 8' 'Week 16' 'Week 24' 'Week 32');
run;


*******************************************************************;
** Example 2;
*******************************************************************;
title1 "Example 2A: Distribution of Diastolic Blood Pressure";
title2 "by Visit, Age Category, and Gender";
 proc sgpanel data =vsdm2;
  where age>. and vstestcd ='DIABP';
  format age agefmt. sex $sexfmt.;

  panelby age;
  vbox vsstresn / category=visit group=sex;

  rowaxis label = "Diastolic Blood Pressure (mmHg)";
  colaxis label = 'Visit' type=discrete values=('Screening' 'Week 0' 'Week 8' 'Week 16' 'Week 24' 'Week 32');
run;


/*ods graphics / height=5in width=8in;*/
title1 "Example 2B: Distribution of Diastolic Blood Pressure";
title2 "by Visit, Age Category, and Gender";
 proc sgpanel data =vsdm2;
  by vstestcd;
  where age>. and vstestcd ='DIABP';
  format age agefmt. sex $sexfmt.;

  panelby age sex / /*rows=1 onepanel novarname*/;
  vbox vsstresn / category=visit ;
  rowaxis label = "Diastolic Blood Pressure (mmHg)";
  colaxis label = 'Visit' type=discrete values=('Screening' 'Week 0' 'Week 8' 'Week 16' 'Week 24' 'Week 32');

run;
/*ods graphics / reset=all;*/


ods graphics / height=6in width=6in;
title1 "Example 2C: Distribution of Diastolic Blood Pressure";
title2 "by Visit, Age Category, and Gender";
 proc sgpanel data =vsdm2;
  by vstestcd;
  where age>. and vstestcd ='DIABP';
  format age agefmt. sex $sexfmt.;

  panelby age sex / layout=lattice;
  vbox vsstresn / category=visit ;
  rowaxis label = "Diastolic Blood Pressure (mmHg)";
  colaxis label = 'Visit' type=discrete values=('Screening' 'Week 0' 'Week 8' 'Week 16' 'Week 24' 'Week 32');
run;
ods graphics / reset=all;


*******************************************************************;
** Supporting Code;
*******************************************************************;


proc means data = vsdm2 noprint nway;
 by vstestcd vstest visitnum visit;
 class armcd sex;
 var vsstresn;
 output out = summary n=n mean=mean stddev=sd;
run;

data summary2;
 set summary;
  lower = mean-2.0*sd;
  upper = mean+2.0*sd;
run;


*******************************************************************;
** Example 3;
*******************************************************************;
ods graphics / height=5in width=9in;
title1 "Example 2A: Distribution of Diastolic Blood Pressure";
title2 "by Visit, Gender, and Treatment Group";
 proc sgpanel data =summary2;
  where vstestcd ='DIABP';
  format sex $sexfmt. mean 3.;

  panelby sex / rows=1;


  highlow x=visit low=lower high=upper / group=armcd highcap=serif lowcap=serif /*groupdisplay=cluster clusterwidth=0.2*/;



  series x=visit y=mean                / group=armcd /*groupdisplay=cluster clusterwidth=0.2*/ 
                                         /*markers markerattrs=(symbol=circleFilled)*/
                                         /*datalabel=mean*/;

  rowaxis label = "Diastolic Blood Pressure (mmHg)";
  colaxis label = 'Visit' type=discrete values=('Screening' 'Week 0' 'Week 8' 'Week 16' 'Week 24' 'Week 32');
run;
ods graphics / reset=all;
