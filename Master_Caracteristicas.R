#Elaboración de gráficos sección características
#Responsables:
#Luis Valentín Cruz lvcruz@colmex.mx
#Lorena Ochoa alochoa@colmex.mx


#########################
#CARACTERISTICAS        #
#########################

#Limpia la memoria de R
rm(list = ls())
setwd("E:/Embarazo/scripts") 


#Declaramos los directorios que utilizaremos 

graf = "E:/Embarazo/graf"
datosnac = "E:/project/data/modif/Nacimientos"
datos_graf= "E:/Embarazo/dta_graf"




#########################
#ESTADO CIVIL           #
#########################

# Leer base de datos

#install.packages("readstata13")
library(readstata13)
require(htmltools)

library(RColorBrewer)

library(plotly)
#library("foreign")

TEPareja<- read.dta13(paste(datosnac,sep="/","pareja.dta"))

TEParejawide<- read.dta13(paste(datos_graf,sep="/","parejawide.dta"))

#Redondeamos porcentajes
TEParejawide$porcentaje0r<-round(TEParejawide$porcentaje0,digits=2)
TEParejawide$porcentaje1r<-round(TEParejawide$porcentaje1,digits=2)


#Hagamos el gráfico para pareja con puntos en las líneas

graf1<- plot_ly(TEParejawide, x = ~ANO_NAC ) %>%
  add_trace(y = ~porcentaje0, name = 'Sin pareja',mode = 'lines+markers',
            hoverinfo = 'text',
            text = ~paste('<br>Sin Pareja' , "<br> Año: ",ANO_NAC, '<br>Porcentaje:', porcentaje0r, '%'), line = list(color = 'rgb(22, 96, 167)', width = 4)) %>%
  add_trace(y = ~porcentaje1, name = 'Con pareja', mode = 'lines+markers', 
            hoverinfo = 'text',
            text = ~paste('<br>Con Pareja' ,"<br> Año: ",ANO_NAC, '<br>Porcentaje:', porcentaje1r, '%')) %>%
  layout(title = 'Estado civil de la madre al nacimiento',
         xaxis = list(title = "Año de nacimiento"),
         yaxis = list(side = 'left', title = 'Porcentaje (%)', showgrid = TRUE, zeroline = FALSE))
graf1


library(htmlwidgets)

#Guardamos la gráfica dinámica
saveWidget(graf1, file=paste(graf, "Con_Pareja.html",sep="/"),selfcontained = FALSE )


##########################
#OCUPACION DE LOS PADRES #
##########################


#proyecto Embarazo
#Hacemos graficos de caracteristicas


#Limpia la memoria de R
rm(list = ls())
setwd("E:/Embarazo/scripts") 


#Declaramos los directorios que utilizaremos 

graf = "E:/Embarazo/graf"
datosnac = "E:/project/data/modif/Nacimientos"
datos_graf= "E:/Embarazo/dta_graf"


################
####HAgamos para Trabajo de padres

# por trabajo de padres
# Leer base de datos

#install.packages("readstata13")
library(readstata13)
require(htmltools)

#library("foreign")

TrabPadres<- read.dta13(paste(datos_graf,sep="/","sitlab_pad_graf.dta"))
rownames(TrabPadres)<-c("Trabaja", "Estudia", "No estudia ni trabaja")



TraPad2012<- read.dta13(paste(datos_graf,sep="/","Tr_pad_2012graf.dta"))
rownames(TraPad2012)<-c("Trabaja", "Estudia", "No estudia ni trabaja")



#Haciendo Pie Hole
############################

library(plotly)
library(RColorBrewer)


#install.packages("readstata13")
library(readstata13)
require(htmltools)

#library("foreign")


TraPad2009<- read.dta13(paste(datos_graf,sep="/","Tr_pad_2009graf.dta"))
rownames(TraPad2009)<-c("Trabaja", "Estudia", "No estudia ni trabaja")


