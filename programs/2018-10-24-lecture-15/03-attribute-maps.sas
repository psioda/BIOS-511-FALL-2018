/*****************************************************************************
* Project           : BIOS 511 Course
*
* Program name      : 03-attribute-maps.sas
*
* Author            : Matthew A. Psioda
*
* Date created      : 2018-10-23
*
* Purpose           : This program is designed to provide examples
*                     of using attribute maps in SAS
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
title "Example 1: Number of ECHO Trial Subjects by Treatment Group";
proc sgplot data = echo.dm;
  vbar armcd / group=country groupdisplay=cluster stat=percent;
  xaxis label="Treatment Group";
  yaxis grid;
run;

*******************************************************************;
** Example 2;
data attributes_ex2;
 infile datalines dlm=" "; 
 length id $10 value $10 fillcolor $20;
 input id $ value $ fillcolor $;
datalines;
CNT CAN veryLightBlue
CNT MEX blue
CNT USA veryDarkBlue
;
run;


title "Example 2: Number of ECHO Trial Subjects by Treatment Group";
proc sgplot data = echo.dm dattrmap=attributes_ex2;
  vbar armcd / group=country groupdisplay=cluster stat=percent attrid=CNT;
  xaxis label="Country";
  yaxis grid;
run; 
 
*******************************************************************;
** Example 3; 
data attributes_ex3;
 infile datalines dlm=","; 
 length id $10 value $20 fillcolor $20;
 input id $ value $ fillcolor $;
datalines;
CNT,Canada,veryLightYellow
CNT,Mexico,yellow
CNT,United States,veryDarkYellow
;
run;

proc format;
 value $cntfmt
  "CAN" = "Canada"
  "MEX" = "Mexico"
  "USA" = "United States";
run;

title "Number of ECHO Trial Subjects by Treatment Group";
proc sgplot data = echo.dm dattrmap=attributes_ex3;
  format country $cntfmt.;
  vbar armcd / group=country groupdisplay=cluster stat=percent attrid=CNT;
  xaxis label="Country";
  yaxis grid;
run;


*******************************************************************;
** Example 4; 

proc sort data = echo.dm(keep=usubjid armcd) out = dm;
 by usubjid;
run;

proc sort data = echo.vs out = vs1;
 by usubjid;
 where visitnum = 5;
run;

proc transpose data = vs1 out = vs2(drop=_name_ _label_);
 by usubjid;
 id vstestcd;
 idlabel vstest;
 var vsstresn;
run;

data vs3;
 merge dm(in=a) vs2(in=b);
 by usubjid;
  if not (a and b) then 
   put "ER" "ROR: Subject not found in both datasets -- " usubjid=;
run;


data attributes_ex4;
 infile datalines dlm=","; 
 length id $10 value $20 linecolor markercolor markersymbol  $20;
 input id $ value $ linecolor $ markercolor $ markersymbol $ linepattern ;
datalines;
TRT,ECHOMAX,red,veryLightRed,circleFilled,1
TRT,PLACEBO,blue,veryLightBlue,diamondFilled,2
;
run;

title "Example 4: Blood Pressure LOESS Curve by Treatment Group";
proc sgplot data = vs3 dattrmap=attributes_ex4;
 loess x=sysbp y=diabp / group=armcd attrid=trt markerattrs=(size=4) jitter;
 refline 90   / axis=y lineattrs=(color=gray pattern=2 thickness=2);
 refline 140  / axis=x lineattrs=(color=gray pattern=2 thickness=2);
run;

 