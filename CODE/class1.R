IDs <- 1:50

IDs1<-1.235:56

seq(1,50,2)

rep(1:50,1)

Obs<- rep(1:50,times=3)

words <- rep(c("daffodil", "water", "dog", "goat", "cheese"), times=5)

test <- cbind(Obs, words)

test2 <- data.frame(Obs, words)

test3 <- data.frame(1:25, words)

class(test3)

d1 <- read.csv(file="Dat/journeynorth.csv")
d2 <- read.csv(file="Dat/journeynorth2.csv")