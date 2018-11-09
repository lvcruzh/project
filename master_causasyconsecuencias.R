#Elaboracion de graficos seccion causas y consecuencias
#Responsables:
#Luis Valentin Cruz lvcruz@colmex.mx
#Lorena Ochoa alochoa@colmex.mx

rm(list = ls())
#########################
# GRAFICOS CORRELACIONES
#########################

datos = "E:/econometria_aplicada/project/data/database/causas"
datos1 = "E:/econometria_aplicada/project/data/database/consecuencias"

library(haven)
library("xts", lib.loc="~/R/win-library/3.5")
library("zoo", lib.loc="~/R/win-library/3.5")
library("PerformanceAnalytics")

#Causas
data = read_dta(paste(datos, "causas.dta", sep="/"))
data$`Tasa de fertilidad` = data$tasa_emb 
data$tasa_emb <- NULL

data$`Tasa de violencia sexual` = data$TViol 
data$TViol <- NULL
  
data$`Tasa de violencia infantil` = data$ViolInfant_Index
data$ViolInfant_Index <- NULL

data$CVE_ENT <- NULL

chart.Correlation(data, histogram = T, pch= 19)

#Consecuencias
data1 = read_dta(paste(datos1, "corr_consecuences.dta", sep="/"))
data1$cve_ent <- NULL

data1$`Tasa de fertilidad` = data1$tasa
data1$tasa <- NULL

data1$`Ingreso mensual` = data1$imr
data1$imr <- NULL

data1$`Escolaridad` = data1$ano_edu
data1$ano_edu <- NULL

data1$`Pobreza` = data1$pobreza
data1$pobreza <- NULL

chart.Correlation(data1, histogram = T, pch= 19)

rm(list = ls())
##################
#MAPAS LEAFLET
##################
install.packages(zoo)
install.packages(xts)
if (!require("devtools")) {
  install.packages("devtools")
}
devtools::install_github("diegovalle/mxmaps")

library(mxmaps)
library(leaflet) 
library(scales)
library(haven)
library(htmlwidgets)

datos = "F:/econometria_aplicada/project/data/database/consecuencias"
graf = "F:/econometria_aplicada/project/graficos"

#Consecuencias
consecuencias <- read_dta(paste(datos,"corr_consecuences.dta", sep="/"))
consecuencias$region = consecuencias$cve_ent
consecuencias$cve_ent <- NULL

df_mxstate <- merge(df_mxstate,consecuencias,by="region")

#Ingreso
df_mxstate$value <- df_mxstate$imr
pal <- colorNumeric("BuPu", domain = df_mxstate$value)
map1<- mxstate_leaflet(df_mxstate,
                       pal,
                       ~ pal(value),
                       ~ sprintf("Estado: %s<br/>Ingreso promedio mensual: %s MXN",
                                 state_name, comma(value))) %>%
  addLegend(position = "bottomright", 
            pal = pal, 
            values = df_mxstate$value,
            title = "MXN",
            labFormat = labelFormat(prefix = "$")) %>%
  addProviderTiles("CartoDB.Positron")

saveWidget(map1, file=paste(graf, "ingreso.html",sep="/"),selfcontained = FALSE)

#Educacion
df_mxstate$value <- df_mxstate$ano_edu
pal <- colorNumeric("Greens", domain = df_mxstate$value)
map2<- mxstate_leaflet(df_mxstate,
                       pal,
                       ~ pal(value),
                       ~ sprintf("Estado: %s<br/>Años de educación: %s",
                                 state_name, comma(value))) %>%
  addLegend(position = "bottomright", 
            pal = pal, 
            values = df_mxstate$value,
            title = "Años",
            labFormat = labelFormat(prefix = "")) %>%
  addProviderTiles("CartoDB.Positron")
map2

saveWidget(map2, file=paste(graf, "educ.html",sep="/"),selfcontained = FALSE)

