library(tidyverse)
alc18_10 <- read.csv("data_source/new.alc18_10.csv")
alc09_00 <- read.csv("data_source/new.alc09_00.csv")
alc99_80 <- read.csv("data_source/new.alc99_80.csv")
alc79_60 <- read.csv("data_source/new.alc79_60.csv")
abs_12_mois <- read.csv("data_source/abs_12_mois.csv")
abs_vie <- read.csv("data_source/abs_vie.csv")
ex_buveurs <- read.csv("data_source/ex_buveurs.csv")

##### Consommation par pays #####
colnames(alc18_10) <- c("Country","Data Source", "Beverage",alc18_10[1,4:length(alc18_10)])
alc18_10 <- alc18_10[-1,]

colnames(alc09_00) <- c("Country","Data Source", "Beverage",alc09_00[1,4:length(alc09_00)])
alc09_00 <- alc09_00[-1,]

colnames(alc99_80) <- c("Country","Data Source", "Beverage",alc99_80[1,4:length(alc99_80)])
alc99_80 <- alc99_80[-1,]

colnames(alc79_60) <- c("Country","Data Source", "Beverage",alc79_60[1,4:length(alc79_60)])
alc79_60 <- alc79_60[-1,]

alc18_60 <- full_join(full_join(full_join(alc18_10,alc09_00),alc99_80),alc79_60)

alc18_60 <- gather(alc18_60, key = "year", value ="Alcohol..recorded.per.capita..15...consumption..in.litres.of.pure.alcohol.", -c("Country","Data Source","Beverage"))

write_excel_csv(alc18_60, file="data_apres_jointure/alc_total.csv")

#####

##### 
colnames(abs_12_mois) <- c("Country","Year","Both.Sexes","Male","Female")
abs_12_mois <- abs_12_mois[-1,]
abs_12_mois[abs_12_mois=="No data"] <- NA
abs_12_mois <- gather(abs_12_mois, key="gender", value="Alcohol..abstainers.past.12.months", -c("Country","Year"))
abs_12_mois[,4] <- as.numeric(abs_12_mois[,4])
#Dropped 1 country (not sure which one)
colnames(abs_vie) <- c("Country","Year","Both.Sexes","Male","Female")
abs_vie <- abs_vie[-1,]
abs_vie[abs_vie=="."] <- NA
abs_vie <- gather(abs_vie, key="gender", value="Alcohol..abstainers.lifetime", -c("Country","Year"))
abs_vie[,4] <- as.numeric(abs_vie[,4])
#Dropped 1 country (not sure which one)
colnames(ex_buveurs) <- c("Country","Year","Both.Sexes","Male","Female")
ex_buveurs <- ex_buveurs[-1,]
ex_buveurs[ex_buveurs=="."] <- NA
ex_buveurs <- gather(ex_buveurs, key="gender", value="Alcohol..former.drinkers", -c("Country","Year"))
ex_buveurs[,4] <- as.numeric(ex_buveurs[,4])
#Dropped 1 country (not sure which one)

pat_cons <- full_join(abs_12_mois,full_join(abs_vie,ex_buveurs))
pat_cons$Year <- as.numeric(pat_cons$Year)
write_excel_csv(pat_cons, file = "data_apres_jointure/pattern_consommation.csv")

pat_cons_gathered <- gather(pat_cons, key="Consumption.Type", value = "Percent.of.population", -c("Country","Year","gender"))
pat_cons_gathered$Year <- as.numeric(pat_cons_gathered$Year)

write_excel_csv(pat_cons_gathered, file="data_apres_jointure/pattern_consommation_gathered.csv")

pattern_consommation <- read_csv("data_apres_jointure/pattern_consommation.csv")
consumers_profil <- read_csv("data_apres_jointure/consumers_profil.csv")
consumers_profil <- consumers_profil[-1]
consumers_profil$gender <- ifelse(consumers_profil$gender=="Both.sexes","Both.Sexes",ifelse(consumers_profil$gender=="Female","Female","Male"))

