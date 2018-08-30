# created by Hiz jamali
# created on 29/08/2018
# To rename sensor IDs in agronomic datasheet

library(tidyverse)
library(readr)

df <- read_csv("P:/ChrisN/R scripts/2015_canopy_temperature_cotton/data/ct_database_ds.csv")

sensors <- list.files("P:/ChrisN/R scripts/2015_canopy_temperature_cotton/data", full.names = T,pattern = "s*.csv", recursive = T) %>% 
  as.tibble() %>% 
  filter(!str_detect(value, pattern = "database")) %>% 
  mutate(path = dirname(value),
         sensor = basename(value)) %>% 
  
  
  separate(col = value, sep = "/", into = c("path","year", "location","experiment","sensor"), extra = "merge",fill = "right") %>% 
  mutate(sensor = str_remove(sensor, pattern = "^s")) %>% 
  unite(col = "sensor_uid", year, location, sensor, sep = "_", remove = F) %>% 
  unite(col = "new_path", path, sensor_uid, sep = "/", remove = F)

file.copy(sensors$value, sensors$new_path)

dirname("P:/ChrisN/R scripts/2015_canopy_temperature_cotton/data/ct_database_ds.csv")