#Pobreza
df_mxstate$value <- df_mxstate$pobreza
pal <- colorNumeric("Reds", domain = df_mxstate$value)
map3<- mxstate_leaflet(df_mxstate,
                       pal,
                       ~ pal(value),
                       ~ sprintf("Estado: %s<br/>Nivel de pobreza: %s %%",
                                 state_name, comma(value))) %>%
  addLegend(position = "bottomright", 
            pal = pal, 
            values = df_mxstate$value,
            title = "Porcentaje",
            labFormat = labelFormat(suffix =  "%")) %>%
  addProviderTiles("CartoDB.Positron")
map3

saveWidget(map3, file=paste(graf, "pobreza.html",sep="/"),selfcontained = FALSE)

#Causas

datos1 = "F:/econometria_aplicada/project/data/database/causas"
causas <- read_dta(paste(datos1,"causas.dta", sep="/"))
causas$region = causas$CVE_ENT
causas$CVE_ENT <- NULL

df_mxstate <- merge(df_mxstate,causas,by="region")

#Violencia sexual
df_mxstate$value <- df_mxstate$TViol
pal <- colorNumeric("RdPu", domain = df_mxstate$value)
map4<- mxstate_leaflet(df_mxstate,
                       pal,
                       ~ pal(value),
                       ~ sprintf("Estado: %s<br/>Tasa de violencia sexual: %s",
                                 state_name, comma(value))) %>%
  addLegend(position = "bottomright", 
            pal = pal, 
            values = df_mxstate$value,
            title = "Tasa de violencia",
            labFormat = labelFormat(prefix = "")) %>%
  addProviderTiles("CartoDB.Positron")

saveWidget(map4, file=paste(graf, "viol_sex.html",sep="/"),selfcontained = FALSE)

#Violencia infantil
df_mxstate$value <- df_mxstate$ViolInfant_Index
pal <- colorNumeric("Blues", domain = df_mxstate$value)
map5<- mxstate_leaflet(df_mxstate,
                       pal,
                       ~ pal(value),
                       ~ sprintf("Estado: %s<br/>Tasa de violencia infantil: %s",
                                 state_name, comma(value))) %>%
  addLegend(position = "bottomright", 
            pal = pal, 
            values = df_mxstate$value,
            title = "Tasa de violencia",
            labFormat = labelFormat(prefix = "")) %>%
  addProviderTiles("CartoDB.Positron")

saveWidget(map5, file=paste(graf, "viol_infant.html",sep="/"),selfcontained = FALSE)

#Tasa de fertilidad municipios

datos2 = "F:/econometria_aplicada/project/data/modif/Nacimientos"
fertilidad <- read_dta(paste(datos2,"tasaemb_mun.dta", sep="/"))
fertilidad$region = paste(fertilidad$CVE_ENT,fertilidad$CVE_MUN,sep="")
fertilidad$CVE_ENT <- NULL
fertilidad$CVE_MUN <- NULL
fertilidad$ANO_NAC <- NULL

df_mxmunicipio <- merge(df_mxmunicipio,fertilidad,by="region")

df_mxmunicipio$value <- df_mxmunicipio$tasa_emb

magma <- c("#000004FF", "#1D1146FF", "#50127CFF", "#822681FF", "#B63779FF", 
           "#E65163FF", "#FB8761FF", "#FEC387FF", "#FCFDBFFF")
pal <- colorNumeric(magma, domain = df_mxmunicipio$value)
map6 <- mxmunicipio_leaflet(df_mxmunicipio,
                            pal,
                            ~ pal(value),
                            ~ sprintf("Estado: %s<br/>Municipio : %s<br/>Tasa de fertilidad adolescente: %s",
                                      state_name, municipio_name, round(value, 1))) %>%
  addLegend(position = "bottomright", 
            pal = pal, 
            values = df_mxmunicipio$value,
            title = "Tasa de fertilidad",
            labFormat = labelFormat(suffix = "")) %>%
  addProviderTiles("CartoDB.Positron")
map6
saveWidget(map6, file=paste(graf, "tasa_fertilidad.html",sep="/"),selfcontained = FALSE)

rm(list = ls())
###########################
#MAPA FERTILIDAD MUNICIPIOS
###########################

