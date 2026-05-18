
/*------------------------------------------------------------------------------
	Election data is available at 
	https://static.valasztas.hu/letoltesek/valasztasi_eredmenyek_1990-2019.tar
	
	This do file imports election data to Stata. The publication format changes 
	substantially from year to year - this script handles that.
	
	The original draft contained only parlimentary elections 2002-2018, 
	extensions with earlier/later years and EP elections come after that.
	
	
	
------------------------------------------------------------------------------*/

/*

	Load raw delimited files and save them in Stata format

*/

clear
*insheet using ${election}/2002/lis_szkf.txt , delim("|") encode("utf-8")

import delimited using ${election}/2002/lis_szkf.txt , delim("|") 

ren v1 maz
ren v2 taz
ren v3 sorsz
ren v4 mnev
ren v5 telep
ren v6 oevk
ren v7 a
ren v8 b
ren v9 c
ren v10 d
ren v11 e
ren v12 f
ren v13 g
ren v14 h
ren v15 i
ren v16 j
ren v17 megs

lab var maz "Megye azonosító"
lab var taz "Település azonosító"
lab var sorsz "Szavazókör sorszám megyén, településen belül"
lab var mnev "Megyenév"
lab var telep "Településnév"
lab var oevk "OEVK sorszáma megyén belül"
lab var a "Előző nap 16 óráig a névjegyzékbe felvett választópolgárok száma"
lab var b "A szavazás napján a névjegyzékbe felvett választópolgárok száma"
lab var c "A szavazás napján a névjegyzékből törölt választópolgárok száma"
lab var d "Vál.polgárok száma a névjegyzékben a választás befejezésekor"
lab var e "Visszautasított választópolgárok száma"
lab var f "Szavazóként megjelentek száma"
lab var g "Urnában lévő szavazólapok száma"
lab var h "Eltérés a szavazók számától (G-F)"
lab var i "Érvénytelen szavazatok száma"
lab var j "Érvényes szavazatok száma"
lab var megs "Megsemmisítés ténye, vagy üres"


save ${temp}/2002_szkf, replace



clear
import delimited using ${election}/2002/lis_szkt.txt , delim("|") 

ren v1 maz 
ren v2 taz
ren v3 sorsz
ren v4 sor 
ren v5 lnev
ren v6 szav

lab var maz "Megye azonosító"
lab var taz "Település azonosító"
lab var sorsz "Szavazókör sorszám megyén, településen belül"
lab var sor "Lista sorszáma"
lab var lnev "Lista neve"
lab var szav "Kapott érvényes szavazat"


save ${temp}/2002_szkt, replace



clear
*insheet using ${election}/2006/lis_szkf.txt , delim("|")
import delimited using ${election}/2006/lis_szkf.txt , delim("|") 

ren v1 maz
ren v2 taz
ren v3 sorsz
ren v4 mnev
ren v5 telep
ren v6 oevk
ren v7 a
ren v8 b
ren v9 c
ren v10 d
ren v11 e
ren v12 f
ren v13 g
ren v14 h
ren v15 i
ren v16 j
ren v17 k
ren v18 l
ren v19 m
ren v20 kulkepv
ren v21 megs
ren v22 keszult

lab var maz "Megye azonosító
lab var taz "Település azonosító
lab var sorsz "Szavazókör sorszáma
lab var mnev "Megye neve
lab var telep "Település neve
lab var oevk "OEVK
lab var a"Előző nap 16 óráig a névjegyzékbe felvett választópolgárok száma
lab var b"A szavazás napján a névjegyzékbe felvett választópolgárok száma
lab var c"A választópolgárok száma a névjegyzékben a  választás befejezésekor
lab var d"A külképviseleti névjegyzékben szereplők száma*
lab var e"A névjegyzékben szereplő választópolgárok száma összesen**
lab var f"Visszautasított választópolgárok száma
lab var g"A szavazókörben szavazóként megjelentek száma**
lab var h"A szavazókörbe beérkezett külképviseleti belső borítékok száma*
lab var i"Szavazóként megjelentek száma összesen
lab var j"Urnában lévő szavazólapok száma
lab var k"Eltérés a szavazóként megjelentek számától (többlet:+/hiány)
lab var l"Érvénytelen szavazatok száma
lab var m"Érvényes szavazatok száma
lab var kulkepv "Szavazókör típusa"
lab var megs"Megsemmisített jegyzőkönyv
lab var keszult"Készült


