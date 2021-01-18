library(tidyverse)
alc18_10 <- read.csv("~/8)SSD/LogSpec/alcohol-around-the-world/new.alc18_10.csv")
alc09_00 <- read.csv("~/8)SSD/LogSpec/alcohol-around-the-world/new.alc09_00.csv")
alc99_80 <- read.csv("~/8)SSD/LogSpec/alcohol-around-the-world/new.alc99_80.csv")
alc79_60 <- read.csv("~/8)SSD/LogSpec/alcohol-around-the-world/new.alc79_60.csv")

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
