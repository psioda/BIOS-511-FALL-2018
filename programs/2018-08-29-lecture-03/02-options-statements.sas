/*****************************************************************************
* Project           : BIOS 511 Course
*
* Program name      : 02-options-statements.sas
*
* Author            : Matthew A. Psioda
*
* Date created      : 2018-08-29
*
* Purpose           : This program is designed to help students understand
*                     the options statement.
*
* Revision History  :
*
* Date          Author   Ref (#)  Revision
* 
*
*
* searchable reference phrase: *** [#] ***;
* 
******************************************************************************/

** commonly used statements that go just be program header;
option mergenoby=nowarn ;*nodate nonumber nocenter orientation=landscape;

libname orion "C:/Users/psioda/Documents/GitHub/BIOS-511-FALL-2018/data/orion";

%let root = C:/Users/psioda/Documents/GitHub/BIOS-511-FALL-2018/programs/2018-08-29-lecture-03;

** main body of the SAS program;
ods pdf file="&root/output/options-file1.pdf";
 proc print data = orion.charities(obs=10); run;
ods pdf close;