save ${temp}/2006_szkf, replace


clear
*insheet using ${election}/2006/lis_szkt.txt , delim("|")
import delimited using ${election}/2006/lis_szkt.txt , delim("|")

ren v1 maz 
ren v2 taz
ren v3 sorsz
ren v4 sor 
ren v5 lnev
ren v6 szav
ren v7 tamszam
ren v8 tami

lab var maz "Megye azonosító
lab var taz "Település azonosító
lab var sorsz "Szavazókör sorszáma
lab var sor"Lista sorszáma
lab var lnev "Lista neve
lab var szav"Érvényes szavazat
lab var tamszam"Támogató szervezetek száma 
lab var tami"Támogató szervezetek felsorolása (TAMSZAM-ban lévő számú )

save ${temp}/2006_szkt, replace


clear
*insheet using ${election}/2010/lis_szkf.txt , delim("|")
import delimited using ${election}/2010/lis_szkf.txt , delim("|") 

ren v1 maz
ren v2 taz
ren v3 sorsz
ren v4 mnev
ren v5 telep
ren v6 oevk
ren v7 a
ren v8 b
ren v9 c
ren v10 d
ren v11 e
ren v12 g
ren v13 h
ren v14 i
ren v15 j
ren v16 k
ren v17 l
ren v18 m
ren v19 kulkepv
ren v20 megs
ren v21 keszult

lab var maz "Megye azonosító
lab var taz "Település azonosító
lab var sorsz "Szavazókör sorszáma
lab var mnev "Megye neve
lab var telep "Település neve
lab var oevk "OEVK
lab var a"A névjegyzék zárásakor a névjegyzékben lévő választópolgárok száma
lab var b"A szavazás napján a névjegyzékbe igazolás alapján felvett választópolgárok száma
lab var c"A választópolgárok száma a névjegyzékben a szavazás befejezésekor
lab var d"A külképviseleti névjegyzékben szereplők száma
lab var e"A névjegyzékben szereplő választópolgárok száma összesen
lab var g"A szavazókörben szavazóként megjelent választópolgárok száma
lab var h"A szavazásról szóló nyilatkozatok száma
lab var i"Szavazóként megjelent választópolgárok száma
lab var j"Az urnában és az érvényes szavazási iratokban lévő szavazólapok száma
lab var k"Eltérés a szavazóként megjelentek számától (többlet: + /hiányzó: -)
lab var l"Érvénytelen szavazatok száma
lab var m"Érvényes szavazatok száma
lab var kulkepv"Szavazókör típusa
lab var megs"Megsemmisített jegyzőkönyv
lab var keszult"Készült

save ${temp}/2010_szkf, replace



clear
import delimited using ${election}/2010/lis_szkt.txt , delim("|")

ren v1 maz 
ren v2 taz
ren v3 sorsz
ren v4 sor 
ren v5 lnev
ren v6 szav
ren v7 tamszam
ren v8 tami

lab var maz "Megye azonosító
lab var taz "Település azonosító
lab var sorsz "Szavazókör sorszáma
lab var sor"Lista sorszáma
lab var lnev"Lista neve
lab var szav"Érvényes szavazat
lab var tamszam"Támogató szervezetek száma
lab var tami"Támogató szervezetek felsorolása

save ${temp}/2010_szkt, replace



*** 2014

* lista
clear
import excel using ${election}/2014/Listás-szavazás-jkv.xlsx , first
save ${temp}/2014_lista, replace




*** 2018 lista