consumers_profil_gathered <- gather(consumers_profil, key="profile", value="percent.of.pop.profile", -c("Country","Year","gender"))
consumers_profil_gathered$percent.of.pop.profile <- as.numeric(consumers_profil_gathered$percent.of.pop.profile)
write_excel_csv(consumers_profil_gathered, file="data_apres_jointure/consumers_profil_gathered.csv")

# test <- inner_join(pat_cons_gathered,consumers_profil)
# test2 <- full_join(pattern_consommation,consumers_profil)
# 
# alc16 <- alc_total[alc_total$year==2016,1:5]
# test <- inner_join(pat_cons,inner_join(consumers_profil,alc16))

# Cree un liste de continent et regions.  Du change pas mal de noms pour qu'il sont comme l'autre data.frame
# Change qq unes de alc18_60 car ils etait moins bon.  Enlever les duplicats de Nauru
# Enlever les pays du "regions" qui sont pas dans la data.frame de alc18-60

  
regions <- read_csv('C:/Users/Kevin/Documents/8)SSD/LogSpec/test/alcohol-around-the-world/Regions.csv')
regions <- regions[-2]
regions <- regions[regions$Year==2016,]
regions <- regions[-1]
regions[regions$Country=="United Kingdom",1] <-  "United Kingdom of Great Britain and Northern Ireland"
regions[regions$Country=="United States",1] <- "United States of America"
regions[regions$Country=="Tanzania",1] <- "United Republic of Tanzania"
regions[regions$Country=="Venezuela",1] <- "Venezuela (Bolivarian Republic of)"
regions[regions$Country=="Vietnam",1] <- "Viet Nam"
regions[regions$Country=="Bolivia",1] <- "Bolivia (Plurinational State of)"
regions[regions$Country=="Brunei",1] <- "Brunei Darussalam"
regions[regions$Country=="Congo, Dem. Rep.",1] <- "Democratic Republic of the Congo"
regions[regions$Country=="Congo, Rep.",1] <- "Congo"
regions[regions$Country=="North Korea",1] <- "Democratic People's Republic of Korea"
regions[regions$Country=="Czech Republic",1] <- "Czechia"
regions[regions$Country=="Iran",1] <- "Iran (Islamic Republic of)"
regions[regions$Country=="South Korea",1] <- "Republic of Korea"
regions[regions$Country=="Lao",1] <- "Lao People's Democratic Republic"
regions[regions$Country=="Macedonia, FYR",1] <- "North Macedonia"
regions[regions$Country=="Micronesia, Fed. Sts.",1] <- "Micronesia (Federated States of)"
regions[regions$Country=="Moldova",1] <- "Republic of Moldova"
regions[regions$Country=="Russia",1] <- "Russian Federation"
regions[regions$Country=="Syria",1] <- "Syrian Arab Republic"
regions[regions$Country=="Swaziland",1] <- "Eswatini"

alc18_60[alc18_60$Country=="CÃ´te d'Ivoire",1] <- "Cote d'Ivoire"
alc18_60[alc18_60$Country=="Cabo Verde",1] <- "Cape Verde"
alc18_60 <- alc18_60[-which(alc18_60$Country=="Nauru"&alc18_60$`Data Source`!=" Data source"),]
regions <- regions[-c(which(countries2=="Kosovo"),which(countries2=="Western Sahara"),
                               which(countries2=="Aruba"),which(countries2=="Bermuda"),
                               which(countries2=="Cayman Islands"),which(countries2=="Greenland"),which(countries2=="Hong Kong, China"),
                               which(countries2=="Macao, China"),which(countries2=="Marshall Islands"),which(countries2=="Monaco"),
                               which(countries2=="Palestine"),which(countries2=="Palau"),which(countries2=="Puerto Rico"),
                               which(countries2=="San Marino"),which(countries2=="South Sudan"),
                               which(countries2=="Taiwan"),which(countries2=="Turks and Caicos Islands"),which(countries2=="Zimbabwe")),1:3]

