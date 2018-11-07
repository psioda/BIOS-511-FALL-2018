/*****************************************************************************
* Project           : BIOS 511 Course
*
* Program name      : 01-Sample-Macro-Program.sas
*
* Author            : Matthew A. Psioda
*
* Date created      : 2018-11-05
*
* Purpose           : This program is designed to help students understand
*                     how SAS Macro's function.
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




/****************************************************************************/
/********************* Basic Use of Macro Variables *************************/


%let root     = C:/Users/psioda/Documents/GitHub/BIOS-511-FALL-2018; ** define the ROOT macro variable;
%let dataPath = &root./data/echo;                                    ** use TEXT SUBSTITUTION to define the DATAPATH macro variable;


%put NOTE: dataPath = &dataPath.;                                    ** write value of DATAPATH to SAS log;
%put NOTE: &=datapath.;                                              ** short hand;


libname echo "&dataPath";                                            ** use TEXT SUBSTITUION to define the ECHO libref;


/****************************************************************************/
/************************** Brute Force Code ********************************/

/*** Analyze Country Variable ***/
proc freq data = echo.DM noprint order=freq;
 table country / out = countryDist;
run;
title1 "Number and Percent of ECHO Trial subjects by Country";
proc print data = countryDist label noobs;
 label count   = "n";
 label percent = "%";
 format percent 6.2;
 var country count percent;
run;

/*** Analyze Sex Variable ***/
proc freq data = echo.DM noprint order=freq;
 table sex / out = sexDist;
run;
title1 "Number and Percent of ECHO Trial subjects by Sex";
proc print data = sexDist label noobs;
 label count   = "n";
 label percent = "%";
 format percent 6.2;
 var sex count percent;
run;

/*** Analyze Race Variable ***/
proc freq data = echo.DM noprint order=freq;
 table race / out = raceDist;
run;
title1 "Number and Percent of ECHO Trial subjects by Race";
proc print data = raceDist label noobs;
 label count   = "n";
 label percent = "%";
 format percent 6.2;
 var race count percent;
run;



/****************************************************************************/
/********************* Simple Macro w/o Parameters **************************/
%macro freqTab1;
	proc freq data = echo.DM noprint order=freq;
	  table &var1. / out = &var1.Dist;
	run;

	title1 "Number and Percent of ECHO Trial subjects by &var1.";
	proc print data = &var1.Dist label noobs ;
	  label count   = "n";
	  label percent = "%";
	  format percent 6.2;
	    var &var1. count percent;
	run;
%mend freqTab1;

%let var1 = Country;
%freqTab1;

%let var1 = Sex;
%freqTab1;

%let var1 = Race;
%freqTab1;


/****************************************************************************/
/******************** Simple Macro w Positional Parameter********************/
%macro freqTab2(var2);
	proc freq data = echo.DM noprint order=freq;
	 table &var2. / out = &var2.Dist;
	run;

	title1 "Number and Percent of ECHO Trial subjects by &var2.";
	proc print data = &var2.Dist label noobs ;
	  label count   = "n";
	  label percent = "%";
	  format percent 6.2;
	    var &var2. count percent;
	run;
%mend freqTab2;

%freqTab2(Country);
%freqTab2(Sex);
%freqTab2(Race);

/****************************************************************************/
/****************** Simple Macro w Non-positional Parameter******************/
%macro freqTab3(var3=armcd);
	proc freq data = echo.DM noprint order=freq;
	 table &var3. / out = &var3.Dist;
	run;

	title1 "Number and Percent of ECHO Trial subjects by &var3.";
	proc print data = &var3.Dist label noobs ;
	  label count   = "n";
	  label percent = "%";
	  format percent 6.2;
	    var &var3. count percent;
	run;
%mend freqTab3;

%freqTab3;
%freqTab3(var3=Country);
%freqTab3(var3=Sex);
%freqTab3(var3=Race);
