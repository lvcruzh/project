*Procesamiento EDIREH

*Responsables:
*Luis Valentín Cruz lvcruz@colmex.mx
*Lorena Ochoa alochoa@colmex.mx
*********************************************************************************
*ENDIREH 2006                                                                   *
*Embarazo                                                                       *
*********************************************************************************

****Configuración base para tiempo
clear all
set more off
set rmsg on, permanently 

global Orig_Endir2006 = "E:\Embarazo\Bdatos\ENDIREH\2006\base_datos_endireh06_dbf"
global modif_Endir2006 = "E:\Embarazo\modif_Endir\Endir2006"
global pob = "E:\Embarazo\modif\Poblacion"
global Viol_infancia= "E:\Embarazo\modif_Endir\Violencia"

**Leemos la base
*Cuestionario
*TVivienda
*Para obtener factor de vivienda y si es rural o urbano, además 
*llaves para unir con otros: control y viv_sel

quietly use "$Orig_Endir2006\06_DS.dta", clear
keep N_CON V_SEL N_REN SEXO EDAD DOM
la var SEXO "sexo 1:H 2:M"
la var EDAD "Edad en años"
keep if EDAD >=15 & EDAD <=19
keep if SEXO==2
save "$modif_Endir2006\06_DSLimp.dta", replace

**************************************************
***PAra violencia infantil 
*TVivienda
*Para obtener factor de vivienda y si es rural o urbano, además 
*llaves para unir con otros: control y viv_sel

quietly use "$Orig_Endir2006\06_DS.dta", clear
keep N_CON V_SEL N_REN SEXO EDAD DOM
la var SEXO "sexo 1:H 2:M"
la var EDAD "Edad en años"
keep if EDAD >=15 
keep if SEXO==2
save "$Viol_infancia\2006_DSLimp.dta", replace
*Tiene a todas las mujeres de la encuesta mayores de 15 años
**************************


***Otro cuestionario

quietly use "$Orig_Endir2006\06_MC1.dta", clear
keep N_CON V_SEL N_REN  P3_19_6  P3_22_6 P3_19_6C P3_24_2 P3_24_2C P3_24_3 P3_24_3C P3_24_2C FAC_PER DOM P5_5 P5_7
*
la var P3_19_6 "1 sí, Durante el último año en su trabajo, ¿su jefe inmediato la obligó a tener relaciones sexuales?"
la var P3_22_6 "1 Sí, Durante su vida de estudiante, ¿algún compañero, maestro, personal obligó a tener relaciones sexuales?"
la var P3_19_6C "Abiertas tipo,Durante su vida de estudiante, ¿algún compañero, maestro, personal o autoridad escolar la obligó a tener relaciones sexuales?"
/*la values P3_19_6C P3_19_6Clabel
la de P3_19_6Clabel 101	"Exesposo" 102	"Esposo (a)" 103 "Concubina" 104 "Amante del esposo" 105 "Esposa de su exesposo"///
106	"Hijo de su ex" 107	"Hijo(a)" 108 "Hijo(a) adoptivo" 109 "Hijastro (a)"///
111	"Empleado (a) domÚstico"///
112	"Nana"///
113	"Mayordomo"///
114	"Tutor"///
115	"Padre"///
116	"Madre"///
117	"Padre y madre"///
118	"Padrastro, madrastra"///
119	"Hermano (a)" ///
120	"Medio hermano (a)"///
121	"Hermanastro (a)" ///
122	"Abuelo (a)" ///
123	"Bisabuelo (a)" ///
126	"TÝo (a)" ///
127	"Sobrino (a)"///
128	"Primo (a)"///
129	"Suegro (a), ex"///
130	"Consuegro (a)"///
131	"Nuera, yerno, ex"///

141	"Amigos"///
142	"Vecino (s), conocido (a)"///
143	"Novio"///
144	"Compa±ero (a), exc"///
145	"Desconocido"///
146	"Padres adoptivos"


*/

**Pregunta violación
la var P3_24_2 "1 sí Dígame si a lo largo de su vida usted la obligaron a tener rel sex?"

**Pregunta forzar por dinero
la var P3_24_3 " 1 sí Dígame si a lo largo de su vida la obligaron a tener rel sex por dinero?"

*Renombrar para apppend
rename P3_19_6 P_Ult_AnTrab
rename P3_22_6 P_VidEstObligRelSex
rename P3_24_2 P_ObligRelSex
rename P3_24_3 P_ObligRelSexDin
**Quienes:
rename P3_24_2C PQn_ObligRelSex
rename P3_24_3C PQn_ObligRelSexDin

la var P5_5 "A usted las personas con las que vivía le pegaban seguido(2)"
la var P5_7 "Recuerda si las personas con las que vivía la insultaban o la ofend seguido(2)"

save "$modif_Endir2006\06_MC1Limp.dta", replace

***************************
*Cuestionario Endireh 06MD1

quietly use "$Orig_Endir2006\06_MD1.dta", clear
keep N_CON V_SEL N_REN P3_17_6 P3_20_6 P3_22_2 P3_22_3 P3_22_2C P3_22_3C FAC_PER DOM P5_5 P5_7
*
la var P3_17_6 "1 sí, Durante el último año en su trabajo, ¿su jefe inmediato la obligó a tener relaciones sexuales?"
la var P3_20_6 "1 Sí, Durante su vida de estudiante, ¿algún compañero, maestro, personal obligó a tener relaciones sexuales?"


**Pregunta violación
la var P3_22_2 "1 si Dígame si a lo largo de su vida usted la obligaron a tener rel sex?"

**Pregunta forzar por dinero
la var  P3_22_3 "1 si Dígame si a lo largo de su vida la obligaron a tener rel sex por dinero?"

*Renombrar para apppend
rename P3_17_6 P_Ult_AnTrab
rename P3_20_6 P_VidEstObligRelSex
rename P3_22_2 P_ObligRelSex
rename P3_22_3 P_ObligRelSexDin
**Quienes:
rename P3_22_2C PQn_ObligRelSex
rename P3_22_3C PQn_ObligRelSexDin

la var P5_5 "A usted las personas con las que vivía le pegaban seguido(2)"
la var P5_7 "Recuerda si las personas con las que vivía la insultaban o la ofend seguido(2)"

save "$modif_Endir2006\06_MD1Limp.dta", replace


******************
*Cuestionario Endireh 06MS

quietly use "$Orig_Endir2006\06_MS.dta", clear
keep N_CON V_SEL N_REN P7_2 P7_3 P10_6 P16_6  P7_2C P7_3C FAC_PER DOM
*
la var P16_6 "1 sí, Durante el último año en su trabajo, ¿su jefe inmediato la obligó a tener relaciones sexuales?"
la var P10_6 "1 Sí, Durante su vida de estudiante, ¿algún compañero, maestro, personal obligó a tener relaciones sexuales?"


**Pregunta violación
la var P7_2 "Dígame si a lo largo de su vida usted la obligaron a tener rel sex?"

**Pregunta forzar por dinero
la var  P7_3 "Dígame si a lo largo de su vida la obligaron a tener rel sex por dinero?"


*Renombrar para apppend
rename P16_6  P_Ult_AnTrab
rename P10_6 P_VidEstObligRelSex
rename P7_2 P_ObligRelSex
rename P7_3 P_ObligRelSexDin
**Quienes:
rename P7_2C PQn_ObligRelSex
rename P7_3C PQn_ObligRelSexDin

save "$modif_Endir2006\06_MSLimp.dta", replace


**************

*Hacemos append de 3 cuestionarios

quietly use "$modif_Endir2006\06_MC1Limp.dta", clear
append using "$modif_Endir2006\06_MD1Limp.dta"
append using "$modif_Endir2006\06_MSLimp.dta"
save "$modif_Endir2006\mujeres2006.dta", replace
*

**Hacemos Merge entre cuestionario SDEM(10-19a) y mujeres para quedarnos solo
*con el grupo de edad de interés

