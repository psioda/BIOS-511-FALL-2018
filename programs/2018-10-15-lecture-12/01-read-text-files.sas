/*****************************************************************************
* Project           : BIOS 511 Course
*
* Program name      : 01-read-text-files.sas
*
* Author            : Matthew A. Psioda
*
* Date created      : 2018-10-14
*
* Purpose           : This program is designed to provide examples
*                     for reading data from a text file;
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
%let rawPath  = &root./programs/2018-10-15-lecture-12/text.files;


** visualize the dataset to be used;
title "Print out of the SASHELP.CLASS Dataset";
proc print data = sashelp.class; run;



/****************** COLUMN FORMAT *******************************/
title1 "Print out of CLASS_COLUMN_FORMAT.DAT";
** reading in data in COLUMN format;
** using $ sign ensures variables are created as character;
data classA;
 infile "&rawPath./class_column_format.dat";
 input Name $ 1-10 Age 12-14 Sex $ 16 Height 18-22 Weight 23-29;
run; 

proc print data = classA; run;
ods select Variables;
proc contents data = classA; run;


** reading in data in COLUMN format assuming it is in LIST format;
** using length statement;
data classB;
 infile "&rawPath./class_column_format.dat" dlm=" ";
 length Name $20 Sex $5;
 input Name 1-10 Age 12-14 Sex 16 Height 18-22 Weight 23-29;
run; 

proc print data = classB; run;
ods select Variables;
proc contents data = classB; run;


** example to show how not using COLUMN format will break with missing data;
data classC;
 infile "&rawPath./class_column_format_missing.dat" dlm=" ";
 input Name $ Age Sex $ Height Weight;
run;

title1 "Print out of CLASS_COLUMN_FORMAT_MISSING.DAT";
proc print data = classC; run;




/************************* LIST FORMAT *******************************/

** space dilimeter;
data classD;
 infile "&rawPath./CLASS_LIST_FORMAT_SPACE.TXT" dlm=" " firstobs=2;
 length Name $10 Sex $5;
 input Name Age Sex Height Weight;
run; 
title1 "Print out of CLASS_LIST_FORMAT_SPACE.TXT";
proc print data = classD; run;

** TAB dilimeter;
data classE;
 infile "&rawPath./CLASS_LIST_FORMAT_TAB.DAT" dlm="09"x firstobs=2;
 length Name $10 Sex $5;
 input Name Age Sex Height Weight;
run; 
title1 "Print out of CLASS_LIST_FORMAT_TAB.DAT";
proc print data = classE; run;

** COMMA dilimeter;
data classF;
 infile "&rawPath./CLASS.CSV" dlm="," firstobs=2;
 length Name $10 Sex $5;
 input Name Age Sex Height Weight;
run; 
title1 "Print out of CLASS.CSV";
proc print data = classF; run;

** Using PROC IMPORT;
proc import datafile = "&rawPath./CLASS_LIST_FORMAT_TAB.DAT" out = classG dbms=dlm replace; 
delimiter="09"x;
run;
title1 "Print out of CLASS_LIST_FORMAT_TAB.DAT";
proc print data = classG; run;


/************************* DATES *******************************/
title1 "Print out of CLASS_LIST_FORMAT_TAB.DAT";

data classH;
 infile "&rawPath./CLASS_LIST_FORMAT_TAB_DATES.DAT" dlm="09"x firstobs=2;
 length Name $10 Sex $5;
 informat date date9.; ** instruction for how to read in data;
 format date date9.;   ** instruction for how to format data for display;
 input Name Age Sex Height Weight date;
run; 

proc print data = classH; run;



proc import datafile = "&rawPath./CLASS_LIST_FORMAT_TAB_DATES.DAT" out = classI dbms=dlm replace; 
delimiter="09"x;
run;
title1 "Print out of CLASS_LIST_FORMAT_TAB.DAT";
proc print data = classI; run;

ods select Variables;
proc contents data = classI; run;

/************************* EXCEL FILES *******************************/


** Works for SDM v9.4, SS 3.6;
proc import datafile = "&rawPath./class.xls" out = classJ dbms=excel replace;   ** 97-2003 excel file;
sheet='class$';
run; 

** Works for SDM v9.4, SS 3.6;
proc import datafile = "&rawPath./class.xlsx" out = classK dbms=excel replace;  ** Current excel type;
sheet='class$';
run; 

** Works for SDM v9.4, SS 3.6, SUE;
proc import datafile = "&rawPath./class.xls" out = classL dbms=xls replace;     ** 97-2003 excel file;
sheet='class';
run; 

** Works for SDM v9.4, SS 3.6, SUE;
proc import datafile = "&rawPath./class.xlsx" out = classM dbms=xlsx replace;   ** Current excel type;
sheet='class';
run; 

** Works for SDM v9.4, SS 3.6;
libname class pcfiles path="&rawPath./class.xls";                               ** 97-2003 excel file;
data classN;
 set class.'class$'n;
run;
libname class clear;

** Works for SDM v9.4, SS 3.6;
libname class pcfiles path="&rawPath./class.xlsx";                             ** Current excel type;
data classO;
 set class.'class$'n;
run;
libname class clear;
