
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
keep if _W_Weight!=.&_W_Weight!=0
order treat_name _Co_name _W_Weight
keep treat_name _Co_name _W_Weight

replace _W_Weight=round(_W_Weight*1000)/1000
tostring _W_Weight, force replace
replace _W_Weight=substr(_W_Weight,1,4)

replace _W_Weight = _W_Weight + " \\"

preserve
keep if _n<=46
listtex using "${tabledir}/synthetic_control_units_1.tex", replace
copy "${tabledir}/synthetic_control_units_1.tex" "${tabledir}/table_oa2.tex", replace
restore, preserve
keep if _n>46
listtex using "${tabledir}/synthetic_control_units_2.tex", replace
copy "${tabledir}/synthetic_control_units_2.tex" "${tabledir}/table_oa3.tex", replace
restore

keep _Co_name
rename _Co_name telnev_helyes
duplicates drop telnev_helyes, force
save ${temp}/synth_list.dta, replace