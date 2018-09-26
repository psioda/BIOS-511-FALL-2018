/*****************************************************************************
* Project           : BIOS 511 Course
*
* Program name      : 01-controlling-data-step-processing.sas
*
* Author            : Evan Kwiatkowski
*
* Date created      : 2018-09-26
*
* Purpose           : This program is designed to teach students about using
*					  the DROP, KEEP, and RENAME commands within a DATA step
*					  and how to conditionally create multiple datasets within
*					  a single DATA step.
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

title "Sashelp.class --- Student Data";
proc print data=sashelp.class noobs;
run;

/**********************************************************************/
/*** Task 1: How does the placement of DROP and KEEP affect output? ***/
/**********************************************************************/

/*** Task 1.1 ***/
/*** Suppose we want WORK.CLASS with the variables Name, Sex, and Age ***/
/*** Do each of the 4 data steps below produce the same output? 	  ***/
/*** What are the differences between these 4 data steps? 			  ***/

title "Task 1.1(a)";
data attempt11_a(keep=Name Sex Age);
	set sashelp.class;
run;

title "Task 1.1(b)";
data attempt11_b;
	set sashelp.class(keep=Name Sex Age);
run;

title "Task 1.1(c)";
data attempt11_c(drop=Height Weight);
	set sashelp.class;
run;

title "Task 1.1(d)";
data attempt11_d;
	set sashelp.class(drop=Height Weight);
run;

/*** Task 1.2 ***/
/*** Suppose we only want the variables Name and Height_Ft 			  ***/
/*** Do each of the 4 data steps below produce the same output? 	  ***/

title "Task 1.2(a)";
data attempt12_a(keep=Name Height_Ft);
	set sashelp.class;
	Height_Ft=Height/12;
run;

title "Task 1.2(b)";
data attempt12_b;
	set sashelp.class(keep=Name Height_Ft);
	Height_Ft=Height/12;
run;

title "Task 1.2(c)";
data attempt12_c(drop=Sex Age Height Weight);
	set sashelp.class;
	Height_Ft=Height/12;
run;

title "Task 1.2(d)";
data attempt12_d;
	set sashelp.class(drop=Sex Age Height Weight);
	Height_Ft=Height/12;
run;

/*** Task 1.3 ***/
/*** Let's try two ways of modifying example (2) ***/
/*** Do both produce the desired output? 		 ***/

title "Task 1.3(b1)";
data attempt13_b1(drop=Height);
	set sashelp.class(keep=Name Height);
	Height_Ft=Height/12;
run;

title "Task 1.3(b2)";
data attempt13_b2;
	set sashelp.class(keep=Name Height);
	Height_Ft=Height/12;
	drop Height;
run;

/******************************************************************************/
/*** Task 2: Conditionally create multiple datasets within single DATA step ***/
/******************************************************************************/

/*** What is the expected output? ***/

data female male;
	set sashelp.class;
	if sex="M" then output male;
	else if sex="F" then output female;
run;

/*** How would we create an overall table called "total" in the WORK directory? ***/

data total female male; /*** Is it enough to add "total" to this line? ***/
	set sashelp.class;
	if sex="M" then output male;
	else if sex="F" then output female;
run;

data total female male; 
	set sashelp.class;
	/*** Where should we add an "output" statement? ***/
	if sex="M" then output male;
	else if sex="F" then output female;
run;

/*** How would we create a new variable "ageNow" that is in all three datasets? ***/

data total female male;
	set sashelp.class;
	output total; /*** Does this work? ***/
	ageNow = age+10;
	if sex="M" then output male;
	else if sex="F" then output female;
run;

/*** Create the classGrates dataset ***/
data classGrades;
input ID $ Grade $;
datalines;
Alfred	A
Alice	B
Barbara	C
Carol	A
Henry	B
James	C
Jane	A
Janet	A
Jeffrey	A
John	B
Joyce	B
Judy	C
Louise	C
Mary	C
Philip	A
Robert	B
Ronald	C
Thomas	D
William	F
;
run;

/*** How can we rename a variable and merge datasets? ***/

data merged;
	merge sashelp.class work.classGrades;
	by Name;
run;






