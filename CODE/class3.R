#LOAD LIBS
library(tidyverse)

jn <- read.csv("Dat/journeynorth.csv")
jn2 <- read.csv("Dat/journeynorth2.csv")


jn_full <- rbind(jn, jn2)

unique(jn_full$Town)

roanoke <- jn_full[jn_full$Town=="Roanoke",]

roanoke1<-subset(jn_full, Town=="Roanoke")

roanoke2<-jn_full %>% dplyr::filter(Town=="Roanoke")

percRoanoke <- nrow(roanoke) / nrow(jn_full)


length(roanoke$Town)/ length(jn_full$Town)

max(roanoke$Number)

sum(roanoke$Number)

sum(is.na(jn_full$Number)) #number of NAs
percna <-sum(is.na(jn_full$Number)) / (sum(jn_full$Number, na.rm=TRUE))


nonas<-subset(jn_full, !is.na(jn_full$Number))

nrow(nonas)

sapply(jn_full, function(x) sum(is.na(x)))

ordered <- nonas[order(-nonas$Number),] 

tot_perstate <- aggregate(nonas$Number, by=nonas["State.Province"], FUN=mean)

