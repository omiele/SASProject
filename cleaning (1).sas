/* Data Cleaning */

DATA background_part1 ;
   set _TEMP0.background_part1; 
   new = input(brothers, 8.);
   drop brothers;
   rename new=brothers;
   new1 = input(self_regulation, 8.);
   drop self_regulation;
   rename new1=self_regulation;
run;
DATA background_part2 ;
   set _TEMP1.background_part2; 
   new = input(brothers, 8.);
   drop brothers;
   rename new=brothers;
   new1 = input(self_regulation, 8.);
   drop self_regulation;
   rename new1=self_regulation;
run;
DATA Merged_data ; 
  MERGE background_part1 background_part2; 
  BY caseid; 
RUN;
/* Importing demographics.csv */
%web_drop_table(demographics);

FILENAME REFFILE '/folders/myfolders/Ibra/demographics.csv';

PROC IMPORT DATAFILE=REFFILE
	DBMS=CSV
	OUT=demographics;
	GETNAMES=YES;
RUN;

PROC CONTENTS DATA=demographics; RUN;


%web_open_table(demographics);

/* Renaming id variable to caseid before merge */
Data demographics2;
set demographics;
rename id = caseid;
run;
proc sort data=demographics2; by caseid; run;
DATA Merged_data2 ; 
  MERGE Merged_data demographics2; 
  BY caseid; 
RUN;

Data Merged_data2 ;
set merged_data2;
if living_in_household < 0 THEN do; living_in_household=.;end;
if runaway < 0 THEN do; runaway = .;end;
if income < 0 THEN do; income = .;end;
if child_support = -103 THEN do; child_support = .;end;
if grade_level < 0 THEN do; grade_level = .;end;
if grades < 0 THEN do; grades = .;end;
if age_first_offense < 0 THEN do; age_first_offense = .;end;
if ADHD < 0 THEN do; ADHD = .;end;
if age_first_arrest < 0 THEN do; age_first_arrest = .;end;
if friends < 0 THEN do; friends = .;end;
if number_of_arrests < 0 THEN do; number_of_arrests = .;end;
if detention_jail < 0 THEN do; detention_jail = .;end;
if survey_year = 7 THEN do; survey_year = 2007;end;
run;

/*** Analyze numeric variables ***/
title "Descriptive Statistics for Numeric Variables";

proc means data=WORK.MERGED_DATA2 n nmiss min mean median max std;
	var runaway Sisters Age_first_Offense Emotionality Age_first_arrest Friends 
		Number_of_arrests Detention_jail brothers self_regulation Survey_Year 
		Survey_Month Survey_Day Gender Ethnicity;
run;

/*** Analyze date variables ***/
title "Minimum and Maximum Dates";

proc sql ;
	select "Birthdate" label="Date variable", min(Birthdate) 
		format=MMDDYY10. label="Minimum date" , max(Birthdate) 
		format=MMDDYY10. label="Maximum date" from WORK.MERGED_DATA2;
quit;




