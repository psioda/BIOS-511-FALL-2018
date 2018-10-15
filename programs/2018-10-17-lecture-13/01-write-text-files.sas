/*****************************************************************************
* Project           : BIOS 511 Course
*
* Program name      : 01-write-text-files.sas
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
%let rawPath  = &root./programs/2018-10-17-lecture-13/text.files;


** visualize the dataset to be used;
title "Print out of the SASHELP.CLASS Dataset";
proc print data = sashelp.class; run;



/****************** COLUMN FORMAT *******************************/
data _null_;
 set sashelp.class;
 file "&rawPath./class_column_format.dat";
 put Name  1-10 Age 12-14 Sex 16 Height 18-22 Weight 23-29;
run; 

/****************** LIST FORMAT *******************************/
data _null_;
 set sashelp.class;
 file "&rawPath./class_list_format_tab.dat" dlm='09'x;
 put Name Age Sex Height Weight;
run; 

data _null_;
 set sashelp.class;
 file "&rawPath./class_list_format_space.dat" dlm=" ";
 put Name Age Sex Height Weight;
run; 

data _null_;
 set sashelp.class;
 file "&rawPath./class_noheader.csv" dlm=",";
 put Name Age Sex Height Weight;
run; 

proc export data=sashelp.class file="&rawPath./class.csv" dbms=csv replace; run;

/****************** EXCEL FORMAT *******************************/

** Works for SDM v9.4, SS 3.6, SUE;
proc export data=sashelp.class file="&rawPath./sashelp.xls" dbms=xls replace; 
sheet="class";
run;

proc export data=sashelp.baseball file="&rawPath./sashelp.xls" dbms=xls replace; 
sheet="baseball";
run;

** Works for SDM v9.4, SS 3.6, SUE;
proc export data=sashelp.class file="&rawPath./sashelp.xlsx" dbms=xlsx replace; 
sheet="class";
run;

proc export data=sashelp.baseball file="&rawPath./sashelp.xlsx" dbms=xlsx replace; 
sheet="baseball";
run;

** Works for SDM v9.4, SS 3.6;
libname sh pcfiles path="&rawPath./sashelp2.xls";                               ** 97-2003 excel file;
data sh.class;
 set sashelp.class;
run;

data sh.baseball;
 set sashelp.baseball;
run;
libname sh clear;

** Works for SDM v9.4, SS 3.6;
libname sh pcfiles path="&rawPath./sashelp2.xlsx";                             ** Current excel type;
data sh.class;
 set sashelp.class;
run;

data sh.baseball;
 set sashelp.baseball;
run;
libname sh clear;
