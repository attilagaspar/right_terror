import delimited ${parlgov}/view_party.csv, clear
keep if inlist(country_name, "Hungary","Slovakia","Greece","Austria","Romania","Bulgaria","France","Italy", "Poland")

preserve
	import delimited ${parlgov}/view_election.csv, clear
	tempfile elect
	save `elect'
restore 
merge 1:m party_id using `elect', gen(merge_elect)
keep if merge_elect==3

* generate election date from string, keep only data starting from 1994
gen ed = date(election_date, "YMD")
format ed %td
drop if ed<12504
gen year = year(ed)


keep if left_right>=7



drop if vote_share<1

collapse (sum) vote_share (first) country_id , by(country_name year election_type election_date )

collapse (mean) vote_share (first) country_id , by(country_name year)

local oldmember_color = "black%15"
local newmember_color = "black%30"

egen reference_year = max(year) if year<2008, by(country_name)

gen vote_share_ref1 = vote_share if year==reference_year
egen vote_share_ref2 = min(vote_share_ref1), by(country_name)
replace vote_share = vote_share - vote_share_ref2

*collapse (sum) vote_share  (first) country_id, by(country_name year)
*twoway (line vote_share year, by(country_name))
keep if year>=2000
keep if year<2020
twoway (connected vote_share year if country_name == "Hungary", mcolor(black) lcolor(black) lwidth(vthick) msize(huge) ) ///
(connected vote_share year if country_name == "Austria", lcolor(`oldmember_color') mcolor(`oldmember_color') msize(large)  lwidth(thick) ) ///
(connected vote_share year if country_name == "France", lcolor(`oldmember_color') mcolor(`oldmember_color') msize(large) lwidth(thick) ) ///
(connected vote_share year if country_name == "Greece", lcolor(`oldmember_color') mcolor(`oldmember_color') msize(large) lwidth(thick) ) ///
(connected vote_share year if country_name == "Italy", lcolor(`oldmember_color') mcolor(`oldmember_color') msize(large) lwidth(thick) ) ///
(connected vote_share year if country_name == "Bulgaria", lcolor(`newmember_color') mcolor(`newmember_color') lpattern(dash) msize(large) lwidth(thick) ) ///
(connected vote_share year if country_name == "Poland", lcolor(`newmember_color') mcolor(`newmember_color') lpattern(dash) msize(large) lwidth(thick) ) ///
(connected vote_share year if country_name == "Romania", lcolor(`newmember_color') mcolor(`newmember_color') lpattern(dash) msize(large) lwidth(thick) ) ///
(connected vote_share year if country_name == "Slovakia", lcolor(`newmember_color') mcolor(`newmember_color') lpattern(dash) msize(large) lwidth(thick) ), ///
legend(order(1 "Hungary" 2 "Austria"  ///
3 "France" 4 "Greece" 5 "Italy" ///
6 "Bulgaria" 7 "Poland" 8 "Romania" 9 "Slovakia" )) xline(2007.5, lwidth(thick)) ///
ytitle("Vote share gain of far-right parties" "relative to pre-crisis level (pp)") xlabel(2000 2004 2008 2012 2016 2020) xtitle("Election year")
 
graph export ${figuredir}/farright.pdf, replace
 