clear
import excel using ${election}/2018/Listás_szavazás_szkjkv.xlsx, firstrow
save ${temp}/2018_lista, replace


use ${temp}/2002_szkf, clear

ren telep telnev_bpker
ren d eligible
ren i invalid
ren j valid

gen elteres_positive = h
replace elteres_positive = 0 if elteres_positive < 0
gen elteres_negative = h
replace elteres_negative = 0 if elteres_negative > 0


tempfile 2002
save `2002'


use ${temp}/2002_szkt, clear

merge m:1 maz taz sorsz using `2002'

ren lnev lista

keep telnev_bpker sorsz oevk eligible valid invalid lista szav elteres*

gen ty = 2002
save ${temp}/election_2002, replace


use ${temp}/2006_szkf, clear

ren telep telnev_bpker
ren c eligible
ren l invalid
ren m valid

gen elteres_positive = k
replace elteres_positive = 0 if elteres_positive < 0
gen elteres_negative = k
replace elteres_negative = 0 if elteres_negative > 0


tempfile 2006
save `2006'


use ${temp}/2006_szkt, clear

merge m:1 maz taz sorsz using `2006'

ren lnev lista

keep telnev_bpker sorsz oevk eligible valid invalid lista szav elteres*

gen ty = 2006

save ${temp}/election_2006, replace


use ${temp}/2010_szkf, clear

ren telep telnev_bpker
ren c eligible
ren l invalid
ren m valid

gen elteres_positive = k
replace elteres_positive = 0 if elteres_positive < 0
gen elteres_negative = k
replace elteres_negative = 0 if elteres_negative > 0


tempfile 2010
save `2010'


use ${temp}/2010_szkt, clear

merge m:1 maz taz sorsz using `2010'

ren lnev lista

keep telnev_bpker sorsz oevk eligible valid invalid lista szav elteres*

gen ty = 2010
save ${temp}/election_2010, replace



use ${temp}/2014_lista, clear

foreach X of varlist LISTÁS MEGYEKÓD MEGYE OEVK SZÉKHELY SZH_KER TELEPÜLÉS_SORSZÁM TELEPÜLÉS SZAVAZÓKÖR  {
	replace `X' = `X'[_n-1] if `X' == ""
}
*

foreach X of varlist VÁLASZTÓPOLGÁR MEGJELENTEK URNÁBAN_LEVŐ ELTÉRÉS ÉRVÉNYTELEN ÉRVÉNYES {
	replace `X' = `X'[_n-1] if `X' == .
}
*

drop if strpos(SZAVAZÓKÖR_AZON, "F")

ren ÉRVÉNYTELEN invalid
ren ÉRVÉNYES valid
ren TELEPÜLÉS telnev_bpker
ren LISTA lista
ren VÁLASZTÓPOLGÁR eligible
ren SZAVAZAT szav
ren SZAVAZÓKÖR sorsz
ren OEVK oevk 

replace ELTÉRÉS = URNÁBAN_LEVŐ-MEGJELENTEK /* everything is zero */ 

gen elteres_positive = ELTÉRÉS
replace elteres_positive = 0 if elteres_positive < 0
gen elteres_negative = ELTÉRÉS
replace elteres_negative = 0 if elteres_negative > 0



destring oevk, replace
destring sorsz, replace

keep telnev_bpker sorsz invalid valid eligible szav lista oevk elteres*

gen ty = 2014
save ${temp}/election_2014, replace



use ${temp}/2018_lista, clear

foreach X of varlist LISTÁS MEGYEKÓD MEGYE OEVK SZÉKHELY SZH_KER TELEPÜLÉS_SORSZÁM TELEPÜLÉS SZAVAZÓKÖR  {
	replace `X' = `X'[_n-1] if `X' == ""
}
*

foreach X of varlist VÁLASZTÓPOLGÁR MEGJELENTEK URNÁBAN_LEVŐ ELTÉRÉS ÉRVÉNYTELEN ÉRVÉNYES {
	replace `X' = `X'[_n-1] if `X' == .
}
*

