use ${temp}/analysis_data_set.dta, clear

keep if donor_pool == 1


local controls = " pop pop1859 unemp taxpayers de55 de56 de62 de63 kh07 mn04 mn11 mn12"

gen election_trend = 0 if year<2006
replace election_trend = year-2005 if year>2005

* date dummies
tab election_date, gen(date_)


* treated 9 vs donor pool
gen treatment_single= treatment
replace treatment_single = 0 if treatment_single==1
replace treatment_single = 1 if treatment_single==2

foreach v of varlist date_1 date_2 date_3 date_5 date_6 date_7 date_8 date_9 {
	
	gen `v'_tr= treatment_single*`v'
	
	
}

egen i = group(telnev_helyes)

la var date_1 "1998"
la var date_2 "2002"
la var date_3 "2004 (EP)"
la var date_5 "2009 (EP)"
la var date_6 "2010"
la var date_7 "2014"
la var date_8 "2014 (EP)"
la var date_9 "2018"
la var date_1_tr "1998 $\times$ Attacked"
la var date_2_tr "2002 $\times$ Attacked"
la var date_3_tr "2004 (EP) $\times$ Attacked"
la var date_5_tr "2009 (EP) $\times$ Attacked"
la var date_6_tr "2010 $\times$ Attacked"
la var date_7_tr "2014 $\times$ Attacked"
la var date_8_tr "2014 (EP) $\times$ Attacked"
la var date_9_tr "2018 $\times$ Attacked"
la var treatment_single "Ever Attacked"


eststo clear
*reghdfe extreme_right_share_valid date_1 date_2 date_3 date_5 date_6 date_7 date_8 date_9 date_1_tr_single date_2_tr_single date_3_tr_single date_5_tr_single date_6_tr_single date_7_tr_single date_8_tr_single date_9_tr_single  	, cluster(kist175) absorb(i )  

reghdfe extreme_right_share_valid date_1 date_2 date_3 date_5 date_6 date_7 date_8 date_9 date_1_tr date_2_tr date_3_tr date_5_tr date_6_tr date_7_tr date_8_tr date_9_tr treatment_single 	, cluster(kist175) absorb(i ) 
estadd local smpl "Donor pool"
estadd local serr "Clustered"
estadd local fe "Yes" 
eststo
*esttab using ../tables/eventstudy_attack_donor.tex, replace ///
*mgroups("Extreme right vote share, pp.", pattern(1 0 0 0)) ///	
*	 label nonotes star(* 0.10 ** 0.05 *** 0.01) staraux  se(3) b(3) nomtitles

