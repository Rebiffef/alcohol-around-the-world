library(tidyverse)
#IMPORT
alc09_00 <- as.data.frame(read.csv("alc09_00.csv",dec=","))

# UNUSED COLUMN
alc09_00<-alc09_00[,!(colnames(alc09_00) %in% c("X.1"))]
# column name
names(alc09_00)[c(1,2)]<-alc09_00[1,c(1,2)]
#DATA CLEANING
alc09_00<-alc09_00 %>% pivot_longer(colnames(alc09_00)[c(-1,-2)], names_to='year',values_to=colnames(alc09_00)[3])

alc09_00$year<-lapply(alc09_00$year, function(i){
  if (substr(i,nchar(i),nchar(i))==".") {
   "2009"
   #"1999"
  }else{
    switch(as.numeric(substr(i,nchar(i),nchar(i))),"2008","2007","2006","2005","2004","2003","2002","2001","2000")
    #if (substr(i,nchar(i)-1,nchar(i)-1)==".") {
    #  switch(as.numeric(substr(i,nchar(i),nchar(i))),"1998","1997","1996","1995","1994","1993","1992","1991","1990")
    #}else{
    #  switch(as.numeric(substr(i,nchar(i),nchar(i)))+1,"1989","1988","1987","1986","1985","1984","1983","1982","1981","1980")
    #}
  }
})
alc09_00$year<-as.numeric(alc09_00$year)

alc09_00<-alc09_00[alc09_00[,2]!=colnames(alc09_00)[2],]

alc09_00$Country<-as.factor(alc09_00$Country)

alc09_00$`Beverage Types`<-as.factor(alc09_00$`Beverage Types`)

alc09_00$Alcohol..recorded.per.capita..15...consumption..in.litres.of.pure.alcohol.<-as.numeric(alc09_00$Alcohol..recorded.per.capita..15...consumption..in.litres.of.pure.alcohol.)

write.csv(alc09_00,"alc09_00.csv")
#write.csv(alc09_00,"alc99_80.csv")
