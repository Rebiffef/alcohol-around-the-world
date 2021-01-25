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

write_excel_csv(alc18_60, file="alc_total.csv")

#####

##### 
colnames(abs_12_mois) <- c("Country","Year","Both.Sexes","Male","Female")
abs_12_mois <- abs_12_mois[-1,]
abs_12_mois[abs_12_mois=="No data"] <- NA
abs_12_mois <- gather(abs_12_mois, key="Sex", value="Alcohol..abstainers.past.12.months", -c("Country","Year"))
abs_12_mois[,4] <- as.numeric(abs_12_mois[,4])
#Dropped 1 country (not sure which one)
colnames(abs_vie) <- c("Country","Year","Both.Sexes","Male","Female")
abs_vie <- abs_vie[-1,]
abs_vie[abs_vie=="."] <- NA
abs_vie <- gather(abs_vie, key="Sex", value="Alcohol..abstainers.lifetime", -c("Country","Year"))
abs_vie[,4] <- as.numeric(abs_vie[,4])
#Dropped 1 country (not sure which one)
colnames(ex_buveurs) <- c("Country","Year","Both.Sexes","Male","Female")
ex_buveurs <- ex_buveurs[-1,]
ex_buveurs[ex_buveurs=="."] <- NA
ex_buveurs <- gather(ex_buveurs, key="Sex", value="Alcohol..former.drinkers", -c("Country","Year"))
ex_buveurs[,4] <- as.numeric(ex_buveurs[,4])
#Dropped 1 country (not sure which one)

pat_cons <- full_join(abs_12_mois,full_join(abs_vie,ex_buveurs))

write_excel_csv(pat_cons, file="pat_cons.csv")

