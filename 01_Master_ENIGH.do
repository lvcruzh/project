*Procesamiento de base de datos ENIGH 1992-2016

*Responsables:
*Luis Valentín Cruz lvcruz@colmex.mx
*Lorena Ochoa alochoa@colmex.mx

*ENIGH
*Limpieza
********************************************************************************

***Adecuamos limpieza ENIGH para Embarazo

**Usamos de base el Ejercicio 1 -PS2
**Mantenemos base de municipios

***Configuración base para tiempo
clear all
set more off
set rmsg on, permanently 

global modif_ENIGH= "E:\Embarazo\mod_Enigh"
global orig_ENIGH = "E:\EcoApli\bases\ENIGH"

**1992 Concentrado 
use "$orig_ENIGH\1992\concen.dta", clear
keep folio ubica_geo
gen entidad=substr(ubica_geo,1,2)
gen municipio=substr(ubica_geo,3,3)
save "$modif_ENIGH\con92.dta", replace


quietly use "$orig_ENIGH\1992\ingresos.dta",clear
mmerge folio using "$modif_ENIGH\con92.dta"
keep if _merge==3
drop _merge
save "$modif_ENIGH\ing92.dta", replace

* 1992 Ingreso
use "$modif_ENIGH\ing92.dta",clear
quietly keep if clave=="P001" | clave=="P002" | clave=="P004" | clave=="P006" // 
gen year=1992
egen id=concat(folio numren)
replace ing_mp=ing_mp/1000
replace ing_tri=ing_tri/1000
collapse (sum)ing_mp ing_tri, by (id entidad municipio) // 
quietly save "$modif_ENIGH\ingMun92.dta", replace

*1992 Población

use "$orig_ENIGH\1992\pobla92.dta", clear
gen year=1992
egen id=concat(folio numren)
merge n:1 id using "$modif_ENIGH\ingMun92.dta" //en la base de población se une a ingreso
	*Hay muchos que no hacen match
drop _merge


*Crea variable para nivel de educación
destring ed_formal, replace
quietly gen niv_edu=0 if ed_formal==0 |  ed_formal ==1 // sin educacion 
	replace niv_edu=1 if  ed_formal==2 | ed_formal ==3 // primaria
	replace niv_edu=2 if  ed_formal==4 | ed_formal ==5 // secundaria 
	replace niv_edu=3 if  ed_formal==6 | ed_formal ==7 // preparatoria 
	replace niv_edu=4 if  ed_formal==8 | ed_formal ==9 // universidad  
	la val niv_edu edu
	la var niv_edu "Nivel educativo"
	la de edu 0 "Sin educacion" 1 "Primaria" 2 "Secundaria" 3 "Preparatoria" 4 "Universidad o más"

* Crea variable para años de educación
recode ed_formal (0=0) (1=3) (2=6) (3=7) (4=9) (5=10) (6=12) (7=13) (8=17) ///
	(9=18), gen(year_edu)
	
/* 	sin instrucción			=	0 años
	primaria incompleta		=	3 años
	primaria completa		=	6 años
	secundaria incompleta	=	7 años
	secundaria completa		=	9 años
	prepa incompleta		=	10 años
	prepa completa			=	12 años
	superior incompleta		=	13 años
	superior completa		=	17 años
	posgrado (al menos)		=	18 años	
*/	

* Crea una variable que cuente todas las horas trabajadas (2trabajos)
destring hr_semana, replace
destring hr_sem_sec, replace
quietly gen hrs_tra=hr_semana+hr_sem_sec  //

* Variable para el tamaño de localidad * estrato

*Guardar 
quietly save "$modif_ENIGH\1992.dta", replace
*Esta base tiene las variables de ingresos,pobla y concentrado



*Factor de expansion de hogares
quietly use "$orig_ENIGH\1992\hogares.dta",clear
gen year=1992
merge 1:n folio  using "$modif_ENIGH\1992.dta"
drop _merge


destring sexo, replace

* Renombrar variables 
rename estrato rural

destring rural, replace

* Guardar
keep year id edad sexo niv_edu year_edu hrs_tra ing_mp ing_tri rural factor entidad municipio
save "$modif_ENIGH\1992.dta", replace 
*erase "$modif_ENIGH\ing92.dta"

/**************
Lso siguientes años siguien el mism proceso, solo que como la base no es uniforme
en nombres se requiere poner mucha atención ene le nombre de las variables de interes 
y donde se encuentran guardadas
************************************************/


**1994 Concentrado 
use "$orig_ENIGH\1994\concen.dta", clear
keep folio ubica_geo
gen entidad=substr(ubica_geo,1,2)
gen municipio=substr(ubica_geo,3,3)
save "$modif_ENIGH\con94.dta", replace


quietly use "$orig_ENIGH\1994\ingresos.dta",clear
mmerge folio using "$modif_ENIGH\con94.dta"
keep if _merge==3
drop _merge
save "$modif_ENIGH\ing94.dta", replace

* 1994 Ingreso
use "$modif_ENIGH\ing94.dta",clear
quietly keep if clave=="P001" | clave=="P002" | clave=="P004"
egen id=concat(folio num_ren)
gen year=1994
collapse (sum)ing1 ing_tri, by (id entidad municipio)
quietly save "$modif_ENIGH\ingMun94.dta", replace
*********************

*1994 Población

use "$orig_ENIGH\1994\pobla94.dta",clear
gen year=1994
egen id=concat (folio num_ren)
merge n:1 id using "$modif_ENIGH\ingMun94.dta"
     ***hacen match muy pocos
drop _merge


* Nivel educ
destring ed_formal, replace
quietly gen niv_edu=0 if ed_formal==0 | ed_formal ==1
	replace niv_edu=1 if  ed_formal==2 | ed_formal ==3 
	replace niv_edu=2 if  ed_formal==4 | ed_formal ==5  
	replace niv_edu=3 if  ed_formal==6 | ed_formal ==7  
	replace niv_edu=4 if  ed_formal==8 | ed_formal ==9 
	la val niv_edu edu
	la var niv_edu "Nivel educativo"
	la de edu 0 "Sin educacion" 1 "Primaria" 2 "Secundaria" 3 "Preparatoria" 4 "Universidad"

* Años educacion
recode ed_formal (0 1 =0) (2=1) (3=2) (4=3) (5=4) (6=5) (7=6) (8 16 =7) ///
	(9=8) (10=9) (11=10) (12=12) (13=13) (14=17) (15=18), gen(year_edu)

***REquiere suma preguntar VALE??
/* 
drop tot_hrs
destring hrs_sem, replace
destring hrs_sec, replace
gen tot_hrs=hrs_sem + hrs_sec 
 */


destring tot_hrs, replace

* * *Guardar 
quietly save "$modif_ENIGH\1994.dta", replace

*  Factor
clear all
quietly use "$orig_ENIGH\1994\hogares.dta"
gen year=1994
merge 1:n folio using "$modif_ENIGH\1994.dta"
drop _merge


destring sexo, replace

* REname  
rename ing1 ing_mp
rename tot_hrs hrs_tra
rename estrato rural

destring rural, replace 

* Guardar lo útil  
keep year id edad sexo niv_edu year_edu hrs_tra ing_mp ing_tri rural factor entidad municipio

save "$modif_ENIGH\1994.dta", replace 
*erase "$modif_ENIGH\ing94.dta"


*********************************************
********************************************



**1996 Concentrado 
use "$orig_ENIGH\1996\concen.dta", clear
keep folio ubica_geo
gen entidad=substr(ubica_geo,1,2)
gen municipio=substr(ubica_geo,3,3)
save "$modif_ENIGH\con96.dta", replace


quietly use "$orig_ENIGH\1996\ingresos.dta",clear
mmerge folio using "$modif_ENIGH\con96.dta"
keep if _merge==3
drop _merge
save "$modif_ENIGH\ing96.dta", replace


