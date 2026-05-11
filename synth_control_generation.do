
/*

this script generates synthetic control attacked villages

*/




use ${temp}/analysis_data_set.dta, clear

* only use election years
drop if year!=1998&year!=2002&year!=2004&year!=2006&year!=2009&year!=2010&year!=2014&year!=2018

egen t = group(year)

cap rm "${temp}/synth/*.dta"  // delete temporary files 


	local n = 0
	foreach s in "Galgagyörk" "Piricse" "Nyíradony" "Tarnabod" "Nagycsécs" "Alsózsolca" ///
	"Tatárszentgyörgy" "Tiszalök" "Kisléta"   {  //"Ipolytarnóc" "Kisvárda" "Tura" "Erdőkertes"
	preserve


		drop if election_date==652 // this drops 2014 eu elections so we have a single observation from 2014 (parliamentary elections)
		* balanced panel kell
		egen i = group(telnev_helyes)
		replace i = i+10
		local n= `n'+1
		replace i = `n' if telnev_helyes=="`s'"
		*egen t = group(year)

		
		tab t 
		
		
		* retrieve panel ID of attack location
		levelsof i if telnev_helyes=="`s'", local(treatedobs)

		sum pop if telnev_helyes=="`s'"
		local popmean = r(mean)
		local popmin =  `popmean'/1.3
		local popmax =  `popmean'*1.3
		
		egen pm = mean(pop), by(telnev_helyes)
		*keep if (pm>`popmin'&pm<`popmax'&min_distance_to_realized>100)|telnev_helyes=="`s'"
		*keep if (pm>`popmin'&pm<`popmax'&min_distance_to_realized>100)|telnev_helyes=="`s'"
		keep if (donor_pool==1&min_distance_to_realized>100)|telnev_helyes=="`s'"
		* drop other treated vars
*		keep if (inrange(pop,800,1200)&min_distance_to_realized>200)|telnev_helyes=="`s'"

		*keep if min_distance_to_realized>15|telnev_helyes=="`s'"

		egen c = count(i), by(i)
		drop if c<8  // drop newly created villages or those that merge
		tsset i t  // strongly balanced now

		disp "`treatedobs'"
		disp "`s'"

		count // 
		synth extreme_right_share_valid pop  mentions0708(4) cum_mentions0707(4) min_distance_to_debrecen pop1859 unemp taxpayers de55 de56 de62 de63 kh07 mn04 mn11 mn12 roma_nationality2001(2) ig01(2(1)8) ig11(2(1)8) ig23(2(1)8) , trunit(`treatedobs') trperiod(4) keep("${temp}/synth/synth_`treatedobs'.dta",replace)  figure
		graph export ${temp}/synth/fig_`s'.png,replace
		
		keep i telnev_helyes
		duplicates drop
		rename i _Co_Number
		rename telnev_helyes _Co_name
		gen treat_name = "`s'"
		tempfile names
		save `names'

		use ${temp}/synth/synth_`treatedobs'.dta, clear
		drop if (_W_Weight==0|_W_Weight==.)&_time==.
		merge 1:1 _Co_Number using `names', gen(merge_name)
		drop if merge_name==2
		replace _Co_name="" if _W_Weight==0
		drop merge_name
		save, replace
		
	restore

}