# Ajouter les continents/regions qui etait pas dans le dataframe region.  
missing.countries <- data.frame(Country=c("Cook Islands","Niue","Zambia","Zimbabwe"),Continent=c("Oceania","Oceania","Africa","Africa"),Region=c("Polynesia","Polynesia","Southern Africa","Southern Africa"))
regions <- rbind(regions, missing.countries)


#295 NA sont introduit.  C'est 59*5 (c'est une etude sur 59 ans) mais je sais pas lequelles sont introduit. Pareil si je fais inner_join...et left_join  
alc18_60.regions <- full_join(alc18_60,regions)
write_excel_csv(alc18_60.regions, file="data_apres_jointure/alc18_60_regions.csv")


##### Ce que j'ai utiliser pour trouver les extra pays pour faire le jointure #####
# countries <- unique(alc18_60$Country)
# countries2 <- unique(regions$Country)
# region.countries <- str_sort(countries2[-c(which(countries2=="Kosovo"),which(countries2=="Western Sahara"),
#                                            which(countries2=="Aruba"),which(countries2=="Bermuda"),
#                                            which(countries2=="Cayman Islands"),which(countries2=="Greenland"),which(countries2=="Hong Kong, China"),
#                                            which(countries2=="Macao, China"),which(countries2=="Marshall Islands"),which(countries2=="Monaco"),
#                                            which(countries2=="Palestine"),which(countries2=="Palau"),which(countries2=="Puerto Rico"),
#                                            which(countries2=="San Marino"),which(countries2=="South Sudan"),
#                                            which(countries2=="Taiwan"),which(countries2=="Turks and Caicos Islands"),which(countries2=="Zimbabwe"))])
# removed.countries <- countries2[c(which(countries2=="Kosovo"),which(countries2=="Western Sahara"),
#                                   which(countries2=="Aruba"),which(countries2=="Bermuda"),
#                                   which(countries2=="Cayman Islands"),which(countries2=="Greenland"),which(countries2=="Hong Kong, China"),
#                                   which(countries2=="Macao, China"),which(countries2=="Marshall Islands"),which(countries2=="Monaco"),
#                                   which(countries2=="Palestine"),which(countries2=="Palau"),which(countries2=="Puerto Rico"),
#                                   which(countries2=="San Marino"),which(countries2=="South Sudan"),
#                                   which(countries2=="Taiwan"),which(countries2=="Turks and Caicos Islands"),which(countries2=="Zimbabwe"))]
# removed.countries.list1 <- countries[c(which(countries=="Cook Islands"),which(countries=="Niue"),which(countries=="Zambia"))]
# alc.countries <- str_sort(countries[-c(which(countries=="Cook Islands"),which(countries=="Niue"),which(countries=="Zambia"))])
# alc.countries[length(alc.countries):200]=NA
# region.countries[length(region.countries):200]=NA
# test4 <- data.frame(alc.countries, region.countries)

# countries.removed <- countries2[-c(1,3)]

##### Extra pour trouve autres erreurs (pas trop utiles pour autres personnes) #####
# alc18_60[which(alc18_60$`Data Source` !=" Data source"),]
# countries[which(str_detect(countries,"Zimbabwe")==T)]
# countries[29]
# summary(alc18_60)
# str(alc18_60[which(alc18_60$Country=="Nauru"),2])
# alc18_60[which(alc18_60$Country=="Nauru"&alc18_60$year==1999),]
# alc18_60[which(alc18_60$Country=="Cook Islands"),]
# alc18_60[which(is.na(alc18_60$Alcohol..recorded.per.capita..15...consumption..in.litres.of.pure.alcohol.)),]
#####