**********************************
* 1996 Ingreso
use "$modif_ENIGH\ing96.dta",clear

quietly keep if clave=="P001" | clave=="P002" | clave=="P004"
gen year=1996
egen id=concat(folio num_ren)
collapse (sum)ing1 ing_tri, by (id entidad municipio)
quietly save "$modif_ENIGH\ingMun96.dta", replace

*1996 Población
clear all
use "$orig_ENIGH\1996\pobla96.dta"
gen year= 1996
egen id=concat (folio num_ren) 
merge n:1 id using "$modif_ENIGH\ingMun96.dta"
drop _merge


*  nivel educativo 
destring ed_formal, replace 
	quietly gen niv_edu=0 if ed_formal==0 | ed_formal ==1 |ed_formal ==2 | ed_formal ==3 | ed_formal ==4 | ed_formal ==5 | ed_formal == 6 // sin educacion 
	replace niv_edu=1 if  ed_formal ==7 | ed_formal==8 | ed_formal ==9 | ed_formal ==16 // primaria
	replace niv_edu=2 if  ed_formal==10 | ed_formal ==11   // secundaria 
	replace niv_edu=3 if  ed_formal==12 | ed_formal ==13 // preparatoria 
	replace niv_edu=4 if  ed_formal==14 | ed_formal ==15 // universidad 
	la val niv_edu edu
	la var niv_edu "Nivel educativo"
	la de edu 0 "sin educacion" 1 "primaria" 2 "secundaria" 3 "preparatoria" 4 "universidad o mas"


* años de educación
recode ed_formal (0 1 =0) (2=1) (3=2) (4=3) (5=4) (6=5) (7=6) (8 16 =7) ///
	(9=8) (10=9) (11=10) (12=12) (13=13) (14=17) (15=18), gen(year_edu)

* horas trabajadas
destring hrs_sem, replace
destring hrs_sec, replace
quietly gen hrs_tra=hrs_sem+hrs_sec

* *Guardar
quietly save "$modif_ENIGH\1996.dta", replace

*Factor
clear all
quietly use "$orig_ENIGH\1996\hogares.dta"
gen year=1996
merge 1:n folio using "$modif_ENIGH\1996.dta"
drop _merge

destring sexo, replace

* Rename 
rename ing1 ing_mp
rename estrato rural 

destring rural, replace

* Guardar, quedarse con entidad y municipio
keep year id edad sexo niv_edu year_edu hrs_tra ing_mp ing_tri rural factor entidad municipio
save "$modif_ENIGH\1996.dta", replace 
*erase "$modif_ENIGH\ing96.dta"

*********************Año 1998
*********************************************


**1998 Concentrado 
use "$orig_ENIGH\1998\concen.dta", clear
keep folio ubica_geo
gen entidad=substr(ubica_geo,1,2)
gen municipio=substr(ubica_geo,3,3)
save "$modif_ENIGH\con98.dta", replace


quietly use "$orig_ENIGH\1998\ingresos.dta",clear
mmerge folio using "$modif_ENIGH\con98.dta"
keep if _merge==3
drop _merge
save "$modif_ENIGH\ing98.dta", replace


**********************************
* 1998 Ingreso
use "$modif_ENIGH\ing98.dta",clear

quietly keep if clave=="P001" | clave=="P002" | clave=="P003" | clave=="P004" | clave=="P006" | clave=="P008"
egen id=concat(folio num_ren)
collapse (sum)ing_1 ing_tri, by (id entidad municipio)
quietly save "$modif_ENIGH\ingMun98.dta", replace

*1998 Población
clear all
use "$orig_ENIGH\1998\pobla98.dta"
gen year=1998
egen id=concat (folio num_ren)
merge n:1 id using "$modif_ENIGH\ingMun98.dta"
**Quedan pocas obs
drop _merge



destring ed_formal, replace 
	quietly gen niv_edu=0 if ed_formal==0 | ed_formal ==1 |ed_formal ==2 |ed_formal ==7 | ed_formal ==3 | ed_formal ==4 | ed_formal ==5 | ed_formal == 6 // sin educacion 
	replace niv_edu=1 if   ed_formal==8 | ed_formal ==9 | ed_formal ==10 // primaria
	replace niv_edu=2 if  ed_formal==11 | ed_formal ==12   // secundaria 
	replace niv_edu=3 if  ed_formal==13 | ed_formal ==14 // preparatoria 
	replace niv_edu=4 if  ed_formal==15 | ed_formal ==16 // universidad 
	la val niv_edu edu
	la var niv_edu "nivel educativo"
	la de edu 0 "sin educacion" 1 "primaria" 2 "secundaria" 3 "preparatoria" 4 "universidad o mas"


recode ed_formal (1 2 =0) (3=1) (4=2) (5=3) (6=4) (7=5) (8=6) (9 =7) ///
	(10=8) (11=9) (12=10) (13=12) (14=13) (15=17) (16=18), gen(year_edu)


destring tot_hrs, replace
***REquiere suma preguntar VALE??
/*
drop tot_hrs
destring hrs_sem, replace
destring hrs_sec, replace
gen tot_hrs=hrs_sem + hrs_sec 
 */

* *Guardar 
quietly save "$modif_ENIGH\1998.dta", replace

* Factor

quietly use "$orig_ENIGH\1998\hogares.dta", clear
gen year=1998
merge 1:n folio using "$modif_ENIGH\1998.dta"
drop _merge


destring sexo, replace

* Rename para que se pueda appendear  
rename ing_1 ing_mp
rename tot_hrs hrs_tra
rename estrato rural

destring rural, replace

* Guardar
keep year id edad sexo niv_edu year_edu hrs_tra ing_mp ing_tri rural factor entidad municipio
save "$modif_ENIGH\1998.dta", replace 

****************************Año 2000
*********************************************


**2000 Concentrado 
use "$orig_ENIGH\2000\concen.dta", clear
keep folio ubica_geo
gen entidad=substr(ubica_geo,1,2)
gen municipio=substr(ubica_geo,3,3)
save "$modif_ENIGH\con00.dta", replace


quietly use "$orig_ENIGH\2000\ingresos.dta",clear
mmerge folio using "$modif_ENIGH\con00.dta"
keep if _merge==3
drop _merge
save "$modif_ENIGH\ing00.dta", replace


**********************************
* 2000 Ingreso
use "$modif_ENIGH\ing00.dta",clear

quietly keep if clave=="P001" | clave=="P002" | clave=="P003" | clave=="P004" | clave=="P006" | clave=="P008"
egen id=concat(folio num_ren)
collapse (sum)ing_1 ing_tri, by (id entidad municipio)
quietly save "$modif_ENIGH\ingMun00.dta", replace

*2000 Población

use "$orig_ENIGH\2000\pobla.dta", clear
gen year=2000
egen id=concat (folio num_ren) 
merge n:1 id using "$modif_ENIGH\ingMun00.dta"
*match pocos
drop _merge


*  Nivel educativo
destring ed_formal, replace 
	gen niv_edu=0 if ed_formal==0 | ed_formal ==1 |ed_formal ==2 |ed_formal ==7 | ed_formal ==3 | ed_formal ==4 | ed_formal ==5 | ed_formal ==6 // sin educacion 
	replace niv_edu=1 if   ed_formal==8 | ed_formal ==9 | ed_formal ==10 // primaria
	replace niv_edu=2 if  ed_formal==11 | ed_formal ==12   // secundaria 
	replace niv_edu=3 if  ed_formal==13 | ed_formal ==14 // preparatoria 
	replace niv_edu=4 if  ed_formal==15 | ed_formal ==16 // universidad 
	la val niv_edu edu
	la var niv_edu "nivel educativo"
	la de edu 0 "sin educacion" 1 "primaria" 2 "secundaria" 3 "preparatoria" 4 "universidad o mas"

