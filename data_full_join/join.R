#data set loading
consumers<-as.data.frame(read.csv("consumers_profil.csv",dec=","))[,-1]
colnames(consumers)[4:8]<-unlist(lapply(4:8,function(i){sub(".csv","",colnames(consumers)[i])}))
abstainers<-as.data.frame(read.csv("pattern_consommation.csv",dec=","))
alcool<-as.data.frame(read.csv("alc18_60_regions.csv",dec=","))[,-2]

#names homogenization
colnames(abstainers)[3]<-colnames(consumers)[3]<-"Gender"
colnames(alcool)[3]<-"Year"
colnames(alcool)[4]<-"consumption.in.litres.of.pure.alcohol.per.capita"
alcool$Gender<-rep("Both.Sexes",dim(alcool)[1])
consumers$Gender[consumers$Gender=="Both.sexes"]<-"Both.Sexes"

# join
library(dplyr)
library(readr)
behavior<-full_join(consumers,abstainers,by=c("Country","Year","Gender"))
# correction : harmonisation
behavior$Country[behavior$Country=="Côte d'Ivoire"]<-"Cote d'Ivoire"
behavior<-right_join(unique(alcool[,c("Country","Continent","Region")]),behavior,by=c("Country"))
# Correction Pays manquants
behavior[behavior$Country=="Monaco",c("Continent","Region")]<-behavior[behavior$Country=="France",c("Continent","Region")][1:sum(behavior$Country=="Monaco"),]
behavior[behavior$Country=="South Sudan",c("Continent","Region")]<-behavior[behavior$Country=="Sudan",c("Continent","Region")][1:sum(behavior$Country=="South Sudan"),]

behavior$Beverage<-rep(levels(as.factor(alcool$Beverage))[1],dim(behavior)[1])
alcohol_consumption<-full_join(alcool,behavior,by=c("Country","Continent","Region","Year","Gender","Beverage"))

alcohol_consumption<-alcohol_consumption[,c(5,6,1,3,7,2,4,8:15)]
alcohol_consumption[,7:15]<-unlist(lapply(7:15, function(i){as.numeric(alcohol_consumption[,i])}))
alcohol_consumption[,5:6]<-lapply(5:6, function(i){as.factor(alcohol_consumption[,i])})

write_csv(alcohol_consumption,"alcohol_consumption.csv")

#alcohol_consumption_2016<-right_join(alcool,behavior,by=c("Country","Year","Gender"))
#alcohol_consumption_2016<-alcohol_consumption_2016[,c(1,3,5,2,4,6:13)]
#alcohol_consumption_2016[,5:13]<-unlist(lapply(5:13, function(i){as.numeric(alcohol_consumption_2016[,i])}))
#alcohol_consumption_2016[,3:4]<-lapply(3:4, function(i){as.factor(alcohol_consumption_2016[,i])})
#write.csv(alcohol_consumption_2016,"alcohol_consumption_2016.csv")
