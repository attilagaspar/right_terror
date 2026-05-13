use ${temp}/analysis_data_set.dta, clear

merge m:1 telnev_helyes using ${temp}/synth_list.dta, gen(merge_synth_list)
replace extreme_right_share_valid = extreme_right_share_valid*100

gen synthgroup = 0
replace synthgroup = 1 if merge_synth_list==3

egen ever_treatment = max(treatment), by(tazon)
*egen min_roma10 = min(roma_nationality2001), by(tazon)
local treated_cond = "ever_treatment==2&year==2006"
local control0_cond = "ever_treatment==0&year==2006"
local control1_cond = "ever_treatment==0&year==2006&donor_pool==1"
local control2_cond = "year==2006&ever_treatment==1"
local control3_cond = "year==2006&synthgroup==1"

* Initialize a 3x5 matrix (3 variables, 5 columns)
matrix results = J(20,9,.)

replace roma_share2001=roma_share2001*100

local i = 1
foreach var of varlist extreme_right_share_valid pop pop1859 de55 de56 de62 de63 roma_share2001 taxpayers unemp  kh07 mn04 mn11 mn12 ig01 ig11 ig23 min_distance_to_debrecen  cum_mentions0707 mentions0708 {

    * Mean for treated group:
    summarize `var' if `treated_cond', meanonly
    local m_t = r(mean)
	
	
	* Whole
    * Mean for controls (first condition):
    summarize `var' if `control0_cond', meanonly
    local m_0 = r(mean)
	
	count if `treated_cond' | (`control0_cond')
    * T-test comparing treated and first condition controls:
    ttest `var' if `treated_cond' | (`control0_cond'), by(treatment)
    local p_0 = r(p)
	
	
	* DONOR POOL
    * Mean for controls (first condition):
    summarize `var' if `control1_cond', meanonly
    local m_f = r(mean)
	
	count if `treated_cond' | (`control1_cond')
    * T-test comparing treated and first condition controls:
    ttest `var' if `treated_cond' | (`control1_cond'), by(treatment)
    local p_f = r(p)
	

	* PLANNED
    * Mean for controls (second condition):
    summarize `var' if `control2_cond', meanonly

    local m_s = r(mean)
	
    * T-test comparing treated and second condition controls:

    ttest `var' if `treated_cond' | (`control2_cond'), by(treatment)
    local p_s = r(p)
	
	
	* SYNTHETIC
    * Mean for controls (second condition):
    summarize `var' if `control3_cond', meanonly

    local m_r = r(mean)
	
    * T-test comparing treated and second condition controls:

    ttest `var' if `treated_cond' | (`control3_cond'), by(treatment)
    local p_r = r(p)


    * Save the results in the matrix:
    matrix results[`i',1] = `m_t'
    matrix results[`i',2] = `m_0'
    matrix results[`i',3] = `p_0'
    matrix results[`i',4] = `m_f'
    matrix results[`i',5] = `p_f'
    matrix results[`i',6] = `m_s'
    matrix results[`i',7] = `p_s'    
	matrix results[`i',8] = `m_r'
    matrix results[`i',9] = `p_r' 
    local ++i
}

* Label rows and columns
matrix rownames results = extreme_right_share_valid pop pop1859 de55 de56 de62 de63 roma_share2001 taxpayers unemp  kh07 mn04 mn11 mn12 ig01 ig11 ig23 min_distance_to_debrecen  cum_mentions0707 mentions0708
matrix colnames  results = Attacked "Whole country" "p diff." "Donor pool" "p diff." Planned "p diff." "Synthetic pool" "p diff."

la var extreme_right_share_valid "Extreme right share in 2006 (pp)"
la var pop "Population"
la var pop1859 "Population aged 18-59"
la var de55 "Live births"
la var de56 "Deaths"
la var de62 "Population inflow"
la var de63 "Population outflow"
la var roma_share2001 "Roma share in 2001 census (pp)"
la var taxpayers "Pays income tax"
la var unemp "Unemployed"
la var kh07 "Registred cars"
la var mn04 "Long term unemployed"
la var mn11 "Unemployed, primary school ed."
la var mn12 "Unemployed, vocational school ed."
la var ig01 "Registered crimes"
la var ig11 "Registered thefts"
la var ig23 "Registered offenders"
la var min_distance_to_debrecen "Distance to Debrecen"
la var cum_mentions0707 "Total kuruc.info mentions until 1st attack"
la var mentions0708 "Kuruc.info mentions in 2007 until 1st attack"


* Display the matrix in the Results window:
matlist results, format(%9.3f)

* hardcode formatting

* Determine matrix dimensions:
local nrows = rowsof(results)
local ncols = colsof(results)

* Loop over rows and columns to round each element to 3 decimals:
forvalues i = 1/`nrows' {
    forvalues j = 1/`ncols' {
        matrix results[`i', `j'] = round(results[`i', `j'], 0.01)
    }
}


esttab matrix(results) using "${tabledir}/balance_table_2.tex", replace ///
    cells("b(fmt(3))") ///
    title("Balance Table") ///
	refcat(pop "\textbf{Demography}" taxpayers "\textbf{Local economy}" ig01 "\textbf{Crime}" min_distance_to_debrecen "\textbf{Terrorists' focus}", nolabel) ///
    label ///
	nomtitles
copy "${tabledir}/balance_table_2.tex" "${tabledir}/table_oa3.tex", replace


*	mgroups("Attacked" "Whole country" "Donor pool" "Planned" "Synthetic pool", pattern(1 1 0 1 0 1 0 1 0)) ///

	