*  Años de educación
recode ed_formal (1 2 =0) (3=1) (4=2) (5=3) (6=4) (7=5) (8=6) (9 =7) ///
	(10=8) (11=9) (12=10) (13=12) (14=13) (15=17) (16=18), gen(year_edu)

*Horas trabajadas

destring tot_hrs, replace
/*Preguntar VALE
drop tot_hrs
destring hrs_sem, replace
destring hrs_sec, replace
gen tot_hrs = hrs_sem + hrs_sec 
*/

quietly save "$modif_ENIGH\2000.dta", replace

* factor
clear all
quietly use "$orig_ENIGH\2000\hogares.dta"
gen year=2000
merge 1:n folio using "$modif_ENIGH\2000.dta"
drop _merge


destring sexo, replace

* REname
rename ing_1 ing_mp
rename tot_hrs hrs_tra 
rename estrato rural

destring rural, replace
 
*Guardar
keep year id edad sexo niv_edu year_edu hrs_tra ing_mp ing_tri rural factor entidad municipio
save "$modif_ENIGH\2000.dta", replace 
erase "$modif_ENIGH\ing00.dta"

*********************************************
*********************************************


**2002 Concentrado 
use "$orig_ENIGH\2002\concen.dta", clear
keep folio ubica_geo
gen entidad=substr(ubica_geo,1,2)
gen municipio=substr(ubica_geo,3,3)
save "$modif_ENIGH\con02.dta", replace


quietly use "$orig_ENIGH\2002\ingresos.dta",clear
mmerge folio using "$modif_ENIGH\con02.dta"
keep if _merge==3
drop _merge
save "$modif_ENIGH\ing02.dta", replace


**********************************
* 2002 Ingreso
use "$modif_ENIGH\ing02.dta",clear

quietly keep if clave=="P001" | clave=="P002" | clave=="P003" | clave=="P004" | clave=="P006" | clave=="P007" | clave=="P008"
egen id=concat(folio num_ren)
collapse (sum)ing_1 ing_tri, by (id entidad municipio)
quietly save "$modif_ENIGH\ingMun02.dta", replace

*2002 Población

use "$orig_ENIGH\2002\pobla02.dta", clear
gen year=2002
egen id=concat (folio num_ren)
merge n:1 id using "$modif_ENIGH\ingMun02.dta"
drop _merge


destring ed_formal, replace 
	gen niv_edu=0 if ed_formal==0 | ed_formal ==1 |ed_formal ==2 | ed_formal ==3 | ed_formal ==4 | ed_formal ==5 | ed_formal == 6 | ed_formal == 7 // sin educacion 
	replace niv_edu=1 if  ed_formal ==8 | ed_formal==8 | ed_formal ==9 | ed_formal ==10  // primaria//// 
	replace niv_edu=2 if  ed_formal ==11 | ed_formal==12 | ed_formal ==13   ////
	| ed_formal ==14 | ed_formal==15 | ed_formal ==16 | ed_formal ==17 // secundaria 
	replace niv_edu=3 if  ed_formal==17 | ed_formal ==18 | ed_formal ==19 ////
	| ed_formal ==20 | ed_formal ==21 | ed_formal ==22 | ed_formal ==23 | ed_formal ==18 ////
	| ed_formal ==25 | ed_formal ==25 | ed_formal ==27 | ed_formal ==28 | ed_formal ==29  // preparatoria 
	replace niv_edu=4 if  ed_formal ==30 | ed_formal==31 | ed_formal==32 |  ed_formal==33  // universidad 
	la val niv_edu edu
	la var niv_edu "nivel educativo"
	la de edu 0 "sin educacion" 1 "primaria" 2 "secundaria" 3 "preparatoria" 4 "universidad o mas"



	recode ed_formal (1 2 =0) (3=1) (4=2) (5=3) (6=4) (7=5) (8=6) (9 =7) ///
	(10=8) (11 12=9) (13 14=10) (15 16 17=11) (18 19 =12)(20 21 22=13) ///
	(23 24=14) (25 26= 15) (27 28 29 30= 16) (31=17)(32 33=18), gen(year_edu)


destring hrs_sem, replace
destring hrs_sec, replace
quietly gen hrs_tra=hrs_sem+hrs_sec



* *Guardar 
quietly save "$modif_ENIGH\2002.dta", replace

* Factor
clear all
quietly use "$orig_ENIGH\2002\hogares.dta"
gen year=2002
merge 1:n folio using "$modif_ENIGH\2002.dta"
drop _merge


destring sexo, replace

* REname  
rename ing_1 ing_mp
rename estrato rural 

destring rural, replace
* Guardar  
keep year id edad sexo niv_edu year_edu hrs_tra ing_mp ing_tri rural factor entidad municipio
save "$modif_ENIGH\2002.dta", replace 
*erase "$modif_ENIGH\ing02.dta"

********Año 2004
*********************************************

**2004 Concentrado 
use "$orig_ENIGH\2004\concen.dta", clear
keep folio ubica_geo
gen entidad=substr(ubica_geo,1,2)
gen municipio=substr(ubica_geo,3,3)
save "$modif_ENIGH\con04.dta", replace


quietly use "$orig_ENIGH\2004\ingresos.dta",clear
mmerge folio using "$modif_ENIGH\con04.dta"
keep if _merge==3
drop _merge
save "$modif_ENIGH\ing04.dta", replace


**********************************
* 2004 Ingreso
use "$modif_ENIGH\ing04.dta",clear

quietly keep if clave=="P001" | clave=="P002" | clave=="P003" | clave=="P004" | clave=="P006" | clave=="P007" | clave=="P008"
egen id=concat(folio num_ren)
collapse (sum)ing_1 ing_tri, by (id municipio entidad)
quietly save "$modif_ENIGH\ingMun04.dta", replace

*2004 Población

use "$orig_ENIGH\2004\pobla04.dta", clear
gen year=2004
egen id=concat (folio num_ren) 
merge n:1 id using "$modif_ENIGH\ingMun04.dta",
drop _merge


destring n_instr161, replace
	gen niv_edu=0 if n_instr161==0 | (n_instr161==1) | (n_instr161==.)
	replace niv_edu=1 if n_instr161==2 | n_instr161==3 
	replace niv_edu=2 if n_instr161==3 | n_instr161==4
	replace niv_edu=3 if n_instr161==4 | n_instr161==5 | n_instr161==6
	replace niv_edu=4 if n_instr161==7 | n_instr161==8 | n_instr161==9
	la val niv_edu edu
	la var niv_edu "nivel educativo"
	la de edu 0 "sin educacion" 1 "primaria" 2 "secundaria" 3 "preparatoria" 4 "universidad o mas"

 
destring n_instr162, replace
		gen esc = 0 if ((n_instr161 ==0 | n_instr161 ==1 | n_instr161 ==.))
		replace esc =	n_instr162 if (n_instr161==2)
		replace esc =	6 if (esc>6 & esc!=.) & n_instr161==2
		replace esc = 	6 + n_instr162 if (n_instr161==3)
		replace esc =	9 if (esc>9 & esc!=.) & n_instr161==3
		replace esc = 	9 + n_instr162 if (n_instr161==4)
		replace esc =	12 if (esc>12 & esc!=.) & n_instr161==4
		replace esc =	14 if (n_instr161==5 & (n_instr162>=1 & n_instr162<=3))
		replace esc =	6+n_instr162 if ///
			(n_instr161==6 & (n_instr162>=1 & n_instr162<=3))
		replace esc =	9 if n_instr161==6 & (esc>9 & esc!=.)
		replace esc =	9+n_instr162 if ///
			(n_instr161==6 & (n_instr162>=1 & n_instr162<=3))
		replace esc =	12 if n_instr161==6 & (esc>12 & esc!=.)
		replace esc =	12+n_instr162 if ///
			(n_instr161==6 & (n_instr162>=1 & n_instr162<=3))
		replace esc =	15 if n_instr161==6 & (esc>15 & esc!=.)
		replace esc =	9 if n_instr161==6 & esc==.
		replace esc = 	12 + n_instr162 if ///
			(n_instr161==7 & (n_instr162>=1 & n_instr162<=3))
		replace esc = 	16 if (n_instr161==7|n_instr161==5) & (n_instr162>=4)
		replace esc = 	18 if (n_instr161==8 | n_instr161==9)
		rename esc year_edu
 
