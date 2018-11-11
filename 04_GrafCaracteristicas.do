*Procesamiento bases para graficos

*Responsables:
*Luis Valentín Cruz lvcruz@colmex.mx
*Lorena Ochoa alochoa@colmex.mx
*********************************************************************************
*Graficas de características                                                                   *
*Embarazo                                                                       *
*********************************************************************************
***Grafica Caracteristicas 
***

*Pareja

global data="E:\project\data\modif\Nacimientos"
global dta_graf= "E:\Embarazo\dta_graf"
global modif="E:\project\data\modif\ENADID"


clear all
use"$data\pareja.dta", clear
reshape wide tot embarazo porcentaje, i(ANO_NAC) j(pareja)
save "$dta_graf\parejawide.dta",replace



***Dif de edad de los padres

use"$data\dif_edad.dta", clear
gen edad_mad=EDAD_MADN
tostring EDAD_MADN, replace
replace EDAD_MADN=EDAD_MADN+" años"
la var EDAD_MADN "Edad de la madre"
la var dif_mode "Moda Diferencia de edad"
la var dif_mean "Promedio Diferencia de edad"
la var dif_median "Mediana Diferencia de edad"

save "$dta_graf\dif_edadgraf.dta",replace

use "$dta_graf\dif_edadgraf.dta",clear
gen ed_pad_mode=edad_mad + dif_mode
gen ed_pad_mean=edad_mad + dif_mean
gen ed_pad_median=edad_mad + dif_median
save "$dta_graf\dif_edadgraf1.dta",replace



**Queremos hacerla long
use "$dta_graf\dif_edadgraf.dta",clear
rename dif_mode dif1 
**1 es moda
rename dif_mean dif2
**2 es promedio
rename dif_median dif3
**3 es mediana
reshape long dif, i(EDAD_MADN) j(tipo)

gen TIPO="."
	replace TIPO="Moda" if tipo==1
	replace TIPO="Promedio" if tipo==2
	replace TIPO="Mediana" if tipo==3

gen edad_pad=edad_mad + dif
la var edad_pad "Edad del padre"
la var edad_mad "Edad de la madre"
label var EDAD_MADN
la var EDAD_MADN "Edad de la madre String"

replace EDAD_MADN=EDAD_MADN +" "+TIPO

save "$dta_graf\dif_edadgraf_long.dta",replace

************
****Nuevo
************

use "$dta_graf\dif_edadgraf_long.dta",replace
replace EDAD_MADN=substr(EDAD_MADN,1,8)
save "$dta_graf\dif_edadgraf_longNVO.dta",replace


****Situacion laboral de padre
*Sea si=1 y no=0
*Definimos las siguientes variables
*Solo trabaja: trabaja
*Solo estudia: estudia
*Trabaja y estudia: tye
*No trabaja ni estudia: ntne

**PAdre
use "$data\sitlab_pad.dta", clear
gen tipo=.
	replace tipo=1 if trabaja_p==1
	*Tipo=1 padre trabaja
	replace tipo=2 if estudia_p==1
	*Tipo2, estudia
	replace tipo=3 if tye_p==1
	*Tipo3, trabaja y estudia
	replace tipo=4 if ntne_p==1
	*Tipo 4, no estudia ni trabaja
drop trabaja_p estudia_p tye_p ntne_p
reshape wide tot porcentaje totales, i(tipo) j(ANO_NAC)
gen etiqueta="."
	replace etiqueta="Trabaja" if tipo==1
	replace etiqueta="Estudia" if tipo==2
	replace etiqueta="Trabaja y estudia" if tipo==3
	replace etiqueta="No estudia ni trabaja" if tipo==4
save "$dta_graf\sitlab_pad_graf.dta",replace


use "$dta_graf\sitlab_pad_graf.dta",clear
keep etiqueta tot2012
order etiqueta tot2012
save "$dta_graf\Tr_pad_2012graf.dta",replace


use "$dta_graf\sitlab_pad_graf.dta",clear
keep etiqueta tot2015
order etiqueta tot2015
save "$dta_graf\Tr_pad_2015graf.dta",replace