quietly use "$modif_Endir2006\06_DSLimp.dta", clear
mmerge N_CON V_SEL  using "$modif_Endir2006\mujeres2006"
**NO usamos N_REN En merge para mantener las observaciones
keep if _merge==3
drop _merge
*generamos entidad con info de Control
decode N_CON, generate(CONTROL)
gen entidad=substr(CONTROL,1,2)

/*
*/	
	
	
save "$modif_Endir2006\mujeres2006_edad", replace
***************


*********
*****
***Hacer datos por estados
*Estamos interesados en la cantidad de violaciones por año a nivel estado
use "$modif_Endir2006\mujeres2006_edad.dta", clear
destring EDAD,replace 
gen grupo=.
	replace grupo=1 if EDAD <15
	replace grupo=2 if EDAD >=15
	drop if grupo==1
    drop grupo
collapse (sum) P_ObligRelSex [aw=FAC_PER] , by (entidad)
gen anio=2006
rename entidad CVE_ENT

save "$modif_Endir2006\Endir2006ViolacEst.dta", replace
*Indica cuantas personas en ese año por entidad, considerando el factor de expansión

***Procesamos población 


*Importar excel 

import excel "E:\Embarazo\modif\Poblacion\INEGI_PoblaMujEdos2.xlsx", sheet("INEGI_PoblaMujEdos") cellrange(A2:H34) firstrow
rename A CVE_ENT
rename Total nom_ent
rename C a1990
rename D a1995
rename E a2000
rename F a2005
rename G a2010
drop H
 la var a1990 "poblacion mujeres entre 15 y 19 años en 1990"
 la var a1995 "poblacion mujeres entre 15 y 19 años en 1995"
 la var a2000 "poblacion mujeres entre 15 y 19 años en 2000"
 la var a2005 "poblacion mujeres entre 15 y 19 años en 2005"
 la var a2010 "poblacion mujeres entre 15 y 19 años en 2010"
 
 save "$pob\pob_Edos.dta", replace


****
*Hacemos merge con la población por Edo y calculamos tasa
quietly use "$pob\pob_Edos.dta", clear
*destring CVE_ENT, replace
merge 1:m CVE_ENT using "$modif_Endir2006\Endir2006ViolacEst.dta"
keep if _merge==3
drop _merge
gen tasaViol2006Edo=P_ObligRelSex/a2005*1000
la var tasaViol2006Edo "tasa de violación 2006 Edos por cada 1000 jovenes muj"
save "$modif_Endir2006\Endir2006TasaViolEdos.dta", replace

*Quien las obliga
*Estamos interesados en quien hace  violaciones por año a nivel estado
use "$modif_Endir2006\mujeres2006_edad.dta", clear
destring EDAD,replace 
gen grupo=.
	replace grupo=1 if EDAD <15
	replace grupo=2 if EDAD >=15
drop if grupo==1
drop grupo
	
collapse (sum) P_ObligRelSex[aw=FAC_PER] , by (entidad PQn_ObligRelSex)
gen anio=2006
rename entidad CVE_ENT
***Para generar una celda con el valor de la etiqueta "encode/decode"
decode PQn_ObligRelSex, generate(Codigo)
drop PQn_ObligRelSex
rename Codigo PQn_ObligRelSex
destring PQn_ObligRelSex, replace

la values PQn_ObligRelSex PQn_ObligRelSexlabel
la de PQn_ObligRelSexlabel 101	"Exesposo" 102	"Esposo (a)" ////
107	"Hijo(a)" ////
115	"Padre" ////
116	"Madre" ////
117	"Padre y madre" ////
118	"Padrastro, madrastra" ////
119	"Hermano (a)"  ////
120	"Medio hermano (a)" ////
121	"Hermanastro (a)"  ////
122	"Abuelo (a)"  ////
123	"Bisabuelo (a)"  ////
126	"TÝo (a)"  ////
127	"Sobrino (a)" ////
128	"Primo (a)" ////
129	"Suegro (a), ex" ////
130	"Consuegro (a)" ////
131	"Nuera, yerno, ex" ////
132 "cuñado ex" ////
134 "Padrino" ////
137 "familiar" ////
141	"Amigos" ////
142	"Vecino (s), conocido (a)" ////
143	"Novio" ////
144	"Compa±ero (a), exc" ////
145	"Desconocido" ////
146	"Padres adoptivos"

save "$modif_Endir2006\Endir2006QuienViolacEst.dta", replace
***Esta indica eventos por estados por quien lo hace




**Obligan a prostitución
*Estamos interesados en la cantidad de eventos donde obligan a adolesc a relac 
* sexual por dinero a nivel estado
use "$modif_Endir2006\mujeres2006_edad.dta", clear
destring EDAD,replace 
gen grupo=.
	replace grupo=1 if EDAD <15
	replace grupo=2 if EDAD >=15
	drop if grupo==1
    drop grupo
collapse (sum) P_ObligRelSexDin [aw=FAC_PER] , by (entidad)
gen anio=2006
rename entidad CVE_ENT
save "$modif_Endir2006\Endir2006SexDinEst.dta", replace
*Cant de eventos en que se obliga a RSex por dinero

*Hacemos merge con la población por Edo y caclulamos tasa
quietly use "$pob\pob_Edos.dta", clear
*destring CVE_ENT, replace
merge 1:m CVE_ENT using "$modif_Endir2006\Endir2006SexDinEst.dta"
keep if _merge==3
drop _merge
gen tasaSexDin2006Edo=P_ObligRelSexDin/a2005*1000
la var tasaSexDin2006Edo "tasa de obligar a rel sex por dinero Edos 2006"
save "$modif_Endir2006\Endir2006TasaSexDinEdos.dta", replace


*Quien las obliga

*Estamos interesados en quien la obliga a rel.sex. por dinero a nivel estado
use "$modif_Endir2006\mujeres2006_edad.dta", clear
destring EDAD,replace 
gen grupo=.
	replace grupo=1 if EDAD <15
	replace grupo=2 if EDAD >=15
drop if grupo==1
drop grupo
	
collapse (sum) P_ObligRelSexDin[aw=FAC_PER] , by (entidad PQn_ObligRelSexDin)
gen anio=2006
rename entidad CVE_ENT

***Para generar una celda con el valor de la etiqueta "encode/decode"
decode PQn_ObligRelSexDin, generate(Codigo)
drop PQn_ObligRelSexDin
rename Codigo PQn_ObligRelSexDin
destring PQn_ObligRelSexDin, replace

la values PQn_ObligRelSexDin PQn_ObligRelSexDinlabel
la de PQn_ObligRelSexDinlabel 101	"Exesposo" 102	"Esposo (a)" ////
107	"Hijo(a)" ////
115	"Padre" ////
116	"Madre" ////
117	"Padre y madre" ////
118	"Padrastro, madrastra" ////
119	"Hermano (a)"  ////
120	"Medio hermano (a)" ////
121	"Hermanastro (a)"  ////
122	"Abuelo (a)"  ////
123	"Bisabuelo (a)"  ////
126	"TÝo (a)"  ////
127	"Sobrino (a)" ////
128	"Primo (a)" ////
129	"Suegro (a), ex" ////
130	"Consuegro (a)" ////
131	"Nuera, yerno, ex" ////
132 "cuñado ex" ////
134 "Padrino" ////
137 "familiar" ////
141	"Amigos" ////
142	"Vecino (s), conocido (a)" ////
143	"Novio" ////
144	"Compa±ero (a), exc" ////
145	"Desconocido" ////
146	"Padres adoptivos"

save "$modif_Endir2006\Endir2006QuienSexDinEdos.dta", replace
**Datos por entidad de quien las obliga por dinero//En gral desconocidos.

*****************************************************************


*********************************************************************************
*ENDIREH 2011                                                                   *
*Embarazo                                                                       *
*********************************************************************************

**Base 2011

****Configuración base para tiempo
clear all
set more off
set rmsg on, permanently 

global Orig_Endir2011 = "E:\Embarazo\Bdatos\ENDIREH\2011\base_datos_endireh11_dbf"
global modif_Endir2011 = "E:\Embarazo\modif_Endir\Endir2011"
global pob = "E:\Embarazo\modif\Poblacion"

