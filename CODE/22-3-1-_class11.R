#1. check lost and found
#2. balcony
#3. notes thurs

library(sf)
library(tidyverse)


watershed <- st_read("DATA/Wildcat_Creek_Watershed.shp")

bldg_ftprint <- st_read("DATA/rileycnty_bldftprnt.shp")

species <- st_read("DATA/Kansas_Species_of_Concern_GCS.shp")

#conservation <- st_read("DATA/ConservationEasements.shp")

ag_ease <- st_read("DATA/AgProtectionEasements.shp")

#protected <- st_read("DATA/KS_protected_Areas.shp")

################################################################################

#need to put spatial data in same coordinate ref system


watershed <- st_transform(watershed, st_crs(ag_ease)) #use same CRS as ag_ease
bldg_ftprint <- st_transform(bldg_ftprint, st_crs(ag_ease))
species <- st_transform(species, st_crs(ag_ease))

st_crs(watershed)
st_crs(bldg_ftprint)
st_crs(species)
st_crs(ag_ease)

###############################################################################

str(watershed)
str(species)
str(ag_ease)
str(bldg_ftprint)

ggplot()+ 
  geom_sf(data=watershed)+
  geom_sf(data= ag_ease, color="red") +
  geom_sf(data=species, fill = "blue", alpha=0.8)


spp_wcc <- species[watershed, ]

# do not use : spp_wcc <- species [watershed, op = st_within] #nothing falls within watershed, only intersects
ggplot()+ 
  geom_sf(data=watershed, fill="green", alpha= 0.4)+
  geom_sf(data= ag_ease, color="red") +
  geom_sf(data=spp_wcc, fill = "blue", alpha=0.8)+ 
  theme_bw()

ag_ease_wcc <- ag_ease[watershed, ] #only ag easements that intersect

ggplot()+ 
  geom_sf(data=watershed, fill="green", alpha= 0.4)+
  geom_sf(data= ag_ease_wcc, color="red") +
  geom_sf(data=spp_wcc, fill = "blue", alpha=0.8)+ 
  theme_bw()

# how much of watershed has ag easement within it?

?st_intersection

ag_wat <- st_intersection(ag_ease_wcc, watershed) #will always get warning

ggplot()+ 
  geom_sf(data=watershed, fill="green", alpha= 0.4)+
  geom_sf(data= ag_wat, fill="pink", alpha= 0.7) +
  geom_sf(data=spp_wcc, fill = "blue", alpha=0.8)+ 
  theme_bw()

#we can calculate area of ag in watershed using st_area
#however, it'll calculate it for each feature, including the stuff that overlaps
#so, we need to dissolve boundaries/combine easements together

int_comb <- st_union(ag_wat)

ggplot()+ 
  geom_sf(data=watershed, fill="green", alpha= 0.4)+
  geom_sf(data= int_comb, fill="pink", alpha= 0.8) +
  geom_sf(data=spp_wcc, fill = "blue", alpha=0.8)+ 
  theme_bw()
#now we can calculate area of all ag easements in watershed

ag_ease_area <- st_area(int_comb)

ag_ease_area_num<- as.numeric(ag_ease_area)

watershed_area <- st_area (watershed) %>% as.numeric(.)

ag_ease_area_num

watershed_area

perc_ag_ease <- (ag_ease_area_num /watershed_area ) * 100

perc_ag_ease