destring horastrab, replace


* *Guardar 
quietly save "$modif_ENIGH\2004.dta", replace

*factor
clear all
quietly use "$orig_ENIGH\2004\hogares.dta"
gen year=2004
merge 1:n folio using "$modif_ENIGH\2004.dta"
drop _merge


destring sexo, replace

*Rename
rename horastrab hrs_tra
rename ing_1 ing_mp
rename estrato rural


destring rural, replace
*Guardar
keep year id edad sexo niv_edu year_edu hrs_tra ing_mp ing_tri rural factor entidad municipio
save "$modif_ENIGH\2004.dta", replace 
*erase "$modif_ENIGH\ing04.dta"

*********************************************
***********Año 2006
********

**2006 Concentrado 
use "$orig_ENIGH\2006\Concen.dta", clear
keep folio ubica_geo
gen entidad=substr(ubica_geo,1,2)
gen municipio=substr(ubica_geo,3,3)
save "$modif_ENIGH\con06.dta", replace


quietly use "$orig_ENIGH\2006\ingresos.dta",clear
mmerge folio using "$modif_ENIGH\con06.dta"
keep if _merge==3
drop _merge
save "$modif_ENIGH\ing06.dta", replace


**********************************
* 2006 Ingreso
use "$modif_ENIGH\ing06.dta",clear

quietly keep if clave=="P001" | clave=="P002" | clave=="P003" | clave=="P004" | clave=="P006" | clave=="P007" | clave=="P008"
egen id=concat(folio num_ren)
collapse (sum)ing_1 ing_tri, by (id entidad municipio)
quietly save "$modif_ENIGH\ingMun06.dta", replace

*2006 Población
clear all
use "$orig_ENIGH\2006\poblacion.dta"
gen year=2006
egen id=concat (folio num_ren) 
merge n:1 id using "$modif_ENIGH\ingMun06.dta"
drop _merge



destring n_instr141, replace
	gen niv_edu=0 if n_instr141==0 | (n_instr141==1) | (n_instr141==2) | (n_instr141==.)
	replace niv_edu=1 if (n_instr141==2) | (n_instr141==3)
	replace niv_edu=2 if (n_instr141==3) | (n_instr141==4)
	replace niv_edu=3 if (n_instr141==4) | (n_instr141==5) | (n_instr141==6)
	replace niv_edu=4 if (n_instr141==7) | (n_instr141==8) | (n_instr141==9)
	la val niv_edu edu
	la var niv_edu "nivel educativo"
	la de edu 0 "sin educacion" 1 "primaria" 2 "secundaria" 3 "preparatoria" 4 "universidad o mas"


destring n_instr142, replace
gen esc = 0 if ((n_instr141 ==0 | n_instr141 ==1 | n_instr141 ==.))
		replace esc =	n_instr142 if (n_instr141==2)
		replace esc =	6 if (esc>6 & esc!=.) & n_instr141==2
		replace esc = 	6 + n_instr142 if (n_instr141==3)
		replace esc =	9 if (esc>9 & esc!=.) & n_instr141==3
		replace esc = 	9 + n_instr142 if (n_instr141==4)
		replace esc =	12 if (esc>12 & esc!=.) & n_instr141==4
		replace esc =	14 if (n_instr141==5 & (n_instr142>=1 & n_instr142<=3))
		replace esc =	6+n_instr142 if ///
			(n_instr141==6 & (n_instr142>=1 & n_instr142<=3))
		replace esc =	9 if n_instr141==6 & (esc>9 & esc!=.)
		replace esc =	9+n_instr142 if ///
			(n_instr141==6 & (n_instr142>=1 & n_instr142<=3))
		replace esc =	12 if n_instr141==6 & (esc>12 & esc!=.)
		replace esc =	12+n_instr142 if ///
			(n_instr141==6 & (n_instr142>=1 & n_instr142<=3))
		replace esc =	15 if n_instr141==6 & (esc>15 & esc!=.)
		replace esc =	9 if n_instr141==6 & esc==.
		replace esc = 	12 + n_instr142 if ///
			(n_instr141==7 & (n_instr142>=1 & n_instr142<=3))
		replace esc = 	16 if (n_instr141==7|n_instr141==5) & (n_instr142>=4)
		replace esc = 	18 if (n_instr141==8 | n_instr141==9)	
		rename esc year_edu
 
destring horas_trab, replace

*guardar
quietly save "$modif_ENIGH\2006.dta", replace

*factor***Hogares
clear all
quietly use "$orig_ENIGH\2006\hogares.dta"
gen year=2006
merge 1:n folio using "$modif_ENIGH\2006.dta"
drop _merge

destring sexo, replace

* Rename  
rename ing_1 ing_mp
rename horas_trab hrs_tra
rename estrato rural


destring rural, replace 
* Guardar 
keep year id edad sexo niv_edu year_edu hrs_tra ing_mp ing_tri rural factor entidad municipio
save "$modif_ENIGH\2006.dta", replace 


*********************************************
*******Año 2008
********

**2008 Concentrado 
use "$orig_ENIGH\2008\Tradicional\Tra_Concentrado_2008_concil_2010.dta", clear
keep folioviv foliohog ubica_geo
gen entidad=substr(ubica_geo,1,2)
gen municipio=substr(ubica_geo,3,3)
save "$modif_ENIGH\con08.dta", replace


quietly use "$orig_ENIGH\2008\Tradicional\Tra_Ingresos_2008_concil_2010.dta",clear
mmerge folioviv foliohog using "$modif_ENIGH\con08.dta"
keep if _merge==3
drop _merge
save "$modif_ENIGH\ing08.dta", replace


**********************************
* 2008 Ingreso
use "$modif_ENIGH\ing08.dta",clear

quietly keep if clave=="P001" | clave=="P002" | clave=="P003" | clave=="P004" | clave=="P005" | clave=="P006" | clave=="P007"
egen id=concat(folioviv foliohog numren)
collapse (sum)ing_1 ing_tri, by (id entidad municipio)
quietly save "$modif_ENIGH\ingMun08.dta", replace

*2008 Población
clear all
use "$orig_ENIGH\2008\Tradicional\pobla08.dta"
gen year=2008
egen id=concat(folioviv foliohog numren) 
merge n:1 id using "$modif_ENIGH\ingMun08.dta"
quietly drop _merge

*
destring n_instr161, replace
	gen niv_edu=0 if n_instr161==0 | (n_instr161==1) | (n_instr161==2) | (n_instr161==.)
	replace niv_edu=1 if (n_instr161==2) | (n_instr161==3)
	replace niv_edu=2 if (n_instr161==3) | (n_instr161==4)
	replace niv_edu=3 if (n_instr161==4) | (n_instr161==5) | (n_instr161==6)
	replace niv_edu=4 if (n_instr161==7) | (n_instr161==8) | (n_instr161==9)
	la val niv_edu edu
	la var niv_edu "nivel educativo"
	la de edu 0 "sin educacion" 1 "primaria" 2 "secundaria" 3 "preparatoria" 4 "universidad o mas"