#Instalar los paquetes necesarios 
#################################
install <- function(packages){
  new.packages <- packages[!(packages %in% installed.packages()[, "Package"])]
  if (length(new.packages)) 
    install.packages(new.packages, dependencies = TRUE)
  sapply(packages, require, character.only = TRUE)
}

required.packages <- c("digest", "foreign","tidyverse","rgdal", "rgeos","sp","maptools","ggmap","statar","readxl", "viridis")

install(required.packages)
################################

inp = "E:/econometria_aplicada/T3/ejercicio1/input"
edos = paste(inp, 'estados', sep='/')
muns = paste(inp, 'municipios', sep='/')
maps = "E:/econometria_aplicada/project/graficos"
datos = "E:/econometria_aplicada/project/data/modif/Nacimientos"

# Leemos los shapefiles
edos <- readOGR(paste(edos, "ESTADOS.shp", sep="/"), "ESTADOS", stringsAsFactors=F)

muns <- readOGR(paste(muns, "MUNICIPIOS.shp", sep="/"), "MUNICIPIOS", stringsAsFactors=F)

#Leemos los datos que queremos graficar
library(haven)

data = read_dta(paste(datos, "tasaemb_mun.dta", sep="/"))

#Tenemos que juntar las bases que tenemos para hacer el mapa

data$id=paste(data$CVE_ENT,data$CVE_MUN, sep = "")
tempo <- data

head(muns@data)
muns@data$joint_cve <- paste0(muns@data$CVE_ENT, muns@data$CVE_MUN) #agregamos la columna inegi que concatena las claves
head(muns@data)

munsF <- fortify(muns, region = "joint_cve") %>%
  left_join(tempo, by="id")

rm(tempo)

#Graficando

#Los limites estatales
edosF <- fortify(edos)
ggplot() + geom_polygon(data=edosF, aes(x = long, y = lat, group = group, col=red), size = 1, color = "black", fill=NA)

#Embarazo
map <- ggplot() +
  geom_polygon(data=munsF, aes(x = long, y = lat, group = group, fill = tasa_emb), color="black", size = 0.05) +
  geom_polygon(data=edosF, aes(x = long, y = lat, group = group, col=red), size =0.7 , color = "white", fill=NA) +
  theme_void() +
  #scale_fill_continuous(name="Tasa de fertilidad", type="viridis", guide = "colourbar") +
  scale_fill_gradient(low = "lightcyan", high = "royalblue3",name="Tasa de fertilidad", guide = "colourbar") +
  labs(y="", x="", caption = "Fuente: ElaboraciÃ³n propia con datos del INEGI") +
  coord_map() +
  theme(legend.title=element_text(size=13, face="bold",vjust=1),
        legend.text=element_text(size=8,angle = 90, hjust = 1),
        legend.justification="left", 
        legend.box="horizontal",
        legend.position="bottom",
        legend.key.size = unit(0.5, "cm"), legend.key.width = unit(1, "cm")) +
  guides(colour = guide_colourbar(title.position="top", title.hjust = 0.5))
map
ggsave(paste(maps, "Mapa_fertilidad.pdf", sep="/"), plot=map, width = 12, height = 12)

map1 <- ggplot() +
  geom_polygon(data=munsF, aes(x = long, y = lat, group = group, fill = tasa_emb), color="black", size = 0.05) +
  geom_polygon(data=edosF, aes(x = long, y = lat, group = group, col=red), size =0.7 , color = "white", fill=NA) +
  theme_void() +
  scale_fill_viridis(name="Tasa de fertilidad",option = "magma", guide = "colourbar") +
  labs(y="", x="", caption = "Fuente: ElaboraciÃ³n propia con datos del INEGI",title="Tasa de fertilidad adolescente (2016)", subtitle= "Nacimientos por cada 1,000 mujeres de 15 a 19 aÃ±os") +
  coord_map() +
  theme(legend.title=element_text(size=13, face="bold",vjust=1),
        legend.text=element_text(size=8,angle = 90, hjust = 1),
        legend.justification="left", 
        legend.box="horizontal",
        legend.position="bottom",
        legend.key.size = unit(0.5, "cm"), legend.key.width = unit(1, "cm")) +
  guides(colour = guide_colourbar(title.position="top", title.hjust = 0.5))
