/*****************************************************************************
* Project           : BIOS 511 Course
*
* Program name      : 02-proc-print.sas
*
* Author            : Matthew A. Psioda
*
* Date created      : 2018-08-25
*
* Purpose           : This program is designed to help students understand
*                     the PRINT Procedure
*
* Revision History  :
*
* Date          Author   Ref (#)  Revision
* 
*
*
* searchable reference phrase: *** [#] ***;
******************************************************************************/
option mergenoby=nowarn;
libname orion "C:/Users/psioda/Documents/GitHub/BIOS-511-FALL-2018/data/orion";



/******************************************************************************
 Q: What if I want to get a print out of information on the variables in a 
    dataset (i.e., their types, lengths, etc)
 
 A: Use the CONTENTS Procedure
 ******************************************************************************/  
title;
footnote;   
proc contents data = orion.customer; run;
proc contents data = orion.country;  run;



/******************************************************************************
 Q: What is the primary purpose of the print procedure?
 
 A: The PRINT procedure prints the observations in a SAS data set, 
    using all or some of the variables. You can create a variety of 
    reports ranging from a simple listing to a highly customized 
    report that groups the data and calculates totals and 
    subtotals for numeric variables. 
    
    For the majority of SAS programmers, PROC PRINT is used to display data
    in listing format. The data summary features are seldom used.
   
 ******************************************************************************/
   
*** Most basic use of proc print (print everything in the dataset);
title1 h=2 "Data Listing";
title2 h=1 "Print out of the orion.country data set";
proc print data = orion.country; run;

*** Print with labels, suppress observation numbers, ID by country;
proc print data = orion.country label; 
 id country;
run;


*** Print with temporary labels + use custom label line breaks, no observation numbers;
proc print data = orion.country label split='^' noobs; 
 label Country            = 'Country Abbrev.'
       Country_Name       = 'Current Name^of Country'
       Country_ID 	      = 'Country ID' 
       Continent_ID       = 'Numeric ID^for Continent'
       Country_FormerName = 'Former^Country^Name';
run;


*** Use of the VAR statement to print a subset of variables & ID by country;
title2 h=1 "Print out of the orion.country data set";
proc print data = orion.country label; 
  id country;
  var Country_Name Population;
run;  
   
   
   
   
   
   
/******************************************************************************
 Q: How can we print data listings separately for sets of observations in our
    data set (i.e., a listing of male and female customers)
 
 A: You can use two PROC PRINT steps or use a single PROC PRINT step with a 
    BY statement (note the data must be ordered)
   
 ******************************************************************************/   

**************************************************************;
** option #1 - two PROC PRINT steps;
title1    j=c color=blue  "Data listing for Male Orion Customers";
footnote1 j=l color=black "Confidential information - please store in a secure environment.";
proc print data = orion.customer label;
 where gender = 'M';
run;

title1 j=c color=blue "Data listing for Female Orion Customers";
proc print data = orion.customer label;
 where gender = 'F';
run;

**************************************************************;
** option #2 - Using BY processing + make use of default by-line printing;
title1 j=c color=blue "Data listing for Orion Customers";
proc sort data = orion.customer out = customer; 
 by gender;
run;

proc print data = customer label;
 by gender;
run;

**************************************************************;
** option #3 - Using BY processing & using #byval() in TITLE statement;
option nobyline; ** turn off default by-line printing;
proc sort data = orion.customer out = customer; 
 by gender;
run;

title1 j=c color=black "Data listing for #byval(gender) Orion Customers";
footnote1 "Confidential information - please store in a secure environment.";
proc print data = customer label n noobs;
 by gender;
 where customer_type_id < 2000; 
 ** Q: would observations with missing customer_type_id be printed?;
run;






/******************************************************************************
 Q: What is the difference between BY and PAGEBY?
 
 A: When you use a BY statement, a data listing is printed for each distinct
    value of the BY variables (i.e., combination of country and gender in the
    example below).
    
    By default, each data listing goes on a new page. With the PAGEBY option
    you can control which data listings (if any) are printed on the same page.
   
 ******************************************************************************/

option byline;
proc sort data = orion.customer out = customer; 
 by country gender;
run;

title1 j=c color=black "Data listing for Orion Customers";
footnote1 "Confidential information - please store in a secure environment.";
proc print data = customer label n noobs;
 by country gender;
 pageby country; ** all data listings for each country are on one page (if possible);
 where customer_type_id < 2000; 
 ** Q: would observations with missing customer_type_id be printed?;
run;






/******************************************************************************
 Q: What if I only want to print a subset of observations in my dataset
    just to get some perspective on the data structure?
 
 A: Use the FIRSTOBS= & OBS= dataset options
 ******************************************************************************/     
 
title1 j=c color=blue "Data listing for a Subset of Male Orion Customers";
footnote1 "Confidential information - please store in a secure environment.";
proc print data = orion.customer(firstobs=10 obs=20) label n;
 ** can you describe how firstobs= and obs= work together?;
 where gender = 'M';
 ** how can I modify the WHERE statement so that in addition to only
    printing data for males, only customers with customer_type_id 
    at least equal to 2000 are included?;
run;


   