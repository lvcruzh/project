*Procesamiento de datos administrativos de nacimientos y población del INEGI

*Responsables:
*Luis Valentin Cruz lvcruz@colmex.mx
*Lorena Ochoa alochoa@colmex.mx

*NACIMIENTOS
********************************************************************************
clear all
set more off
set rmsg on, permanently 

global orig = "E:\econometria_aplicada\project\data\orig\dta\Nacimientos"
global modif = "E:\econometria_aplicada\project\data\modif\Nacimientos"
global pob = "E:\econometria_aplicada\project\data\modif\Poblacion"

*La muestra de interés son las adolescentes de 15 a 19 años de edad
*Depuramos los datos para todos los años de 1990 a 2017, eliminamos valores faltantes
forval i=0/7 {
quietly use "$orig\NACIM9`i'"
keep if EDAD_MADN>=15 & EDAD_MADN<20
drop if ENT_RESID==99 | MUN_RESID==999 | ANO_NAC==99 | ANO_NAC<90

*Homogeneizar el fortmato de los años
tostring ANO_NAC, replace force
replace ANO_NAC="19" + ANO_NAC
destring ANO_NAC, replace

tostring ANO_REG, replace force
replace ANO_REG="19" + ANO_REG
destring ANO_REG, replace

*Generar la variable para contar el numero de embarazos
gen embarazo=1
quietly save "$modif\NACIM9`i'", replace 
}

forval i=8/9 {
quietly use "$orig\NACIM9`i'"
keep if EDAD_MADN>=15 & EDAD_MADN<20
drop if ENT_RESID==99 | MUN_RESID==999 | ANO_NAC==99| ANO_NAC<1990
gen embarazo=1
quietly save "$modif\NACIM9`i'", replace 
}

forval i=0/9 {
quietly use "$orig\NACIM0`i'"
keep if EDAD_MADN>=15 & EDAD_MADN<20
drop if ENT_RESID==99 | MUN_RESID==999 | ANO_NAC==99| ANO_NAC<1990
gen embarazo=1
quietly save "$modif\NACIM0`i'", replace 
}

forval i=0/7 {
quietly use "$orig\NACIM1`i'"
keep if EDAD_MADN>=15 & EDAD_MADN<20
drop if ENT_RESID==99 | MUN_RESID==999 | ANO_NAC==99| ANO_NAC<1990
gen embarazo=1
quietly save "$modif\NACIM1`i'", replace 
}

*Creamos una sola base de datos para todos los años
quietly use "$modif\NACIM90"
forval i=1/9{
append using "$modif\NACIM9`i'"
}
forval i=0/9{
append using "$modif\NACIM0`i'"
}
forval i=0/7{
append using "$modif\NACIM1`i'"
}
sort ANO_NAC ENT_RESID MUN_RESID, stable

*Hay dos variables para mes de nacimiento, hacemos una sola
gen mes=.
replace mes=MES_NACIM if MES_NACIM!=.
replace mes=MES_NAC if MES_NAC!=.
drop MES_NAC MES_NACIM
rename mes MES_NAC
quietly compress

*Guardamos la base completa
quietly save"$modif\embarazo_adolesc.dta", replace

*POBLACION
********************************************************************************
clear all
set more off
set rmsg on, permanently 

global data="E:\econometria_aplicada\project\data\orig\database\poblacion"
global dta ="E:\econometria_aplicada\project\data\orig\dta"
global modif = "E:\econometria_aplicada\project\data\modif\Poblacion"

quietly use "$data\inegi_pob.dta"
drop c2
rename c1 CVE_MUN
rename c3 a1990
rename c4 a1995
rename c5 a2000
rename c6 a2005
rename c7 a2010
keep if CVE_MUN!=.

quietly save "$dta\pob_mun.dta", replace

*Realizando la imputacion de los valores faltantes por el metodo del vecino mas cercano
quietly use "$dta\pob_mun.dta"
tostring CVE_MUN, replace
replace CVE_MUN = "0" + CVE_MUN if length(CVE_MUN)==4

rename CVE_MUN MUN
gen CVE_ENT = substr(MUN,1,2)
gen CVE_MUN = substr(MUN,3,5)
drop MUN

replace a2005=a2010[_n] if a2005[_n]==.
replace a2000=a2005[_n] if a2000[_n]==.
replace a1995=a2000[_n] if a1995[_n]==.
replace a1990=a1995[_n] if a1990[_n]==.

quietly save "$modif\pob_mun_imp.dta", replace

*TASA DE FERTILIDAD 
********************************************************************************
clear all
set more off
set rmsg on, permanently 