drop if strpos(SZAVAZÓKÖR_AZON, "F")

ren ÉRVÉNYTELEN invalid
ren ÉRVÉNYES valid
ren TELEPÜLÉS telnev_bpker
ren LISTA lista
ren VÁLASZTÓPOLGÁR eligible
ren SZAVAZAT szav
ren SZAVAZÓKÖR sorsz
ren OEVK oevk 




replace ELTÉRÉS  = URNÁBAN_LEVŐ-MEGJELENTEK /* this are lots of cases when this updates the difference. WHY? */

gen elteres_positive = ELTÉRÉS
replace elteres_positive = 0 if elteres_positive < 0
gen elteres_negative = ELTÉRÉS
replace elteres_negative = 0 if elteres_negative > 0
 



destring oevk, replace
destring sorsz, replace

keep telnev_bpker sorsz invalid valid eligible szav lista oevk elteres*

gen ty = 2018
save ${temp}/election_2018, replace

* append data 2002 to 2018

clear
forval i=2002(4)2018 {
	append using ${temp}/election_`i'
}



* check whether the id-s are good?
gisid telnev_bpker sorsz ty lista 



gen L = ""

replace L = "fidesz" if strpos(lista, "FIDESZ")
replace L = "fidesz" if strpos(lista, "Fidesz")
replace L = "fidesz" if strpos(lista, "MDF")
replace L = "fidesz" if strpos(lista, "MAGYAR DEMOKRATA FORUM")
replace L = "fidesz" if strpos(lista, "MAGYAR DEMOKRATA FÓRUM")


replace L = "szoc" if strpos(lista, "MAGYAR SZOCIALISTA PÁRT")
replace L = "szoc" if strpos(lista, "MAGYAR  SZOCIALISTA PÁRT")
replace L = "szoc" if strpos(lista, "MSZP")
replace L = "szoc" if strpos(lista, "Magyar Szocialista Párt")
replace L = "szoc" if strpos(lista, "ÖSSZEFOGÁS")
replace L = "szoc" if strpos(lista, "DEMOKRATIKUS KOALÍCIÓ")
replace L = "szoc" if strpos(lista, "EGYÜTT 2014")
replace L = "szoc" if strpos(lista, "EGYÜTT - A KORSZAKVÁLTÓK PÁRTJA")
replace L = "szoc" if strpos(lista, "SZABAD DEMOKRATÁK SZÖVETSÉGE")
replace L = "szoc" if strpos(lista, "Szabad Demokraták Szövetsége")

replace L = "lmp" if strpos(lista, "LEHET MÁS A POLITIKA")
replace L = "lmp" if strpos(lista, "LMP")
replace L = "lmp" if strpos(lista, "Lehet Más a Politika")

replace L = "jobbik" if strpos(lista, "MAGYAR IGAZSÁG ÉS ÉLET PÁRJA")
replace L = "jobbik" if strpos(lista, "MAGYAR IGAZSÁG ÉS ÉLET PÁRTJA")
replace L = "jobbik" if strpos(lista, "JOBBIK MAGYARORSZÁGÉRT MOZGALOM")
replace L = "jobbik" if strpos(lista, "Jobbik")
replace L = "jobbik" if strpos(lista, "JOBBIK")
replace L = "jobbik" if strpos(lista, "MIÉP")

replace L = "resztli" if L == ""

foreach v of var * {
        local l`v' : variable label `v'
            if `"`l`v''"' == "" {
            local l`v' "`v'"
        }
}

collapse (sum) szav  (mean) eligible valid invalid oevk elteres*, by(telnev_bpker sorsz ty  L)

collapse (sum) szav eligible valid invalid elteres* (mean)  oevk, by(telnev_bpker ty  L)

ren szav szav_
reshape wide szav, i(telnev_bpker ty ) j(L) string

