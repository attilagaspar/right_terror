use "${survey}/HEPS2_2009.dta", clear

foreach v of varlist e_6_1_9 e_6_2_9 e_6_3_9 e_6_4_9 e_6_5_9 e_6_6_9 e_6_7_9 e_6_8_9 e_6_9_9 e_6_10_9  {
	
	
	replace `v' = . if `v'==99
	
}

foreach v of varlist e_5_1_9 e_5_2_9 e_5_3_9 e_5_4_9 e_5_5_9  {
	
	
	replace `v' = . if `v'==9
	
}

la var e_6_1_ "Chinese"
la var e_6_2 "Germans"
la var e_6_3 "Russians" 
la var e_6_4 "Americans"
la var e_6_5 "Arabs"
la var e_6_6 "Romanians"
la var e_6_7 "Jews"
la var e_6_8 "Slovaks"
la var e_6_9 "Roma"
la var e_6_10 "Austrians"



preserve 
	keep e_6_9_9 e_6_5_9 e_6_1_9 e_6_6_9  e_6_7_9 e_6_3_9  e_6_8_9 e_6_4_9 e_6_10_9 e_6_2_9 
	rename *_9 *
	rename e_6_* favorable*
	gen i = _n
	reshape long favorable, i(i) j(j)
	cap label drop nation
	label define nation 1 "Chinese" ///
		2 "Germans" ///
		3 "Russians"  ///
		4 "Americans" ///
		5 "Arabs" ///
		6 "Romanians" ///
		7 "Jews" ///
		8 "Slovaks" ///
		9 "Roma" ///
		10 "Austrians"
	la val j nation 
	sum
	egen mean_fav = mean(favorable), by(j)
	graph hbox favorable, over(j ,sort(1)) nooutside ///
	ylabel(1 `" "1" "Very" "unfavorable" "' 2 3 4 5 6 7 8 9 `" "9" "Very" "favorable" "') note(" ") ytitle("") ///
	 box(1, color(black)) ///
box(2, color(black%30))  ///
box(3, color(black%30))  ///
box(4, color(black%30))  ///
box(5, color(black%30))  ///
box(6, color(black%30))  ///
box(7, color(black%30))  ///
box(8, color(black%30))  ///
box(9, color(black))  ///
box(10, color(black%30)) 
	graph export ${figuredir}/ethnic_groups.pdf, replace

restore


preserve 
	keep if baljobb>4 // only those who identify as right-wing
	sum e_6_9_9, det
	keep e_6_9_9 e_6_5_9 e_6_1_9 e_6_6_9  e_6_7_9 e_6_3_9  e_6_8_9 e_6_4_9 e_6_10_9 e_6_2_9 
	rename *_9 *
	rename e_6_* favorable*
	gen i = _n
	reshape long favorable, i(i) j(j)
	cap label drop nation
	label define nation 1 "Chinese" ///
		2 "Germans" ///
		3 "Russians"  ///
		4 "Americans" ///
		5 "Arabs" ///
		6 "Romanians" ///
		7 "Jews" ///
		8 "Slovaks" ///
		9 "Roma" ///
		10 "Austrians"
	la val j nation 
	sum
	egen mean_fav = mean(favorable), by(j)
	graph hbox favorable, over(j ,sort(1)) nooutside ///
	ylabel(1 `" "1" "Very" "unfavorable" "' 2 3 4 5 6 7 8 9 `" "9" "Very" "favorable" "') note(" ") ytitle("") ///
	 box(1, color(black)) ///
box(2, color(black%30))  ///
box(3, color(black%30))  ///
box(4, color(black%30))  ///
box(5, color(black%30))  ///
box(6, color(black%30))  ///
box(7, color(black%30))  ///
box(8, color(black%30))  ///
box(9, color(black))  ///
box(10, color(black%30)) 
	graph export ${figuredir}/ethnic_groups_right.pdf, replace

restore



la var e_5_1_9 "The Roma should receive more assistance than others."
la var e_5_2_9 "The growth of the Roma population is a threat to the security of the society."
la var e_5_3_9 "Many Roma do not work because they cannot get a job."
la var e_5_4_9 "It is good that there are still entertainment venues that do not admit Roma."
la var e_5_5_9 "A tendency toward crime is in the blood of the Roma."

foreach v of varlist e_5_1_9 e_5_2_9 e_5_3_9 e_5_4_9  {
	cap drop `v'_cat*
	tab `v', gen(`v'_cat)
	local mylabel : variable label `v'

	graph hbar `v'_cat*,  stack bar(1, color(black) lcolor(white)) ///
	bar(2, color(black%60) lcolor(white)) ///
	bar(3, color(black%40) lcolor(white)) ///
	bar(4, color(black%20) lcolor(white)) ///
	bar(5, color(black%10) lcolor(white)) name(bar_`v', replace) ///
	legend(off) subtitle("`mylabel'",   size(medium)) ///
	ysize(1) xsize(1) leg(off) ylabel(0 " " .2 " " .4 " " .6 " " .8 " "  1 " ")
}

foreach v of varlist  e_5_5_9 {
	cap drop `v'_cat*
	tab `v', gen(`v'_cat)
	local mylabel : variable label `v'

	graph hbar `v'_cat*,  stack bar(1, color(black) lcolor(white)) ///
	bar(2, color(black%60) lcolor(white)) ///
	bar(3, color(black%40) lcolor(white)) ///
	bar(4, color(black%20) lcolor(white)) ///
	bar(5, color(black%10) lcolor(white)) name(bar_`v', replace) /// 	*legend(order(1 "1 - Strongly disagree" 2 "2" 3 "3" 4 "4" 5 "5 - Strongly agree" ) pos(6) row(1) col(5)) ///
	subtitle("`mylabel'",   size(medium)) ///
	ysize(1	) xsize(1.5) leg(off)  ylabel(0 `" "Strongly" "disagree" "' .2 "20%" .4 "40%" .6 "60%" .8 "80%"  1 `" "Strongly" "agree" "') 
}


graph combine  bar_e_5_1_9 bar_e_5_2_9 bar_e_5_3_9 bar_e_5_4_9 bar_e_5_5_9  , col(1) row(5) xsize(1) ysize(1.3)   imargin(0 0 0 0) graphregion(margin(4 4 4 4))

graph export ${figuredir}/roma_statements.pdf, replace


preserve
	keep if baljobb>3
	
foreach v of varlist e_5_1_9 e_5_2_9 e_5_3_9 e_5_4_9  {
	cap drop `v'_cat*
	tab `v', gen(`v'_cat)
	local mylabel : variable label `v'

	graph hbar `v'_cat*,  stack bar(1, color(black) lcolor(white)) ///
	bar(2, color(black%60) lcolor(white)) ///
	bar(3, color(black%40) lcolor(white)) ///
	bar(4, color(black%20) lcolor(white)) ///
	bar(5, color(black%10) lcolor(white)) name(bar_`v', replace) ///
	legend(off) subtitle("`mylabel'",   size(medium)) ///
	ysize(1) xsize(1) leg(off) ylabel(0 " " .2 " " .4 " " .6 " " .8 " "  1 " ")
}

foreach v of varlist  e_5_5_9 {
	cap drop `v'_cat*
	tab `v', gen(`v'_cat)
	local mylabel : variable label `v'

	graph hbar `v'_cat*,  stack bar(1, color(black) lcolor(white)) ///
	bar(2, color(black%60) lcolor(white)) ///
	bar(3, color(black%40) lcolor(white)) ///
	bar(4, color(black%20) lcolor(white)) ///
	bar(5, color(black%10) lcolor(white)) name(bar_`v', replace) /// 	*legend(order(1 "1 - Strongly disagree" 2 "2" 3 "3" 4 "4" 5 "5 - Strongly agree" ) pos(6) row(1) col(5)) ///
	subtitle("`mylabel'",   size(medium)) ///
	ysize(1	) xsize(1.5) leg(off)  ylabel(0 `" "Strongly" "disagree" "' .2 "20%" .4 "40%" .6 "60%" .8 "80%"  1 `" "Strongly" "agree" "') 
}


graph combine  bar_e_5_1_9 bar_e_5_2_9 bar_e_5_3_9 bar_e_5_4_9 bar_e_5_5_9  , col(1) row(5) xsize(1) ysize(1.3)   imargin(0 0 0 0) graphregion(margin(4 4 4 4))

graph export ${figuredir}/roma_statements_right.pdf, replace

restore



/*
grc1leg  bar_e_5_1_9 bar_e_5_2_9 bar_e_5_3_9 bar_e_5_4_9 bar_e_5_5_9 , col(1) row(5)  xsize(1) ysize(1)

graph hbox e_5_1_9 e_5_2_9 e_5_3_9 e_5_4_9 e_5_5_9, ylabel(1 `" "1" "Strongly" "disagree" "' 2 3 4  `" "5" "Strongly" "agree" "') ///
 box(1, color(black%30)) ///
box(2, color(black%30))  ///
box(3, color(black%30))  ///
box(4, color(black%30))  ///
box(5, color(black%30))  ///
box(6, color(black%30))  ///
box(7, color(black%30))  ///
box(8, color(black%30))  ///
box(9, color(black))  ///
box(10, color(black%30)) ///
nooutside note(" ") ///
        text( 8 48 "Romanians") ///
        text( 8 38 "Jews") ///
        text( 8 28 "Slovaks") ///
        text( 8 18 "Roma") ///
		text( 8 8 "Austrians") ///
		leg(off) ///
		xsize(1) ysize(1)		
		
		

dsds
foreach v of varlist e_6_1_9 e_6_2_9 e_6_3_9 e_6_4_9 e_6_5_9 e_6_6_9 e_6_7_9 e_6_8_9 e_6_9_9 e_6_10_9 {
	
	
	tab `v' , gen(`v'_val)	
}

collapse (mean) *_val*


*keep e_6_1_9_val* e_6_2_9_val* e_6_3_9_val*
gen i = 1	
reshape long e_6_1_9_val e_6_2_9_val e_6_3_9_val ///
			 e_6_4_9_val e_6_5_9_val e_6_6_9_val ///
			 e_6_7_9_val e_6_8_9_val e_6_9_9_val e_6_10_9_val, i(i) j(val) 


la var e_6_1_ "Chinese"
la var e_6_2 "Germans"
la var e_6_3 "Russians" 
la var e_6_4 "Americans"
la var e_6_5 "Arabs"
la var e_6_6 "Romanians"
la var e_6_7 "Jews"
la var e_6_8 "Slovaks"
la var e_6_9 "Roma"
la var e_6_10 "Austrians"

			 
rename e_6_1_ chinese
rename e_6_2 german
rename e_6_3 russian 
rename e_6_4 american
rename e_6_5 arab
rename e_6_6 romanian
rename e_6_7 jew 
rename e_6_8 slovaks
rename e_6_9 roma 
rename e_6_10 austrian


*twoway line chinese german russian american arab romanian jew slovaks roma austrian val 
 
twoway line american jew roma austrian val, leg(pos(6) col(2) row(2)) xsize(1) ysize(1) xlabel(1 `" "1" "Very" "unfavorable" "' 2 3 4 5 6 7 8 9 `" "9" "Very" "favorable" "') ytitle("Share of respondents") lwidth(thin thick thick thin) lpattern(dash dot solid dash_dot longdash) lcolor(black black black black) xtitle("Opinion")