global modif = "E:\econometria_aplicada\project\data\modif\Nacimientos"
global pob = "E:\econometria_aplicada\project\data\modif\Poblacion"

*Estamos interesados en la cantidad de embarazos por año a nivel estatal y muncipal

*Nivel estatal 
quietly use "$modif\embarazo_adolesc"
keep if ENT_RESID!=.
collapse (sum) embarazo, by (ENT_RESID ANO_NAC)

*Generamos clave de entidad 
gen CVE_ENT = ENT_RESID
tostring CVE_ENT, replace force
replace CVE_ENT="0"+CVE_ENT if length(CVE_ENT)==1
quietly save "$modif\embarazo_ent", replace

quietly use "$pob\pob_Edos.dta"
merge 1:m CVE_ENT using "$modif\embarazo_ent"
keep if _merge==3
drop _merge

forval i=1990/1994{
gen tasa_`i'= round((embarazo/a1990)*1000) if ANO_NAC==`i'
}
forval i=1995/1999{
gen tasa_`i'= round((embarazo/a1995)*1000) if ANO_NAC==`i'
}
forval i=2000/2004{
gen tasa_`i'= round((embarazo/a2000)*1000) if ANO_NAC==`i'
}
forval i=2005/2009{
gen tasa_`i'= round((embarazo/a2005)*1000) if ANO_NAC==`i'
}
forval i=2010/2017{
gen tasa_`i'= round((embarazo/a2010)*1000) if ANO_NAC==`i'
}
sort CVE_ENT ANO_NAC, stable
gen tasa_emb=.
forval i=1990/2017{
replace tasa_emb=tasa_`i' if tasa_`i'!=.
}
quietly save "$modif\tasa_ent_embarazo", replace

*Municipios
quietly use "$modif\embarazo_adolesc"
collapse (sum) embarazo, by (ENT_RESID MUN_RESID ANO_NAC)

*Generamos clave de entidad y municipio
gen CVE_ENT = ENT_RESID
tostring CVE_ENT, replace force
replace CVE_ENT="0"+CVE_ENT if length(CVE_ENT)==1

gen CVE_MUN = MUN_RESID
tostring CVE_MUN, replace force
replace CVE_MUN="00"+CVE_MUN if length(CVE_MUN)==1
replace CVE_MUN="0"+CVE_MUN if length(CVE_MUN)==2

quietly save "$modif\embarazo_mun", replace

quietly use "$pob\pob_mun_imp.dta"
merge 1:m CVE_ENT CVE_MUN using "$modif\embarazo_mun"
keep if _merge==3
drop _merge

forval i=1990/1994{
gen tasa_`i'= round((embarazo/a1990)*1000) if ANO_NAC==`i'
}
forval i=1995/1999{
gen tasa_`i'= round((embarazo/a1995)*1000) if ANO_NAC==`i'
}
forval i=2000/2004{
gen tasa_`i'= round((embarazo/a2000)*1000) if ANO_NAC==`i'
}
forval i=2005/2009{
gen tasa_`i'= round((embarazo/a2005)*1000) if ANO_NAC==`i'
}
forval i=2010/2017{
gen tasa_`i'= round((embarazo/a2010)*1000) if ANO_NAC==`i'
}

sort CVE_ENT CVE_MUN ANO_NAC, stable
gen tasa_emb=.
forval i=1990/2017{
replace tasa_emb=tasa_`i' if tasa_`i'!=.
}
quietly save "$modif\tasa_mun_embarazo", replace

*CARACTERIZACION DE NACIMIENTOS
********************************************************************************
clear all
set more off
set rmsg on, permanently

global data = "E:\econometria_aplicada\project\data\modif\Nacimientos"

*Usamos la base de embarazo adolescente que ya habiamos generado
*Estamos interesados en ver cuales son las caracteristicas de las adolescentes embarazadas

**************************
*¿Con pareja o sin pareja?
**************************

quietly use "$data\embarazo_adolesc.dta"

*Nos quedamos con las que reportaron su estado civil
drop if EDOCIV_MAD==9

*Dummies para si esta con pareja o no
gen pareja=0
replace pareja=1 if EDOCIV_MAD==2 | EDOCIV_MAD==3

*Obtener porcentajes para todos los años
collapse(sum) embarazo, by(ANO_NAC pareja)

quietly save "$data\temp1.dta", replace

quietly use "$data\temp1.dta"
gen tot=embarazo
collapse(sum) tot, by(ANO_NAC)
quietly save "$data\temp2.dta", replace

