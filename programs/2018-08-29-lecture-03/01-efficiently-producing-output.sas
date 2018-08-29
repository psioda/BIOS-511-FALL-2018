/*****************************************************************************
* Project           : BIOS 511 Course
*
* Program name      : 01-efficiently-producing-output.sas
*
* Author            : Matthew A. Psioda
*
* Date created      : 2018-08-29
*
* Purpose           : This program is designed to help students understand
*                     how to make multiple output files without having to
*                     type file paths multiple times;
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
 Q: How can I produce multiple output files in a single location and avoid
    having to type the file path to that location many times in the program?
 
 A: Create and use a SAS macro variable;
 ******************************************************************************/ 

** cumbersome option;
ods pdf file="C:/Users/psioda/Documents/GitHub/BIOS-511-FALL-2018/programs/2018-08-29-lecture-03/output/file1.pdf";
 proc print data = orion.charities(obs=10); run;
ods pdf close;

ods pdf file="C:/Users/psioda/Documents/GitHub/BIOS-511-FALL-2018/programs/2018-08-29-lecture-03/output/file2.pdf";
 proc print data = orion.customer(obs=10); run;
ods pdf close;

ods pdf file="C:/Users/psioda/Documents/GitHub/BIOS-511-FALL-2018/programs/2018-08-29-lecture-03/output/file3.pdf";
 proc print data = orion.country(obs=10); run;
ods pdf close;

** more elegant option;

** define a SAS macro variable named root and give it the value of the "root" directory where your files will go;
%let root = C:/Users/psioda/Documents/GitHub/BIOS-511-FALL-2018/programs/2018-08-29-lecture-03;

ods pdf file="&root/output/file4.pdf";
 proc print data = orion.charities(obs=10); run;
ods pdf close;

ods pdf file="&root/output/file5.pdf";
 proc print data = orion.customer(obs=10); run;
ods pdf close;

ods pdf file="&root/output/file6.pdf";
 proc print data = orion.country(obs=10); run;
ods pdf close;

** one a SAS macro variable is defined (i.e., the %LET statement is submitted), anywhere that the SAS code
   compiler finds an ampersand (&) followed by the macro variable name (e.g., root), SAS will replace the 
   text &root with the value of the macro variable. This is called "resolving" the macro variable.
   
** generally macro variable definitions that are to be used throughout a program are defined near the top of the program.


