/*

	This script merges 
		- election data
		- attack data
		- settlement level controls
	to generate the main analysis data file.

*/

* romák száma - census 2001
import excel "${census_roma_share}/roma2001raw.xlsx", sheet("Munka1") firstrow clear
split telnév, gen(x) parse("/")
replace x1=strtrim(x1)
rename x1 telnev_helyes 
drop x*
drop if strpos(telnév,"A városokban együtt")!=0


replace telnev_helyes="Baranyahídvég" if telnev_helyes=="Baranyahidvég"
replace telnev_helyes="Búcsúszentlászló" if telnev_helyes=="Bucsuszentlászló"
replace telnev_helyes="Kővágótöttös" if telnev_helyes=="Kővágótőttős"
replace telnev_helyes="Rábahídvég" if telnev_helyes=="Rábahidvég"
replace telnev_helyes="Sajóhídvég" if telnev_helyes=="Sajóhidvég"
replace telnev_helyes="Szabadhídvég" if telnev_helyes=="Szabadhidvég"
replace telnev_helyes="Óhíd" if telnev_helyes=="Óhid"


keep roma_nationality2001 roma_culturally2001 roma_mothertongue2001 roma_language_user2001 telnev_helyes
gen year=2002 // we merge it to 2002 because 2001 is not in the data set
tempfile roma
save `roma'

* új kontrollváltozók kellenek tstarból
		* romák
		* bűnözés
		 * nem kell mindegyiknek minden időszakban elérhetőnek lennie!

use "${tstar}/2018/de.dta", clear
keep ev tazon de55 de56 de62 de63 //élveszületés halálozások, elvándorlás, odavándorlás
tempfile de
save `de'

use "${tstar}/2018/kh.dta", clear
keep ev tazon  kh07 // autók száma
tempfile kh
save `kh'

use "${tstar}/2018/mn.dta", clear
keep ev tazon mn04 /// ht munkanélk
		mn11 mn12 // szakmókus munkanélk
tempfile mn
save `mn'

use "${tstar}/2018/ig.dta", clear
keep ev tazon ig01 ig11 ig23 // összes lopás  bűnelkövetők száma



merge 1:1 ev tazon using `de', gen(merge_de)
merge 1:1 ev tazon using `kh', gen(merge_kh)
merge 1:1 ev tazon using `mn', gen(merge_mn)

rename ev  year
tempfile tstar_ext
save `tstar_ext'

use "${tstar}/tstar_2018.dta", clear
merge 1:1 year tazon using `tstar_ext', gen(merge_tstar_ext)
drop if telnev_helyes=="Budapest" //single obs.
tempfile tstar
save `tstar'


use ${temp}/election_panel.dta, clear

*no data in tstar on Budapest districts
drop if strpos(telnev_bpker,"Budapest")!=0

rename telnev_bpker telnev_helyes 

merge m:1 telnev_helyes year using `tstar', gen(merge_tstar)

merge m:1 telnev_helyes year using `roma', gen(merge_census2001_roma)

* missings are zeroes 
foreach v of varlist roma_nationality2001 roma_culturally2001 roma_mothertongue2001 roma_language_user2001 {
	
	replace `v'=0 if year==2002&`v'==.
	
}

*keep election years only
drop if year!=1998&year!=2002&year!=2004&year!=2006&year!=2009&year!=2010&year!=2014&year!=2018
drop if merge_tstar==2  // these year-settlement combinations did not exist in the given year



merge m:1 telnev_helyes using ${temp}/treatment.dta, gen(merge_treatment)

drop if merge_treatment==2


gen extreme_right_share = szav_jobbik / szav_eligible
gen extreme_right_share_valid = szav_jobbik / szav_valid

gen treatment=0
replace treatment=1 if planned==1
replace treatment=2 if realized==1

gen geo_treatment=0
replace geo_treatment=1 if min_distance_to_planned<=15
replace geo_treatment=2 if min_distance_to_realized<=15



tsset tazon election_date


/*

	create donor pool


*/


gen donor_pool = 0

* population
egen mean_pop = mean(pop), by(telnev_helyes)
replace donor_pool = 1 if mean_pop<=10000

* share of roma in 2001


*cumulative mentions in kuruc info
merge m:1 telnev_helyes year using  ${temp}/kuruc_yearly.dta, gen(merge_kuruc)
*drop if merge_kuruc==2

*mentions in 2008 before killings
merge m:1 telnev_helyes using  ${temp}/kuruc_2008.dta, gen(merge_kuruc2008)
*drop if merge_kuruc==2
gen cm2007 = cum_mentions if year==2007
*egen cum_mentions2007 = min(cm2007), by(telnev_helyes)
*replace donor_pool = 0 if cum_mentions2007==0


* only use settlements with positive roma share in 2001
gen roma_share = roma_nationality2001/pop
egen roma_share2001 = min(roma_share), by(telnev_helyes)
replace donor_pool=0 if roma_share2001==0

/*

	create treatment cluster

*/

gen treatment_cluster = ""

foreach s in "Galgagyörk" "Piricse" "Nyíradony" "Tarnabod" "Nagycsécs" "Alsózsolca" ///
	"Tatárszentgyörgy" "Tiszalök" "Kisléta" {
		replace treatment_cluster = "`s'" if min_distance_to_realized==distance_to_`s'
	}
	
foreach s in "Ipolytarnóc" "Kisvárda" "Tura" "Erdőkertes" {

		replace treatment_cluster = "`s'" if min_distance_to_planned==distance_to_`s'&min_distance_to_planned<min_distance_to_realized

}

save ${temp}/analysis_data_set.dta, replace


