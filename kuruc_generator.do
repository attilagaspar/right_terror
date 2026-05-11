/*

	this script generates mention counts in the kuruc.info data

	- load every settlement name from TSTAR data
	- generate a list of every Settlement
	- also generate the adjective form
	- find noun and adjective in kuruc.info mentions, tag mentioned setlements
	- save different versions of the data (total, panel, total in 2008 prior to first attack)
	
*/

* load settlement names

use "${tstar}/2018/de.dta", clear

keep telnev_helyes tazon
duplicates drop

* create matching variables

drop if telnev_helyes==""

gen name2 = lower(telnev_helyes)
replace name2=name2+"i" if substr(name2,-1,1)!="i"

replace name2 = subinstr(name2,"Á","á",1)
replace name2 = subinstr(name2,"É","é",1)
replace name2 = subinstr(name2,"Ő","ő",1)
replace name2 = subinstr(name2,"Ö","ö",1)
replace name2 = subinstr(name2,"Ú","ú",1)
replace name2 = subinstr(name2,"Ó","ó",1)
replace name2 = subinstr(name2,"Ü","ü",1)

rename telnev_helyes name

tempfile settlements
save `settlements'

import delimited "${kuruc}/consolidated_data.csv", varnames(1) clear
append using `settlements'

gen count1 = 0 if name!=""
gen count2 = 0 if name!=""

levelsof name, local(nms1)

local n = 0
qui foreach s in `nms1' {
	local n = `n'+1
	cap drop mentions_`n'=0
	gen mentions_`n'=0
	replace mentions_`n'=mentions_`n'+1 if strpos(text,"`s'")!=0
	
}
		

levelsof name2, local(nms2)
local n = 0
qui foreach s in `nms2' {
	local n = `n'+1
	replace mentions_`n'=mentions_`n'+1 if strpos(text,"`s'")!=0
}

local n = 0
qui foreach s in `nms1' {
	local n = `n'+1
	rename mentions_`n' mentions_`s'	
}

split date, gen(dt)
rename dt1 year
replace year=subinstr(year,".","",1)

rename dt2 month

collapse (sum) mentions_* , by(year month)

* 1. Generate a numerical month variable
gen month_num = .
replace month_num = 1 if month == "január"
replace month_num = 2 if month == "február"
replace month_num = 3 if month == "március"
replace month_num = 4 if month == "április"
replace month_num = 5 if month == "május"
replace month_num = 6 if month == "június"
replace month_num = 7 if month == "július"
replace month_num = 8 if month == "augusztus"
replace month_num = 9 if month == "szeptember"
replace month_num = 10 if month == "október"
replace month_num = 11 if month == "november"
replace month_num = 12 if month == "december"

* 2. Ensure month_num is treated as a numerical variable
destring month_num, replace

* 3. Create a monthly date variable using month and year
destring year, force replace
gen monthly_date = ym(year, month_num)
format monthly_date %tm

* reshape

reshape long mentions_, i(monthly_date) j(settlement) string

rename mentions_ mentions

egen i = group(settlement)
tsset i monthly_date
bysort i : gen cum_mentions = sum(mentions)
gen log_cum_mentions = log(1+cum_mentions)


rename settlement telnev_helyes

gen treated = 0
foreach s in "Galgagyörk" "Piricse" "Nyíradony" "Tarnabod" "Nagycsécs" "Alsózsolca" ///
	"Tatárszentgyörgy" "Tiszalök" "Kisléta" {
		
		replace treated = 1 if telnev_helyes=="`s'"
		
	}

	
gen treatment_date = .
replace treatment_date = tm(2008m7) if telnev_helyes=="Galgagyörk"
replace treatment_date = tm(2008m8) if telnev_helyes=="Piricse"
replace treatment_date = tm(2008m9) if telnev_helyes=="Nyíradony"
replace treatment_date = tm(2008m9) if telnev_helyes=="Tarnabod"
replace treatment_date = tm(2008m11) if telnev_helyes=="Nagycsécs"
replace treatment_date = tm(2008m12) if telnev_helyes=="Alsózsolca"
replace treatment_date = tm(2009m2) if telnev_helyes=="Tatárszentgyörgy"
replace treatment_date = tm(2009m4) if telnev_helyes=="Tiszalök"
replace treatment_date = tm(2009m8) if telnev_helyes=="Kisléta"


gen relative_date = monthly_date - treatment_date


save ${temp}/kuruc_data.dta, replace



use ${temp}/kuruc_data.dta, clear

keep if year==2008|year==2007
keep if (month_num<7&year==2008)|(month_num>=7&year==2007)
gen cum_mentions0707=cum_mentions if month_num==6&year==2008
collapse (sum) mentions (firstnm) cum_mentions0707, by(telnev_helyes)
gen year=2006

rename mentions mentions0708 
save ${temp}/kuruc_2008.dta, replace


use ${temp}/kuruc_data.dta, clear

collapse (sum) mentions, by(telnev_helyes year)
egen i = group(telnev_helyes)
tsset i year
bysort i : gen cum_mentions = sum(mentions)
gen lag_cum_mentions = l.cum_mentions
gen log_lag_cum_mentions = log(lag_cum_mentions+1)

gen fwd_cum_mentions = f.cum_mentions
gen log_fwd_cum_mentions = log(fwd_cum_mentions+1)

keep cum_mentions log_lag_cum_mentions log_fwd_cum_mentions telnev_helyes year
save ${temp}/kuruc_yearly.dta, replace