foreach v of var * {
        label var `v' "`l`v''"
}

local partok "fidesz jobbik lmp szoc resztli"
foreach X of local partok {
	gen sh_`X' = szav_`X' / valid
}

gen sh_turnout = (valid + invalid) / eligible
gen sh_invalid = invalid / (valid + invalid)

lab var szav_fidesz "Szavazatok száma: FIDESZ
lab var szav_szoc "Szavazatok száma: baloldal
lab var szav_lmp "Szavazatok száma: LMP
lab var szav_jobbik "Szavazatok száma: JOBBIK
lab var szav_resztli "Szavazatok száma: resztli

lab var sh_szoc "Szavazat arány: baloldal
lab var sh_lmp "Szavazat arány: LMP
lab var sh_jobbik "Szavazat arány: JOBBIK
lab var sh_fidesz "Szavazat arány: FIDESZ
lab var sh_resztli "Szavazat arány: resztli


lab var sh_turnout "Részvétel"
lab var sh_invalid "Érvénytelen szavazatok aránya"


tempfile data_02_18
save `data_02_18'




/*

Additional years start from here

*/



/*

1998

*/
import delimited "${election}/1998/lis_szkt.txt", clear 
rename v6 lista
rename v7 szav_

replace lista = strtrim(lista)
replace lista="fidesz" if lista=="FIDESZ"
replace lista="fidesz" if lista=="KERESZTÉNYDEMOKRATA NÉPPÁRT"
replace lista="fidesz" if lista=="MDF"
replace lista="fidesz" if lista=="MDNP-NÉPPÁRT"

replace lista="szoc" if lista=="SZDSZ"
replace lista="szoc" if lista=="MAGYAR SZOCIALISTA PÁRT"

replace lista="jobbik" if lista=="MAGYAR IGAZSÁG ÉS ÉLET PÁRTJA"
*replace lista="jobbik" if lista=="FÜGGETLEN KISGAZDAPÁRT"

replace lista="resztli" if lista!="fidesz"&lista!="szoc"&lista!="jobbik"

*1. forudlo
keep if v1==1
drop v1

collapse (sum) szav_, by( v2 v3  lista)

rename v2 maz
rename v3 taz

egen i = group(maz taz)

reshape wide szav_, i(i) j(lista) string

drop i

tempfile result
save `result'

import delimited "${election}/1998/szkf.txt", clear 
drop if v1=="Egyéni"

keep if v2==1 // 1. ford
drop v1 v2

rename v3 maz
rename v4 taz
collapse (sum) szav_eligible=v12 szav_valid=v17 (first) telnev_bpker=v7, by(maz taz)

merge 1:1 maz taz using `result', gen(merge_result_to_header1998)

gen election_type = "OGY"
gen ty = 1998

tempfile r98
save  `r98'

/*

2009

*/

import delimited "${election}/2009_EP/cdtelept.txt", clear


replace v6=strtrim(v6)
replace v4=strtrim(v4)

replace v6="fidesz" if v6=="FIDESZ-KDNP"
replace v6="szoc" if v6=="SZDSZ"
replace v6="resztli" if v6=="MCF ROMA Ö."
replace v6="resztli" if v6=="MUNKÁSPÁRT"
replace v6="szoc" if v6=="MSZP"
replace v6="jobbik" if v6=="JOBBIK"
replace v6="lmp" if v6=="LMP-HP"
replace v6="resztli" if v6=="MDF"

rename v6 lista
rename v7 szav_
rename v4 telnev_bpker
collapse (sum) szav, by(telnev_bpker lista)

egen i = group(telnev_bpker)
reshape wide szav, i(i) j(lista) string

egen szav_valid = rowtotal(szav*)

tempfile result
save  `result'

import delimited "${election}/2009_EP/cdtelepf.txt", clear
replace v4=strtrim(v4)
rename v4 telnev_bpker


merge 1:1 telnev_bpker using `result', gen(merge_result_to_header2009)

rename v5 szav_eligible
keep telnev_bpker szav* 