**Leemos la base
*Cuestionario
*TVivienda
*Para obtener factor de vivienda y si es rural o urbano, además 
*llaves para unir con otros: control y viv_sel

quietly use "$Orig_Endir2011\dtaTViviend.dta", clear
keep CONTROL VIV_SEL FAC_VIV DOMINIO
save "$modif_Endir2011\dtaTViviend2011Limp.dta", replace

*Leemos cuestionario SDEM
*Para hacer match de EDAD con el resto

quietly use "$Orig_Endir2011\dtaTSDem.dta", clear
keep CONTROL VIV_SEL HOGAR N_REN SEXO EDAD FAC_VIV DOMINIO
keep if SEXO==2
keep if  EDAD>=10 & EDAD<=19
gen edad_nolab=.
replace edad_nolab=EDAD
drop EDAD
rename edad_nolab EDAD
save "$modif_Endir2011\dtaTSDem2011Limp.dta", replace

*Cuestionario TUnidas1 //casadas o con pareja
*llaves CONTROL VIV_SEL HOGAR ** R_SEL_M

quietly use "$Orig_Endir2011\dtaTUnidas1.dta", clear
keep CONTROL VIV_SEL HOGAR R_SEL_M AP2_6_4 AP2_7_4_1 AP2_7_4_2 FAC_PER AP2_6_6 AP2_7_6_1 AP3_3 AP3_2

*Pregunta sobre violación
la var AP2_6_4 " 1 sí Sin considerar a su esposo o pareja, ¿dígame si 4 la han obligado a tener relaciones sexuales?"
destring AP2_6_4, replace
replace AP2_6_4=. if AP2_6_4==9

la var AP2_7_4_1 "¿quién o quiénes le han (RESPUESTA DE 2.6)?"

	la values AP2_7_4_1 AP2_7_4_1label
la de AP2_7_4_1label 1 "Padre"  2 "Hermano(a)" 4 "Tío(a)" 3 "Suegro(a)" 5 "Cuñado(a)"  6 "Otro familiar" 7 "patron/jefe" 8"compañero de trabajo" 9 "maestro" 10 "compañero de escuela" 11 "aut escolar" 12 "desconocido" 13 "vecino" 14"policia/militar" 15 "amigos" 16 "otro"

*Pregunta sobre prostitución/ obligado por dinero
la var AP2_6_6 "1 sí , la han obligado a realizar actos sexuales por dinero?"
destring AP2_6_6, replace
replace AP2_6_6=. if AP2_6_6==9

la var AP2_7_6_1 "2.7 Dígame ¿quién o quiénes le han (RESPUESTA DE 2_6_6)?"
destring AP2_7_6_1, replace
replace AP2_7_6_1=. if AP2_7_6_1==99
la values AP2_7_6_1 AP2_7_6_1label
la de AP2_7_6_1label  1 "Padre"  2 "Hermano(a)" 4 "Tío(a)" 3 "Suegro(a)" 5 "Cuñado(a)"  6 "Otro familiar" 7 "patron/jefe" 8"compañero de trabajo" 9 "maestro" 10 "compañero de escuela" 11 "aut escolar" 12 "desconocido" 13 "vecino" 14"policia/militar" 15 "amigos" 16 "otro"

rename AP2_6_4 Obli_RelSx
rename AP2_7_4_1 QuinObli_RelSx
rename AP2_6_6 Obli_RelSxDin
rename AP2_7_6_1 QuinObli_RelSxDin

*nuevas
la var AP3_3 "3.3 ¿Recuerda si las personas con las que vivía la insultaban o la ofendían …2 seguido"
la var AP3_2 "3.2 ¿Las personas con las que vivía le pegaban a usted …2 seguido"

save "$modif_Endir2011\dtaTUnidas12011Limp.dta", replace

******************
*Cuestionario TDunida1  // Divorciadas
*llaves CONTROL VIV_SEL HOGAR ** R_SEL_M

quietly use "$Orig_Endir2011\dtaTDunida1.dta", clear
keep CONTROL VIV_SEL HOGAR R_SEL_M BP2_6_4 BP2_7_4_1 BP2_6_6 BP2_7_6_1 FAC_PER BP3_3 BP3_2

*Pregunta sobre violación
la var BP2_6_4 "1 sí ,  la han obligado a tener relaciones sexuales?"
destring BP2_6_4, replace
replace BP2_6_4=. if BP2_6_4==9


la var BP2_7_4_1 "2.7 Dígame ¿quién o quiénes le han (RESPUESTA DE 2_6_4)?"
destring BP2_7_4_1, replace
replace BP2_7_4_1=. if BP2_7_4_1==99
la values BP2_7_4_1 BP2_7_4_1label
la de BP2_7_4_1label  1 "Padre"  2 "Hermano(a)" 4 "Tío(a)" 3 "Suegro(a)" 5 "Cuñado(a)"  6 "Otro familiar" 7 "patron/jefe" 8"compañero de trabajo" 9 "maestro" 10 "compañero de escuela" 11 "aut escolar" 12 "desconocido" 13 "vecino" 14"policia/militar" 15 "amigos" 16 "otro"

*Pregunta sobre prostitución 
la var BP2_6_6 "1 sí ,  la han obligado a realizar actos sexuales por dinero?"
destring BP2_6_6, replace
replace BP2_6_6=. if BP2_6_6==9

la var BP2_7_6_1 "2.7 Dígame ¿quién o quiénes le han (RESPUESTA DE 2_6_6)?"
destring BP2_7_6_1, replace
replace BP2_7_6_1=. if BP2_7_6_1==99
la values BP2_7_6_1 BP2_7_6_1label
la de BP2_7_6_1label  1 "Padre"  2 "Hermano(a)" 4 "Tío(a)" 3 "Suegro(a)" 5 "Cuñado(a)"  6 "Otro familiar" 7 "patron/jefe" 8"compañero de trabajo" 9 "maestro" 10 "compañero de escuela" 11 "aut escolar" 12 "desconocido" 13 "vecino" 14"policia/militar" 15 "amigos" 16 "otro"

rename BP2_6_4 Obli_RelSx
rename BP2_7_4_1 QuinObli_RelSx
rename BP2_6_6 Obli_RelSxDin
rename BP2_7_6_1 QuinObli_RelSxDin

*nuevas
la var BP3_3 "3.3 ¿Recuerda si las personas con las que vivía la insultaban o la ofendían …2 seguido"
la var BP3_2 "3.2 ¿Las personas con las que vivía le pegaban a usted …2 seguido"

save "$modif_Endir2011\dtaTDunida12011Limp.dta", replace


*************************
*Cuestionario TSolter1  // Solteras
*llaves CONTROL VIV_SEL HOGAR ** R_SEL_M


quietly use "$Orig_Endir2011\dtaTSolter1.dta", clear
keep CONTROL VIV_SEL HOGAR R_SEL_M CP2_6_4 CP2_7_4_1 CP2_6_6 CP2_7_6_1 FAC_PER

*Pregunta sobre violación
la var CP2_6_4 "1 sí ,  la han obligado a tener relaciones sexuales?"
destring CP2_6_4, replace
replace CP2_6_4=. if CP2_6_4==9

la var CP2_7_4_1 "2.7 Dígame ¿quién o quiénes le han (RESPUESTA DE 2_6_4)?"
destring CP2_7_4_1, replace
replace CP2_7_4_1=. if CP2_7_4_1==99
la values CP2_7_4_1 CP2_7_4_1label
la de CP2_7_4_1label  1 "Padre"  2 "Hermano(a)" 4 "Tío(a)" 3 "Suegro(a)" 5 "Cuñado(a)"  6 "Otro familiar" 7 "patron/jefe" 8"compañero de trabajo" 9 "maestro" 10 "compañero de escuela" 11 "aut escolar" 12 "desconocido" 13 "vecino" 14"policia/militar" 15 "amigos" 16 "otro"

