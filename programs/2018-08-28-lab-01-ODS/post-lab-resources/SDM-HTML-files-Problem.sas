
libname orion "C:\Users\psioda\Documents\GitHub\BIOS-511-FALL-2018\data\orion";

** creates temporary HTML file;
proc print data = orion.charities; run;



** creates permanent HTML file;
ods html file="C:\Users\psioda\Documents\GitHub\BIOS-511-FALL-2018\programs\2018-08-28-lab-01-ODS\output\test.html";

proc print data = orion.charities; run;

ods html close;