TraPad2012<- read.dta13(paste(datos_graf,sep="/","Tr_pad_2012graf.dta"))
rownames(TraPad2012)<-c("Trabaja", "Estudia", "No estudia ni trabaja")

TraPad2015<- read.dta13(paste(datos_graf,sep="/","Tr_pad_2015graf.dta"))
rownames(TraPad2015)<-c("Trabaja", "Estudia", "No estudia ni trabaja")


library(plotly)

p <- plot_ly(TraPad2009, labels = ~etiqueta, values = ~tot2009) %>%
  add_pie(hole=0.6) %>%
  layout(title = 'Ocupación de padres en 2009',showlegend = F,
         xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
         yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
p

library(htmlwidgets)

#Guardamos la gráfica dinámica
saveWidget(p, file=paste(graf, "OcupPadres2009.html",sep="/"),selfcontained = FALSE )



p1 <- plot_ly(TraPad2012, labels = ~etiqueta, values = ~tot2012)%>%
  add_pie(hole=0.6) %>%
  layout(title = 'Ocupación de padres en 2012',showlegend = F,
         xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
         yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
p1

#Guardamos la gráfica dinámica
saveWidget(p1, file=paste(graf, "OcupPadres2012.html",sep="/"),selfcontained = FALSE )


p2 <- plot_ly(TraPad2015, labels = ~etiqueta, values = ~tot2015) %>%
  add_pie(hole=0.6) %>%
  layout(title = 'Ocupación de padres en 2015',
         xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
         yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
p2

#Guardamos la gráfica dinámica
saveWidget(p2, file=paste(graf, "OcupPadres2015.html",sep="/"),selfcontained = FALSE )


###########################
###OCUPACION DE LAS MADRES#
###########################

###Leemos bases para madres

TraMad2009<- read.dta13(paste(datos_graf,sep="/","Tr_mad_2009graf.dta"))
rownames(TraMad2009)<-c("Trabaja", "Estudia", "No estudia ni trabaja")


TraMad2012<- read.dta13(paste(datos_graf,sep="/","Tr_mad_2012graf.dta"))
rownames(TraMad2012)<-c("Trabaja", "Estudia", "No estudia ni trabaja")

TraMad2015<- read.dta13(paste(datos_graf,sep="/","Tr_mad_2015graf.dta"))
rownames(TraMad2015)<-c("Trabaja", "Estudia", "No estudia ni trabaja")

#Prueba color
a<- c('#dd1c77', '#1F77B4', '#c994c7')
m <- plot_ly(TraMad2009, labels = ~etiqueta, values = ~tot2009) %>%
  add_pie(hole=0.6) %>%
  layout(title = 'Ocupación de madres en 2009',showlegend = F,
         xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE, domain = c(0.05, 0.30)),
         yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE, domain = c(0.05, 0.30))) 
m

#Guardamos la gráfica dinámica
saveWidget(m, file=paste(graf, "OcupMadres2009.html",sep="/"),selfcontained = FALSE )


m1 <- plot_ly(TraMad2012, labels = ~etiqueta, values = ~tot2012) %>%
  add_pie(hole=0.6) %>%
  layout(title = 'Ocupación de madres en 2012', showlegend = F,
         xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE, domain = c(0.35, 0.65)),
         yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE, domain = c(0.35, 0.65)))
m1

#Guardamos la gráfica dinámica
saveWidget(m1, file=paste(graf, "OcupMadres2012.html",sep="/"),selfcontained = FALSE )


m2 <- plot_ly(TraMad2015, labels = ~etiqueta, values = ~tot2015) %>%
  add_pie(hole=0.6) %>%
  layout(title = 'Ocupación de madres en 2015',
         xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE, domain = c(0.7, 0.95)),
         yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE, domain = c(0.7, 0.95)))
m2

#Guardamos la gráfica dinámica
saveWidget(m2, file=paste(graf, "OcupMadres2015.html",sep="/"),selfcontained = FALSE )

