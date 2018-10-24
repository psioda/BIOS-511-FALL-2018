/*****************************************************************************
* Project           : BIOS 511 Course
*
* Program name      : 02-styleattrs-statement.sas
*
* Author            : Matthew A. Psioda
*
* Date created      : 2018-10-23
*
* Purpose           : This program is designed to provide examples
*                     of using the STYLEATTRS stat
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
title "Example 1A: Percent of Subjects per Country and Treatment Group";
 proc sgplot data = echo.dm;
  vbar armcd / group=country groupdisplay=cluster stat=percent;
 run;

title "Example 1B: Percent of Subjects per Country and Treatment Group";
proc sgplot data = echo.dm;
 styleattrs dataColors=(blue black orange); ** controls group colors that are cycled through;
  vbar armcd / group=country groupdisplay=cluster stat=percent;
run;


data DM;
 set echo.DM;
  yearEnr = scan(rficdtc,1,'-');
  trtDur  = input(rfxendtc,yymmdd10.)-input(rfxstdtc,yymmdd10.)+1;

  cnt_arm = catx('-',country,armcd);
run; proc sort; by cnt_arm; run;




*******************************************************************;
** Example 2;
title "Example 1A: Age Distribution by Year of Enrollment";
proc sgplot data = dm;
  vbox age / group=yearEnr groupdisplay=cluster;
  yaxis label = 'Age (years)';
  keylegend / title="Year of Enrollment";
run;


ods graphics / noborder;
title "Example 2A: Age Distribution by Year of Enrollment";
proc sgplot data = dm;
 styleattrs dataColors=(red purple); 
  vbox age / group=yearEnr groupdisplay=cluster;
  yaxis label = 'Age (years)';
  keylegend / title="Year of Enrollment";
run;
ods graphics / reset=all;


*******************************************************************;
** Example 3;
ods graphics / attrpriority=none;
title "Example 3: Age Distribution by Country and Treatment Group";
proc sgplot data = dm;
  styleattrs dataColors=(red purple) datasymbols=(diamondFilled squareFilled); 
  scatter x=cnt_arm y=trtDur / group=armcd jitter markerattrs=(size=5);
  yaxis label = 'Age (years)';
  xaxis label = 'Country / Treatment Group' splitchar='-' fitpolicy=splitalways;
run;
ods graphics / reset=all;