gen election_type = "EP"
gen ty = 2009

tempfile r09
save  `r09'

/*

2004

*/

import delimited "${election}/2004_EP/cdtelept.txt", clear


replace v6=strtrim(v6)
replace v4=strtrim(v4)

replace v6="fidesz" if v6=="FIDESZ"
replace v6="szoc" if v6=="SZDSZ"
replace v6="resztli" if v6=="SZDP"
replace v6="resztli" if v6=="MUNKÁSPÁRT"
replace v6="szoc" if v6=="MSZP"
replace v6="jobbik" if v6=="MNSZ"
replace v6="jobbik" if v6=="MIÉP"
replace v6="lmp" if v6=="LMP-HP"
replace v6="resztli" if v6=="MDF"


rename v6 lista
rename v7 szav_
rename v4 telnev_bpker
collapse (sum) szav, by(telnev_bpker lista)


egen i = group(telnev_bpker)
reshape wide szav, i(i) j(lista) string

egen szav_valid = rowtotal(szav*)

tempfile result
save  `result'



import delimited "${election}/2004_EP/cdtelepf.txt", clear
replace v4=strtrim(v4)
rename v4 telnev_bpker


merge 1:1 telnev_bpker using `result', gen(merge_result_to_header2004)

rename v5 szav_eligible
keep telnev_bpker szav*  

gen election_type = "EP"
gen ty = 2004


tempfile r04
save  `r04'
/*
2014
*/
import delimited "${election}/2014_EP/2014_ep_listas_szavazas_jkv.csv", clear

keep if lista!=""

replace lista=strtrim(lista)

replace lista="fidesz" if lista=="FIDESZ-KDNP"
replace lista="szoc" if lista=="DEMOKRATIKUS KOALÍCIÓ"
replace lista="szoc" if lista=="EGYÜTT-PM"
replace lista="szoc" if lista=="MSZP"
replace lista="lmp" if lista=="LMP"
replace lista="resztli" if lista=="A HAZA NEM ELADÓ"
replace lista="resztli" if lista=="SMS"
replace lista="jobbik" if lista=="JOBBIK"

collapse (sum) szav_ = szavazat, by(jkv_azon lista) 
reshape wide szav_, i(jkv_azon) j(lista) string

tempfile result
save `result'

import delimited "${election}/2014_EP/2014_ep_listas_szavazas_jkv.csv", clear

keep if lista==""

merge 1:1 jkv_azon using `result', gen(merge_result_to_header2014) update replace

rename település telnev_bpker

collapse (sum) szav_* szav_eligible=választópolgár szav_valid=érvényes, by(telnev_bpker)

gen election_type = "EP"
gen ty = 2014


append using  `r09'
append using  `r04'
append using  `r98'



drop maz taz merge*
order telnev_bpker ty

/*

	Put together with other election file
	
*/

preserve

	*use ${temp}/election_2002_2018_01_lista, clear
	use `data_02_18', clear
	rename eligible szav_eligible 
	rename valid szav_valid
	keep szav* telnev_bpker ty 
	gen election_type="OGY"

	tempfile ogy 
	save `ogy'	

restore

append using `ogy'


/*

	Clean inconsistent settlement names

*/



gen t = lower(telnev_bpker)
replace t = strtrim(t)

replace t = subinstr(t,"Á","á",.)
replace t = subinstr(t,"É","é",.)
replace t = subinstr(t,"Ű","ű",.)
replace t = subinstr(t,"Ú","ú",.)
replace t = subinstr(t,"Ö","ö",.)
replace t = subinstr(t,"Ü","ü",.)
replace t = subinstr(t,"Ó","ó",.)
replace t = subinstr(t,"Ő","ő",.)
replace t = subinstr(t,"Õ","ő",.)
replace t = subinstr(t,"Í","í",.)
replace t = subinstr(t,"õ","ő",.)
replace t = subinstr(t,"Û","ű",.)
replace t = subinstr(t,"û","ű",.)
drop if t==""
drop if strpos(t,"székhely")!=0

