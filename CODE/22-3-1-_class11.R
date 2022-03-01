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