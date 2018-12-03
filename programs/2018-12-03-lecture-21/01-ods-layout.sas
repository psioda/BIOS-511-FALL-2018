/*****************************************************************************
* Project           : BIOS 511 Course
*
* Program name      : 01-ODS-Layout.sas
*
* Author            : Matthew A. Psioda
*
* Date created      : 2018-12-03
*
* Purpose           : This program demonstrates ODS layout;
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
%let outPath   = &root./programs/2018-12-03-lecture-21/output;        ** use TEXT SUBSTITUTION to define the OUTPATH macro variable;

libname echo "&dataPath";                                             ** use TEXT SUBSTITUION to define the ECHO libref;


proc SQL noprint;
 create table vs as
 select a.*,b.armcd
 from echo.vs as a, echo.dm as b
 where a.usubjid=b.usubjid and a.vstestcd in ('SYSBP' 'DIABP' ) and a.visitnum >=0
 order by visitnum,visit,vstestcd;
quit;

proc means data = vs noprint nway;
 class vstestcd visitnum visit armcd;
 var vsstresn;
 output out = summary mean=mean uclm=ucl lclm=lcl max=max min=min;
run;

data summary;
 set summary;
  label mean = 'Mean'
        lcl  = 'LL'
		ucl  = 'UL';
	var = put(mean,6.1)||' ('||strip(put(lcl,6.1))||','||strip(put(ucl,6.1))||')';

	week = input(scan(visit,2),best.);
run; 

proc transpose data = summary out = tran_summaryS(drop=_:) prefix=s_;
 by visitnum visit week;
 where vstestcd = 'SYSBP';
 id armcd;
 var var;
run;

proc transpose data = summary out = tran_summaryD(drop=_:) prefix=d_;
 by visitnum visit week;
 where vstestcd = 'DIABP';
 id armcd;
 var var;
run;

data tran_summary;
 merge tran_summaryS tran_summaryD;
 by visitnum visit week;
run;

ods noresults;
title;
footnote;


/* Set landscape orientation, and turn off the date and page number */
options orientation=landscape nodate nonumber;

/* Ensure that all ODS destinations are closed */
ods _all_ close;

/* Inline styles will be used later, so set the ESCAPECHAR value */
ods escapechar="^";

/* Open the PDF destination, turn off the table of contents/bookmarks, */
/* and set NOGTITLE which removes titles from graph images */
ods pdf file="&outPath.\odslayout.pdf" notoc nogtitle;

title1 "Summary of Blood Pressure Change Over 32-Week Dosing Period for ECHO Trial";
footnote1 "Created by SAS version: &sysver";

/* Define a layout that is 7.25 inches high and 10.5 inches wide. 
   We have set the system option ORIENTATION= to LANDSCAPE on an OPTIONS statement. 
   We defined a title and footnote, whose text will be placed outside the layout. */
ods layout start height=7.00in width=8.5in; 

ods region x=0.0in y=0.5in width=6in; 
proc odstext ;
   p " ";
   p "Summary of Systolic/Diastolic Blood Pressure by Treatment Group" / 
      style=[font=(Arial) fontsize=12pt just=c];
   p "Mean (95% Confidence Interval)" / 
      style=[font=(Arial) fontsize=8pt just=c];

run;

proc report data = tran_summary split='^';
 column (visitnum week 
          ("Systolic Blood Pressure" s_echomax s_placebo)
          ("Diastolic Blood Pressure" d_echomax d_placebo) );
  define visitnum   / group order=formatted noprint;
  define week       / group "Weeks^Post Dose"                 style={cellwidth=1.00in just=c};
  define s_echomax  / display "Investigational Treatment"     style={cellwidth=1.10in};
  define s_placebo  / display "Placebo"                       style={cellwidth=1.10in};
  define d_echomax  / display "Investigational Treatment"     style={cellwidth=1.10in};
  define d_placebo  / display "Placebo"                       style={cellwidth=1.10in};
run;


ods region x=0.5in y=4in width=5.0in; 
data features;
   input feature $100.;
   datalines;
To be enrolled in the ECHO Trial subjects had to present with SBP >= 125 and DBP >= 85 at baseline.
Treated subjects received 4mg ECHOMAX tablets twice daily over the 32 week dosing period.
;
run;

proc odstext ;
   p " ";
   p "Notes:" / 
      style=[font=(Arial) fontsize=8pt just=l];
run;
proc odslist data=features;
   item feature / value=1 style={bullet="disc" font=(Arial) fontsize=8pt just=l indent=0.0in};
   end;
run;


ods region x=6in y=.5in; 
ods graphics on / reset noborder height=2.75in width=3.5in;

proc sgplot data=summary noautolegend;
   title;
   footnote;
    where vstestcd = 'SYSBP';
   highlow x=week low=lcl high=ucl / /*lineattrs=(color=biyg thickness=12pt)*/ highcap=serif lowcap=serif groupdisplay=cluster clusterwidth=0.2;
   series x=week y=mean / markers markerattrs=(size=10pt symbol=circlefilled) group=armcd name="x" groupdisplay=cluster clusterwidth=0.2;
   xaxis label=" " display=(noticks nolabel) valueattrs=(color=white);
   yaxis label="Systolic Blood Pressure (mmHg)" ;
run;

ods region x=6in y=3.50in; 
ods graphics on / reset noborder height=2.75in width=3.5in;

proc sgplot data=summary;
   title;
   footnote;
    where vstestcd = 'DIABP';
   highlow x=week low=lcl high=ucl / /*lineattrs=(color=biyg thickness=12pt)*/ highcap=serif lowcap=serif groupdisplay=cluster clusterwidth=0.2;
   series x=week y=mean / markers markerattrs=(size=10pt symbol=circlefilled) group=armcd name="x" groupdisplay=cluster clusterwidth=0.2;
   xaxis label="Weeks Post Dose" values=(0 8 16 24 32);
   yaxis label="Diastolic Blood Pressure (mmHg)" ;
   keylegend "x"/ noborder;
run;

/* End the current layout */ 
ods layout end;

/* Close the PDF destination so that we can open FILE.PDF */
ods pdf close;

