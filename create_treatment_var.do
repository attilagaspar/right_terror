/*

	This script sets up a data file that marks planned and realized attacks
	and distances to planned attacks and realized attacks by settlement
	
*/


import delimited "${distances}/distances.csv", clear

gen realized = 0

foreach s in "Galgagyörk" "Piricse" "Nyíradony" "Tarnabod" "Nagycsécs" "Alsózsolca" ///
	"Tatárszentgyörgy" "Tiszalök" "Kisléta" {
		disp "`s'"
		replace realized = 1 if fromname=="`s'"
		gen distance_to_`s' = distancemeters if fromname=="`s'"
	}
	
gen planned = 0
foreach s in "Ipolytarnóc" "Kisvárda" "Tura" "Erdőkertes" {
	disp "`s'"
	replace planned = 1 if fromname=="`s'"
	gen distance_to_`s' = distancemeters if fromname=="`s'"
} 

gen debrecen = 0
replace debrecen = 1 if fromname=="Debrecen"
gen budapest = 0
replace budapest = 1 if fromname=="Budapest"

keep if planned==1|realized==1|debrecen==1|budapest==1

egen min_distance_to_planned = min(distancemeters) if planned==1, by(toname)
egen min_distance_to_realized = min(distancem) if realized==1, by(toname)
egen min_distance_to_budapest = min(distancem) if budapest==1, by(toname)
egen min_distance_to_debrecen = min(distancem) if debrecen==1, by(toname)

collapse (min) min_distance_to_* distance_to_*, by(toname)

foreach v of varlist min_distance_to_* distance_to* {
	
	replace `v'=round(`v'/1000)
	
}


gen planned=1 if min_distance_to_planned==0
gen realized=1 if min_distance_to_realized==0

replace planned=0 if planned==.
replace realized=0 if realized==.

rename toname telnev_helyes
save ${temp}/treatment.dta, replace