quietly use"$data\temp2.dta"
merge 1:n ANO_NAC using "$data\temp1.dta"
drop _merge
sort ANO_NAC
gen porcentaje = (embarazo/tot)*100
quietly save"$data\pareja.dta", replace

erase "$data\temp1.dta"
erase "$data\temp2.dta"

******************
*Mes de nacimiento
******************
clear all
quietly use "$data\embarazo_adolesc.dta"
*Eliminar los missings y los no especificados
keep if MES_NAC!=.
drop if MES_NAC==99
*Nos interesan los embarazos por cada mes y año
collapse(sum) embarazo, by(ANO_NAC MES_NAC)
drop if ANO_NAC==2017
sort MES_NAC ANO_NAC
quietly save"$data\temp1.dta", replace

quietly use "$data\temp1.dta"
collapse(sum) embarazo, by(ANO_NAC)
rename embarazo totales
quietly save "$data\temp2.dta", replace

quietly use "$data\temp2.dta"
merge 1:m ANO_NAC using "$data\temp1.dta"
gen porcentaje = (embarazo/totales)*100
sort ANO_NAC  MES_NAC
drop _merge
quietly save  "$data\mes_nac.dta", replace
erase "$data\temp1.dta"
erase "$data\temp2.dta"

****************
*Mes de embarazo
****************
*Suponer que el embarazo dura 9 meses
clear all
quietly use "$data\mes_nac.dta"
collapse(sum) embarazo, by(MES_NAC)
*Restamos lo nueve meses desde el nacimiento
gen MES_EMBARAZO = MES_NAC-9
*Reajustamos para obtener el numero de mes
replace MES_EMBARAZO=MES_EMBARAZO[_n]+12 if MES_EMBARAZO<=0 
sort MES_EMBARAZO
gen tot=embarazo[1]+embarazo[2]+embarazo[3]+embarazo[4]+embarazo[5]+embarazo[6]+ ///
embarazo[7]+embarazo[8]+embarazo[9]+embarazo[10]+embarazo[11]+embarazo[12]
gen porcentaje = (embarazo/tot)*100
gen mes=""
replace mes="Ene" if MES_EMBARAZO==1
replace mes="Feb" if MES_EMBARAZO==2
replace mes="Mar" if MES_EMBARAZO==3
replace mes="Abr" if MES_EMBARAZO==4
replace mes="May" if MES_EMBARAZO==5
replace mes="Jun" if MES_EMBARAZO==6
replace mes="Jul" if MES_EMBARAZO==7
replace mes="Ago" if MES_EMBARAZO==8
replace mes="Sep" if MES_EMBARAZO==9
replace mes="Oct" if MES_EMBARAZO==10
replace mes="Nov" if MES_EMBARAZO==11
replace mes="Dic" if MES_EMBARAZO==12

quietly save"$data\mes_embarazo.dta", replace

*********************
*Diferencia de edades
*********************
clear all 
quietly use "$data\embarazo_adolesc.dta"
*Nos quedamos con los que reportan edades validas
keep EDAD_MADN EDAD_PADN ANO_NAC
drop if EDAD_MADN==. | EDAD_MADN==99 | EDAD_PADN==. | EDAD_PADN==99
*Obtener moda, media, mediana
egen mode_edadp = mode(EDAD_PADN), by(EDAD_MADN)
egen mean_temp = mean(EDAD_PADN), by(EDAD_MADN)
gen mean_edadp = round(mean_temp)
drop mean_temp
egen median_edadp = median(EDAD_PADN), by(EDAD_MADN)
*Diferencias en edad
gen dif_mode = mode_edadp - EDAD_MADN
gen dif_mean = mean_edadp - EDAD_MADN
gen dif_median = median_edadp - EDAD_MADN

collapse dif_mode dif_mean dif_median, by(EDAD_MADN)
quietly save"$data\dif_edad.dta", replace

**********************************
*¿Situacion laboral de los padres?
**********************************
clear all
quietly use "$data\embarazo_adolesc.dta"

*Nos quedamos con valores validos
drop if ACT_MAD==. | ACT_MAD==9 | ACT_PAD==. |ACT_PAD==9
drop if SITLAB_PAD==.|SITLAB_PAD==9|SITLAB_MAD==.|SITLAB_MAD==9

keep ANO_NAC ACT_MAD ACT_PAD SITLAB_MAD SITLAB_PAD

*ACT_PAD/MAD
*1 Trabaja
*2 No Trabaja // Se refiere a trabajos no remunerados

*SITLAB_PAD/MAD
*2 Estudia
*1(Trabaja),3(Labores del hogar),4,5,6 Otros