#####################################
#DIFERENCIA DE EDAD ENTRE LOS PADRES#
#####################################


#Limpia la memoria de R
rm(list = ls())
setwd("E:/Embarazo/scripts") 


#Declaramos los directorios que utilizaremos 

graf = "E:/Embarazo/graf"
datosnac = "E:/project/data/modif/Nacimientos"
datos_graf= "E:/Embarazo/dta_graf"


###Diferencia de edad

library(readstata13)
require(htmltools)

#library("foreign")

DifEdad<- read.dta13(paste(datos_graf,sep="/","dif_edadgraf1.dta"))

DifEdadlong <-read.dta13(paste(datos_graf,sep="/","dif_edadgraf_long.dta"))

DifEdMEdiana <-read.dta13(paste(datos_graf,sep="/","dif_edadgraf_mediana.dta"))


library(readstata13)
require(htmltools)

DifEdadlNVO <-read.dta13(paste(datos_graf,sep="/","dif_edadgraf_longNVO.dta"))

DifEdad$ref<-c(0,0,0,0,0)

library(ggplot2)
library(ggalt)
theme_set(theme_classic())

library(RColorBrewer)

png("GrafDif_Edad_PadresR1.png")

GrafA1<-ggplot(DifEdad, aes(y=EDAD_MADN, x=ref, xend=dif_median)) +
  geom_dumbbell(size=3, color="#e3e2e1",
                colour_x = "#5b8124", colour_xend = "#bad744",
                dot_guide=F, dot_guide_size=0.25,
                position=position_dodgev(height=0.4)) +
  labs(x="Diferencia de edad (Años)", y="Edad de la madre al nacimiento", title="Diferencia de edad entre padre y madre", subtitle = "Mediana") +
  theme_minimal() +
  theme(panel.grid.major.x=element_line(size=0.05))

GrafA1
setwd("E:/Embarazo/graf")
print(GrafA1)
dev.off()
ggsave("GrafDif_Edad_PadresR2.png",width = 20, height = 20, units = "cm")

setwd("E:/Embarazo/scripts") 


###############
#
##


#proyecto Embarazo
#Hacemos graficos de caracteristicas


#Limpia la memoria de R
rm(list = ls())
setwd("E:/Embarazo/scripts") 


#Declaramos los directorios que utilizaremos 

graf = "E:/Embarazo/graf"
datosnac = "E:/project/data/modif/Nacimientos"
datos_graf= "E:/Embarazo/dta_graf"




###############################
#Rural/Urbano 
# Leer base de datos

#install.packages("readstata13")
library(readstata13)
require(htmltools)

library(RColorBrewer)

library(plotly)
#library("foreign")

Ruralwide<- read.dta13(paste(datos_graf,sep="/","ruralwide.dta"))

#Redondeamos porcentajes creando nueva variable para grafico
Ruralwide$porcentaje0r<-round(Ruralwide$porcentaje0,digits=2)
Ruralwide$porcentaje1r<-round(Ruralwide$porcentaje1,digits=2)


#Hagamos el gráfico para pareja con puntos en las líneas

grafRural<- plot_ly(Ruralwide, x = ~ANO_NAC ) %>%
  add_trace(y = ~porcentaje0, name = 'Urbano',mode = 'lines+markers',
            hoverinfo = 'text',
            text = ~paste('<br>Urbano' , "<br> Año: ",ANO_NAC, '<br>Porcentaje:', porcentaje0r, '%', '<br>Num.embarazos:', embarazo0 ), line = list(color = 'rgb(22, 96, 167)', width = 4)) %>%
  add_trace(y = ~porcentaje1, name = 'Rural', mode = 'lines+markers', 
            hoverinfo = 'text',
            text = ~paste('<br>Rural' ,"<br> Año: ",ANO_NAC, '<br>Porcentaje:', porcentaje1r, '%', '<br>Num.embarazos:', embarazo1)) %>%
  layout(title = 'Residencia de la madre al nacimiento',
         xaxis = list(title = "Residencia de la madre al nacimiento"),
         yaxis = list(side = 'left', title = 'Porcentaje (%)', showgrid = TRUE, zeroline = FALSE))
