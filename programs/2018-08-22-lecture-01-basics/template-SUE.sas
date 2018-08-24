/*****************************************************************************
* Project           : BIOS 511 Course
*
* Program name      : template-SUE.sas
*
* Author            : James Howard Goodnight (JHG)
*
* Date created      : YYYY-MM-DD
*
* Purpose           : This program is designed to be a template that can be
*                     reused throughout the BIOS 511 course. 
*
* Revision History  :
*
* Date          Author   Ref (#)  Revision
* YYYY-MM-DD     JHG       1      Added summary of height and weight to printed
*                                 output. 
*
*
* searchable reference phrase: *** [#] ***;
*
* Note: Standard header taken from :
*  https://www.phusewiki.org/wiki/index.php?title=Program_Header
******************************************************************************/
option mergenoby=nowarn;

%let root       = /folders/myshortcuts/BIOS-511-FALL-2018/programs/2018-08-22-lecture-01-basics;
%let outputPath = &root./output;


ods pdf file="&outputPath./classfit-SUE.pdf" style=journal;

    title "Print out of the sashelp.classfit dataset";
	proc print data = sashelp.classfit; 
	run;
	
	*** [1] ***;
	title "Summary statistics for height and weight";
	proc means data = sashelp.classfit n mean std median min max; 
		var height weight;
	run;
		
ods pdf close;