**
destring n_instr162, replace
gen esc = 0 if ((n_instr161 ==0 | n_instr161 ==1 | n_instr161 ==.))
		replace esc =	n_instr162 if (n_instr161==2)
		replace esc =	6 if (esc>6 & esc!=.) & n_instr161==2
		replace esc = 	6 + n_instr162 if (n_instr161==3)
		replace esc =	9 if (esc>9 & esc!=.) & n_instr161==3
		replace esc = 	9 + n_instr162 if (n_instr161==4)
		replace esc =	12 if (esc>12 & esc!=.) & n_instr161==4
		replace esc =	14 if (n_instr161==5 & (n_instr162>=1 & n_instr162<=3))
		replace esc =	6+n_instr162 if ///
			(n_instr161==6 & (n_instr162>=1 & n_instr162<=3))
		replace esc =	9 if n_instr161==6 & (esc>9 & esc!=.)
		replace esc =	9+n_instr162 if ///
			(n_instr161==6 & (n_instr162>=1 & n_instr162<=3))
		replace esc =	12 if n_instr161==6 & (esc>12 & esc!=.)
		replace esc =	12+n_instr162 if ///
			(n_instr161==6 & (n_instr162>=1 & n_instr162<=3))
		replace esc =	15 if n_instr161==6 & (esc>15 & esc!=.)
		replace esc =	9 if n_instr161==6 & esc==.
		replace esc = 	12 + n_instr162 if ///
			(n_instr161==7 & (n_instr162>=1 & n_instr162<=3))
		replace esc = 	16 if (n_instr161==7|n_instr161==5) & (n_instr162>=4)
		replace esc = 	18 if (n_instr161==8 | n_instr161==9)
		rename esc year_edu


* *Guardar
save "$modif_ENIGH\pobla08.dta", replace

* *Horas totales trab está en el documento de trabajos
clear all
quietly use "$orig_ENIGH\2008\Tradicional\Trabajos.dta"
egen id=concat(folioviv foliohog numren)
collapse (sum) htrab, by(id)
gen hrs_tra=htra
quietly save "$modif_ENIGH\Trabajos2008.dta", replace
clear all
quietly use "$modif_ENIGH\pobla08.dta"
merge 1:1 id using "$modif_ENIGH\Trabajos2008.dta"
drop _merge



* *Guardar 
quietly save "$modif_ENIGH\2008.dta", replace

* factor
clear all
quietly use "$orig_ENIGH\2008\Tradicional\Tra_Hogares_2008_concil_2010.dta"
gen year=2008
merge 1:n folioviv foliohog using "$modif_ENIGH\2008.dta" //
drop _merge

gen rural=estrato
drop estrato

*
destring sexo, replace

* REname  
rename ing_1 ing_mp

* Guardar 
keep year id edad sexo niv_edu year_edu hrs_tra ing_mp ing_tri rural factor entidad municipio
save "$modif_ENIGH\2008.dta", replace 
*erase "$modif_ENIGH\ing08.dta"
*erase "$modif_ENIGH\Trabajos2008.dta"
*erase "$modif_ENIGH\pobla08.dta"

*********************************************
****************Año 2010

********

**2010 Concentrado 
use "$orig_ENIGH\2010\Tradicional\Tra_Concentrado_2010_concil_2010.dta", clear
keep folioviv foliohog ubica_geo
gen entidad=substr(ubica_geo,1,2)
gen municipio=substr(ubica_geo,3,3)
save "$modif_ENIGH\con10.dta", replace


quietly use "$orig_ENIGH\2010\Tradicional\Tra_Ingresos_2010_concil_2010.dta",clear
mmerge folioviv foliohog using "$modif_ENIGH\con10.dta"
keep if _merge==3
drop _merge
save "$modif_ENIGH\ing10.dta", replace


**********************************
* 2010 Ingreso
use "$modif_ENIGH\ing10.dta",clear

quietly keep if clave=="P001" | clave=="P002" | clave=="P003" | clave=="P004" | clave=="P005" | clave=="P006" | clave=="P007"
egen id=concat(folioviv foliohog numren)
collapse (sum)ing_1 ing_tri, by (id entidad municipio)
quietly save "$modif_ENIGH\ingMun10.dta", replace

*2010 Población
clear all
use "$orig_ENIGH\2010\Tradicional\poblacion.dta"
gen year=2010
egen id=concat(folioviv foliohog numren) 
merge n:1 id  using "$modif_ENIGH\ingMun10.dta"
drop _merge

*
destring nivelaprob, replace
	gen niv_edu=0 if nivelaprob==0 | (nivelaprob==1) | (nivelaprob==2) |(nivelaprob==.)
	replace niv_edu=1 if (nivelaprob==2) | (nivelaprob==3)
	replace niv_edu=2 if (nivelaprob==3) | (nivelaprob==4)
	replace niv_edu=3 if (nivelaprob==4) | (nivelaprob==5) | (nivelaprob==6)
	replace niv_edu=4 if (nivelaprob==7) | (nivelaprob==8) | (nivelaprob==9)
	la val niv_edu edu
	la var niv_edu "nivel educativo"
	la de edu 0 "sin educacion" 1 "primaria" 2 "secundaria" 3 "preparatoria" 4 "universidad o mas"


**
destring gradoaprob, replace
rename nivelaprob n_instr161
rename gradoaprob n_instr162
gen esc = 0 if ((n_instr161 ==0 | n_instr161 ==1 | n_instr161 ==.))
		replace esc =	n_instr162 if (n_instr161==2)
		replace esc =	6 if (esc>6 & esc!=.) & n_instr161==2
		replace esc = 	6 + n_instr162 if (n_instr161==3)
		replace esc =	9 if (esc>9 & esc!=.) & n_instr161==3
		replace esc = 	9 + n_instr162 if (n_instr161==4)
		replace esc =	12 if (esc>12 & esc!=.) & n_instr161==4
		replace esc =	14 if (n_instr161==5 & (n_instr162>=1 & n_instr162<=3))
		replace esc =	6+n_instr162 if ///
			(n_instr161==6 & (n_instr162>=1 & n_instr162<=3))
		replace esc =	9 if n_instr161==6 & (esc>9 & esc!=.)
		replace esc =	9+n_instr162 if ///
			(n_instr161==6 & (n_instr162>=1 & n_instr162<=3))
		replace esc =	12 if n_instr161==6 & (esc>12 & esc!=.)
		replace esc =	12+n_instr162 if ///
			(n_instr161==6 & (n_instr162>=1 & n_instr162<=3))
		replace esc =	15 if n_instr161==6 & (esc>15 & esc!=.)
		replace esc =	9 if n_instr161==6 & esc==.
		replace esc = 	12 + n_instr162 if ///
			(n_instr161==7 & (n_instr162>=1 & n_instr162<=3))
		replace esc = 	16 if (n_instr161==7|n_instr161==5) & (n_instr162>=4)
		replace esc = 	18 if (n_instr161==8 | n_instr161==9)
		rename esc year_edu


* *Guardar 
quietly save "$modif_ENIGH\2010.dta", replace

* *Horas totales trab
clear all
quietly use "$orig_ENIGH\2010\Tradicional\Trabajos.dta"
egen id=concat(folioviv foliohog numren)
collapse (sum) htrab, by(id)
gen hrs_tra=htrab
quietly save "$modif_ENIGH\Trabajos2010.dta", replace
clear all
quietly use "$modif_ENIGH\2010.dta"
merge 1:1 id using "$modif_ENIGH\Trabajos2010.dta"
drop _merge
quietly save "$modif_ENIGH\2010.dta", replace


* tam_loc


* factor de expansión
clear all
quietly use "$orig_ENIGH\2010\Tradicional\Tra_Hogares_2010_concil_2010.dta"
gen year=2010
merge 1:n folioviv foliohog using "$modif_ENIGH\2010.dta" //
drop _merge

gen rural=tam_loc
drop tam_loc

*
destring sexo, replace

* REname  
rename ing_1 ing_mp

* Guardar 
keep year id edad sexo niv_edu year_edu hrs_tra ing_mp ing_tri rural factor entidad municipio
save "$modif_ENIGH\2010.dta", replace 
*erase "$modif_ENIGH\ing10.dta"
*erase "$modif_ENIGH\Trabajos2010.dta"

