library(tidyverse)
library(USAboundaries)
library(USAboundariesData)
library(sf)
library(sp)


bea <- readRDS("DATA/clean_KS_BEA_data.rds")
counties <- st_read("DATA/KS_counties.shp") # use st_write to save as geodatabase

head(counties)
head(bea)

#geoid and GeoFIPS don't overlap


bea <-bea %>%
  mutate(GEOID = str_extract(GeoFIPS, "\\d+"))

bea_sf <- left_join(counties, bea, by=c("geoid" = "GEOID"))
# must always have the shapefiles in the X position--R will yell at you otherwise!!

ggplot(bea_sf)+
  geom_sf(aes(fill=log(total))) +
  theme_bw()


bea_sf %>%
  filter(Year==2012) %>%
  ggplot(.)+
  geom_sf(aes(fill=log(total))) +
  theme_bw()


bea_sf %>%
  mutate(perc_total = total/ sum(total)) %>%
  filter(Year==2012) %>%
  ggplot(.)+
  geom_sf(aes(fill=perc_total)) +
  theme_bw() #need to get in terms of EACH year


bea_test<-bea_sf %>%
  group_by(Year)%>%
  mutate(perc_total = total/ sum(total) * 100) 

bea_test%>%
  filter(Year==2012) %>%
  summarize(sum= sum(perc_total)) #confident now that percent adds up to 100

bea_test%>%
  filter(Year==2012) %>%
  ggplot(.)+
  geom_sf(aes(fill=perc_total)) +
  theme_bw()

cnty_pts <- st_centroid(bea_test) #will give warning--maybe want to switch to equal area projection

st_crs(bea_test)

bea_test%>%
  ggplot(.)+
  geom_sf(aes(fill=perc_total), alpha=0.7) +
  theme_minimal() +
  geom_sf(data=cnty_pts, aes(size=Ag))+
  facet_wrap(~Year)+
  theme(axis.title=element_blank(),
        axis.text=element_blank(),
        axis.ticks=element_blank(),
        panel.grid.major = element_blank()) +
  scale_fill_viridis_c()