*Pregunta sobre prostitución 
la var CP2_6_6 "1 sí ,  la han obligado a realizar actos sexuales por dinero?"
destring CP2_6_6, replace
replace CP2_6_6=. if CP2_6_6==9

la var CP2_7_6_1 "2.7 Dígame ¿quién o quiénes le han (RESPUESTA DE 2_6_6)?"
destring CP2_7_6_1, replace
replace CP2_7_6_1=. if CP2_7_6_1==99
la values CP2_7_6_1 CP2_7_6_1label
la de CP2_7_6_1label  1 "Padre"  2 "Hermano(a)" 4 "Tío(a)" 3 "Suegro(a)" 5 "Cuñado(a)"  6 "Otro familiar" 7 "patron/jefe" 8"compañero de trabajo" 9 "maestro" 10 "compañero de escuela" 11 "aut escolar" 12 "desconocido" 13 "vecino" 14"policia/militar" 15 "amigos" 16 "otro"

rename CP2_6_4 Obli_RelSx
rename CP2_7_4_1 QuinObli_RelSx
rename CP2_6_6 Obli_RelSxDin
rename CP2_7_6_1 QuinObli_RelSxDin

save "$modif_Endir2011\dtaTSolter12011Limp.dta", replace

**************
*Hacemos append de 3 cuestionarios

quietly use "$modif_Endir2011\dtaTUnidas12011Limp.dta", clear
append using "$modif_Endir2011\dtaTDunida12011Limp.dta"
append using "$modif_Endir2011\dtaTSolter12011Limp.dta"
save "$modif_Endir2011\mujeres2011", replace
*

**Hacemos Merge entre cuestionario SDEM(10-19a) y mujeres para quedarnos solo
*con el grupo de edad de interés

quietly use "$modif_Endir2011\dtaTSDem2011Limp.dta", clear
mmerge CONTROL VIV_SEL HOGAR using "$modif_Endir2011\mujeres2011"
keep if _merge==3
drop _merge
decode CONTROL, generate (Control_A)
gen entidad= substr(Control_A,1,2)

/*
*/	
save "$modif_Endir2011\mujeres2011_edad", replace

***Hacer datos por estados
*Estamos interesados en la cantidad de violaciones por año a nivel estado
use "$modif_Endir2011\mujeres2011_edad.dta", clear
destring EDAD,replace 
gen grupo=.
	replace grupo=1 if EDAD <15
	replace grupo=2 if EDAD >=15
	drop if grupo==1
	drop grupo
collapse (sum) Obli_RelSx [aw=FAC_PER] , by (entidad)
gen anio=2011
rename entidad CVE_ENT

save "$modif_Endir2011\Endir2011ViolacEst.dta", replace
*Indica cuantas personas en ese año por entidad, considerando el factor de expansión


*Hacemos merge con la población por Edo y calculamos tasa
quietly use "$pob\pob_Edos.dta", clear
*destring CVE_ENT, replace
merge 1:m CVE_ENT using "$modif_Endir2011\Endir2011ViolacEst.dta"
keep if _merge==3
drop _merge
gen tasaViol2011Edo=Obli_RelSx/a2010*1000
la var tasaViol2011 "tasa de violación Edos por cada 1000 jovenes muj"
save "$modif_Endir2011\Endir2011TasaViolEdos.dta", replace

*Quien las obliga

*Estamos interesados en quien hace  violaciones por año a nivel estado
use "$modif_Endir2011\mujeres2011_edad.dta", clear
destring EDAD,replace 
gen grupo=.
	replace grupo=1 if EDAD <15
	replace grupo=2 if EDAD >=15
drop if grupo==1
drop grupo
	
collapse (sum) Obli_RelSx[aw=FAC_PER] , by (entidad QuinObli_RelSx)
gen anio=2011
rename entidad CVE_ENT

save "$modif_Endir2011\Endir2011QuienViolacEst.dta", replace


**Obligan a prostitución
*Estamos interesados en la cantidad de eventos donde obligan a adolesc a relac 
* sexual por dinero a nivel estado
use "$modif_Endir2011\mujeres2011_edad.dta", clear
destring EDAD,replace 
gen grupo=.
	replace grupo=1 if EDAD <15
	replace grupo=2 if EDAD >=15
	drop if grupo==1
    drop grupo
collapse (sum) Obli_RelSxDin [aw=FAC_PER] , by (entidad)
gen anio=2011
rename entidad CVE_ENT
save "$modif_Endir2011\Endir2011SexDinEst.dta", replace
*Cant de eventos en que se obliga a RSex por dinero

*Hacemos merge con la población por Edo y caclulamos tasa
quietly use "$pob\pob_Edos.dta", clear
*destring CVE_ENT, replace
merge 1:m CVE_ENT using "$modif_Endir2011\Endir2011SexDinEst.dta"
keep if _merge==3
drop _merge
gen tasaSexDin2011Edo=Obli_RelSxDin/a2010*1000
la var tasaSexDin2011Edo "tasa de obligar a rel sex por dinero Edos"
save "$modif_Endir2011\Endir2011TasaSexDinEdos.dta", replace


*Quien las obliga

*Estamos interesados en quien la obliga a rel.sex. por dinero a nivel estado
use "$modif_Endir2011\mujeres2011_edad.dta", clear
destring EDAD,replace 
gen grupo=.
	replace grupo=1 if EDAD <15
	replace grupo=2 if EDAD >=15
drop if grupo==1
drop grupo
	
collapse (sum) Obli_RelSxDin[aw=FAC_PER] , by (entidad QuinObli_RelSxDin)
gen anio=2011
rename entidad CVE_ENT
save "$modif_Endir2011\Endir2011QuienSexDinEdos.dta", replace
**Datos por entidad de quien las obliga//En gral desconocidos.


*****************************************************************


*********************************************************************************
*ENDIREH 2016                                                                   *
*Embarazo                                                                       *
*********************************************************************************

**Base 2016

****Configuración base para tiempo
clear all
set more off
set rmsg on, permanently 

global Orig_Endir2016 = "E:\Embarazo\Bdatos\ENDIREH\2016\bd_mujeres_endireh2016_sitioinegi_stata"
global modif_Endir2016 = "E:\Embarazo\modif_Endir\Endir2016"
global pob = "E:\Embarazo\modif\Poblacion"

**Leemos la base

quietly use "$Orig_Endir2016\BD_MUJERES_ENDIREH2016_SitioINEGI.dta"
keep if edad >=10 & edad <=19
gen grupo=.
replace grupo=1 if edad >=10 & edad <=14
replace grupo=2 if edad >=15 & edad <=19
save "$modif_Endir2016\Endir2016Limp.dta", replace

use "$modif_Endir2016\Endir2016Limp.dta", clear
gen embar_prev5a=.
	replace embar_prev5a=1 if p9_2=="1"
	replace embar_prev5a=0 if p9_2!="1"
la var embar_prev5a "embarazo en 5 años previos"
la var p9_3 "num de embarazos en los 5 años previos"
	destring p9_3, replace
la var p9_4_1 "Nacidos vivos de esos embarazos"
	destring p9_4_1, replace
la var p9_4_2 "Nacidos muertos de esos embarazos"
	destring p9_4_2, replace
la var p9_4_3 "Num de abortos de esos embarazos"
	destring p9_4_3, replace
	replace p9_4_3=. if p9_4_3==99
*Maltrato físico en el parto
la var p9_8_3 "1 sí ¿Le dijeron cosas ofensivas o humillantes, ¿así gritaba cuando se lo hicieron? o cuando se lo hicieron, ahí si abrió las piernas ¿no?"
	destring p9_8_3, replace
	replace p9_8_3=. if p9_8_3==9
*Esterilización sin consentimiento
la var p9_8_7 " 1 sí Le colocaron algún método anticonceptivo o la operaron o esterilizaron para ya no tener hijos sin preguntarle o avisarle"
	replace p9_8_7=. if p9_8_7==9
la var p9_8_8 "1 sí La presionaron para que usted aceptara que le pusieran un dispositivo o la operaran para ya no tener hijos?"
	destring p9_8_8, replace
	replace p9_8_8=. if p9_8_8==9

