/*****************************************************************************
* Project           : BIOS 511 Course
*
* Program name      : 01-macros.sas
*
* Author            : Matthew A. Psioda
*
* Date created      : 2018-12-04
*
* Purpose           : This program demonstrates using a macro;
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

%let root      = C:/Users/psioda/Documents/GitHub/BIOS-511-FALL-2018; 
%let dataPath  = &root./data/echo;                                    
%let outPath   = &root./programs/2018-12-04-exam-review/03-transposing-data;        

libname echo "&dataPath";                                             


** How do I write a macro that perfoms linear regression of the dependent variable Y (separately) 
   on indepdent variables with prefix XXX in a dataset;


  /** linear regression template code:

	 ods select none;
     ods output ParameterEstimates = ParmEst;
     proc reg data = <input dataset> plots=(none);
      model <dependent variable> = <independent variable> / clb; 
     run;
     quit;
     ods select all;

  **/


** code is used to simulate a dataset;
data reg_dat;
 call streaminit(123);

 subject = .;

 format Y X_COVA X_COVB X_COVC X_EXPOSURE 7.3;
 Y = .;
 array x[4] X_COVA X_COVB X_COVC X_EXPOSURE;
 array b[4] _temporary_ (0 1 2 2);

 do subject = 1 to 20;
 	 y = 0;
	 do j = 1 to dim(x);
	  x[j] = rand('normal');
	  y    = y + x[j]*b[j];
	 end;
     y    = y + rand('normal',0,5);
     output;
 end;
 drop j;
run;
proc print data = reg_dat; run;


** example linear regression code;
 ods select none;
 ods output ParameterEstimates = work.ParmEst;
 proc reg data = reg_dat plots=(none);
  model y = X_EXPOSURE / clb; 
 run;
 quit;
 ods select all;
 
 title "Single-Variable Regression Estimates";
 proc print data = parmEst;
  where upcase(variable)  ='X_EXPOSURE';
 run;


/*
  What do I need to do:
   [1] Get a list of independent variables
   [2] Count the number of indepdentn variables
   [3] Perform linear regression with each independent variable
   [4] Append the results to a dataset that stores all estimates
       from the regressions by the end
   [5] Print out the regression estimates
*/

%macro linRegA(ds=,Dvar=,covList=);

	%let numVar = %sysfunc(countw(&covList.,|));
	/*%put &=numVar;*/
    %do i = 1 %to &numVar;
    
     %let cov = %scan(&covList.,&i.,|);
     
	 ods select none;
     ods output ParameterEstimates = ParmEst&i.;
     proc reg data = &ds. plots=(none);
      model &dvar. = &cov. / clb; 
     run;
     quit;
     ods select all;
    
    %end;
    
    data results;
     set 
        %do i = 1 %to &numVar; 
           ParmEst&i.
        %end;
       ;
       where upcase(variable) ^= "INTERCEPT";
    run;
    
    proc print data = results; run;
    
    
%mend;
option mprint;
%linRegA(ds=work.reg_dat,Dvar=Y,covList=X_COVA|X_COVB|X_COVC);


%macro linRegB(ds=,Dvar=,covPrefix=);

    proc contents data = &ds. out = contents noprint; run;
    
    data contents;
     set contents;
     where upcase(substr(name,1,2)) = upcase("&covPrefix"); 
    run;
   
%mend;
%linRegB(ds=work.reg_dat,Dvar=Y,covPrefix=X_);
proc print data = contents; run;
