library(tidyverse)
alc18_10 <- read.csv("/home/kevin/M1SSD/Logiciel_Special/TableauAlcoolComparaison/alc18_10.csv")
alc09_00 <- read.csv("/home/kevin/M1SSD/Logiciel_Special/TableauAlcoolComparaison/alc09_00.csv")
alc99_80 <- read.csv("/home/kevin/M1SSD/Logiciel_Special/TableauAlcoolComparaison/alc99_80.csv")
alc79_60 <- read.csv("/home/kevin/M1SSD/Logiciel_Special/TableauAlcoolComparaison/alc79_60.csv")

colnames(alc18_10) <- c("Country","Data Source", "Beverage",alc18_10[1,4:length(alc18_10)])
alc18_10 <- alc18_10[2:nrow(alc18_10),1:length(alc18_10)]

colnames(alc09_00) <- c("Country","Data Source", "Beverage",alc09_00[1,4:length(alc09_00)])
alc09_00 <- alc09_00[2:nrow(alc09_00),1:length(alc09_00)]

colnames(alc99_80) <- c("Country","Data Source", "Beverage",alc99_80[1,4:length(alc99_80)])
alc99_80 <- alc99_80[2:nrow(alc99_80),1:length(alc99_80)]

colnames(alc79_60) <- c("Country","Data Source", "Beverage",alc79_60[1,4:length(alc79_60)])
alc79_60 <- alc79_60[2:nrow(alc79_60),1:length(alc79_60)]

alc18_60 <- full_join(full_join(full_join(alc18_10,alc09_00),alc99_80),alc79_60)

# Doit changer pour qu'ils ont tous le meme DataSource, car il y a Nauru qui 
# apparait 2 fois dans alc99_80.  Aussi dans Beverage il y a un "Beverage Type" 
# qu'on doit probablement enlever.  Hmmm non il y a aucun alors peutetre c'est bon. 
summary(alc18_60)
str(alc18_60)
levels(alc18_60[[3]])