grafRural


library(htmlwidgets)

#Guardamos la gráfica dinámica Rural
saveWidget(grafRural, file=paste(graf, "Rural.html",sep="/"),selfcontained = FALSE )


######################################
#RESIDENCIA DE LA MADRE AL NACIMIENTO#
######################################

#Rural/Urbano 
# Leer base de datos

#install.packages("readstata13")
library(readstata13)
require(htmltools)

library(RColorBrewer)

library(plotly)
#library("foreign")

#Hagamos el gráfico para pareja con puntos en las líneas

grafRural1<- plot_ly(Ruralwide, x = ~ANO_NAC, type="scatter",y = ~porcentaje0, name = 'Urbano',mode = 'lines+markers',
                     hoverinfo = 'text',marker = list(color='goldenrod'),
                     text = ~paste('<br>Urbano' , "<br> Año: ",ANO_NAC, '<br>Porcentaje:', porcentaje0r, '%', '<br>Num.embarazos:', embarazo0 ), line = list(color = 'goldenrod', width = 4)) %>%
  add_trace(y = ~porcentaje1, name = 'Rural', mode = 'lines+markers', type="scatter",
            hoverinfo = 'text',marker = list(color='limegreen'),
            text = ~paste('<br>Rural' ,"<br> Año: ",ANO_NAC, '<br>Porcentaje:', porcentaje1r, '%', '<br>Num.embarazos:', embarazo1), line = list(color = 'limegreen', width = 4)) %>%
  layout(title = 'Residencia de la madre al nacimiento',
         xaxis = list(title = "Años"),
         yaxis = list(side = 'left', title = 'Porcentaje (%)', showgrid = TRUE, zeroline = FALSE))
grafRural1


library(htmlwidgets)

#Guardamos la gráfica dinámica Rural
saveWidget(grafRural1, file=paste(graf, "Rural1.html",sep="/"),selfcontained = FALSE )


####################
#MES DE NACIMIENTO##
####################

rm(list=ls())
setwd("E:/econometria_aplicada/project")

library(haven)
library(RColorBrewer)
library(ggplot2)
library("viridisLite", lib.loc="~/R/win-library/3.5")
library(viridis)

#Directorios 
grafs = "E:/econometria_aplicada/project/graficos"
datos = "E:/econometria_aplicada/project/data/modif/Nacimientos"

#Meses en que nacen mas bebes

mes_nac<-read_dta(paste(datos, "mes_nac.dta", sep="/"))


g1 <- ggplot(mes_nac,aes(x=ANO_NAC,y=MES_NAC,fill=embarazo)) +
  scale_fill_viridis(name="Nacimientos", option="A",guide = "colourbar" )+
  labs(x="",y="",title="Número de nacimientos") +
  scale_x_continuous(expand=c(0,0),breaks = seq(1990,2016,5)) +
  scale_y_continuous(expand=c(0,0),breaks = seq(1,12,1), labels = c("Ene","Feb","Mar","Abr","May","Jun","Jul","Ago","Sep","Oct","Nov","Dic")) +
  coord_fixed()+
  geom_tile(colour="white",size=0.25, show.legend=TRUE) +
  theme(
    legend.title=element_blank(),
    legend.margin = grid::unit(0,"cm"),
    legend.key.height=grid::unit(0.8,"cm"),
    legend.key.width=grid::unit(0.2,"cm"),
    axis.text.x=element_text(size=12),
    axis.text.y=element_text(vjust = 0.2, size = 12),
    axis.ticks=element_line(size=0.4),
    plot.title=element_text(hjust=0,size=14,face="bold"),
    plot.background=element_blank(),
    panel.border=element_blank()
  )
