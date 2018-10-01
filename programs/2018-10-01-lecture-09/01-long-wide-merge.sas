/*****************************************************************************
* Project           : BIOS 511 Course
*
* Program name      : 01-long-wide-merge.sas
*
* Author            : Matthew A. Psioda
*
* Date created      : 2018-10-01
*
* Purpose           : This program is design to teach students about
*                     merging data sets and transforming data sets
*                     from long to wide format;
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
%let dataPath = &root./programs/2018-10-01-lecture-09/data;
libname lecture "&dataPath";

** Task #1: Merge on treatment group information (ARMCD) from the DM dataset;
** [1] The new dataset (WORK.VS2) should only have observations matching those in the WORK.VS dataset.
       That is, we should not keep observations from DM that have no match in the WORK.VS dataset.;

/* Question: Conceptually... what do we need to do to achieve this goal?
  [1] 
  [2] 
  [3] 
*/


proc sort data = lecture.VS out = work.VS;
 by usubjid;
run;

proc sort data = echo.dm(keep=usubjid armcd) out = dm;
 by usubjid;
run;

data work.VS2;
 merge work.VS work.dm;
 by usubjid;
run;



** Task #2: Construct a dataset (WORK.HR[x]) that has all HR values on a single observation for each subject. 
**   [1] The variables in this dataset should be named: usubjid armcd SCR WK00 WK08 WK16 WK24 WK32 (or something similar);

/********************************************************************************/
/* Strategy #1 -> Make a dataset of results for each visit and merge them all together. */

		data SCR WK00 WK08 WK16 WK24 WK32;
		 set work.VS2;

		       if upcase(VISIT) = 'SCREENING' then output SCR;
		  else if upcase(VISIT) = 'WEEK 0'    then output WK00;
		  else if upcase(VISIT) = 'WEEK 8'    then output WK08;
		  else if upcase(VISIT) = 'WEEK 16'   then output WK16;
		  else if upcase(VISIT) = 'WEEK 24'   then output WK24;
		  else if upcase(VISIT) = 'WEEK 32'   then output WK32;

		  keep usubjid armcd vsstresn;
		run;

		** code to print out all the datasets;
        proc print data = work.SCR;  run;
		proc print data = work.WK00; run;
        proc print data = work.WK08; run;
		proc print data = work.WK16; run;
		proc print data = work.WK24; run;
		proc print data = work.WK32; run;

		data work.HRa;
		 merge SCR WK00 WK08 WK16 WK24 WK32;
		 by usubjid;
		run;


		proc print data = work.HRa; run;
/********************************************************************************/
/* Strategy #2 -> Use an ARRAY /w RETAIN and conditional OUTPUTs statements in a single data step */

		data work.HRb;
		 set work.VS2;
		 by usubjid;

		 retain SCR WK00 WK08 WK16 WK24 WK32;
		 array hr[6] SCR WK00 WK08 WK16 WK24 WK32; ** note this array CREATES variables that do not exist;

		 ** what does this code do?;
		 if visitnum = -1 then arrayID = 1;
		 else                  arrayID = visitnum + 1;

		 hr[arrayID] = vsstresn;

		 ** why is this conditional output statement necessary;
		 if last.usubjid then output;

		 keep usubjid armcd SCR WK00 WK08 WK16 WK24 WK32;
		run;
/********************************************************************************/
/* Strategy #3 -> Use PROC TRANSPOSE (always nice when it can be used) */


		proc transpose data = work.VS2 out = work.HRc;
		 by usubjid;     ** defines the observations in the new data set;
		 id visit;       ** defines the columns in the new data set;
		 var vsstresn;   ** defines the values of the variables (columns) in the new data set;
		run;
/********************************************************************************/

































/*data work.VS "C:\Users\psioda\Documents\GitHub\BIOS-511-FALL-2018\programs\2018-10-01-lecture-09\data\vs";*/
/* set echo.VS;*/
/*  where usubjid in ('ECHO-011-001' 'ECHO-011-002');*/
/*  where also vstestcd in ('HR');*/
/**/
/*  if usubjid = 'ECHO-011-002' and visitnum = 4 then delete;*/
/**/
/*  keep usubjid vstest: vsstresn vsstresu visit:; */
/*run; */
/*proc sort; by visitnum; run;*/
/*proc print noobs ; run;*/

/********************************************************************************/
