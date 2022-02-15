library(USAboundaries)
library(USAboundariesData)

counties <-us_counties(states = "KS")

class(counties)
head(counties)
 
#gives bounding box: max extent of coverage