cap drop coef se t lower_ci upper_ci 
gen coef = .
gen se = .
gen t = .
forvalues n = 1/9 {
	
	replace t = `n' in `n'
	cap replace coef = _b[date_`n'_tr] in `n'
	cap replace se = _se[date_`n'_tr] in `n'
	
	
}
gen lower_ci = coef - 1.96 * se
gen upper_ci = coef + 1.96 * se

replace coef=0 in 4
replace t = tm(1998m5) if t == 1 

replace t = tm(2002m4) if t == 2
replace t = tm(2006m4) if t == 4
replace t = tm(2010m4) if t == 6
replace t = tm(2014m4) if t == 7
replace t = tm(2018m4) if t == 9 

* For European Parliament elections (EP)
replace t = tm(2004m6) if t == 3 
replace t = tm(2009m6) if t == 5
replace t = tm(2014m5)+4 if t == 8 
format t %tm
 
twoway (rcap lower_ci upper_ci t, lcolor(black)) (connected coef t, mcolor(black) lcolor(black)), ytitle("Difference in extreme right"  "share in valid votes") ///
ylabel(-0.08 "-8%" -0.04 "-4%" 0 "0%" .04 "4%" .08 "8%" .12 "12%" .16 "16%" .20 "20%" ) xline(582 595) yline(0)  xlabel(460 507 533 555 593 603 651 699) ///
xlabel(460 "98" 507 "02" 555 "06"  603 "10" 651 "14" 699 "18" 533 "04" 593 "09" 652 " "  ) xtitle("Election year") ///
leg(off) title("(A) Attacked 9 villages vs. donor pool") name(es1, replace) xsize(1) ysize(1)

*graph export ../figures/eventstudy1.png, replace
*graph export ../figures/eventstudy1.pdf, replace




*reference category: date_4, 555 (april 2006)
preserve
keep if treatment>0
replace treatment = treatment-1

drop *_tr 

foreach v of varlist date_1 date_2 date_3 date_5 date_6 date_7 date_8 date_9 {
	
	gen `v'_tr = treatment*`v'
	
	
}

cap drop treatment_single
rename treatment treatment_single


la var date_1 "1998"
la var date_2 "2002"
la var date_3 "2004 (EP)"
la var date_5 "2009 (EP)"
la var date_6 "2010"
la var date_7 "2014"
la var date_8 "2014 (EP)"
la var date_9 "2018"
la var date_1_tr "1998 $\times$ Attacked"
la var date_2_tr "2002 $\times$ Attacked"
la var date_3_tr "2004 (EP) $\times$ Attacked"
la var date_5_tr "2009 (EP) $\times$ Attacked"
la var date_6_tr "2010 $\times$ Attacked"
la var date_7_tr "2014 $\times$ Attacked"
la var date_8_tr "2014 (EP) $\times$ Attacked"
la var date_9_tr "2018 $\times$ Attacked"
la var treatment_single "Ever Attacked"

reghdfe extreme_right_share_valid date_1 date_2 date_3  date_5 date_6 date_7 date_8 date_9 date_1_tr date_2_tr date_3_tr date_5_tr date_6_tr date_7_tr date_8_tr date_9_tr  treatment_single  if geo_treatment!=0	,  absorb(telnev_helyes)  
estadd local smpl "Planned attacks"
estadd local serr "Robust"
estadd local fe "Yes" 
eststo 

esttab using ${tabledir}/eventstudy.tex,  order(date_1 date_2 date_3 date_5 date_6 date_7 date_8 date_9 date_1_tr date_2_tr date_3_tr date_5_tr date_6_tr date_7_tr date_8_tr date_9_tr  ) keep(date_1 date_2 date_3 date_5 date_6 date_7 date_8 date_9 date_1_tr date_2_tr date_3_tr date_5_tr date_6_tr date_7_tr date_8_tr date_9_tr  ) replace ///
mgroups("DV: Extreme right vote share, pp.", pattern(1 0 0 0)  ///
 prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) ///
	 label nonotes star(* 0.10 ** 0.05 *** 0.01) staraux  se(3) b(3) nomtitles ///
	 scalars(	"r2 $ R^2 $" N	"smpl Control group" ///
			"serr Standard errors" ///
			"fe Fixed effects" ///
			)
copy "${tabledir}/eventstudy.tex" "${tabledir}/table_oa6.tex", replace

cap drop coef se t lower_ci upper_ci 
gen coef = .
gen se = .
gen t = .
forvalues n = 1/9 {
	
	replace t = `n' in `n'
	cap replace coef = _b[date_`n'_tr] in `n'
	cap replace se = _se[date_`n'_tr] in `n'
	
	
}
gen lower_ci = coef - 1.96 * se
gen upper_ci = coef + 1.96 * se

replace coef=0 in 4
replace t = tm(1998m5) if t == 1 

replace t = tm(2002m4) if t == 2
replace t = tm(2006m4) if t == 4
replace t = tm(2010m4) if t == 6
replace t = tm(2014m4) if t == 7
replace t = tm(2018m4) if t == 9 

* For European Parliament elections (EP)
replace t = tm(2004m6) if t == 3 
replace t = tm(2009m6) if t == 5
replace t = tm(2014m5)+4 if t == 8 
format t %tm

twoway (rcap lower_ci upper_ci t, lcolor(black)) (connected coef t, mcolor(black) lcolor(black)), ytitle("") /// ytitle("Difference in extreme right share in valid votes") 
ylabel(-0.08 "-8%" -0.04 "-4%" 0 "0%" .04 "4%" .08 "8%" .12 "12%" .16 "16%" .20 "20%" ) xline(582 595) yline(0)  xlabel(460 507 533 555 593 603 651 699) ///
xlabel(460 "98" 507 "02" 555 "06"  603 "10" 651 "14" 699 "18" 533 "04" 593 "09" 652 " "  ) xtitle("Election year") ///
leg(off) name(es3, replace) title("(B) Attacked vs. planned") xsize(1) ysize(1) 

   
*graph export ../figures/eventstudy3.png, replace
*graph export ../figures/eventstudy3.pdf, replace


 *grc1leg es1 es2 es3,  
graph combine  es1  es3 ,  xsize(2) ysize(1) col(2) 
graph export ${figuredir}/combined_eventstudy.png, replace
graph export ${figuredir}/combined_eventstudy.pdf, replace
graph export ${figuredir}/figure1.pdf, replace