*Abuso fisico familiar
la var p10_1_2 "1 sí ¿alguna o algunas personas de su familia la han manoseado, tocado, besado o se le han arrimado, recargado o encimado sin su consentimiento"
destring p10_1_2, replace
replace p10_1_2=1 if p10_1_2==1 | p10_1_2==2 | p10_1_2==3
replace p10_1_2=0 if p10_1_2==4
replace p10_1_2=. if p10_1_2==9

*Violacion por familiar
la var p10_1_3 "1 sí ¿alguna o algunas personas de su familia la han obligado a tener relaciones sexuales en contra de su voluntad"
	destring p10_1_3, replace
	replace p10_1_3=1 if p10_1_3==1 | p10_1_3==2 | p10_1_3==3
	replace p10_1_3=0 if p10_1_3==4
	replace p10_1_3=. if p10_1_3==9
*Intento de violación por familiar 
la var p10_1_4 "1sí alguna o algunas personas de su familia han tratado de obligarla a tener relaciones sexuales en contra de su voluntad"
	destring p10_1_4, replace
	replace p10_1_4=1 if p10_1_4==1 | p10_1_4==2 | p10_1_4==3
	replace p10_1_4=0 if p10_1_4==4
	replace p10_1_4=. if p10_1_4==9
* Quien la ha forzado a tener rel sex
la var p10_2_3_1 "Quién o quiénes la han obligado a tener relaciones sexuales en contra de su voluntad?"
	destring p10_2_3_1, replace
	replace p10_2_3_1=. if p10_2_3_1==99
	
	la values p10_2_3_1 p10_2_3_1label
la de p10_2_3_1label 1 "Padre" 2 "Madre" 3 "Padrastro/madrastra" 4 "Abuelo(a)" 5 "Hijo(a)" 6 "Hermano(a)" 7 "Tío(a)" 8 "Primo(a)" 9 "Suegro(a)" 10 "Cuñado(a)" 11 "Sobrino(a)" 12 "Yerno" 13 "Otro familiar" 99 "No especificado"

*Preg2 igual
la var p10_2_3_2 "Quién o quiénes la han obligado a tener relaciones sexuales en contra de su voluntad?"
	destring p10_2_3_2, replace
	replace p10_2_3_2=. if p10_2_3_2==99
	
	la values p10_2_3_2 p10_2_3_2label
la de p10_2_3_2label 1 "Padre" 2 "Madre" 3 "Padrastro/madrastra" 4 "Abuelo(a)" 5 "Hijo(a)" 6 "Hermano(a)" 7 "Tío(a)" 8 "Primo(a)" 9 "Suegro(a)" 10 "Cuñado(a)" 11 "Sobrino(a)" 12 "Yerno" 13 "Otro familiar" 99 "No especificado"

*Preg3 igual
la var p10_2_3_3 "Quién o quiénes la han obligado a tener relaciones sexuales en contra de su voluntad?"
	destring p10_2_3_3, replace
	replace p10_2_3_3=. if p10_2_3_3==99
	
	la values p10_2_3_3 p10_2_3_3label
la de p10_2_3_3label 1 "Padre" 2 "Madre" 3 "Padrastro/madrastra" 4 "Abuelo(a)" 5 "Hijo(a)" 6 "Hermano(a)" 7 "Tío(a)" 8 "Primo(a)" 9 "Suegro(a)" 10 "Cuñado(a)" 11 "Sobrino(a)" 12 "Yerno" 13 "Otro familiar" 99 "No especificado"


***Pregunta Ministerio Publico denuncia violación
la var p10_12_3_1 "En esa última vez, que acudió a el Ministerio Público ¿cuál o cuáles fueron las situaciones por las que presentó la queja o denuncia"
	destring p10_12_3_1, replace
	recode p10_12_3_1 (1 2 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 =0)(3 = 1) (99 = .)
	*replace p10_12_3_1=. if p10_12_3_1==99 |p10_12_3_1==99
	
	la values p10_12_3_1 p10_12_3_1label
la de p10_12_3_1label 1 "la han obligado a tener relaciones sexuales en contra de su voluntad" 0 "otro caso"	
	***Nadie se presento ante el MP 	

**Preg2
la var p10_12_3_2 "En esa última vez, que acudió a el Ministerio Público ¿cuál o cuáles fueron las situaciones por las que presentó la queja o denuncia"
	destring p10_12_3_2, replace
	recode p10_12_3_2 (1 2 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 =0)(3 = 1) (99 = .)
	*replace p10_12_3_2=. if p10_12_3_2==99 |p10_12_3_2==99
	
	la values p10_12_3_2 p10_12_3_2label
la de p10_12_3_2label 1 "la han obligado a tener relaciones sexuales en contra de su voluntad" 0 "otro caso"	
	***1 persona se presento ante el MP 		

**Preg3
la var p10_12_3_3 "En esa última vez, que acudió a el Ministerio Público ¿cuál o cuáles fueron las situaciones por las que presentó la queja o denuncia"
	destring p10_12_3_3, replace
	recode p10_12_3_3 (1 2 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 =0)(3 = 1) (99 = .)
	*replace p10_12_3_3=. if p10_12_3_3==99 |p10_12_3_3==99
	
	la values p10_12_3_3 p10_12_3_3label
la de p10_12_3_3label 1 "la han obligado a tener relaciones sexuales en contra de su voluntad" 0 "otro caso"	
	***Nadie se presento ante el MP 		
	
***Limpieza de la base 
 destring sexo, replace
 keep if sexo==2
 
 la var fac_viv "Factor vivienda Ponderador quese utiliza paraestimar resultadosde las preguntasque se refieren alas viviendas y lapoblación en genera"
 la var fac_muj "Factor de la mujer"
 
 keep id_viv id_muj c_unica c_viv c_hog upm ren_m_ele viv_sel prog hogar nom_ent ///
 cve_mun nom_mun cod_res cod_res_mu t_instrum id_viv id_muj c_unica c_viv c_hog upm ///
 ren_m_ele viv_sel prog hogar cve_ent nom_ent cve_mun nom_mun cod_res cod_res_mu t_instrum ///
 fac_viv fac_muj estrato sexo dominio ///
 grupo embar_prev5a p9_3 p9_4_1 ///
p9_4_2 ///
p9_4_3 ///
p9_8_3 ///
p9_8_7 ///
p9_8_8 ///
p10_1_2 ///
p10_1_3 ///
p10_1_4 ///
p10_2_3_1 ///
	p10_2_3_2 /// 
	p10_2_3_3 ///
p10_12_3_1 ///
p10_12_3_2 ///
p10_12_3_3 p11_6 p11_7  ///

la var dominio "U’ ‘Urbano’ ‘C’ ‘Complemento urbano’ ‘R’ ‘Rural’"
gen urbano=.
replace urbano=1 if dominio=="U" | dominio=="C"
replace urbano=0 if dominio=="R"

save "$modif_Endir2016\Endir2016Limp1.dta", replace	
	
*************************************
*Estamos interesados en la cantidad de violaciones por año a nivel municipal
quietly use "$modif_Endir2016\Endir2016Limp1.dta", clear
collapse (sum) p10_1_3 [aw=fac_muj], by (cve_mun nom_mun cve_ent nom_ent grupo)
gen anio=2016
rename cve_mun CVE_MUN
rename cve_ent CVE_ENT
drop if grupo==1
drop grupo
save "$modif_Endir2016\Endir2016ViolacMun.dta", replace


*Estamos interesados en la cantidad de violaciones por año a nivel estado
quietly use "$modif_Endir2016\Endir2016Limp1.dta", clear
collapse (sum) p10_1_3 [aw=fac_muj], by (cve_ent nom_ent grupo)
gen anio=2016
rename cve_ent CVE_ENT
drop if grupo==1
drop grupo
save "$modif_Endir2016\Endir2016ViolacEst.dta", replace

