/*****************************************************************************
* Project           : BIOS 511 Course
*
* Program name      : 01-formats.sas
*
* Author            : Matthew A. Psioda
*
* Date created      : 2018-09-05
*
* Purpose           : This program is designed to help students understand
*                     how to make and use formats;
*
* Revision History  :
*
* Date          Author   Ref (#)  Revision
* 
*
*
* searchable reference phrase: *** [#] ***;
******************************************************************************/
option mergenoby=nowarn nodate nonumber;
ods noproctitle;

%let root     = C:/Users/psioda/Documents/GitHub/BIOS-511-FALL-2018; 
%let dataPath = &root./data/echo;

libname echo "&dataPath";

/******************************************************************************
 Q: Where can I find a list of SAS supplied formats?
 A: You can google "SAS 9.4 Formats and Informats: Reference"
 ******************************************************************************/ 


/******************************************************************************
 Q: How can I use SAS-supplied formats in a PROC step?
 A: You can use any format by temporarily attaching the format to one or
    more variables in the PROC step using a FORMAT statement.
 ******************************************************************************/ 

  ** this DATA step simply creates a dataset named "dates" that contains
     one numeric variable named "date" with three observations;
  data work.dates;
   date = 0;             output;
   date = "28Jan1982"d;  output;
   date = today();       output;
  run;

  title "Print out of unformatted numeric date variables";
  proc print data = work.dates noobs; 
  run;

  title "Print out of formatted (date9. format) numeric date variables";
  proc print data = work.dates noobs; 
   format date date9.;
  run;

  title "Print out of formatted (yymmdd10. format) numeric date variables";
  proc print data = work.dates noobs label; 
   format date yymmdd10.;
   label date = "Special Dates in American History"; ** temporarily attach a label; 
  run;

/******************************************************************************
 Q: Can I permanently attach a format to a variable?
 A: If you attach a format to a variable in a DATA step, the newly created
    dataset retain the format association;
 ******************************************************************************/ 

 data work.dates2; ** dataset to create;
  set work.dates;  ** dataset to use as input;
   format date yymmdd10.;
   label date = "Special Dates in American History"; ** permanently attach a label;
 run;
 
 title "Print out of formatted (yymmdd10. format) numeric date variables";
 proc print data = work.dates2 noobs label; 
 run;
 
/******************************************************************************
 Q: Can I create my own formats and use them in a PROC step?
 A: You can create your own formats using the FORMAT procedure and make use
    of them in any PROC step by temporarily attaching them to a variable using
    a FORMAT statement;
 ******************************************************************************/ 

 proc format;
  
  ** format for a numeric variable;
  value ageCatA 
         0  -  65 = '<=65'
        65< - 150 = '>65';
        
        
  ** mostly equivalent to the ageCatA. format -- when is it not;
  value ageCatB 
        LOW -  65  = '<=65'
        65< - HIGH = '>65';       
   
  ** format for a character variable;
  value $ gender 
        "M"  = "Male"
        "F"  = "Female";
 run;
 
 proc freq data = echo.dm order=freq;
  table age sex;
  
  ** appropriate format statement for a numeric variable;
  format age ageCatA.;
  
  ** appropriate format statement for a numeric variable;
  format sex $gender.;
 run;
   
/******************************************************************************
 Q: Can I create my own formats and permanently attach them to a variable?
 A: You can create your own formats using the FORMAT procedure and permanently
    attach them to a variable by using a FORMAT statement in a DATA step that
    creates a dataset;
 ******************************************************************************/ 

 data work.DM;
  set echo.DM;
   format age ageCatB. sex $gender.;
 run;
 
 ods select Variables;
 proc contents data = work.DM; run;

 proc freq data = work.dm order=freq;
  table age sex;
 run;

 ** notes: 
    [1] Permanently attaching user-defined formats to temporary datasets (i.e., datasets in
        the work library) is a good practice if the format is to be used multiple times.
        
    [2] Permanently attaching user-defined formats to permanent datasets (i.e., datasets that
        may be shared with collaborators) is not a good practice because one would need to 
        provide the format catalog with the dataset for users to be able to use the format
        and even view the data!;

 data echo.DM_FORMAT_ATTACHED_DELETE;
  set echo.DM;
   format age ageCatB. sex $gender.;
 run;

