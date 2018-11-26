/*****************************************************************************
* Project           : BIOS 511 Course
*
* Program name      : 01-basic-joins.sas
*
* Author            : Matthew A. Psioda
*
* Date created      : 2018-11-26
*
* Purpose           : This program is designed to teach students about proc SQL;
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

%let root      = C:/Users/psioda/Documents/GitHub/BIOS-511-FALL-2018; ** define the ROOT macro variable;
%let dataPath  = &root./data/echo;                                    ** use TEXT SUBSTITUTION to define the DATAPATH macro variable;
%let outPath   = &root./programs/2018-11-26-lecture-19/output;        ** use TEXT SUBSTITUTION to define the OUTPATH macro variable;

libname echo "&dataPath";                                             ** use TEXT SUBSTITUION to define the ECHO libref;


data VS;
 set echo.VS(where=(scan(usubjid,2,'-')='011' and vstestcd in ('WEIGHT') ) obs=50);
run; proc sort; by visitnum visit; run;



** a simple inner join to produce a data listing
 [1] SELECT clause    -> which variables to pull from which datasets
 [2] FROM clause      -> which datasets to pull variables from
 [3] WHERE clause     -> used for inner join to subset matching observations
 [4] ORDER BY clause  -> defines the order of the observations (i.e., the sort order); 
proc SQL;
 select dm.usubjid,dm.age,dm.armcd,dm.sex,
        vs.visitnum,vs.visit,vs.vsstresn
 from  echo.dm,
       work.vs
 where dm.usubjid=vs.usubjid
 order by usubjid, visitnum;
quit;


** same simple inner join to produce a dataset;
proc SQL;
 create table work.vs2 as /** this is the line that has been added */
 select dm.usubjid,dm.age,dm.armcd,dm.sex,
        vs.visitnum,vs.visit,vs.vsstresn
 from  echo.dm,
       work.vs
 where dm.usubjid=vs.usubjid
 order by usubjid, visitnum;
quit;


** deriving new variables ;
proc SQL;
 create table work.vs3 as /** this is the line that has been added */

 select dm.usubjid,

        (dm.age - mean(dm.age)) as age                   format=6.2 label = 'Mean Centered Age',

        dm.armcd,

		case /** example using CASE/WHEN/END **/
		 when dm.armcd = 'ECHOMAX' then 1
		 when dm.armcd = 'PLACEBO' then 0
		 else 99
		end as armcdn                                    label = 'Planned Arm Code (Numeric)',

		case /** example using CASE/WHEN/END **/
		 when dm.sex = 'M' then "Male"
		 when dm.sex = 'F' then 'Female'
		 else "?"
		end as sexDesc                                  length=10 label = 'Sex (Full Text)',

        vs.visitnum,
        vs.visit,
        vs.vsstresn as weight                           format=6.2 label = 'Weight (kg)',
		(weight - mean(weight))/std(weight) as weight_Z format=6.2 label = 'Weight Z-score'

 from  echo.dm,work.vs

 where dm.usubjid=vs.usubjid

 order by usubjid, visitnum;
quit;



** same simple inner join to produce a dataset (aliases);
proc SQL;
 create table work.vs5 as /** this is the line that has been added */
 select a.usubjid,a.age,a.armcd,a.sex,
        b.visitnum,b.visit,b.vsstresn
 from  echo.dm as a,
       work.vs as b
 where dm.usubjid=vs.usubjid
 order by usubjid, visitnum;
quit;