*Hacemos merge con la población por municipio y calculamso tasa
quietly use "$pob\pob_mun_imp.dta", clear
merge 1:m CVE_ENT CVE_MUN using "$modif_Endir2016\Endir2016ViolacMun.dta"
keep if _merge==3
drop _merge
gen tasaViol2016=p10_1_3/a2010*1000
la var tasaViol2016 "tasa de violación"
save "$modif_Endir2016\Endir2016TasaViolMun.dta", replace



*Hacemos merge con la población por Edo y caclulamos tasa
quietly use "$pob\pob_Edos.dta", clear
merge 1:m CVE_ENT using "$modif_Endir2016\Endir2016ViolacEst.dta"
keep if _merge==3
drop _merge
gen tasaViol2016Edo=p10_1_3/a2010*1000
la var tasaViol2016 "tasa de violación Edos"
save "$modif_Endir2016\Endir2016TasaViolEdos.dta", replace


***¿?CREO QUE TIENE ERROR
*Quien las obliga Violacion por Estados
use "$modif_Endir2016\Endir2016Limp1.dta", clear
drop grupo
collapse (sum) p10_1_3 [aw=fac_muj], by (cve_ent nom_ent p10_2_3_1)
gen year=2016

rename cve_ent CVE_ENT

save "$modif_Endir2016\Endir2016QuienViolacEst.dta", replace


*****************************************************************


*********************************************************************************
*ENDIREH                                                                        *
*Union de bases - Tasa de violencia                                             *        
*********************************************************************************

**
***Endireh Uniendo indices de violencia 3 años
***Solo donde se pudieron calcular
***2006, 2011, 2016

global modifEnF = "E:\Embarazo\modif_Endir"
global modif_Endir2016 = "E:\Embarazo\modif_Endir\Endir2016"
global modif_Endir2011 = "E:\Embarazo\modif_Endir\Endir2011"
global modif_Endir2006 = "E:\Embarazo\modif_Endir\Endir2006"

***************************
*******Año 2016


*Ponemos bonita para unir 2016

use "$modif_Endir2016\Endir2016TasaViolEdos.dta", clear
rename tasaViol2016 TViol2016
la var TViol2016 "tasa violacion Estados 2016 por cada 1000 adolescentes"
drop a1990 a1995 a2000 a2005 a2010
rename anio year
la var year "año"
rename p10_1_3 NumOblRSex2016
la var NumOblRSex2016 "Num event obliga a Rel sex a adolesc en 2016 "
save "$modifEnF\TasaViol2016.dta", replace


***************************
*******Año 2011

***Ponemos bonita 2011

*Violacion
use "$modif_Endir2011\Endir2011TasaViolEdos.dta", clear
rename tasaViol2011Edo TViol2011
la var TViol2011 "tasa violacion Estados 2011 por cada 1000 adolescentes"
drop a1990 a1995 a2000 a2005 a2010
rename anio year
la var year "año"
rename Obli_RelSx NumOblRSex2011
la var NumOblRSex2011 "Num event obliga a Rel sex a adolesc en 2011 "
save "$modifEnF\TasaViol2011.dta", replace

*Quienes/Quien las obliga
use "$modif_Endir2011\Endir2011QuienViolacEst.dta", clear
la var QuinObli_RelSx "quien las obliga"
rename QuinObli_RelSx QuinObli_RelSx2011
la var CVE_ENT "entidad"
rename Obli_RelSx NumEventAb2011
la var NumEventAb2011 "Numero de eventos reportados donde obligan a la adolescente a tener rel.sex 2011"
rename anio year
la var year "año"
save "$modifEnF\QuienViolac2011.dta", replace


/**********Tal vez no necesario
*Obligan a cambio de dinero
*Hacemos merge con la población por Edo y caclulamos tasa
use "$modif_Endir2011\Endir2011TasaSexDinEdos.dta", clear
rename tasaSexDin2011Edo TSexDin2011
drop a1990 a1995 a2000 a2005 a2010
save "$modifEnF\TasaSexDin2011.dta", replace

*Quien las obliga a cambio de dinero
use "$modif_Endir2011\Endir2011QuienSexDinEdos.dta", clear
la var QuinObli_RelSxDin "Quien las obliga a cambio de dinero"	
la var CVE_ENT "entidad"
rename Obli_RelSxDin NumEventAbusoDin
la var NumEventAbusoDin "Num eventos reportados donde obligan a la adolescente a tener rel.sex por dinero"
save "$modifEnF\QuienSexDin2011.dta", replace
**Datos por entidad de quien las obliga//En gral desconocidos.*/


***************************
*******Año 2006


***Integramos indice 2006
*Tasa Violacion 2006 
use "$modif_Endir2006\Endir2006TasaViolEdos.dta", clear
rename tasaViol2006Edo TViol2006
drop a1990 a1995 a2000 a2005 a2010
rename anio year
la var year "año"
rename P_ObligRelSex NumOblRSex2006
la var NumOblRSex2006 "Num event obliga a Rel sex a adolesc en 2006 "
save "$modifEnF\TasaViol2006.dta", replace

***Quien las obliga 

*Quien las obliga
*Estamos interesados en quien hace  violaciones por año a nivel estado
use "$modif_Endir2006\Endir2006QuienViolacEst.dta", clear
rename PQn_ObligRelSex QuinObli_RelSx2006
la var QuinObli_RelSx2006 "quien las obliga 2006"
la var CVE_ENT "entidad"
rename P_ObligRelSex NumEventAb2006
la var NumEventAb2006 "Numero de eventos reportados donde obligan a la adolescente a tener rel.sex 2006"
rename anio year
la var year "año"
save "$modifEnF\QuienViolac2006.dta", replace


********************
*******Unimos las tasas de violacion por entidad

use "$modifEnF\TasaViol2016.dta", clear
mmerge CVE_ENT using "$modifEnF\TasaViol2011.dta"
drop _merge
mmerge CVE_ENT using "$modifEnF\TasaViol2006.dta"
drop _merge
drop year
save "$modifEnF\TasaViolTodos_wide.dta", replace

****Unimos tasas Long
*Primero renombramos 

use "$modifEnF\TasaViol2016.dta", clear
rename NumOblRSex2016 NumOblRSex
rename TViol2016 TViol
la var nom_ent "Nombre entidad"
la var TViol "Tasa de violación por cada 1000 adolescentes"
save "$modifEnF\TasaViol2016Long.dta", replace


use "$modifEnF\TasaViol2011.dta", clear
rename NumOblRSex2011 NumOblRSex
rename TViol2011 TViol
save "$modifEnF\TasaViol2011Long.dta", replace


use "$modifEnF\TasaViol2006.dta", clear
rename NumOblRSex2006 NumOblRSex
rename TViol2006 TViol
save "$modifEnF\TasaViol2006Long.dta", replace

***HAcemos append para generar base long

use "$modifEnF\TasaViol2016Long.dta", clear
append using "$modifEnF\TasaViol2011Long.dta"
append using "$modifEnF\TasaViol2006Long.dta"

save "$modifEnF\TasaViolTodos_long.dta", replace



*****************************************************************


*********************************************************************************
*ENDIREH                                                                        *
*Tasa de violencia infantil                                                     *        
*********************************************************************************


**ENDIREH 2003

****Configuración base para tiempo
clear all
set more off
set rmsg on, permanently 

global Orig_Endir2003 = "E:\Embarazo\Bdatos\ENDIREH\2003\base_datos_endireh03_dbf\Endireh2003"
global Orig_Endir2006 = "E:\Embarazo\Bdatos\ENDIREH\2006\base_datos_endireh06_dbf"
global Orig_Endir2011 = "E:\Embarazo\Bdatos\ENDIREH\2011\base_datos_endireh11_dbf"
global Orig_Endir2016 = "E:\Embarazo\Bdatos\ENDIREH\2016\bd_mujeres_endireh2016_sitioinegi_stata"
global modif_Endir2006 = "E:\Embarazo\modif_Endir\Endir2006"
global modif_Endir2011 = "E:\Embarazo\modif_Endir\Endir2011"
global modif_Endir2016 = "E:\Embarazo\modif_Endir\Endir2016"
global modif_Endir = "E:\Embarazo\modif_Endir\Violencia"
global pob = "E:\Embarazo\modif\Poblacion"