replace t="baranyahídvég" if t=="baranyahidvég"
replace t="búcsúszentlászló" if t=="bucsuszentlászló"
replace t="fűzvölgy" if t=="füzvölgy"
replace t="galgahévíz" if t=="galgahéviz"
replace t="hosszúvíz" if t=="hosszúviz"
replace t="hévízgyörk" if t=="hévizgyörk"
replace t="kelevíz" if t=="keleviz"
replace t="vízvár" if t=="vizvár"

replace t="kővágótöttös" if t=="kővágótőttős"
replace t="lőkösháza" if t=="lökösháza"
replace t="megyehíd" if t=="megyehid"
replace t="rábahídvég" if t=="rábahidvég"
replace t="sajóhídvég" if t=="sajóhidvég"
replace t="szabadhídvég" if t=="szabadhidvég"
replace t="óhíd" if t=="óhid"

replace t = subinstr(t,"ker.","ker",1) if strpos(t, "budapest")!=0

replace telnev_bpker=strtrim(telnev_bpker)
gen t2=substr(telnev_bpker,1,1)+substr(t,2,.) if substr(t,1,2)!="á" & ///
		substr(t,1,2)!="é" & ///
		substr(t,1,2)!="ó" & ///
		substr(t,1,2)!="ö" & ///
		substr(t,1,2)!="ú" & ///
		substr(t,1,2)!="ü" & ///
		substr(t,1,2)!="ő"
		
replace t2=substr(telnev_bpker,1,2)+substr(t,3,.) if t2==""
replace t2 = subinstr(t2,"Õ","Ő",.)
replace t2 = subinstr(t2,"Û","Ű",.)

drop t telnev_bpker
rename t2 telnev_bpker

replace telnev_bpker = subinstr(telnev_bpker, ".ker", ". kerület",1)
replace telnev_bpker=subinstr(telnev_bpker,"                 "," ",1)



// Create a loop for each district number and replace with lowercase Roman numerals
forvalues i = 1/23 {
    // Convert the district number to a two-digit format
    local num: display %02.0f `i'
    
    // Define the lowercase Roman numeral equivalents
    local roman i ii iii iv v vi vii viii ix x xi xii xiii xiv xv xvi xvii xviii xix xx xxi xxii xxiii
    
    // Replace the string with the Roman numeral and "kerület"
    replace telnev_bpker = subinstr(telnev_bpker, "Budapest " + "`num'", "Budapest " + word("`roman'", `i') + ". kerület", .)
}

* Create a new variable election_date for every observation
gen election_date = .

* For national elections (OGY)
replace election_date = tm(1998m5) if ty == 1998 & election_type == "OGY"
replace election_date = tm(2002m4) if ty == 2002 & election_type == "OGY"
replace election_date = tm(2006m4) if ty == 2006 & election_type == "OGY"
replace election_date = tm(2010m4) if ty == 2010 & election_type == "OGY"
replace election_date = tm(2014m4) if ty == 2014 & election_type == "OGY"
replace election_date = tm(2018m4) if ty == 2018 & election_type == "OGY"

* For European Parliament elections (EP)
replace election_date = tm(2004m6) if ty == 2004 & election_type == "EP"
replace election_date = tm(2009m6) if ty == 2009 & election_type == "EP"
replace election_date = tm(2014m5) if ty == 2014 & election_type == "EP"
replace election_date = tm(2019m5) if ty == 2019 & election_type == "EP"

* Format election_date
format election_date %tm

rename ty year

foreach s in "2002" "2006" "2010" "2014" "2018" {
	*old syntax
	cap rm "${temp}/`s'_szkf.dta"
	cap rm "${temp}/`s'_szkt.dta"
	*new syntax
	cap rm "${temp}/`s'_lista.dta"
	cap rm "${temp}/election_`s'.dta"
}

save ${temp}/election_panel.dta, replace