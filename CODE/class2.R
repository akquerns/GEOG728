data(mtcars)
mtcars
car<-mtcars


#########################
###YEEHAW - LOAD DAT ####
##########################

d1 <- read.csv(file="Dat/journeynorth.csv")
d2 <- read.csv(file="Dat/journeynorth2.csv")

head(d1)
head(d2)

tail(d1)
tail(d2)

str(d1)
str(d2)

df<- rbind(d1,d2)

dim(df)

length(df)#default=no of col

length(df[,1])

dfn <-colnames(df)
df1<-df

colnames(df1) <- c("Yeet", "Yeezy", "Yat", "Yet", "COOOOO", "MROEW")

###################################################

df2 <- df[,c("State.Province", "Number")]
head(df2)

df3<- df[df$Town =="Bowling Green",]

percbg <- (nrow(df3)/nrow(df) )*100
