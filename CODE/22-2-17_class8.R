library(tidyverse)
library(USAboundaries)
library(USAboundariesData)
library(sf)
library(sp)


#########################################################################

                   #   Spatial vector data   #

########################################################################

counties <-us_counties(states = "KS")

class(counties)
head(counties)

bea<- readRDS("DATA/clean_KS_BEA_data.rds")


#gives bounding box: max extent of coverage

ggplot(counties)+
  geom_sf(fill="skyblue1") +
  theme_bw()


st_crs(counties)
#WGS84: global geographic coordinate system

bea <- bea %>%
  select(GeoFIPS:Mining) 

head(bea$GeoFIPS)
head(counties$geoid)
#we need to match by GeoFIPS, but it won't match because bea GeoFIPS looks like trash (slashes, spaces, etc)

#Need to use stringR

bea <-bea %>%
  mutate(GEOID = str_extract(GeoFIPS, "\\d+")) #d= digits, += ALL digits, slashes must be inc

head(bea$GEOID)

##########

bea_sf <- left_join(counties, bea, by=c("geoid" = "GEOID"))
#error for X: state_name and state_abbr are the same. Must get rid of it

bea_sf <- left_join(counties[,-9], bea, by=c("geoid" = "GEOID"))


################################################################################

               # Now let's map again  #

#############################################################################

ggplot(bea_sf)+
  geom_sf(aes(fill=log(total))) +
  theme_bw()
 #always normalize raw input data!

#also need to account for multiple years


bea_sf %>%
  filter(Year==2012) %>%
ggplot(.)+
  geom_sf(aes(fill=log(total))) +
  theme_bw()
