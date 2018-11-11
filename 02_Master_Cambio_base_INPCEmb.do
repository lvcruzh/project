*Procesamiento de base de datos para cambio de base con INPC

*Responsables:
*Luis Valentín Cruz lvcruz@colmex.mx
*Lorena Ochoa alochoa@colmex.mx

*INPC
********************************************************************************

*Proyecto Embarazo
*Adecuacion 
*Para salarios reales

***Para cambio de base del INPC
* limpiar y cambiar INPC para base: enero 2018 
/* se cambia el INPC a anio base enero 2018= 100 y nos quedamos con todos
los meses para cada anio*/


clear all
set more off
*set rmsg off, permanently
global input_INPC="E:\Embarazo\modif\INPC"
global output="E:\Embarazo\modif\INPC"



clear
cd "$input_INPC"
insheet using INPC1.csv
drop if ndicegeneral==.
gen id_anio=substr(periodo,3,2)
gen id_mes=substr(periodo,6,2)

*cambiar de base a enero 2018 = 100
list ndicegeneral if id_anio=="18" & id_mes=="01"
gen inpc_ene18=(ndicegeneral/98.795 )*100

*keep if id_mes=="06" //conservar solo meses de junio para todos los anios
keep id_anio id_mes inpc_ene18
order id_anio id_mes inpc_ene18
rename id_mes month

gen year=id_anio

tostring year, replace force
replace year="19"+id_anio if id_anio=="91"|id_anio=="92"|id_anio=="93"|id_anio=="94"|id_anio=="95"|id_anio=="96"|id_anio=="97"|id_anio=="98"|id_anio=="99"
replace year="20"+id_anio if id_anio=="00"|id_anio=="01"|id_anio=="02"|id_anio=="03"|id_anio=="04"|id_anio=="05"|id_anio=="06"|id_anio=="07"|id_anio=="08"|id_anio=="09"
replace year="20"+id_anio if id_anio=="10"|id_anio=="11"|id_anio=="12"|id_anio=="13"|id_anio=="14"|id_anio=="15"|id_anio=="16"|id_anio=="17"|id_anio=="18"

keep if month=="10"
*Se elige el mes 10(octubre) porque la encuesta ENIGH se levanta entre 21 de agosto al 28 de noviembre de los años de levantamiento

cd "$output"
save INPC.dta, replace

