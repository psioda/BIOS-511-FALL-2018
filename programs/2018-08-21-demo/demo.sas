
%put This program is being run by %upcase(&sysuserid);

data work.class;
 set sashelp.class;
run;

title "Print out of the work.class dataset";
proc print data = work.class; 
run;

proc print

