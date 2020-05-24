

library(leaflet)
library(tidyverse)
library(stringr)
library(maps)
library(tigris)
library(sp)
#set up leaflet app


m <- leaflet() %>%
  addTiles() %>%  # Add default OpenStreetMap map tiles
  addMarkers(lng=174.768, lat=-36.852, popup="The birthplace of R")


mapStates = map("state", fill = TRUE, plot = FALSE)
mapCounties = map("county", fill = T, plot = F)

states = tibble(names = state.name, abb = state.abb, region = state.region)
state_shapes <- states(cb = TRUE, resolution = '20m')

states_merged = geo_join(state_shapes, states, "NAME", "names")


pal = colorFactor("YlOrRd", domain = states_merged$region)

m = leaflet(data = states_merged) %>% addTiles() %>%
  addPolygons(fillColor = ~pal(states_merged$region), stroke = FALSE)



library(geojsonio)

# transfrom .json file into a spatial polygons data frame
states <- 
  geojson_read( 
    x = "https://raw.githubusercontent.com/PublicaMundi/MappingAPI/master/data/geojson/us-states.json"
    , what = "sp"
  )



tx_counties <- counties(state = c("WA","OR","CA","ID"), cb = TRUE, resolution = '20m')

plot(tx_counties)

