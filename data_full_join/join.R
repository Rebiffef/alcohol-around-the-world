setwd("~/Documents/Tableau_alcohol/data_by_topic")

#data set loading
consumers<-as.data.frame(read.csv("consumers_profil.csv",dec=","))[,-1]
colnames(consumers)[4:8]<-unlist(lapply(4:8,function(i){sub(".csv","",colnames(consumers)[i])}))
abstainers<-as.data.frame(read.csv("pattern_consommation.csv",dec=","))
alcool<-as.data.frame(read.csv("alc_total.csv",dec=","))[,-2]

#names homogenization
colnames(abstainers)[3]<-colnames(consumers)[3]<-"Gender"
colnames(alcool)[3]<-"Year"
colnames(alcool)[4]<-"consumption.in.litres.of.pure.alcohol.per.capita"
alcool$Gender<-rep("Both.Sexes",dim(alcool)[1])
consumers$Gender[consumers$Gender=="Both.sexes"]<-"Both.Sexes"

# join
library(dplyr)
behavior<-full_join(consumers,abstainers,by=c("Country","Year","Gender"))
alcohol_consumption<-full_join(alcool,behavior,by=c("Country","Year","Gender"))

alcohol_consumption<-alcohol_consumption[,c(1,3,5,2,4,6:13)]
alcohol_consumption[,5:13]<-unlist(lapply(5:13, function(i){as.numeric(alcohol_consumption[,i])}))
alcohol_consumption[,3:4]<-lapply(3:4, function(i){as.factor(alcohol_consumption[,i])})

write.csv(alcohol_consumption,"alcohol_consumption.csv")
