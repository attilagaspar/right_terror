

clear
set obs 1
gen x=.
tempfile master 
save `master'

local folder "${temp}/synth/" // Folder path

// List all data files in the folder
local files: dir "`folder'" files "*.dta"

gen id = .
gen _Y_treated = .
gen _Y_synthetic = .
gen _time = .

// Loop over each file
foreach file of local files {
    // Open the current file
    use `"`folder'/`file'"', clear
	disp "`file'"
    // Keep only relevant columns
    keep _Y_treated _Y_synthetic _time  _Co_Number  _W_Weight treat_name _Co_name

    // Create a unique ID based on the filename
    gen id = "`file'"

    // Append the current file to the main dataset
    append using `master', force

    // Save the updated master file
tempfile master 
save `master'

}
*drop if _time==.

gen diff = _Y_treated - _Y_synthetic
reg diff i._time



					 
sort t 


gen tn = treat_name
replace treat_name = "Ipolytarnóc (Planned)" if treat_name=="Ipolytarnóc"
replace treat_name = "Kisvárda (Planned)" if treat_name=="Kisvárda"
replace treat_name = "Tura (Planned)" if treat_name=="Tura" 
replace treat_name = "Erdőkertes (Planned)" if treat_name=="Erdőkertes"
replace treat_name = "Tarnabod (Botched)" if treat_name=="Tarnabod"

replace treat_name = "Alsózsolca (1I)" if treat_name=="Alsózsolca"
replace treat_name = "Galkagyörk (0I)" if treat_name=="Galgagyörk"
replace treat_name = "Piricse (1I)" if treat_name=="Piricse"
replace treat_name = "Nyíradony (0I)" if treat_name=="Nyíradony"
replace treat_name = "Nagycsécs (2†, 1I)" if treat_name=="Nagycsécs"
replace treat_name = "Tatárszentgyörgy (2†, 1I)" if treat_name=="Tatárszentgyörgy"
replace treat_name = "Tiszalök (1†)" if treat_name=="Tiszalök"
replace treat_name = "Kisléta (1†, 1I)" if treat_name=="Kisléta"
rename treat_name visible_name
rename tn treat_name 

replace id = subinstr(id,"synth_","",.)
replace id = subinstr(id,".dta","",.)
destring id, force replace
sort id _time
   
   
	   
	  * local n = 13 // Number of groups
	  * local n = 4 // Number of groups

egen max_effect = max(_Y_treated), by(treat_name)
replace max_effect = -max_effect 
egen max_group = group(max_effect)
	

egen avg_effect = mean(_Y_treated) if _time>4, by(treat_name)

egen a = min(avg_effect), by(treat_name)
replace avg_effect=a if avg_effect==.
drop a


replace avg_effect = -avg_effect 

egen avg_group = group(avg_effect)

cap drop year
gen year = .
replace year = 1998 if _time==1
replace year = 2002 if _time==2
replace year = 2004 if _time==3
replace year = 2006 if _time==4
replace year = 2009 if _time==5
replace year = 2010 if _time==6
replace year = 2014 if _time==7
replace year = 2018 if _time==8

tsset avg_group year

	


local plots

local n = 10

forval i = 1/`n' {
	
	levelsof visible_name if avg_group==`i' , local(setlist)
	foreach s in `setlist' {
		local setname`i'="`s'"
	}
	local plots `plots' (line diff year if avg_group==`i', ///
        `style`i'' )
	disp "`setname`i''"
}

keep if year!=.


twoway `plots', ///
	xlabel(1998 "98" 2002 "2002" 2004 "2004" 2006 "2006" 2009 "2009-10" 2010 " "  2014 "2014" 2018 "2018"  ) ///
	ytitle("Diff vote share (Treated - Synthethic control)") ///
	xtitle("Elections") yline(0) ///
    legend(order(1 "`setname1'" ///
                 2 "`setname2'" ///
                 3 "`setname3'" ///
                 4 "`setname4'"  ///
                 5 "`setname5'" ///
                 6 "`setname6'" ///
                 7 "`setname7'" ///
                 8 "`setname8'" ///
                 9 "`setname9'"  ///
				 ))

				 graph export ${figuredir}/synth.png, replace
				 				 graph export ${figuredir}/synth.pdf, replace

				 
				 


preserve
	collapse (mean) diff, by(_time)
	*twoway line diff year
	gen avg_group=10
	tempfile avg 
	save `avg'
restore

append using `avg'

twoway bar diff avg_group  if _time==5, color(black)    ///  
	xlabel(1 "`setname1'" ///
                 2 "`setname2'" ///
                 3 "`setname3'" ///
                 4 "`setname4'"  ///
                 5 "`setname5'" ///
                 6 "`setname6'" ///
                 7 "`setname7'" ///
                 8 "`setname8'" ///
                 9 "`setname9'"  ///
				 10 "Average" , angle(90)) ///
				 xtitle("Attacked settlement") ///
	ytitle("Difference in vote share, pp." "(Treated - Synthethic control)") ///
	title("Effect heterogeneity in 2010") xsize(1) ysize(1.25) ylabel(-.1 "-10" 0 "0" .1 "10" .2 "20" )
					 graph export ${figuredir}/synth_bar2010.png, replace
					 graph export ${figuredir}/synth_bar2010.pdf, replace



preserve
* create framework for did reg
drop if id==.
keep if year==2006|year==2010
gen post = 0 
replace post = 1 if year==2010

* rename outcomes for reshape
rename _Y_treated extreme_right_share_valid1
rename _Y_synthetic extreme_right_share_valid0

* reshape so that synth controls are independent observations
egen i = group(id year) 
reshape long extreme_right_share_valid, i(i) j(treated)

* synthetic controls need new id
replace id = id+900 if treated==0

tsset id post
gen d_extreme_right_share_valid = d.extreme_right_share_valid*100

*reg d_extreme_right_share_valid treated  , rob

keep d_extreme_right_share_valid treated id post
save ${temp}/synth_did.dta, replace
restore


* create framework for did reg pretend
drop if id==.
keep if year==2002|year==2006
gen post = 0 
replace post = 1 if year==2006

* rename outcomes for reshape
rename _Y_treated extreme_right_share_valid1
rename _Y_synthetic extreme_right_share_valid0

* reshape so that synth controls are independent observations
egen i = group(id year) 
reshape long extreme_right_share_valid, i(i) j(treated)

* synthetic controls need new id
replace id = id+900 if treated==0

tsset id post
gen l4_d_extreme_right_share_valid = d.extreme_right_share_valid*100

*reg d_extreme_right_share_valid treated  , rob

keep l4_d_extreme_right_share_valid treated id post
save ${temp}/synth_did_pretrend.dta, replace
