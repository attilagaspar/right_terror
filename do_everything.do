/*******************************************************************************

This script generates the processed data files and empirical evidence from  
Simonovits, Gáspár, Békés, Végh (2025): Right-wing terrorism and far-right support: 
Evidence from anti-Roma attacks in Hungary.


The scripts ran on a Stata MP 18.0 under Windows 11 Pro (Build number 26200.7462).

Lenovo	L-Legion-08135
Processor	12th Gen Intel(R) Core(TM) i5-12450H (2.00 GHz)
Memory	32,0 GB 

*******************************************************************************/


/*
	
	setting up the working environment

*/


/*

RAW DATA ---> ANALYSIS DATA

Raw data is not shared as part of the replication repository but is available 
upon request. The scripts that genererate the analysis data set from raw data
are public.

Raw data should be used in this folder structure:
*/
* election raw data dir
global election = "../data/election"

* settlement distances raw data dir
global distances = "../data/distances"

* census roma share raw dir 
global census_roma_share = "../data"

* settlement control raw data dir
global tstar = "../data/tstar"

* far-right portal (kuruc.info) scraped posts
global kuruc = "../data/kuruc"

* social attitudes survey raw data dir
global survey = "../data/survey2009"



* parlgov data location
global parlgov = "../data/parlgov"

* monthly unemployment data location
global unemp = "../data/unemp"


* data generation output dir
global temp = "../replication_input_data"
*cap mkdir ${temp}

* required packages: synth, spmap, maptile, sensemakr
*ssc install synth 
*ssc install spmap 
*ssc install maptile
*ssc install sensemakr

/*

	Scripts for data generation

*/

* Append election panel from raw data files - the generation script is part of the package
* 		but the original raw CSV/Excel files are not. 
* This script produces ../replication_data/election_panel.dta
*do append_elections_from_raw_data_files.do

* generate treatment variable
*do create_treatment_var.do

* generate far-right portal mentions (VERY SLOW)
*do kuruc_generator.do

* generate analysis data file
*do merge_data_sources.do



/*

RESULT REPLICATION STARTS HERE

*/


* set this to where you extract the code folder
*cd "C:\Users\agaspar\Dropbox\research\rightterror\replication_package"


* set up logging
cap log close
log using replication_log.txt , text replace


* analysis input data dir
global temp = "../replication_input_data"
* map data location
global map = "${temp}/map"


* data generated through the analysis process 
global derived = "../replication_derived_data"
cap mkdir ${temp}/synth 

* outputs: tables folder
global tabledir = "../replication_evidence"
* outputs: figures folder
global figuredir = "../replication_evidence"

cap mkdir ${tabledir}
cap mkdir ${figuredir}


* Install ksh4_bpker geography for maptile
local geopath "`c(sysdir_personal)'maptile_geographies/ksh4_bpker/"
capture mkdir "`c(sysdir_personal)'maptile_geographies"
capture mkdir "`geopath'"

copy "${map}/ksh4_bpker_database.dta"  "`geopath'ksh4_bpker_database.dta", replace
copy "${map}/ksh4_bpker_coords.dta"    "`geopath'ksh4_bpker_coords.dta", replace
copy "${map}/ksh4_bpker_maptile.ado"           "`geopath'ksh4_bpker_maptile.ado", replace


* generate synthetic contrsols
do synth_control_generation.do
* put together synthetic units for regressions
do synth_append.do 
		//also generates 
		//Figure OA5 (synth control effect sizes in 2010
		//Figure OA6 (synth control event study)
* generate donor pool unit list for descriptive table 
do synthetic_units_table.do // also generates Table OA2 


* create synthetic control groups



/*

	run analysis

*/


/*
Tables
*/

do balance.do
*generates
* Table OA3 

do exhibits.do
*generates
* Table 1: Main regression results
* Table OA4: DiD with control variable coefficients
* Table OA5: DiD pre-trends

do exhibits_alternative_outcomes.do
*generates
* Tables OA8-OA10 - Table 1 with alternative outcomes (turnout, mainstream party vote share)

do exhibits_demography.do 
*generates Table OA11 - additional controls

* calculate Cinelli & Hazlett (2020) robustness values (Appendix G.2) 
* IMPORTANT! These do not create additional tables or figures; 
* Instead, it outputs a couple of numbers which then appear in the text.
do regressions_sensemakr.do

/*Figures*/

* Figure 1: Event study
do event_study.do 
* generates
* Figure 1 - event study 
* Table OA6 - corresponding regression 


* Figure 2: Far right support and distance from attacks 
do spatial_decay_figure.do
* generates
* Figure 2 - spatial decay
* Table OA7 - corresponding regression 


do election_survey_evidence.do 
* generates
* Figure OA1 - favorability of different groups among Hungarians
* Figure OA2 - statements about the roma

do map_generation.do
* generates 
* Figure OA4 - map of attacked, control, donor pool 

do partysupport_comparison_figure.do
* generates
* Figure OA3 - far right support in selected countries 


/*
Appendix tables
*/
* OA1: Attack Locations  - hard-coded into text
* OA2: Synthetic control weights - Part1 - synthetic_control_units_1.tex,  - generated by synthetic_units_table.do
* OA3: Synthetic control weights - Part2 - Synthetic_control_units_2.tex - generated by synthetic_units_table.do 
* OA4: Balance table - generated by balance.do
* OA5: Table 1 with control variable coefficients
* OA6: Pre-trend regression
* OA7: Regression corresponding to Figure 1 (generated by event_study.do)
* OA8: Regression corresponding to Figure 2 (generated by spatial_decay_figure.do)
* OA9: Alternative outcome: turnout (generated by exhibits_alternative_outcomes.do)
* OA10: Alternative outcome: left vote share (generated by exhibits_alternative_outcomes.do)
* OA11: Alternative outcome: mainstream right vote share (generated by exhibits_alternative_outcomes.do)
* OA12: Additional demographic controls (generated by exhibits_demography.do)


/*
Appendix figures
*/
* OA1: Favorability of ethnic groups (generated by election_survey_evidence.do)
* OA2: Statements about the Roma (generated by election_survey_evidence.do)
* OA3: Far-righ support in selected countries (generated by partysupport_comparison_figure.do)
* OA4: Map - donor pool, attacked, planned (generated by map_generation.do)
* OA5: Synthetic control effect sizes - synth_bar2010.pdf  (generated by synth_append.do)
* OA6: Synthetic control individual treatment effects (generated by synth_append.do)

