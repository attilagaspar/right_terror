* this script generates the version of Table 1 with additional controls in the 
* Appendix

use "${unemp}/rmnk_112_08.dta", clear

keep telnev telkod regsumy08*
rename regsumy08* mn*
reshape long mn,i(telkod) j(honap) string
destring honap, force replace 

keep if honap<6
collapse (mean) mn, by(telkod telnev )
rename telkod tazon 
tempfile unempl 
save `unempl'

use "${tstar}/2018/de.dta", clear

gen kisgyerek = de04/de03*1000 
gen oda = de62/de03*100
gen el =  de63/de03*100

keep if ev>2001&ev<2008

replace de09 = . if ev<2007


collapse (mean) kisgyerek oda el de09, by(telnev_helyes tazon)

merge 1:1 tazon using `unempl', gen(merge_unemp)

keep if merge_unemp==3

gen unemp2008 = mn/de09*100

la var unemp2008 "Unemployment 2008m1-m5 avg."
la var oda "Yearly inflow (pp), 2002-2007 avg."
la var el "Yearly outflow (pp), 2002-2007 avg."
la var kisgyerek "0-2 yr old / 1000, 2002-2007 avg."

keep tazon telnev_helyes kisgyerek oda el unemp2008
tempfile demo_ctrl
save `demo_ctrl'



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

merge m:1 tazon using `demo_ctrl', gen(merge_demo_extra_ctrl)
tsset i post

local demo_extra = "kisgyerek el unemp2008"



eststo clear 
reg d_extreme_right_share_valid treated `demo_extra' mentions0708 roma_share2001 d.unemp  d.ig01 d.ig23   , cluster(kist175)  
estadd local smpl "Whole country"
estadd local serr "Clustered"
estadd local controls "Yes"
eststo

reg d_extreme_right_share_valid treated `demo_extra' mentions0708 roma_share2001 d.unemp  d.ig01 d.ig23 if donor_pool==1, cluster(kist175)  
estadd local smpl "Donor pool"
estadd local serr "Clustered"
estadd local controls "Yes"
eststo


reg d_extreme_right_share_valid treated `demo_extra' mentions0708 roma_share2001 d.unemp  d.ig01 d.ig23 if treatment!=0, rob
estadd local smpl "Planned attack"
estadd local serr "Robust"
estadd local controls "Yes"
eststo


esttab  using "${tabledir}/did1_extra_demo.tex", keep( treated `demo_extra' _cons )  se(3) b(3) ///
 mgroups("$\Delta$(Extreme right vote share 2010-2006, pp.) in 9 attacked settlements", pattern(1 0 0 ) ///
 prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) ///
  collabels(none)  ///
   replace label nonotes   scalars(	"r2 $ R^2 $" N	"smpl Control group" ///
			"serr Standard errors" ///
			"controls Covariates" ///
			)    star(* 0.10 ** 0.05 *** 0.01) staraux nomtitles
copy "${tabledir}/did1_extra_demo.tex" "${tabledir}/table_oa12.tex", replace


