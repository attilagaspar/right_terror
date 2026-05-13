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

reg d_extreme_right_share_valid treated mentions0708 roma_share2001 d.unemp  d.ig01 d.ig23 if donor_pool==1, cluster(kist175)  
estadd local smpl "Donor pool"
estadd local serr "Clustered"
estadd local controls "Yes"
eststo


reg d_extreme_right_share_valid treated mentions0708 roma_share2001 d.unemp  d.ig01 d.ig23 if treatment!=0, rob
estadd local smpl "Planned attack"
estadd local serr "Robust"
estadd local controls "Yes"
eststo

preserve
append using ${temp}/synth_did.dta
reg d_extreme_right_share_valid treated  if id!=., rob
estadd local smpl "Synthetic"
estadd local serr "Robust"
estadd local controls "No"
eststo
restore 


esttab  using "${tabledir}/did1.tex", keep( treated _cons )  se(3) b(3) ///
 mgroups("$\Delta$(Extreme right vote share 2010-2006, pp.) in 9 attacked settlements", pattern(1 0 0 ) ///
 prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) ///
  collabels(none)  ///
   replace label nonotes   scalars(	"r2 $ R^2 $" N	"smpl Control group" ///
			"serr Standard errors" ///
			"controls Covariates" ///
			)    star(* 0.10 ** 0.05 *** 0.01) staraux nomtitles
copy "${tabledir}/did1.tex" "${tabledir}/table1.tex", replace


la var treated "Attacked"
la var mentions "Kuruc.info mentions before attack"
la var roma_share2001 "Roma share in 2001"
la var ig01 "Number of reported crimes at location"
la var ig23 "Residents with criminal record at location"
la var unemp "Unemployment rate"

eststo clear 
reg d_extreme_right_share_valid treated   if unemp!=.&roma_share2001!=.&ig01!=.&ig23!=. , cluster(kist175)  
estadd local smpl "Whole country"
estadd local serr "Clustered"
estadd local controls "No"
eststo

reg d_extreme_right_share_valid treated mentions0708 roma_share2001 d.unemp  d.ig01 d.ig23   , cluster(kist175)  
estadd local smpl "Whole country"
estadd local serr "Clustered"
estadd local controls "Yes"
eststo

reg d_extreme_right_share_valid treated mentions0708 roma_share2001 d.unemp  d.ig01 d.ig23 if donor_pool==1, cluster(kist175)  
estadd local smpl "Donor pool"
estadd local serr "Clustered"
estadd local controls "Yes"
eststo


reg d_extreme_right_share_valid treated mentions0708 roma_share2001 d.unemp  d.ig01 d.ig23 if treatment!=0, rob
estadd local smpl "Planned attack"
estadd local serr "Robust"
estadd local controls "Yes"
eststo

preserve
append using ${temp}/synth_did.dta
reg d_extreme_right_share_valid treated  if id!=., rob
estadd local smpl "Synthetic"
estadd local serr "Robust"
estadd local controls "No"
eststo
restore 

esttab  using "${tabledir}/did1_appendix.tex",  se(3) b(3) ///
 mgroups("$\Delta$(Extreme right vote share 2010-2006, pp.) in 9 attacked settlements", pattern(1 0 0 ) ///
 prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) ///
  collabels(none)  ///
   replace label nonotes   scalars(	"r2 $ R^2 $" N	"smpl Control group" ///
			"serr Standard errors" ///
			"controls Covariates" ///
			)    star(* 0.10 ** 0.05 *** 0.01) staraux nomtitles
copy "${tabledir}/did1_appendix.tex" "${tabledir}/table_oa4.tex", replace


/*

	Pre-Trends
	
*/
			
eststo clear 
reg l4_d_extreme_right_share_valid treated   if unemp!=.&roma_share2001!=.&ig01!=.&ig23!=. , cluster(kist175)  
estadd local smpl "Whole country"
estadd local serr "Clustered"
estadd local controls "No"
eststo

reg l4_d_extreme_right_share_valid treated mentions0708 roma_share2001 d.unemp  d.ig01 d.ig23   , cluster(kist175)  
estadd local smpl "Whole country"
estadd local serr "Clustered"
estadd local controls "Yes"
eststo

reg l4_d_extreme_right_share_valid treated mentions0708 roma_share2001 d.unemp  d.ig01 d.ig23 if donor_pool==1, cluster(kist175)  
estadd local smpl "Donor pool"
estadd local serr "Clustered"
estadd local controls "Yes"
eststo


reg l4_d_extreme_right_share_valid treated mentions0708 roma_share2001 d.unemp  d.ig01 d.ig23 if treatment!=0, rob
estadd local smpl "Planned attack"
estadd local serr "Robust"
estadd local controls "Yes"
eststo

preserve
append using ${temp}/synth_did_pretrend.dta
reg l4_d_extreme_right_share_valid treated  if id!=., rob
estadd local smpl "Synthetic"
estadd local serr "Robust"
estadd local controls "No"
eststo
restore 

esttab  using "${tabledir}/did_appendix_pretrend.tex",  se(3) b(3) ///
 mgroups("$\Delta$(Extreme right vote share 2006-2002, pp.) in 9 attacked settlements", pattern(1 0 0 ) ///
 prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) ///
  collabels(none)  ///
   replace label nonotes   scalars(	"r2 $ R^2 $" N	"smpl Control group" ///
			"serr Standard errors" ///
			"controls Covariates" ///
			)    star(* 0.10 ** 0.05 *** 0.01) staraux nomtitles
copy "${tabledir}/did_appendix_pretrend.tex" "${tabledir}/table_oa5.tex", replace



