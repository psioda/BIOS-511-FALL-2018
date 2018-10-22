/*****************************************************************************
* Project           : BIOS 511 Course
*
* Program name      : 01-default-ODS-Graphics.sas
*
* Author            : Matthew A. Psioda
*
* Date created      : 2018-10-22
*
* Purpose           : This program is designed to provide examples
*                     of using default ODS graphics
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



/*********************************** Using DEFAULT ODS Graphics ****************************/
** Most analysis proceedures in SAS produce reasonable quality graphics "by default";
** These graphics are helpful for "quick-and-dirty" representations of the data
   put are difficult to customize (based on what you will learn in this course);
** We will learn about making fully customized graphs very soon!;

proc sort data = echo.DM out = DM(keep=usubjid armcd sex age);
 by usubjid;
run;

proc sort data = echo.vs out = vs;
 by usubjid;
run;

proc transpose data = vs out = vs2(drop=_:);
 where visit = 'Week 32';
 by usubjid;
   id vstestcd;
   idlabel vstest;
   var vsstresn;
run;

data vs3;
 merge dm vs2;
run;


*** EXAMPLE 1 - One-Way Frequency Analysis;
proc freq data = DM;
 table armcd / plots=all;
run;

*** EXAMPLE 2 - Linear regression w/ PROC GLM;
** graphs can be selected/excluded with ODS SELECT/EXCLUDE;
proc GLM data = VS3 plots=(all);
 class armcd(ref='PLACEBO');
 model sysbp = armcd;
run;

*** EXAMPLE 3 - Correlation analysis with PROC CORR;
proc corr data = VS3 plots(maxpoints=10000)=ScatterPlot ;
 var weight hr sysbp diabp;
run;

*** EXAMPLE 4 - Correlation analysis with PROC CORR;
proc corr data = VS3 plots(maxpoints=10000)=matrixplot(histogram);
 var weight hr sysbp diabp;
run;

*** EXAMPLE 5 - Logistic regression analysis - Forrest Plot;
data vs4;
 set vs3;
  controlled=(sysbp<140);
  age = age / 10;
run;
proc logistic data = vs4 plots(only)=OddsRatio;
 class armcd(ref='PLACEBO') sex(ref='F') / param=ref;
 model controlled(event='1') = armcd sex age;
run;


/*********************************** Customizing DEFAULT ODS Graphics using GTL ****************************/

proc freq data = DM;
 table armcd / plots=FreqPlot;
run;

proc template;
   source Base.Freq.Graphics.OneWayFreqChart;
run;
 

ods path work.mystore(update) sashelp.tmplmst(read);

proc template;
source Base.Freq.Graphics.OneWayFreqChart;
define statgraph Base.Freq.Graphics.OneWayFreqChart;
   notes "One-Way Bar Charts, Orient=Horizontal";
   dynamic _CUM _ORIENT _VARNAME _VARLABEL _SVARLABEL _FREQVAR _FREQLABEL _SFREQLABEL
      _TIPVAR _TIPVAR2 _INTEGER _byline_ _bytitle_ _byfootnote_;
   begingraph / includeMissingDiscrete=true;
      if (_CUM)
         entrytitle "Cumulative Distribution of " _VARNAME;
      else
         entrytitle "Distribution of " _VARNAME;
      endif;
      if (_ORIENT)
         layout overlay / xaxisopts=(shortlabel=_SVARLABEL) yaxisopts=(label=_FREQLABEL
            shortlabel=_SFREQLABEL griddisplay=auto_on offsetmin=0 offsetmax=.05
            linearopts=(integer=_INTEGER viewmin=0 thresholdmax=1));
            barchartparm x=_LEVEL y=_FREQVAR / datatransparency=.5 rolename=(tip3=
               _TIPVAR tip4=_TIPVAR2) tip=(x y tip3 tip4);
         endlayout;
      else
         layout overlay / xaxisopts=(label=_FREQLABEL shortlabel=_SFREQLABEL
            griddisplay=auto_on offsetmin=0 offsetmax=.05 linearopts=(integer=_INTEGER
            viewmin=0 thresholdmax=1)) yaxisopts=(shortlabel=_SVARLABEL);
            barchartparm x=_LEVEL y=_FREQVAR / orient=horizontal datatransparency=.5
               rolename=(tip3=_TIPVAR tip4=_TIPVAR2) tip=(x y tip3 tip4);
         endlayout;
      endif;
      if (_BYTITLE_)
         entrytitle _BYLINE_ / textattrs=GRAPHVALUETEXT;
      else
         if (_BYFOOTNOTE_)
            entryfootnote halign=left _BYLINE_;
         endif;
      endif;
   endgraph;
end;
run;


proc freq data = DM;
 table armcd / plots=FreqPlot;
run;


ods path reset;

/*********************************** Do it Yourself ODS Graphics ****************************/

title "Percent of ECHO Trial Subjects in Each Treatment Group";
proc sgplot data = DM;
 vbar armcd / fillattrs=(color=darkRed) dataskin=crisp stat=percent;
run;