g1
ggsave(paste(grafs, "Mes_nac.png", sep="/"), plot=g1)

p1 <- ggplot(mes_nac,aes(x=ANO_NAC,y=MES_NAC,fill=porcentaje)) +
  scale_fill_viridis(name="%", option="A",guide = "colourbar" )+
  labs(x="",y="",title="Número de nacimientos") +
  scale_x_continuous(expand=c(0,0),breaks = seq(1990,2016,5)) +
  scale_y_continuous(expand=c(0,0),breaks = seq(1,12,1), labels = c("Ene","Feb","Mar","Abr","May","Jun","Jul","Ago","Sep","Oct","Nov","Dic")) +
  coord_fixed()+
  geom_tile(colour="white",size=0.25, show.legend=TRUE) +
  theme(
    legend.margin = grid::unit(0,"cm"),
    legend.key.height=grid::unit(0.8,"cm"),
    legend.key.width=grid::unit(0.2,"cm"),
    axis.text.x=element_text(size=10),
    axis.text.y=element_text(vjust = 0.2, size = 10),
    axis.ticks=element_line(size=0.4),
    plot.title=element_text(hjust=0,size=12,face="bold"),
    plot.background=element_blank(),
    panel.border=element_blank()
  )
p1
ggsave(paste(grafs, "Mes_nac_porc.png", sep="/"), plot=p1)

################
#ANTICONCEPTIVO#
################


#Treemaps
require(treemap)

datos1 = "E:/econometria_aplicada/project/data/modif/ENADID"

anticoncep <- read_dta(paste(datos1, "antic1ra_rs.dta", sep="/"))
ant <- subset(anticoncep,year==2014)
ant$label = c("Dispositivo",
              "Hormonales",
              "Condón",
              "Otro",
              "Ninguno")

g2 <- treemap(ant, index="label", vSize="porcentaje", vColor="antic", type="index", 
              title="Método anticonceptivo utilizado en la primera relación sexual", palette="YlGnBu", 
              title.legend="", border.col="white", border.lwd=0.5, fontsize.title=13, 
              fontsize.labels=14, fontface.title=2,overlap.labels=0.5)

png(paste(grafs, "anticonceptivo.png", sep="/"))
treemap(ant, index="label", vSize="porcentaje", vColor="antic", type="index", 
        title="Método anticonceptivo utilizado en la primera relación sexual", palette="YlGnBu", 
        title.legend="", border.col="white", border.lwd=0.5, fontsize.title=14, 
        fontsize.labels=20,overlap.labels=0.5)
dev.off() 

############
#RAZONES ###
############

razones <- read_dta(paste(datos1, "razones.dta", sep="/"))
razones$label = c("Quería embarazarse",
                  "No conocía los métodos, no sabía como usarlos o cómo obtenerlos",
                  "Se opuso su pareja",
                  "No creyó que podría quedar embarazada",
                  "No estaba de acuerdo con el uso de anticonceptivos",
                  "No planeaba tener relaciones sexuales",
                  "Le dio pena",
                  "Otra razón")

g3 <- treemap(razones, index="label", vSize="porcentaje", vColor="razon", type="index", 
              title="Razones por las que no usó anticonceptivos en la primera relación sexual", palette="YlGnBu", 
              title.legend="", border.col="white", border.lwd=0.5, fontsize.title=11, 
              fontsize.labels=10, fontface.title=2,overlap.labels=0.5)

png(paste(grafs, "razones.png", sep="/"))
treemap(razones, index="label", vSize="porcentaje", vColor="razon", type="index", 
        title="Razones por las que no usó anticonceptivos en la primera relación sexual", palette="YlGnBu", 
        title.legend="", border.col="white", border.lwd=0.5, fontsize.title=12, 
        fontsize.labels=10, fontface.title=2,overlap.labels=0.5)
dev.off() 


