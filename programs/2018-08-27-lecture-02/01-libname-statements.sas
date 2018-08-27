/*****************************************************************************
* Project           : BIOS 511 Course
*
* Program name      : 01-libname-statements.sas
*
* Author            : Matthew A. Psioda
*
* Date created      : 2018-08-25
*
* Purpose           : This program is designed to help students understand
*                     the LIBNAME statement
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

/******************************************************************************
 Q: Can we read in SAS data sets without using a LIBNAME statement?
 
 A: We could always read a data set by referencing is exact location
    via a directory path and the sas data set name.
    
   The following code creates a data set named 'charities' in the 'work' library
   by reading from a permanent SAS data set with the same name that
   is stored in the directory 
   'C:/Users/psioda/Documents/GitHub/BIOS-511-FALL-2018/data/orion'    
   
*******************************************************************************/

data work.charities;
 set "C:/Users/psioda/Documents/GitHub/BIOS-511-FALL-2018/data/orion/charities";
run;

/****************************************************************************** 
 The 'work' library is just a temporary directory on your computers hard drive where
 your active sas session automatically creates a library reference. 
 
 That folder gets deleted when you close SAS and so any data sets in the 
 work library are temporary!
*******************************************************************************/
   
/******************************************************************************  
 Q: Why use LIBNAME statements?
 
 A: If we want to read from many datasets in a given folder it is cumbersome to
    repeatedly type the full directory path for the location. A LIBNAME statement
    allows us to give the folder a short alias that can be used in programming.
    
    The following code uses a LIBNAME statement to create a library reference 
    (aka a LIBREF) to a location where multiple SAS data sets are stored and then
    prints the contents of some of them.
*******************************************************************************/

libname orion "C:/Users/psioda/Documents/GitHub/BIOS-511-FALL-2018/data/orion";

title "Print out of the orion.charities data set";
proc print data = orion.charities; run;

title "Print out of the orion.consultants data set";
proc print data = orion.consultants; run;

title "Print out of the orion.country data set";
proc print data = orion.country; run;

libname orion clear;

/******************************************************************************  
 Q: What if we only want to read data from a SAS library and want to prevent
    accidentally deleting data sets or modifying them.
 
 A: Make sure to define the library reference as read only. This is good practice
    unless your are sure you want to be modify data sets in or add data sets to
    a directory on your computer.
*******************************************************************************/

libname orion "C:/Users/psioda/Documents/GitHub/BIOS-511-FALL-2018/data/orion";
libname dat   "C:/Users/psioda/Documents/GitHub/BIOS-511-FALL-2018/data" access=read;

data dat.charities;
 set orion.charities;
run;

/*
  ** what does this code actually do?
  proc sort data = orion.charities;
    by code;
  run;
*/


