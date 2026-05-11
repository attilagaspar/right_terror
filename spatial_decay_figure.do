
use ${temp}/analysis_data_set.dta, clear

keep if donor_pool==1  //|treatment>0

*		(lfitci extreme_right_share_valid min_distance_to_realized if min_distance_to_realized<100&year==2009) ///
*		(lfitci extreme_right_share_valid min_distance_to_realized if min_distance_to_realized<100&year==2002), ///

eststo clear
twoway (lfitci extreme_right_share_valid min_distance_to_realized if min_distance_to_realized<100&year==2010, lcolor(black) alcolor(black%30) alwidth(medthick) clwidth(medthick) ) ///
(scatter extreme_right_share_valid min_distance_to_realized if min_distance_to_realized<100&year==2010, msize(small) mcolor(black%50) msymbol(X)) ///
(scatter extreme_right_share_valid min_distance_to_realized if min_distance_to_realized<100&year==2006, msymbol(o) msize(tiny) mcolor(gray%50) ) ///
		(lfitci extreme_right_share_valid min_distance_to_realized if min_distance_to_realized<100&year==2006, lcolor(black) alcolor(black%30) alwidth(medthick) clwidth(medthick)), ///
  text(0.28 -10 "2010", place(e))  text(0.02 -10 "2006", place(e))  ///
		leg(order(3 "2010" 4 "2006" ) row(1)) ytitle("Far right share in valid votes") xtitle("Distance to realized (km)") name(p1, replace)  ylabel(0 "0%" .2 "20%" .4 "40%" .6 "60%" ) 

		preserve
				replace extreme_right_share_valid = extreme_right_share_valid*100
				reg extreme_right_share_valid min_distance_to_realized if min_distance_to_realized<100&year==2010  ,cluster(kist175)  
				eststo
				reg extreme_right_share_valid min_distance_to_realized if min_distance_to_realized<100&year==2006 ,cluster(kist175)  
				eststo
		restore
twoway (lfitci extreme_right_share_valid min_distance_to_planned if min_distance_to_planned<100&year==2010, lcolor(black) alcolor(black%30) alwidth(medthick) clwidth(medthick)) ///
(scatter extreme_right_share_valid min_distance_to_planned if min_distance_to_planned<100&year==2010, msize(small) mcolor(black%50) msymbol(X)) ///
(scatter extreme_right_share_valid min_distance_to_planned if min_distance_to_planned<100&year==2006, msymbol(o) msize(tiny) mcolor(gray%50) ) ///
		(lfitci extreme_right_share_valid min_distance_to_planned if min_distance_to_planned<100&year==2006, lcolor(black) alcolor(black%30) alwidth(medthick) clwidth(medthick)), ///
		leg(off) ytitle(" ")   xtitle("Distance to planned (km)") name(p2, replace) ylabel(0 "0%" .2 "20%" .4 "40%" .6 "60%" ) ///
		  text(0.23 -10 "2010", place(e))  text(0.02 -10 "2006", place(e))  

		preserve
				replace extreme_right_share_valid = extreme_right_share_valid*100
				reg extreme_right_share_valid min_distance_to_planned if min_distance_to_realized<100&year==2010 ,cluster(kist175)  
				eststo 
				reg extreme_right_share_valid min_distance_to_planned if min_distance_to_realized<100&year==2006 ,cluster(kist175)  
				eststo
		restore
grc1leg p1 p2, title(" ") //Far right support as function of distance from realized and planned attacks" "(in valid votes) 
graph export ${figuredir}/spatial_decay_bw.png, replace
graph export ${figuredir}/spatial_decay_bw.pdf, replace

la var min_distance_to_planned "Distance to planned (km)"
la var min_distance_to_realized "Distance to realized (km)"

esttab using ${tabledir}/spatial_figure_table.tex, replace ///
	keep(min_distance_to_realized min_distance_to_planned) ///
	mtitles("2010" "2006" "2010" "2006") ///
mgroups("Extreme right vote share, pp.", pattern(1 0 0 0)) ///	
	 label nonotes star(* 0.10 ** 0.05 *** 0.01) staraux  se(3) b(3)

