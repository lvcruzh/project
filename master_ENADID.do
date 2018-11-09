*Procesamiento de datos ENADID

*Responsables:
*Luis Valentin Cruz lvcruz@colmex.mx
*Lorena Ochoa alochoa@colmex.mx

clear all
set rmsg on, permanently
set more off

global orig="E:\econometria_aplicada\project\data\orig\dta\ENADID"
global modif="E:\econometria_aplicada\project\data\modif\ENADID"

*Edad de la primera relación sexual 2006, 2009, 2014
*****************************************************************************
*2006
quietly use "$orig\2006\tbl_mujer_final.dta"
*Variables de interes
keep folioviv p10d01 fac_muje
*Variable año
gen year=2006
*Filtramos los valores validos
drop if p10d01==. | p10d01==88 |p10d01==99
quietly save "$modif\temp1.dta", replace

*Agregamos en numero de entidad
quietly use "$orig\2006\tbl_hogares_final.dta"
keep folioviv ent
duplicates drop folioviv, force
merge 1:n folioviv using "$modif\temp1.dta"
keep if _merge==3
drop _merge
destring p10d01, replace
rename fac_muje fac_ex
rename p10d01 edad_rs
rename folioviv id
quietly save "$modif\temp2006.dta", replace

erase "$modif\temp1.dta"

*2009 
quietly use "$orig\2009\tr_cmu.dta"
keep llave p7_34 fac_mujer
gen year=2009
destring p7_34, replace
drop if p7_34==. | p7_34==88 |p7_34==99
quietly save "$modif\temp1.dta", replace

quietly use "$orig\2009\tr_sdem.dta"
keep llave ent
duplicates drop llave, force
merge 1:n llave using "$modif\temp1.dta"
keep if _merge==3
drop _merge
rename fac_mujer fac_ex
rename p7_34 edad_rs
rename llave id
quietly save "$modif\temp2009.dta", replace

erase "$modif\temp1.dta"

*2014
quietly use "$orig\2014\tmmujer1.dta"
keep control ent p8_36 fac_per
gen year=2014
destring p8_36, replace
drop if p8_36==. | p8_36==88 |p8_36==99
rename fac_per fac_ex
rename p8_36 edad_rs
rename control id
quietly save "$modif\temp2014.dta", replace

quietly use "$modif\temp2006.dta"
append using "$modif\temp2009.dta"
append using "$modif\temp2014.dta"
quietly save "$modif\1ra_rs", replace

erase "$modif\temp2006.dta"
erase "$modif\temp2009.dta"
erase "$modif\temp2014.dta"

*Obtener la edad media, mediana, moda de la primera relación sexual
quietly use "$modif\1ra_rs"
*Mediana/Moda no admiten pesos
egen median_ent = median (edad_rs), by(year ent) 
egen median_nac = median (edad_rs), by(year) 
egen mode_ent = mode (edad_rs), by(year ent) 
egen mode_nac = mode (edad_rs), by(year)
*Media
egen mean_ent1 = mean(edad_rs) , by(year ent) 
egen mean_nac1 = mean (edad_rs), by(year)
gen mean_ent = round(mean_ent1)
gen mean_nac = round(mean_nac1)
drop mean_ent1 mean_nac1
sort year ent
quietly save "$modif\1ra_rs", replace

*¿Qué metodo anticonceptivo utilizó la primera relacién sexual 2009, 2014?
*******************************************************************************
clear all

*Operación masculina o vasectomía
*Dispositivo, DIU o aparato
*Hormonales (pastillas, inyecciones, implante subdérmico, parche, pastilla de emergencia)
*Condon
*Otro(óvulos, calendario, coito interrumpido)
*No usar nada

*2009
quietly use "$orig\2009\tr_cmu.dta"
gen antic = .
forval i=1/6{
destring p7_35_`i', replace
replace antic=p7_35_`i' if p7_35_`i'!=.
}
keep llave antic fac_mujer
gen year=2009
drop if antic==. 
gen tot=1
collapse(sum) tot [w=fac_mujer], by(year antic)
quietly save "$modif\temp1.dta", replace

*2014
quietly use "$orig\2014\tmmujer1.dta"
gen antic=.
destring p8_37_*, replace

replace antic=2 if p8_37_06==1
replace antic=3 if p8_37_02==1 | p8_37_03==1 | p8_37_04==1 | p8_37_05==1 | p8_37_12==1
replace antic=4 if p8_37_07==1 | p8_37_08==1
replace antic=5 if p8_37_09==1 | p8_37_10==1 | p8_37_11==1 | p8_37_13==1
replace antic=6 if p8_37_01==1

keep if antic!=.
keep control ent antic fac_per
gen year=2014
gen tot=1

collapse(sum) tot [w=fac_per], by(year antic)
quietly save "$modif\temp2.dta", replace

*Unir ambos años
quietly use "$modif\temp1.dta"
append using "$modif\temp2.dta"
quietly save "$modif\temp3.dta", replace

*Obtener el porcentaje de uso de cada método
quietly use "$modif\temp3.dta"
collapse (sum) tot, by (year)
rename tot totales
quietly save "$modif\temp4.dta", replace

quietly use "$modif\temp4.dta"
merge 1:m year using "$modif\temp3.dta"
drop _merge
sort year antic
gen porcentaje=(tot/totales)*100
quietly save "$modif\antic1ra_rs.dta", replace

erase "$modif\temp1.dta"
erase "$modif\temp2.dta"
erase "$modif\temp3.dta"
erase "$modif\temp4.dta"

*¿Por qué no usó algún método anticonceptivo en la primera relación sexual?
*******************************************************************************

*1 Quería embarazarse
*2 No conocía los métodos, no sabía como usarlos o cómo obtenerlos
*3 Se opuso su pareja
*4 No creyó que podría quedar embarazada
*5 No estaba de acuerdo con el uso de anticonceptivos
*6 No planeaba tener relaciones sexuales
*7 Le dio pena
*8 Otra razón

*2014
quietly use "$orig\2014\tmmujer1.dta"
destring p8_38, replace
drop if p8_38==.
keep fac_per p8_38
gen year=2014
rename p8_38 razon
gen tot=1
drop if razon==9
collapse(sum) tot [w=fac_per], by(year razon)
gen totales = tot[1]+tot[2]+tot[3]+tot[4]+tot[5]+tot[6]+tot[7]+tot[8]
gen porcentaje = (tot/totales)*100
quietly save "$modif\razones.dta"
