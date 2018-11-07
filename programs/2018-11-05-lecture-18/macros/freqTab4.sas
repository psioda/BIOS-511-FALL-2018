/*****************************************************************************
* Project           : BIOS 511 Course
*
* macro name        : freqTab4
*
* Author            : Matthew A. Psioda
*
* Date created      : 2018-11-05
*
* Purpose           : This macro can be used to perform a simple one-way
*                     frequency analysis.
*
*                     [1] The macro contains one parameter
*                         named VAR3 whose values are tablulated by 
*                         the macro.
*                     [2] The default value of the VAR4 macro is ARMCD.
*
* Revision History  :
*
* Date          Author   Ref (#)  Revision
* 
*
*
* searchable reference phrase: *** [#] ***;
******************************************************************************/

%macro freqTab4(var4=armcd);

proc freq data = echo.DM noprint order=freq;
 table &var4. / out = &var4.Dist;
run;

title1 "Number and Percent of ECHO Trial subjects by &var4.";
proc print data = &var4.Dist label noobs ;
 label count   = "n";
 label percent = "%";
 format percent 6.2;
 var &var4. count percent;
run;

%mend freqTab4;
