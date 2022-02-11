install.packages("sf") #sf is a fantastic package for handling spatial data that we will use often later in the semester

library(sf)


update.packages()

x <- 6
y <- 8
n <- 1:10
let <- LETTERS[1:10]
z <- c(1, 1, 2, 3, 5, NA, 13)
let_df <- data.frame(n, let)

d<-read.csv("Data/iris.csv", stringsAsFactors = FALSE)
head(d,10)
nrow(d)
ncol(d)
data()
d2<-data("ChickWeight")
d3<-data.frame(d2)

data(mtcars)
ds<-mtcars
head(ds, 5)
dim(ds)
nrow(ds)
ncol(ds)
