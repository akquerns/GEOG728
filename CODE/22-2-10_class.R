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

BEA_tidy <- BEA %>% # make the data into long format for year
  pivot_longer(cols= X2001:X2019, 
               names_to = "Year",
               values_to= "Value",
               names_prefix = "X") #get rid of the weird X at the beginning
str(BEA_tidy)

#we also want a new column for each category (uhhhhh not sure why)


BEA_tidier <- BEA_tidy %>%
  pivot_wider(names_from = Description,
              values_from = Value)

colSums(is.na(BEA_tidier)) #something is wrong--lots of NAs
#by default for pivot_wider, by default it assumes ID col is where you take name from, but we want it o be defined by GEOFIPS and year

BEA_tidier <- BEA_tidy %>%
  pivot_wider(id_cols = c("GeoFIPS", "Year"),
              names_from = Description,
              values_from = Value)

colSums(is.na(BEA_tidier)) #No NAs! 

str(BEA_tidier)

BEA_clean <- BEA_tidier %>%
  mutate_at(vars(Year:`Private services-providing industries 3/`),
                 ~as.numeric(.)) #NAs will be introduced because of values "(D)"

#They also combined state info with county breakdowns in one column (GeoName)


BEA_clean <-BEA_clean %>%
  filter(GeoFIPS != "\"20000\"")
  #get rid of ones that aren't specific to a county
  
  BEA_clean %>% 
  group_by(GeoFIPS)%>%
  summarise_all(~sum(is.na(.)))
            
  
  BEA_clean %>%
    summarise_all(~mean(., na.rm=T))
  
  BEA_clean %>%
    summarise_all(~sd(., na.rm=T))