map1
ggsave(paste(maps, "Mapa_fertilidad1.png", sep="/"), plot=map1, width = 12, height = 12)

rm(list = ls())
##########
#BAR PLOTS
##########

#Historico
library(haven)
library(ggplot2)

datos = "E:/econometria_aplicada/project/data/database/causas"
graf = "E:/econometria_aplicada/project/graficos"

data1 <- read_dta(paste(datos,"enigh.dta",sep = "/"))

#Ingreso
g1 <- ggplot(data1, aes(x = ano_nac)) + 
  geom_bar(aes(y = imr), stat="identity", fill="deeppink4") +
  geom_line(aes(y = tasa*75), size=2, color="khaki") +
  scale_y_continuous(expand=c(0,0), sec.axis = sec_axis(~.*(1/75), name = "Tasa de fertilidad")) +
  scale_x_continuous(expand=c(0,0), breaks = seq(1992,2016,4)) +
  theme_minimal() +
  labs(y = "Pesos (MXN)",
       x = "Año",
       title="Ingreso promedio mensual y tasa de fertilidad adolescente", subtitle= "Nacimientos por cada mil mujeres de 15 a 19 años", caption = "[] Ingreso promedio mensual -- Tasa de fertilidad adolescente") 
g1
ggsave(paste(graf, "bar_ing.png", sep="/"), plot=g1, width = 8, height = 4)

#Educacion
g2 <- ggplot(data1, aes(x = ano_nac)) + 
  geom_bar(aes(y = ano_edu), stat="identity", fill="seagreen4") +
  geom_line(aes(y = tasa/10), size=2, color="khaki") +
  scale_y_continuous(expand=c(0,0), sec.axis = sec_axis(~.*10, name = "Tasa de fertilidad")) +
  scale_x_continuous(expand=c(0,0), breaks = seq(1992,2016,4)) +
  theme_minimal() +
  labs(y = "Años",
       x = "Año",
       title="Escolaridad promedio y tasa de fertilidad adolescente", subtitle= "Nacimientos por cada mil mujeres de 15 a 19 años", caption = "[] Años de escolaridad -- Tasa de fertilidad adolescente") 
g2
ggsave(paste(graf, "bar_edu.png", sep="/"), plot=g2, width = 8, height = 4)

library(readxl)

#Pobreza
data2 <- as.data.frame(read_excel("E:/econometria_aplicada/Excel/pobreza/indicadorespob.xlsx",sheet=1))

x1 <- subset(data2,año==2010)
x2 <- subset(data2,año==2015)
meanx1 <- mean(x1$Pobreza)
meanx2 <- mean(x2$Pobreza)
data3 <- matrix(data = c(2010,2015,meanx1, meanx2,80,70), nrow = 2, ncol = 3)
colnames(data3) <-c("ano_nac","pobreza","tasa")
data3 <- as.data.frame(data3)

g3 <- ggplot(data3, aes(x = ano_nac)) + 
  geom_bar(aes(y = pobreza), stat="identity", fill="seagreen4") +
  geom_line(aes(y = tasa/2), size=2, color="khaki") +
  scale_y_continuous(expand=c(0,0), sec.axis = sec_axis(~.*2, name = "Tasa de fertilidad")) +
  scale_x_continuous(expand=c(0,0),breaks = c(2010,2015)) +
  theme_minimal() +
  labs(y = "Porcentaje (%)",
       x = "Año",
       title="Porcentaje de pobres y tasa de fertilidad adolescente", subtitle= "Nacimientos por cada mil mujeres de 15 a 19 años", caption = "[] Años de escolaridad -- Tasa de fertilidad adolescente") 
g3
ggsave(paste(graf, "bar_pob.png", sep="/"), plot=g3, width = 8, height = 4)



