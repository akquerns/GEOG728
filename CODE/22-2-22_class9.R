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

bea_sf%>%
  ggplot(.)+
  geom_sf(aes(fill=total), alpha=0.7) +
  theme_minimal() +
  geom_sf(data=cnty_pts, aes(size=Ag))+
  facet_wrap(~Year)+
  theme(axis.title=element_blank(),
        axis.text=element_blank(),
        axis.ticks=element_blank(),
        panel.grid.major = element_blank()) +
  scale_fill_viridis_c()

bea_sf %>%
  filter(Year==2012)%>%
  ggplot(.)+
  geom_sf(aes(fill=Mining))+
  geom_sf_label(aes(label = name), label.padding = unit(0.2, "lines"), size=3)+
  scale_fill_viridis_c(direction=-1)

bea_sf %>%
  filter(Year==2012)%>%
  st_transform(., "+proj=lcc +lat_1=38.71666666666667 +lat_2=39.78333333333333 +lat_0=38.33333333333334 +lon_0=-98 +x_0=399999.9999999999 +y_0=0 +ellps=GRS80 +datum=NAD83 +to_meter=0.3048006096012192 +no_defs") %>%
  ggplot(.)+
  geom_sf(aes(fill=Mining))+
  geom_sf_label(aes(label = name), label.padding = unit(0.2, "lines"), size=3)+
  scale_fill_viridis_c(direction=-1)+
  theme_minimal()+
  theme(axis.text=element_blank(),
        axis.title = element_blank(),
        legend.position="bottom")


plot(bea_sf["total"]) # base R plotting

plot(bea_sf["total"], pal = c('#edf8b1','#7fcdbb','#2c7fb8'),
     nbreaks=3,
     breaks="jenks",
     main= "TITLE",
     key.pos=2) # base R plotting, improved

library(tmap)

tmap_mode("plot")


qtm(bea_sf, fill = "Mining",
    legend.outside=TRUE,
    legend.outside.position= "bottom",
    fill.title = "Mining Economic Production",
    style= "natural") # check help for style colors


tm_shape(bea_sf %>% filter(Year==2012))+
  tm_polygons("Mining", title= "Mining $") +
  tm_bubbles("Ag")+
  tm_layout(legend.outside=TRUE,
            inner.margins = c(.2, .05, .05, .1)) +
  tm_compass(size=0.5, type = "rose",
             position= c("right", "bottom"))

tmap_mode("view")

tm_shape(bea_sf %>% filter(Year==2012))+
  tm_polygons("Mining", title= "Mining $")# Interactive plot bc view
