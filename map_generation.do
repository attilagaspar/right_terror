* requirements: spmap, maptile

use "${temp}/analysis_data_set.dta", clear

keep if year==2010
gen ksh4_bpker=tazon
drop if tazon==.

gen dpt = treatment if donor_pool==1|treatment>0
 *~/ado/personal/maptile_geographies/ksh4_bpker_coords.dta
 maptile dpt, geo(ksh4_bpker)  spopt( line( data(${map}/ksh4_bpker_coords.dta) color(white)))  ///
 cutvalues(0 1 2) ndfcolor(white) fcolor(yellow blue red) twopt(legend(order(4 "Attacked" 3 "Planned" 2 "Donor pool" 1 "Not in donor pool") )  xsize(2) ysize(1))
graph export ${figuredir}/map_dp.pdf, replace
graph export ${figuredir}/figure_oa4.pdf, replace