***2003
use "$Orig_Endir2003\nacionalcv.dta", clear
decode LLAVE, generate(llave)
keep llave TIPO
gen entidad=substr(llave,1,2)
save "$modif_Endir\nacional03.dta", replace

use "$Orig_Endir2003\nacionalds.dta", clear
decode LLAVE, generate(llave)
keep llave SEXO EDAD FAC_POB
save "$modif_Endir\DS03.dta", replace

use "$modif_Endir\nacional03.dta", clear
mmerge llave using "$modif_Endir\DS03.dta"
keep if _merge==3
drop _merge
save "$modif_Endir\nacional03.dta", replace

use "$Orig_Endir2003\nacionalm1.dta", clear
decode LLAVE, generate(llave)
keep llave LEPEGABA ESOOCU INSUTABA OCURESO
destring LEPEGABA ESOOCU INSUTABA OCURESO, replace
gen pegaban=.
	replace pegaban=1 if LEPEGABA==1
	replace pegaban=0 if LEPEGABA>=2 & LEPEGABA<=4
gen peg_Seguido=.
	replace peg_Seguido=1 if ESOOCU==2 | ESOOCU==3
	replace peg_Seguido=0 if ESOOCU==1| ESOOCU==4 | ESOOCU==5
gen insultaban=.
	replace insultaban=1 if INSUTABA==1
	replace insultaban=0 if INSUTABA>=2 & INSUTABA<=4
gen insul_Seguido=.
	replace insul_Seguido=1 if OCURESO==2 | OCURESO==3
	replace insul_Seguido=0 if OCURESO==1| OCURESO==4 | OCURESO==5

**Generamso variable alta violencia si peg_seguido =1 y insultseguido=1

gen Hi_enfan_violenc=0
	replace Hi_enfan_violenc=1 if peg_Seguido==1 | insul_Seguido==1
	
save "$modif_Endir\nacMuj1_03.dta", replace


**Unimos base a nacional 3 para discriminar por  sexo = Mujer
 use "$modif_Endir\nacional03.dta", clear
 mmerge llave using "$modif_Endir\nacMuj1_03.dta"
 keep if _merge==3
 drop _merge
 la var SEXO "1 Hombre 2 Mujer"
 drop if SEXO==1
 save "$modif_Endir\violencia_infancia2003.dta", replace
 
 ****Estimamos mujeres que sufrieron violencia 
 
use "$modif_Endir\violencia_infancia2003.dta", clear
la var FAC_POB "factor de población"
collapse (sum) Hi_enfan_violenc [aw=FAC_POB] , by (entidad)
la var  Hi_enfan_violenc "Num de mujeres que padecio violencia en la infancia en 2003"
gen year=2003
save "$modif_Endir\Muj_Hi_viol_infan_Edos_2003.dta", replace


************************************
*ENDIREH 2006
************************************

***PAra violencia infantil 
*TVivienda
*Para obtener factor de vivienda y si es rural o urbano, además 
*llaves para unir con otros: control y viv_sel

quietly use "$Orig_Endir2006\06_DS.dta", clear
keep N_CON V_SEL N_REN SEXO EDAD DOM
la var SEXO "sexo 1:H 2:M"
la var EDAD "Edad en años"
keep if SEXO==2
decode N_CON, generate (n_con)
decode V_SEL, generate (v_sel)

save "$modif_Endir\2006_DSLimpV.dta", replace
*Tiene a todas las mujeres de la encuesta (mayores de 15 años)
**************************

*para cuestionario MujC1
use "$modif_Endir2006\06_MC1Limp.dta", clear
keep N_CON V_SEL N_REN P5_5 P5_7 FAC_PER DOM
decode N_CON, generate (n_con)
gen entidad=substr(n_con,1,2)
decode V_SEL, generate (v_sel)
*guarda base para violencia en infancia
save "$modif_Endir\2006_MC1LimpV.dta", replace

***para cuest MujD1
use "$modif_Endir2006\06_MD1Limp.dta", clear
keep N_CON V_SEL N_REN P5_5 P5_7 FAC_PER DOM
decode N_CON, generate (n_con)
gen entidad=substr(n_con,1,2)
decode V_SEL, generate (v_sel)
save "$modif_Endir\2006_MD1LimpV.dta", replace


***
*Hacemos append de 2 cuestionarios, pues a mujeres solteras no le hacen la pregunta de violencia infantil familiar

quietly use "$modif_Endir\2006_MC1LimpV.dta", clear
append using "$modif_Endir\2006_MD1LimpV.dta"
save "$modif_Endir\TodaEdadmujeres2006V.dta", replace

*HAcemos merge para distinguir sexo
use "$modif_Endir\TodaEdadmujeres2006V.dta", clear
mmerge n_con v_sel using "$modif_Endir\2006_DSLimpV.dta"
keep if SEXO==2
*drop if _merge==2
replace entidad=substr(n_con,1,2)
drop _merge

gen peg_Seguido=.
	replace peg_Seguido=1 if P5_5==2 
	replace peg_Seguido=0 if P5_5!=2
gen insul_Seguido=.
	replace insul_Seguido=1 if P5_7==2 
	replace insul_Seguido=0 if P5_7!=2
**Generamso variable alta violencia si peg_seguido =1 y insultseguido=1
gen Hi_enfan_violenc=0
	replace Hi_enfan_violenc=1 if peg_Seguido==1 | insul_Seguido==1
	

save "$modif_Endir\violencia_infancia2006.dta", replace

****Estimamos mujeres que sufrieron violencia en 2006
 
use "$modif_Endir\violencia_infancia2006.dta", clear
la var FAC_PER "factor de persona"
collapse (sum) Hi_enfan_violenc [aw=FAC_PER] , by (entidad)
la var  Hi_enfan_violenc "Num de mujeres que padecio violencia en la infancia en 2006"
gen year=2006
save "$modif_Endir\Muj_Hi_viol_infan_Edos_2006.dta", replace



************************************
*ENDIREH 2011                      *
************************************

***PAra violencia infantil 
*USamos cuertionarios procesados
*Para obtener factor de vivienda y si es rural o urbano, además 

*DEmografico con edad y sexo
quietly use "$Orig_Endir2011\dtaTSDem.dta", clear
keep CONTROL VIV_SEL HOGAR N_REN SEXO EDAD FAC_VIV DOMINIO
*keep if SEXO==2
decode CONTROL, generate (control)
decode VIV_SEL, generate (viv_sel)
la var SEXO "Sexo 1:H 2:Mujer"
save "$modif_Endir\2011_SDemV.dta", replace

*Usamos cuestionarios de mujeres Con PAreja y sin pareja, (Solteras no incluye esa info)

use "$modif_Endir2011\dtaTUnidas12011Limp.dta", clear
keep CONTROL VIV_SEL HOGAR R_SEL_M AP3_2 AP3_3 FAC_PER
decode CONTROL, generate (control)
decode VIV_SEL, generate (viv_sel)
gen entidad=substr(control,1,2)
la var AP3_2 "¿¿Las personas con las que vivía le pegaban a usted …2 seguido"
la var AP3_3 "¿Recuerda si las personas con las que vivía la insultaban o la ofendían …2 seguido"
save "$modif_Endir\2011_TUnidasV.dta", replace


use "$modif_Endir2011\dtaTDunida12011Limp.dta", clear
keep CONTROL VIV_SEL HOGAR R_SEL_M BP3_2 BP3_3 FAC_PER
decode CONTROL, generate (control)
decode VIV_SEL, generate (viv_sel)
gen entidad=substr(control,1,2)
rename BP3_2 AP3_2
rename BP3_3 AP3_3
save "$modif_Endir\2011_TDUnidasV.dta", replace

***
*Hacemos append de 2 cuestionarios, pues a mujeres solteras no le hacen la pregunta de violencia infantil familiar