*********************************************
*********************Año 2012
***************************

********

**2012 Concentrado 
use "$orig_ENIGH\2012\Tradicional\tra_concentrado_2012_concil_2010.dta", clear
keep folioviv foliohog ubica_geo
gen entidad=substr(ubica_geo,1,2)
gen municipio=substr(ubica_geo,3,3)
save "$modif_ENIGH\con12.dta", replace


quietly use "$orig_ENIGH\2012\Tradicional\tra_ingresos_2012_concil_2010.dta",clear
mmerge folioviv foliohog using "$modif_ENIGH\con12.dta"
keep if _merge==3
drop _merge
save "$modif_ENIGH\ing12.dta", replace


**********************************
* 2012 Ingreso 
use "$modif_ENIGH\ing12.dta",clear


quietly keep if clave=="P001" | clave=="P002" | clave=="P003" | clave=="P004" | clave=="P005" | clave=="P006" | clave=="P007"
egen id=concat(folioviv foliohog numren)
collapse (sum)ing_1 ing_tri, by (id entidad municipio)
quietly save "$modif_ENIGH\ingMun12.dta", replace

*2012 Población

***
***Algo raro en estas observaciones son muy pocas
******
clear all
use "$orig_ENIGH\2012\Tradicional\tra_poblacion_2012_concil_2010.dta"
gen year=2012
egen id=concat(folioviv foliohog numren) 
merge n:1 id using "$modif_ENIGH\ingMun12.dta"
drop _merge


*
destring nivelaprob, replace
	gen niv_edu=0 if nivelaprob==0 | (nivelaprob==1) | (nivelaprob==2) | (nivelaprob==.)
	replace niv_edu=1 if (nivelaprob==2) | (nivelaprob==3)
	replace niv_edu=2 if (nivelaprob==3) | (nivelaprob==4)
	replace niv_edu=3 if (nivelaprob==4) | (nivelaprob==5) | (nivelaprob==6)
	replace niv_edu=4 if (nivelaprob==7) | (nivelaprob==8) | (nivelaprob==9)
	la val niv_edu edu
	la var niv_edu "nivel educativo"
	la de edu 0 "sin educacion" 1 "primaria" 2 "secundaria" 3 "preparatoria" 4 "universidad o mas"

**
destring gradoaprob, replace
rename nivelaprob n_instr161
rename gradoaprob n_instr162
gen esc = 0 if ((n_instr161 ==0 | n_instr161 ==1 | n_instr161 ==.))
		replace esc =	n_instr162 if (n_instr161==2)
		replace esc =	6 if (esc>6 & esc!=.) & n_instr161==2
		replace esc = 	6 + n_instr162 if (n_instr161==3)
		replace esc =	9 if (esc>9 & esc!=.) & n_instr161==3
		replace esc = 	9 + n_instr162 if (n_instr161==4)
		replace esc =	12 if (esc>12 & esc!=.) & n_instr161==4
		replace esc =	14 if (n_instr161==5 & (n_instr162>=1 & n_instr162<=3))
		replace esc =	6+n_instr162 if ///
			(n_instr161==6 & (n_instr162>=1 & n_instr162<=3))
		replace esc =	9 if n_instr161==6 & (esc>9 & esc!=.)
		replace esc =	9+n_instr162 if ///
			(n_instr161==6 & (n_instr162>=1 & n_instr162<=3))
		replace esc =	12 if n_instr161==6 & (esc>12 & esc!=.)
		replace esc =	12+n_instr162 if ///
			(n_instr161==6 & (n_instr162>=1 & n_instr162<=3))
		replace esc =	15 if n_instr161==6 & (esc>15 & esc!=.)
		replace esc =	9 if n_instr161==6 & esc==.
		replace esc = 	12 + n_instr162 if ///
			(n_instr161==7 & (n_instr162>=1 & n_instr162<=3))
		replace esc = 	16 if (n_instr161==7|n_instr161==5) & (n_instr162>=4)
		replace esc = 	18 if (n_instr161==8 | n_instr161==9)
		rename esc year_edu

* *Guardar
 quietly save "$modif_ENIGH\2012.dta", replace

* *Horas totales trab 
clear all
quietly use "$orig_ENIGH\2012\Tradicional\tra_trabajos_2012_concil_2010.dta"
egen id=concat(folioviv foliohog numren)
collapse (sum) htrab, by(id)
gen hrs_tra=htrab
quietly save "$modif_ENIGH\Trabajos2012.dta", replace
clear all
quietly use "$modif_ENIGH\2012.dta", clear
merge 1:1 id using "$modif_ENIGH\Trabajos2012.dta"
drop _merge
quietly save "$modif_ENIGH\2012.dta", replace
 

clear all
quietly use "$orig_ENIGH\2012\Tradicional\tra_viviendas_2012_concil_2010.dta"
gen year=2012
merge 1:n folioviv using "$modif_ENIGH\2012.dta" //
drop _merge
quietly save "$modif_ENIGH\2012.dta", replace

* factor
clear all
quietly use "$orig_ENIGH\2012\Tradicional\tra_hogares_2012_concil_2010.dta"
gen year=2012
merge 1:n folioviv foliohog using "$modif_ENIGH\2012.dta" //
drop _merge

*
destring sexo, replace

* REname  
rename ing_1 ing_mp
rename factor_hog factor
rename tam_loc rural

destring rural, replace 
*Guardar 
keep year id edad sexo niv_edu year_edu hrs_tra ing_mp ing_tri rural factor entidad municipio
save "$modif_ENIGH\2012.dta", replace 
*erase "$modif_ENIGH\ing12.dta"
*erase "$modif_ENIGH\Trabajos2012.dta"

*********************************************
**************Año 2014

********

**2014 Concentrado 
use "$orig_ENIGH\2014\Tradicional\tra_concentrado_2014_concil_2010.dta", clear
keep folioviv foliohog ubica_geo
gen entidad=substr(ubica_geo,1,2)
gen municipio=substr(ubica_geo,3,3)
save "$modif_ENIGH\con14.dta", replace


quietly use "$orig_ENIGH\2014\Tradicional\tra_ingresos_2014_concil_2010.dta",clear
mmerge folioviv foliohog using "$modif_ENIGH\con14.dta"
keep if _merge==3
drop _merge
save "$modif_ENIGH\ing14.dta", replace


**********************************
* 2014 Ingreso 
use "$modif_ENIGH\ing14.dta",clear

quietly keep if clave=="P001" | clave=="P002" | clave=="P003" | clave=="P004" | clave=="P005" | clave=="P006" | clave=="P007"
gen year=2014
egen id=concat(folioviv foliohog numren)
collapse (sum)ing_1 ing_tri, by (id entidad municipio)
quietly save "$modif_ENIGH\ingMun14.dta", replace

*2014 Población
clear all
use "$orig_ENIGH\2014\Tradicional\tra_poblacion_2014_concil_2010.dta"
gen year=2014
egen id=concat(folioviv foliohog numren) 
merge n:1 id using "$modif_ENIGH\ingMun14.dta"
drop _merge


*
destring nivelaprob, replace
	gen niv_edu=0 if nivelaprob==0 | (nivelaprob==1) | (nivelaprob==2) | (nivelaprob==.)
	replace niv_edu=1 if (nivelaprob==2) | (nivelaprob==3)
	replace niv_edu=2 if (nivelaprob==3) | (nivelaprob==4)
	replace niv_edu=3 if (nivelaprob==4) | (nivelaprob==5) | (nivelaprob==6)
	replace niv_edu=4 if (nivelaprob==7) | (nivelaprob==8) | (nivelaprob==9)
	la val niv_edu edu
	la var niv_edu "nivel educativo"
	la de edu 0 "sin educacion" 1 "primaria" 2 "secundaria" 3 "preparatoria" 4 "universidad o mas"


