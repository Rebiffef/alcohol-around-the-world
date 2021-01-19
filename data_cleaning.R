library(tidyverse)

setwd("~/Documents/Tableau_alcohol")

i<-0
for (j in list.files(".","alcohol")) {
  i<-i+1
  assign(paste0('a',i),as.data.frame(read.csv(j,dec=",",skip = 1)))
  assign(paste0('a',i),pivot_longer(get(paste0('a',i)),colnames(get(paste0('a',i)))[c(-1,-2)],names_to = "gender", values_to=j))
  if (i>1) {assign(paste0('a',i),full_join(get(paste0('a',i)),get(paste0('a',i-1))))}
}

write.csv(get(paste0('a',i)),"consumers_profil.csv")
