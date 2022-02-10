####Exploratory Data analysis
#-understand structure of dataset


###Start with class(), str(), dim(), colnames(), head() etc

#look for NAs in rows/cols
#sum(rowsums(is.na(airquality))>0)

#look for means/variation

#look for distribution: hist()

##qqplot to check for normal distribution

##facet_wrap plots multiple things at once, but needs long format. To get this quickly, use reshape2::melt()


################################################################################
library(tidyverse)
BEA<- read.csv("KS_BEA.csv", stringsAsFactors = FALSE)
################################################################################

str(BEA)
colnames(BEA)
head(BEA, 15)

#data is not tidy
#Need each variable in a column, each classification in a row
#Location/year

tail(BEA)
#We also have some rows with empty variables/weird formatting d/t footnotes

BEA <- BEA %>%
  slice(1:3604) #take off the end of the data that looks weird

tail(BEA)

BEA_tidy <- BEA %>%
  pivot_longer(cols= X2001:X2019, 
               names_to = "Year",
               values_to= "Value")
str(BEA_tidy)