**
destring gradoaprob, replace
rename nivelaprob n_instr161
rename gradoaprob n_instr162
gen esc = 0 if ((n_instr161 ==0 | n_instr161 ==1 | n_instr161 ==.))
		replace esc =	n_instr162 if (n_instr161==2)
		replace esc =	6 if (esc>6 & esc!=.) & n_instr161==2
		replace esc = 	6 + n_instr162 if (n_instr161==3)
		replace esc =	9 if (esc>9 & esc!=.) & n_instr161==3
		replace esc = 	9 + n_instr162 if (n_instr161==4)
		replace esc =	12 if (esc>12 & esc!=.) & n_instr161==4
		replace esc =	14 if (n_instr161==5 & (n_instr162>=1 & n_instr162<=3))
		replace esc =	6+n_instr162 if ///
			(n_instr161==6 & (n_instr162>=1 & n_instr162<=3))
		replace esc =	9 if n_instr161==6 & (esc>9 & esc!=.)
		replace esc =	9+n_instr162 if ///
			(n_instr161==6 & (n_instr162>=1 & n_instr162<=3))
		replace esc =	12 if n_instr161==6 & (esc>12 & esc!=.)
		replace esc =	12+n_instr162 if ///
			(n_instr161==6 & (n_instr162>=1 & n_instr162<=3))
		replace esc =	15 if n_instr161==6 & (esc>15 & esc!=.)
		replace esc =	9 if n_instr161==6 & esc==.
		replace esc = 	12 + n_instr162 if ///
			(n_instr161==7 & (n_instr162>=1 & n_instr162<=3))
		replace esc = 	16 if (n_instr161==7|n_instr161==5) & (n_instr162>=4)
		replace esc = 	18 if (n_instr161==8 | n_instr161==9)
		rename esc year_edu  

* *Guardar 
quietly save "$modif_ENIGH\2014.dta", replace

* *Horas totales trab
clear all
quietly use "$orig_ENIGH\2014\Tradicional\tra_trabajos_2014_concil_2010.dta"
egen id=concat(folioviv foliohog numren)
collapse (sum) htrab, by(id)
gen hrs_tra=htrab
quietly save "$modif_ENIGH\Trabajos2014.dta", replace
clear all
quietly use "$modif_ENIGH\2014.dta", replace
merge 1:1 id using "$modif_ENIGH\Trabajos2014.dta"
drop _merge
quietly save "$modif_ENIGH\2014.dta", replace


clear all
quietly use "$orig_ENIGH\2014\Tradicional\tra_vivi_2014_concil_2010.dta"
gen year=2014
merge 1:n folioviv using "$modif_ENIGH\2014.dta" //
drop _merge
quietly save "$modif_ENIGH\2014.dta", replace

* factor
clear all
quietly use "$orig_ENIGH\2014\Tradicional\tra_hogares_2014_concil_2010.dta"
gen year=2014
merge 1:n folioviv foliohog using "$modif_ENIGH\2014.dta" //
drop _merge

*
destring sexo, replace

* REname  
rename ing_1 ing_mp 
rename factor_hog factor
rename tam_loc rural


destring rural, replace
*Guardar 
keep year id edad sexo niv_edu year_edu hrs_tra ing_mp ing_tri rural factor entidad municipio
save "$modif_ENIGH\2014.dta", replace 
*erase "$modif_ENIGH\ing14.dta"
*erase "$modif_ENIGH\Trabajos2014.dta"

*********************************************
**********Año 2016

****************

********

**2016 Concentrado 
use "$orig_ENIGH\2016\concentradohogar.dta", clear
keep folioviv foliohog ubica_geo
gen entidad=substr(ubica_geo,1,2)
gen municipio=substr(ubica_geo,3,3)
save "$modif_ENIGH\con16.dta", replace


quietly use "$orig_ENIGH\2016\ingresos.dta",clear
mmerge folioviv foliohog using "$modif_ENIGH\con16.dta"
keep if _merge==3
drop _merge
save "$modif_ENIGH\ing16.dta", replace


**********************************
* 2016 Ingreso 
use "$modif_ENIGH\ing16.dta",clear

quietly keep if clave=="P001" | clave=="P002" | clave=="P003" | clave=="P004" | clave=="P005" | clave=="P006" | clave=="P007"
gen year=2016
egen id=concat(folioviv foliohog numren)
collapse (sum)ing_1 ing_tri, by (id entidad municipio)
quietly save "$modif_ENIGH\ingMun16.dta", replace

*2016 Población
clear all
use "$orig_ENIGH\2016\poblacion.dta"
gen year=2016
egen id=concat(folioviv foliohog numren)
merge n:1 id using "$modif_ENIGH\ingMun16.dta"
drop _merge

*
destring nivelaprob, replace
	gen niv_edu=0 if nivelaprob==0 | (nivelaprob==1) | (nivelaprob==2) | (nivelaprob==.)
	replace niv_edu=1 if (nivelaprob==2) | (nivelaprob==3)
	replace niv_edu=2 if (nivelaprob==3) | (nivelaprob==4)
	replace niv_edu=3 if (nivelaprob==4) | (nivelaprob==5) | (nivelaprob==6) 
	replace niv_edu=4 if (nivelaprob==7) | (nivelaprob==8) | (nivelaprob==9)
	la val niv_edu edu
	la var niv_edu "nivel educativo"
	la de edu 0 "sin educacion" 1 "primaria" 2 "secundaria" 3 "preparatoria" 4 "universidad o mas"

**
destring gradoaprob, replace
rename nivelaprob n_instr161
rename gradoaprob n_instr162
gen esc = 0 if ((n_instr161 ==0 | n_instr161 ==1 | n_instr161 ==.))
		replace esc =	n_instr162 if (n_instr161==2)
		replace esc =	6 if (esc>6 & esc!=.) & n_instr161==2
		replace esc = 	6 + n_instr162 if (n_instr161==3)
		replace esc =	9 if (esc>9 & esc!=.) & n_instr161==3
		replace esc = 	9 + n_instr162 if (n_instr161==4)
		replace esc =	12 if (esc>12 & esc!=.) & n_instr161==4
		replace esc =	14 if (n_instr161==5 & (n_instr162>=1 & n_instr162<=3))
		replace esc =	6+n_instr162 if ///
			(n_instr161==6 & (n_instr162>=1 & n_instr162<=3))
		replace esc =	9 if n_instr161==6 & (esc>9 & esc!=.)
		replace esc =	9+n_instr162 if ///
			(n_instr161==6 & (n_instr162>=1 & n_instr162<=3))
		replace esc =	12 if n_instr161==6 & (esc>12 & esc!=.)
		replace esc =	12+n_instr162 if ///
			(n_instr161==6 & (n_instr162>=1 & n_instr162<=3))
		replace esc =	15 if n_instr161==6 & (esc>15 & esc!=.)
		replace esc =	9 if n_instr161==6 & esc==.
		replace esc = 	12 + n_instr162 if ///
			(n_instr161==7 & (n_instr162>=1 & n_instr162<=3))
		replace esc = 	16 if (n_instr161==7|n_instr161==5) & (n_instr162>=4)
		replace esc = 	18 if (n_instr161==8 | n_instr161==9)
		rename esc year_edu  


* *Guardar 
quietly save "$modif_ENIGH\2016.dta", replace

* *Horas totales trab
clear all
quietly use "$orig_ENIGH\2016\trabajos.dta"
egen id=concat(folioviv foliohog numren)
collapse (sum) htrab, by(id)
gen hrs_tra=htrab
quietly save "$modif_ENIGH\Trabajos2016.dta", replace
clear all
quietly use "$modif_ENIGH\2016.dta"
merge 1:1 id using "$modif_ENIGH\Trabajos2016.dta"
drop _merge
quietly save "$modif_ENIGH\2016.dta", replace