use "$dta_graf\sitlab_pad_graf.dta",clear
keep etiqueta tot2009
order etiqueta tot2009
save "$dta_graf\Tr_pad_2009graf.dta",replace


**MAdre
use "$data\sitlab_mad.dta", clear
gen tipo=.
	replace tipo=1 if trabaja_m==1
	*Tipo=1 padre trabaja
	replace tipo=2 if estudia_m==1
	*Tipo2, estudia
	replace tipo=3 if tye_m==1
	*Tipo3, trabaja y estudia
	replace tipo=4 if ntne_m==1
	*Tipo 4, no estudia ni trabaja
drop trabaja_m estudia_m tye_m ntne_m
reshape wide tot porcentaje totales, i(tipo) j(ANO_NAC)
gen etiqueta="."
	replace etiqueta="Trabaja" if tipo==1
	replace etiqueta="Estudia" if tipo==2
	replace etiqueta="Trabaja y estudia" if tipo==3
	replace etiqueta="No estudia ni trabaja" if tipo==4
save "$dta_graf\sitlab_mad_graf.dta",replace



use "$dta_graf\sitlab_mad_graf.dta",clear
keep etiqueta tot2012
order etiqueta tot2012
save "$dta_graf\Tr_mad_2012graf.dta",replace


use "$dta_graf\sitlab_mad_graf.dta",clear
keep etiqueta tot2015
order etiqueta tot2015
save "$dta_graf\Tr_mad_2015graf.dta",replace


use "$dta_graf\sitlab_mad_graf.dta",clear
keep etiqueta tot2009
order etiqueta tot2009
save "$dta_graf\Tr_mad_2009graf.dta",replace

****Para lugar de residencia
****Rural/urbano

use "$data\rural.dta", clear
reshape wide totales embarazo porcentaje, i(ANO_NAC) j(rural)
*El cero se refiere a urbano y el 1 a rural
save "$dta_graf\ruralwide.dta",replace


*************
**********
****Graficos sexualidad

**Edad de la primera relacion sexual en mujeres jovenes 15-19años


use "$modif\1ra_rs", clear



*¿Qué metodo anticonceptivo utilizó la primera relacién sexual 2009, 2014?

*Operación masculina o vasectomía
*Dispositivo, DIU o aparato
*Hormonales (pastillas, inyecciones, implante subdérmico, parche, pastilla de emergencia)
*Condon
*Otro(óvulos, calendario, coito interrumpido)
*No usar nada

use "$modif\antic1ra_rs.dta", clear

gen tipo="."
	replace gen="Operación masculina o vasectomía" if antic==1
	replace gen="Dispositivo, DIU o aparato" if antic==2
	replace gen="Hormonales (pastillas, inyecciones, implante subdérmico, etc)" if antic==3
	replace gen="Preservativo/Condón" if antic==4
	replace gen="Otro(óvulos, calendario, coito interrumpido)" if antic==5
	replace gen="No usar nada" if antic==6


*2014 ¿Por qué no usó algún método anticonceptivo en la primera relación sexual?

*1 Quería embarazarse
*2 No conocía los métodos, no sabía como usarlos o cómo obtenerlos
*3 Se opuso su pareja
*4 No creyó que podría quedar embarazada
*5 No estaba de acuerdo con el uso de anticonceptivos
*6 No planeaba tener relaciones sexuales
*7 Le dio pena
*8 Otra razón

use "$modif\razones.dta", clear
gen tipo="."
	replace tipo="Quería embarazarse" if razon==1
	replace tipo="Desconocimiento" if razon==2
	replace tipo="Se opuso su pareja" if razon==3
	replace tipo="No creyó que podría quedar embarazada" if razon==4
	replace tipo="No estaba de acuerdo con el uso de anticonceptivos" if razon==5
	replace tipo="No planeaba tener relaciones sexuales" if razon==6
	replace tipo="Le dio pena" if razon==7
	replace tipo="Otra razón" if razon==8
save "$dta_graf\razonesgraf.dta",replace

