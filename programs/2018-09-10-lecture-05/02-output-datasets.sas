/*****************************************************************************
* Project           : BIOS 511 Course
*
* Program name      : 01-output-datasets.sas
*
* Author            : Matthew A. Psioda
*
* Date created      : 2018-09-10
*
* Purpose           : This program is designed to help students understand
*                     how to create datasets storing summary results from
*                     PROC MEANS, PROC UNIVARIATE, and PROC FREQ (without
*                     using ODS);
*
* Revision History  :
*
* Date          Author   Ref (#)  Revision
* 
*
*
* searchable reference phrase: *** [#] ***;
******************************************************************************/
option mergenoby=nowarn nodate nonumber;
ods noproctitle;

%let root     = C:/Users/psioda/Documents/GitHub/BIOS-511-FALL-2018; 
%let dataPath = &root./data/echo;

libname echo "&dataPath";


** Notes:
   [1] Any ODS object can be turned into a SAS dataset by delivering it to the ODS OUTPUT 
       destination
   [2] Most SAS procedures also allow certain results to be written to a more user-friendly
       SAS dataset using PROC-specific options/statements
   [3] Most of the time, if you want basic summary results in a data set, 
       option [2] is better than [1]
    


/*********************************************************************************************
                            Example # 1;
*********************************************************************************************/

** write the one-way frequency table ODS object into a SAS dataset;
ods output OneWayFreqs = work.A;
proc freq data = echo.DM;
 table armcd ;
run;
proc print data = work.A noobs ; run;


** write the one-way frequency data into a SAS dataset with the (PROC FREQ specific) OUT= option on the TABLE statement;
** note that the NOPRINT option is used to suppress *ALL* ODS output that would be produced by the procedure;
proc freq data = echo.DM noprint;
 table armcd / out = work.B;
run;
proc print data = work.B noobs; run;











/*********************************************************************************************
                            Example # 2;
*********************************************************************************************/ 

*********************************************************************************************;
** write the two-way frequency table ODS object into a SAS dataset;
ods output CrossTabFreqs = work.C;
proc freq data = echo.DM;
 table country*armcd ;
run;
proc print data = work.C noobs label; run;



** write the two-way frequency into a SAS dataset with the OUT= option on the TABLE statement;
** note that the NOPRINT option is used to suppress all ODS output;
proc freq data = echo.DM noprint;
 table country*armcd / out = work.D outpct;
run;
proc print data = work.D noobs; run;













/*********************************************************************************************
                            Example # 3 -- Illustration
*********************************************************************************************/ 

/********************************************************************************************
 Q: Practically speaking, why would you even want to deliver results as a SAS data set?

 A: Often we will want to put many results into a Table and it will require a two-step
    process: (1) obtain results, (2) put then in a Table that is atractive. To do this
    one needs to obtain the results in a format that SAS can further process.
 *******************************************************************************************/


** write the two-way frequency into a SAS dataset with the OUT= option on the TABLE statement;
** note that the NOPRINT option is used to suppress all ODS output;
proc freq data = echo.DM noprint;
 table country*armcd / out = work.D outpct;
run;
proc print data = work.D noobs; run;

proc format;
 value $ cnt
  "CAN" = "Canada"
  "MEX" = "Mexico";
 value $ trt
  "ECHOMAX" = "Intervention"
  "PLACEBO" = "Placebo";
run; 

** we will learn about making graphs later in the semester. This example is just to explain
   why one might want to output results to a SAS dataset instead of a PDF, RTF, or HTML file;
title "Distribution of Subjects by Country for each Treatment Group";
proc sgplot data = work.D;
 vbar armcd / group=country stat=mean response=pct_col groupdisplay=cluster datalabel=count;
 yaxis label='Percent of Treatment Group';
 xaxis label='Treatment Group';
 format country $cnt. armcd $trt.;
run;
title;


















/*********************************************************************************************
                            Example # 4;
*********************************************************************************************/ 

*********************************************************************************************;
** write the five number summary ODS object from PROC MEANS to an output dataset;
ods output summary=work.E;
proc means data = echo.DM n nMiss mean std min max fw=2;
 class armcd;
 var age;
run;
proc print data = work.E noobs ; run;

** write the five number summary from PROC MEANS to an output dataset using the OUTPUT statement;
** this code works verbatim for PROC UNIVARIATE;
proc means data = echo.DM noprint;
 class armcd;
 var age;
 output out = work.F n=sampleSize nMiss=numMiss mean=meanVal std=stdDev min=minimum max=maximum ;
run;
proc print data = work.F noobs ; run;

** using the AUTO_NAME option on the OUTPUT statement to name variables;
** PROC UNIVARIATE does not support AUTO_NAME;
proc means data = echo.DM noprint;
 class armcd;
 var age;
 output out = work.G n= nMiss= mean= std= min= max= / autoname;
run;
proc print data = work.G noobs; run;

















/*********************************************************************************************
                            Example # 5;
*********************************************************************************************/ 
** Analysis with multiple classification variables;
proc means data = echo.DM;
 class armcd country;
 var age;
 output out = work.H n=ageN nMiss=ageMiss mean=ageMean std=ageSD min=ageMin max=ageMax ;
run;
proc print data = work.H noobs ; run;

** The NWAY option for the PROC MEANS statement modifies the output dataset to only include the summary
   for each combination of levels of the variables in the CLASS statement;
proc means data = echo.DM nway;
 class armcd country;
 var age;
 output out = work.I n=ageN nMiss=ageMiss mean=ageMean std=ageSD min=ageMin max=ageMax ;
run;
proc print data = work.I noobs ; run;

** The WAYS statement modifies the output dataset to restrict how 
   data are analyzed using combinations of the class variable;
proc means data = echo.DM;
 class armcd country;
 var age;
 ways 0 1 2;
 output out = work.J n=ageN nMiss=ageMiss mean=ageMean std=ageSD min=ageMin max=ageMax ;
run;
proc print data = work.J noobs ; run;


** The TYPES statement modifies the output dataset to restrict how 
   data are analyzed using combinations of the class variable;
proc means data = echo.DM;
 class armcd country race;
 var age;
 types armcd*(country race);
 output out = work.K n=ageN nMiss=ageMiss mean=ageMean std=ageSD min=ageMin max=ageMax ;
run;
proc print data = work.K noobs; run;


















/*********************************************************************************************
                            Example # 6 - illustration;
*********************************************************************************************/ 

 data work._temp_;
  set work.k;
   class = cats(country,race);
   lowLimit = ageMean - 1.96*ageSD/sqrt(ageN);
   highLimit = ageMean + 1.96*ageSD/sqrt(ageN);
 run; proc sort; by _type_ class; run;

 proc format;
  value type
   5 = 'Race'
   6 = 'Country';
 run;

 option nobyline;
 title1 "Estimated Mean and 95% Confidence Intervals for Age by Treatment Group";
 title2 "Subgroup=#byval(_type_)";
 proc sgplot data = work._temp_;
  by _type_;
  highlow x=class low=lowLimit high=highLimit / 
       group=armcd groupdisplay=cluster highcap=serif lowcap=serif lineattrs=(thickness=2);
  scatter x=class y=ageMean / group = armcd  groupdisplay=cluster markerattrs=(symbol=diamondFilled);
   yaxis label='Age (years)' values=(50 to 75 by 5) grid;
   xaxis label='Subgroup Level';
   format _type_ type.;
   label armcd = 'Treatment Group';
 run; 
