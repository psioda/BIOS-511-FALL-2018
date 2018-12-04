/*****************************************************************************
* Project           : BIOS 511 Course
*
* Program name      : 02-results-into-datasets.sas
*
* Author            : Matthew A. Psioda
*
* Date created      : 2018-12-04
*
* Purpose           : This program demonstrates converting results into SAS datasets;
*
* Revision History  :
*
* Date          Author   Ref (#)  Revision
* 
*
*
* searchable reference phrase: *** [#] ***;
******************************************************************************/
option mergenoby=error nodate nonumber nobyline;
ods noproctitle;
title;
footnote;

%let root      = C:/Users/psioda/Documents/GitHub/BIOS-511-FALL-2018; 
%let dataPath  = &root./data/echo;                                    
%let outPath   = &root./programs/2018-12-04-exam-review/02-results-into-datasets;

libname echo "&dataPath";       



/*
	PROC FREQ 
		[1] Use the OUT option;
		[2] Use ODS statement to direct output object to a dataset;

	PROC MEANS/UNIVARIATE 
		[1] Use the OUTPUT statement;
		[2] Use ODS statement to direct output object to a dataset;
*/




/*ods html close;*/
/*ods html newfile=none;*/

** Example 1 ****************************************************;
title "Example 1";
proc freq data = echo.DM;
 table country*armcd;
run;

** Example 2 ****************************************************;
title "Example 2";
ods select none;
ods output CrossTabFreqs = DS1 ChiSq = CST;
proc freq data = echo.DM;
 table country*armcd / chisq;
run;

ods select all;
proc print data = DS1; run;
proc print data = CST; run;

** Example 3 ****************************************************;
title "Example 3";
proc freq data = echo.DM noprint;
 table country*armcd / out = DS2 outpct;
run;
proc print data = DS2; run;




** Example 4 ****************************************************;
title "Example 4";
proc means data = echo.DM;
 class country armcd;
 var age;
run;

** Example 5 ****************************************************;
title "Example 5";
ods select none;
ods output Summary = DS1;
proc means data = echo.DM;
 class country armcd;
 var age;
run;
ods select all;
proc print data = DS1; run;

** Example 6 ****************************************************;
title "Example 6";
ods select none;
ods output BasicMeasures = DS2;
proc univariate data = echo.DM;
 class country armcd;
 var age;
run;
ods select all;
proc print data = DS2; run;



data temp;
 set echo.DM;
  dur = input(rfxendtc,yymmdd10.)-input(rfxstdtc,yymmdd10.)+1;
run;



** Example 7 ****************************************************;
title "Example 7";
proc means data = temp noprint /*nway*/;
 class country armcd;
 var age dur;
 output out = DS3 n(dur)=dur mean=mean_age mean_dur std=std_age atd_dur;
run;
proc print data = DS3; run;

** Example 8 ****************************************************;
title "Example 8";
proc means data = temp noprint;
 class country armcd;
 var age dur;
 output out = DS4 n(dur)= mean= / autoname;
run;
proc print data = DS4; run;

** Example 9 ****************************************************;
title "Example 9";
proc means data = temp noprint;
 class country armcd;
 var age dur;
 output out = DS5;
run;
proc print data = DS5; run;
