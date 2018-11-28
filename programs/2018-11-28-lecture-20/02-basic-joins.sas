/*****************************************************************************
* Project           : BIOS 511 Course
*
* Program name      : 02-basic-joins.sas
*
* Author            : Matthew A. Psioda
*
* Date created      : 2018-11-28
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
%let outPath   = &root./programs/2018-11-28-lecture-20/output;        ** use TEXT SUBSTITUTION to define the OUTPATH macro variable;

libname echo "&dataPath";                                             ** use TEXT SUBSTITUION to define the ECHO libref;

ods html newfile=proc;



** a simple inner join to produce a dataset;
proc SQL noprint;
 create table work.ae1 as
 select dm.usubjid,dm.age,dm.armcd,dm.sex,dm.country,dm.race,ae.*
 from  echo.dm, echo.ae
 where dm.usubjid=ae.usubjid
 order by usubjid,aestdtc,aeendtc;
quit;
proc print data = work.ae1(obs=20); run;








** a simple inner join to produce a dataset (modified);
proc SQL noprint;
 create table work.ae2 as
 select dm.usubjid,dm.age,dm.armcd,dm.sex,dm.country,dm.race,ae.aeterm,ae.aedecod,ae.aesoc,ae.aestdtc,ae.aeendtc
 from  echo.dm, echo.ae
 where dm.usubjid=ae.usubjid
 order by usubjid,aestdtc,aeendtc;
quit;
proc print data = work.ae2(obs=20); run;







** a simple inner join to produce a dataset (modified);
proc SQL noprint;
 create table work.ae3(drop=u) as
 select dm.usubjid,dm.age,dm.armcd,dm.sex,dm.country,dm.race,ae.*
 from  echo.dm,
       echo.ae(rename=(usubjid=u))
 where dm.usubjid=ae.u
 order by usubjid,aestdtc,aeendtc;
quit;
proc print data = work.ae3(obs=20); run;










** a simple left join to produce a dataset ;
proc SQL noprint;
 create table work.ae4 as
 select dm.usubjid,dm.age,dm.armcd,dm.sex,dm.country,dm.race,ae.aeterm,ae.aedecod,ae.aesoc,ae.aestdtc,ae.aeendtc
 from  echo.dm left join echo.ae on dm.usubjid=ae.usubjid
 order by usubjid,aestdtc,aeendtc;
quit;
proc print data = work.ae4(obs=20); run;