clear all
quietly use "$orig_ENIGH\2016\viviendas.dta"
gen year=2016
merge 1:n folioviv using "$modif_ENIGH\2016.dta" //
drop _merge
quietly save "$modif_ENIGH\2016.dta", replace

* factor
clear all
quietly use "$orig_ENIGH\2016\hogares.dta"
gen year=2016
merge 1:n folioviv foliohog using "$modif_ENIGH\2016.dta" //
drop _merge

*
destring sexo, replace


* REname  
rename ing_1 ing_mp 
rename tam_loc rural
destring rural, replace
* Guardar 
keep year id edad sexo niv_edu year_edu hrs_tra ing_mp ing_tri rural factor entidad municipio
save "$modif_ENIGH\2016.dta", replace 
*erase "$modif_ENIGH\ing16.dta"
*erase "$modif_ENIGH\Trabajos2016.dta"


**********************************************
*Appendeamos todos los años con un solo archivo 


clear all
use "$modif_ENIGH/1992.dta"

forval yr=1994(2)2016 {
	quietly append using "$modif_ENIGH/`yr'.dta", force
	}
	quietly save "$modif_ENIGH/ENIGH_limpia.dta", replace

/*
forval yr=1992(2)2016 {
	erase "$modif_ENIGH/`yr'.dta"
	}
	*/

* Renombramos todas las variables

quietly use "$modif_ENIGH/ENIGH_limpia.dta", clear

destring rural, force replace
la var rural "Tipo de localidad"
la values rural rdef
la de rdef 1 "Urbano" 2 "Urbano" 3 "Urbano" 4 "Rural", modify

la var sexo "Sexo" 
la de sdef 1 "Hombre" 2 "Mujer"
la values sexo sdef

la var year "Año"
la var id "Identificador de individuo"
la var niv_edu "Nivel educativo"
la var year_edu "Años de escolaridad"
la var hrs_tra "Horas trabajadas"
la var ing_mp "Ingreso del mes pasado"
la var ing_tri "Ingreso trimestral normalizado"
la var factor "Factor de expansión"
la var entidad "Entidad"
la var municipio "Municipio"
la var edad "Edad"

quietly save "$modif_ENIGH/ENIGH_limpia.dta", replace

* Base contiene: tamaño de localidad, factor de expansión, año, sexo, edad, id individual, ingreso mensual, trimestral, nivel educativo, años de educación y horas trabajadas, entidad y municipio

***********************************************************************************

*Procesamiento ENIGH
***********************************************************************************
***Adecuacion proyecto Embarazo
**
**Base ENIGH
**PS

***Configuración base para tiempo
clear all
set more off
set rmsg on, permanently 

global modif_ENIGH= "E:\Embarazo\mod_Enigh"
global orig_ENIGH = "E:\EcoApli\bases\ENIGH"
global INPC = "E:\Embarazo\modif\INPC"



clear all

* Nota: la base ENIGH_limpa contiene: tamaño de localidad, factor de expansión, año, sexo, edad, 
* id individual, ingreso mensual, trimestral, nivel educativo, años de educación y horas trabajadas


*Se limpio el INPC con archivo do separado, nos quedamos con indices por año en mes de octubre
*INPC de referencia ENERO de 2018

* Juntamos la base del INPC limpia con la que obtuvimos de limpieza

quietly use "$INPC\INPC.dta",clear
destring year, replace
drop id_anio month
merge 1:n year using "$modif_ENIGH\ENIGH_limpia.dta"
keep if _merge==3
drop _merge
sort year

* Ponemos el ingreso en términos reales

gen ing_mp_real = (ing_mp/inpc_ene18)*100
gen ing_tri_real = (ing_tri/inpc_ene18)*100
*Acotamos la muestra por edad de 15 a 65 años
keep if edad>=15 & edad<=65 //muestra de interés para ingresos y embarazo adolescente




mdesc rural factor sexo edad id ing_mp ing_mp_real ing_tri ing_tri_real niv_edu year_edu hrs_tra entidad municipio
quietly save "$modif_ENIGH\ENIGH_completa.dta", replace

**Generamos grupo 1 Edad de 15-19 años
**Grupo 0 si es otra edad

use "$modif_ENIGH\ENIGH_completa.dta", clear

gen grupo=.
	replace grupo=1 if edad >=15 & edad<=19
	replace grupo=0 if edad >=20


*Crea dummy trabajo

gen trabajo = 0
	replace trabajo = 1 if ing_mp_real !=. | ing_tri_real !=.
label define trabajo 0 "desempleado" 1 "empleado"
label values trabajo trabajo

/* Tabla descriptiva para asegurar que
*no quedaron missings. 
tabstat ing_mp_real ing_tri_real, by (year) save format(%9.2fc) stat(co mean sd min max p1 p5 p25 p50 p75 p95)
*/
quietly save "$modif_ENIGH\ENIGH_completa.dta",replace 



*Genera variable de salario por hora y censoring
clear all
quietly use "$modif_ENIGH\ENIGH_completa.dta"
quietly gen sal_hr = ing_mp_real/(hrs_tra*4.33) if !missing(ing_mp_real)
replace sal_hr=1 if (sal_hr<1 & sal_hr>0)
replace sal_hr=5000 if (sal_hr>5000 & !missing(sal_hr))
quietly save "$modif_ENIGH\ENIGH_completa.dta",replace



**********Análisis salario****
*********************************************************


*Anaslis de salario y el salario por hora en la población 
*a través del tiempo, quitar missing values o ingresos igual a cero. 
* 
quietly use "$modif_ENIGH\ENIGH_completa.dta", clear
drop if sal_hr==. | sal_hr==0
drop if ing_mp_real==.	| ing_mp_real==0
drop if ing_tri_real==.	| ing_tri_real==0
gen shr = round(sal_hr)  //redondeamos para poder usar fweight despúes
gen imr = round(ing_mp_real)
gen itr = round(ing_tri_real)
save "$modif_ENIGH\ENIGH_completa.dta",replace

/*sum detail 
tabstat edad sexo rural imr itr shr year_edu niv_edu , by (year) save format(%9.2fc) stat(co mean sd min max p1 p5 p25 p50 p75 p95)
*/

***Generamos bases de datos de interés colapsando por estados y por municipios


* Tendencias por año de la población total por Municipios
qui use "$modif_ENIGH\ENIGH_completa.dta", clear
collapse (mean) sal_hr ing_mp_real ing_tri_real shr imr itr year_edu [aweight=factor], by(year entidad municipio)
save "$modif_ENIGH\poblasinmiss_gralMun.dta", replace //base completa de trabajadores

* Tendencias por año de la población total por Edos
qui use "$modif_ENIGH\ENIGH_completa.dta", clear
collapse (mean) sal_hr ing_mp_real ing_tri_real shr imr itr year_edu [aweight=factor], by(year entidad)
save "$modif_ENIGH\poblasinmiss_gralEdos.dta", replace //base completa de trabajadores

****por grupo de edad grupo 1 si 15-19 años, grupo=0 si 20-65 años
* Tendencias por año de la población total por Municipios
qui use "$modif_ENIGH\ENIGH_completa.dta", clear
collapse (mean) sal_hr ing_mp_real ing_tri_real shr imr itr year_edu [aweight=factor], by(year entidad municipio grupo)
save "$modif_ENIGH\poblasinmiss_gralMun_gpo.dta", replace //base completa de trabajadores

* Tendencias por año de la población total por Edos
qui use "$modif_ENIGH\ENIGH_completa.dta", clear
collapse (mean) sal_hr ing_mp_real ing_tri_real shr imr itr year_edu [aweight=factor], by(year entidad grupo)
save "$modif_ENIGH\poblasinmiss_gralEdos_gpo.dta", replace //base completa de trabajadores