*Sea si=1 y no=0
*Definimos las siguientes variables
*Solo trabaja: trabaja
*Solo estudia: estudia
*Trabaja y estudia: tye
*No trabaja ni estudia: ntne

gen tot=1

gen trabaja_m=0
replace trabaja_m=1 if ACT_MAD==1 & SITLAB_MAD==1

gen trabaja_p=0
replace trabaja_p=1 if ACT_PAD==1 & SITLAB_PAD==1

gen estudia_m=0
replace estudia_m=1 if ACT_MAD==2 & SITLAB_MAD==2

gen estudia_p=0
replace estudia_p=1 if ACT_PAD==2 & SITLAB_PAD==2

gen tye_m=0
replace tye_m=1 if ACT_MAD==1 & SITLAB_MAD==2

gen tye_p=0
replace tye_p=1 if ACT_PAD==1 & SITLAB_PAD==2

gen ntne_m=0
replace ntne_m=1 if ACT_MAD==2 & SITLAB_MAD!=2 & SITLAB_MAD!=1

gen ntne_p=0
replace ntne_p=1 if ACT_PAD==2 & SITLAB_PAD!=2 & SITLAB_PAD!=1

quietly save "$data\sit_laboral.dta", replace

*Padres 
quietly use "$data\sit_laboral.dta"
collapse(sum) tot, by (ANO_NAC trabaja_p estudia_p tye_p ntne_p)
quietly save "$data\temp1.dta", replace

quietly use "$data\temp1.dta"
collapse(sum) tot, by (ANO_NAC)
rename tot totales
quietly save "$data\temp2.dta",replace

quietly use "$data\temp2.dta"
merge 1:m ANO_NAC using "$data\temp1.dta"
sort ANO_NAC
drop _merge
gen porcentaje= (tot/totales)*100
quietly save "$data\sitlab_pad.dta", replace

erase "$data\temp1.dta"
erase "$data\temp2.dta"

*Madres 
quietly use "$data\sit_laboral.dta"
collapse(sum) tot, by (ANO_NAC trabaja_m estudia_m tye_m ntne_m)
quietly save "$data\temp1.dta", replace

quietly use "$data\temp1.dta"
collapse(sum) tot, by (ANO_NAC)
rename tot totales
quietly save "$data\temp2.dta",replace

quietly use "$data\temp2.dta"
merge 1:m ANO_NAC using "$data\temp1.dta"
sort ANO_NAC
drop _merge
gen porcentaje= (tot/totales)*100
quietly save "$data\sitlab_mad.dta", replace

erase "$data\temp1.dta"
erase "$data\temp2.dta"

*************
*Rural/Urbano
*************
clear all
quietly use "$data\embarazo_adolesc.dta"

*Nos quedamos con valores validos
keep if TLOC_RESID!=. & TLOC_RESID!=99

*De acuerdo con el INEGI, una población se considera rural cuando tiene menos de 2500 habitantes
gen rural=0
replace rural=1 if TLOC_RESID<4

collapse(sum) embarazo, by(ANO_NAC rural)
quietly save "$data\temp1.dta", replace

quietly use "$data\temp1.dta"
collapse(sum) embarazo, by (ANO_NAC)
rename embarazo totales
quietly save "$data\temp2.dta",replace

quietly use "$data\temp2.dta"
merge 1:m ANO_NAC using "$data\temp1.dta"
sort ANO_NAC
drop _merge
gen porcentaje= (embarazo/totales)*100
quietly save "$data\rural.dta", replace

erase "$data\temp1.dta"
erase "$data\temp2.dta"

*TOP FERTILIDAD EN MUNICIPIOS
********************************************************************************
forval i=1990/2016{
clear all
quietly use "E:\econometria_aplicada\project\data\modif\Nacimientos\tasa_mun_embarazo.dta" 
keep CVE_ENT CVE_MUN ANO_NAC tasa_emb
keep if ANO_NAC==`i'
replace tasa_emb=1000 if tasa_emb>1000
gsort -tasa_emb
gen posicion=_n
keep if posicion==1 | posicion==2 |posicion==3 |posicion==4 |posicion==5
quietly save "E:\econometria_aplicada\Embarazo\municipios\top_fert_`i'", replace
}
clear all
quietly use "E:\econometria_aplicada\Embarazo\municipios\top_fert_1990"
forval i=1991/2016{
append using "E:\econometria_aplicada\Embarazo\municipios\top_fert_`i'"
}
quietly save "E:\econometria_aplicada\Embarazo\municipios\top_fertilidad.dta", replace



