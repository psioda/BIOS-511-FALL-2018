/*****************************************************************************
* Project           : BIOS 511 Course
*
* Program name      : template.sas
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
* YYYY-MM-DD     JHG       1      Insert a brief description of the changes
*                                 made to the SAS program. 
*
*
* searchable reference phrase: *** [#] ***;
*
* Note: Standard header taken from :
*  https://www.phusewiki.org/wiki/index.php?title=Program_Header
******************************************************************************/
option mergenoby=nowarn;

%let root     = /folders/myshortcuts/SAS-UE-Programming/A-lectures;
%let filePath = &root./01-Basics;



ods pdf file="&filepath./classfit.pdf" style=sasweb;

    title "Print out of the sashelp.classfit dataset";
	proc print data = sashelp.classfit; 
	run;
	
	title "Summary statistics for height and weight";
	proc means data = sashelp.classfit n mean std median min max; 
		var height weight;
	run;
		
ods pdf close;