quietly use "$modif_Endir\2011_TUnidasV.dta", clear
append using "$modif_Endir\2011_TDUnidasV.dta"
save "$modif_Endir\TodaEdadmujeres2011V.dta", replace

*********
****
*HAcemos merge para distinguir sexo
use "$modif_Endir\TodaEdadmujeres2011V.dta", clear
mmerge control viv_sel using "$modif_Endir\2011_SDemV.dta"
keep if SEXO==2
replace entidad=substr(control,1,2)
drop _merge

gen peg_Seguido=.
	replace peg_Seguido=1 if AP3_2==2 
	replace peg_Seguido=0 if AP3_2!=2
gen insul_Seguido=.
	replace insul_Seguido=1 if AP3_3==2 
	replace insul_Seguido=0 if AP3_3!=2
**Generamso variable alta violencia si peg_seguido =1 y insultseguido=1
gen Hi_enfan_violenc=0
	replace Hi_enfan_violenc=1 if peg_Seguido==1 | insul_Seguido==1
	
save "$modif_Endir\violencia_infancia2011.dta", replace

****Estimamos mujeres que sufrieron violencia en 2011
 
use "$modif_Endir\violencia_infancia2011.dta", clear
la var FAC_PER "factor de persona"
collapse (sum) Hi_enfan_violenc [aw=FAC_PER] , by (entidad)
la var  Hi_enfan_violenc "Num de mujeres que padecio violencia en la infancia en 2011"
gen year=2011
save "$modif_Endir\Muj_Hi_viol_infan_Edos_2011.dta", replace


************************************
**ENDIREH 2016                     *
************************************

***PAra violencia infantil 
*USamos cuertionarios procesados
*Para obtener factor de vivienda y si es rural o urbano, además 

*DEmografico con edad y sexo
use "$modif_Endir2016\Endir2016Limp1.dta", clear	
keep sexo fac_muj p11_6 p11_7 urbano estrato id_viv id_muj c_unica c_viv c_hog cve_ent nom_ent cve_mun nom_mun

la var p11_6 "Las personas con las que vivía le pegaban a usted 2 seguido"
la var p11_7 "Recuerda si las personas con las que vivía la insultaban o la ofendían a usted 2seguido"
la var sexo "Sexo 1:H 2:Mujer"
keep if sexo==2

gen peg_Seguido=.
	replace peg_Seguido=1 if p11_6==2 
	replace peg_Seguido=0 if p11_6!=2
gen insul_Seguido=.
	replace insul_Seguido=1 if p11_7==2 
	replace insul_Seguido=0 if p11_7!=2
**Generamso variable alta violencia si peg_seguido =1 y insultseguido=1
gen Hi_enfan_violenc=0
	replace Hi_enfan_violenc=1 if peg_Seguido==1 | insul_Seguido==1

save "$modif_Endir\violencia_infancia2016.dta", replace


****Estimamos mujeres que sufrieron violencia en 2016
 
use "$modif_Endir\violencia_infancia2016.dta", clear
la var fac_muj "factor de la mujer"
collapse (sum) Hi_enfan_violenc [aw=fac_muj] , by (cve_ent nom_ent)
la var  Hi_enfan_violenc "Num de mujeres que padecio violencia en la infancia/reporte en 2016"
gen year=2016
save "$modif_Endir\Muj_Hi_viol_infan_Edos_2016.dta", replace


*****************
*********
***Uniformidad en nombres y variables de dif años para hacer append
***

use "$modif_Endir\Muj_Hi_viol_infan_Edos_2003.dta", clear

use "$modif_Endir\Muj_Hi_viol_infan_Edos_2006.dta", clear

use "$modif_Endir\Muj_Hi_viol_infan_Edos_2011.dta", clear

use "$modif_Endir\Muj_Hi_viol_infan_Edos_2016.dta", clear
rename cve_ent entidad
la var entidad "Entidad"
save "$modif_Endir\Muj_Hi_viol_infan_Edos_2016.dta", replace

use "$modif_Endir\Muj_Hi_viol_infan_Edos_2003.dta", clear
append using "$modif_Endir\Muj_Hi_viol_infan_Edos_2006.dta"
append using "$modif_Endir\Muj_Hi_viol_infan_Edos_2011.dta"
append using "$modif_Endir\Muj_Hi_viol_infan_Edos_2016.dta"
save "$modif_Endir\ViolenInfantEdos.dta", replace

***Importamos datos de población Mujeres todas las edades por estado
**Para generar tasa de violencia infantil 

clear all

import excel "E:\Embarazo\modif\Poblacion\Poblacion_TotMujeres_todasEdadesEdos1.xlsx", sheet("Poblacion_01") cellrange(A6:H38) clear

rename A entidad
rename B nom_ent
drop C 
rename D pobMuj1990
rename E pobMuj1995
rename F pobMuj2000
rename G pobMuj2005
rename H pobMuj2010

save "$pob\TodaEdadMuj_Pobla.dta", replace

*Hacer merge con pobla
use "$modif_Endir\ViolenInfantEdos.dta", clear
destring entidad, replace
mmerge entidad using "$pob\TodaEdadMuj_Pobla.dta"
keep if _merge==3
gen ViolInfant_Index=.
	replace ViolInfant_Index=Hi_enfan_violenc/pobMuj2000*1000 if year==2003
	replace ViolInfant_Index=Hi_enfan_violenc/pobMuj2005*1000 if year==2006
	replace ViolInfant_Index=Hi_enfan_violenc/pobMuj2010*1000 if year==2011
	replace ViolInfant_Index=Hi_enfan_violenc/pobMuj2010*1000 if year==2016

save"$modif_Endir\TasaViolenciaInfantMujer.dta", replace


*********************
****Municipal       *
*********************

****Estimamos mujeres que sufrieron violencia en 2016 a nivel municipal
 
use "$modif_Endir\violencia_infancia2016.dta", clear
la var fac_muj "factor de la mujer"
collapse (sum) Hi_enfan_violenc [aw=fac_muj] , by (cve_ent nom_ent cve_mun nom_mun)
la var  Hi_enfan_violenc "Num de mujeres que padecio violencia en la infancia/reporte en 2016(Mun)"
gen year=2016
rename cve_ent CVE_ENT
rename cve_mun CVE_MUN
save "$modif_Endir\Muj_Hi_viol_infan_Mun_2016.dta", replace


 
 ****HAgamos base para poblacion total de mujeres por estados y municipios
 clear
  
 import excel "E:\Embarazo\modif\Poblacion\INEGI_Exporta_20181104115859 Todas muj1 Limp.xlsx", sheet("INEGI_Exporta_20181104115859 To") cellrange(A7:H2470) firstrow
	rename A cve_mun_id
	rename B nom_mun
	rename C PobMuj1990
	rename D PobMuj1995
	rename E PobMuj2000
	rename F PobMuj2005
	rename G PobMuj2010
	drop H
gen cve_ent=substr(cve_mun_id,1,2)
gen cve_mun=substr(cve_mun_id,-3,.)

encode cve_ent, generate(tirar)

destring tirar, replace
recode tirar (34 33 = .)
keep if tirar!=.
drop tirar 
save "$pob\pob_Mun_TodaEdadMuj.dta", replace



**Hacer merge con pobla

use "$modif_Endir\Muj_Hi_viol_infan_Mun_2016.dta", clear


*Hacemos merge con la población por municipio y calculamos tasa violencia infantil
***2016
quietly use "$pob\pob_Mun_TodaEdadMuj.dta", clear
rename cve_ent CVE_ENT
rename cve_mun CVE_MUN
merge 1:m CVE_ENT CVE_MUN using "$modif_Endir\Muj_Hi_viol_infan_Mun_2016.dta"
keep if _merge==3
drop _merge
gen tasaViolEnfant2016=Hi_enfan_violenc/PobMuj2010*1000
la var tasaViolEnfant2016 "tasa de violencia infantil, reporte mujeres 2016"
save "$modif_Endir\TasaViol_Enfant_Mun.dta", replace

*2016 es el único año con datos disponibles a nivel municipal
