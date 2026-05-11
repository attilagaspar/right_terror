use ${temp}/analysis_data_set.dta, clear

/*

	Exhibit A: Difference-in-differences for 2006-2010

*/

keep if year==2002|year==2006|year==2010
drop if tazon==. // these settlements did not exist in given year
tsset tazon year
gen d_extreme_right_share_valid = (extreme_right_share_valid - l4.extreme_right_share_valid)*100
gen l4_d_extreme_right_share_valid = l4.d_extreme_right_share_valid
drop if year==2002

gen post = 0 
replace post = 1 if year==2010

egen i = group(telnev_helyes)
tsset i post

gen treated = 0 
replace treated = 1 if treatment==2
la var treated "Attacked"


replace unemp = unemp/pop1859 *100
replace taxpayers = taxpayers/pop1859*100
foreach v of varlist ig* kh07 de55 de62 {
	
	replace `v'=`v'/pop*100
	

}



eststo clear 
reg d_extreme_right_share_valid treated mentions0708 roma_share2001 d.unemp  d.ig01 d.ig23   , cluster(kist175)  
estadd local smpl "Whole country"
estadd local serr "Clustered"
estadd local controls "Yes"
eststo

sensemakr d_extreme_right_share_valid treated mentions0708 roma_share2001 d.unemp  d.ig01 d.ig23  , treat(treated) 





reg d_extreme_right_share_valid treated mentions0708 roma_share2001 d.unemp  d.ig01 d.ig23 if donor_pool==1, cluster(kist175)  
estadd local smpl "Donor pool"
estadd local serr "Clustered"
estadd local controls "Yes"
eststo
sensemakr d_extreme_right_share_valid treated mentions0708 roma_share2001 d.unemp  d.ig01 d.ig23 if donor_pool==1,    treat(treated) 


reg d_extreme_right_share_valid treated mentions0708 roma_share2001 d.unemp  d.ig01 d.ig23 if treatment!=0, rob
estadd local smpl "Planned attack"
estadd local serr "Robust"
estadd local controls "Yes"
eststo
sensemakr d_extreme_right_share_valid treated mentions0708 roma_share2001 d.unemp  d.ig01 d.ig23 if treatment!=0, treat(treated) 



preserve
append using ${temp}/synth_did.dta
reg d_extreme_right_share_valid treated  if id!=., rob
estadd local smpl "Synthetic"
estadd local serr "Robust"
estadd local controls "No"
eststo
sensemakr d_extreme_right_share_valid treated  if id!=., treat(treated) 

restore 
