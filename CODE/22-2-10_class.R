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
BEA<- read.csv("DATA/KS_BEA.csv", stringsAsFactors = FALSE)
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

colSums(is.na(BEA_tidier)) #something is wrong--lots of NAs--assumes we take a unique record of GEOFIPS,
#which isn't right because we have multiple years for each loc


#by default for pivot_wider, by default it assumes ID col is where you take name from, but we want it o be defined by GEOFIPS and year

BEA_tidier <- BEA_tidy %>%
  pivot_wider(id_cols = c("GeoFIPS", "Year"),
              names_from = Description,
              values_from = Value)

colSums(is.na(BEA_tidier)) #No NAs! 

str(BEA_tidier) #notice how all are monetary values are characters, not numbers

BEA_clean <- BEA_tidier %>%
  mutate_at(vars(Year:`Private services-providing industries 3/`),
                 ~as.numeric(.)) #NAs will be introduced because of values "(D)"

#They also combined state info with county breakdowns in one column (GeoName)

str(BEA_clean)

BEA_clean <-BEA_clean %>%
  filter(GeoFIPS != " \"20000\"")
  #get rid of ones that aren't specific to a county
  
  BEA_clean %>% 
  group_by(GeoFIPS)%>%
  summarise_all(~sum(is.na(.)))
            
  
 
  length(unique(BEA_clean$GeoFIPS))#how many unique counties?
  length(unique(BEA_clean$Year))#how many unique counties?
  
  # does that equal total obs? 
  105*19 #answer: 1995
  
  BEA_clean %>%
    group_by(Year)%>%
    summarize_all(~sum(is.na(.))) #how many NAs are there by year for each column?
  
  BEA_clean %>%
    group_by(GeoFIPS)%>%
    summarize_all(~sum(is.na(.))) %>%
    arrange(desc(.))#how many NAs are there by county for each column?

   BEA_clean %>%
    summarise_all(~mean(., na.rm=T)) #give me the mean of all columns, drop NAs
  
  BEA_clean %>%
    summarise_all(~sd(., na.rm=T)) #give me the sd() of all columns, drop NAs
  
 BEA_clean <- BEA_clean %>%
    rename(tot='All industry total')
  
  BEA_clean %>%
    filter(Year==2012)%>%
    ggplot(.)+
    geom_histogram(aes(x=tot))
  
  
  ggplot(BEA_clean) +
    geom_boxplot(aes(x=GeoFIPS, y= tot), fill="skyblue1") +
    theme(axis.text.x = element_text(angle=90))+
    theme_bw()

  ggplot(BEA_clean)+
    geom_point(aes(x=Year, y=BEA_clean$`  Agriculture, forestry, fishing and hunting` )) +
    geom_smooth(aes(x=Year, y=BEA_clean$`  Agriculture, forestry, fishing and hunting` ))
  