# created by Hiz jamali
# created on 29/08/2018
# To rename sensor IDs in agronomic datasheet


rm(list=ls(all=TRUE))##clear workspace
print(ls())##check output is zero to confirm clear workspace

library(tidyverse)

setwd("K:/AusBIOTIC database/Definative_cT_Raw/canopy_temperature_data_to_be_uploaded_to_DAP/canopy_temperature")

meta_data <- read_csv("../cotton_canopy_sensor_agronomic_data.csv")

sensors <- list.files(full.names = F,pattern = "*.csv", recursive = T) %>% 
  as.tibble() %>% 
  filter(!str_detect(value, pattern = "database")) %>% 
  mutate(path = dirname(value),
         sensor_filename = basename(value)) %>%
  separate(col = path, sep = "/", into = c("planting_year","location","experiment_name"), remove = F, extra = "merge",fill = "right") %>%
  mutate(planting_year = as.integer(planting_year)) %>% 
  # mutate(sensor_filename = str_replace(sensor_filename, pattern = "^.*PHEN", "PHEN")) %>% 
  # mutate(sensor_filename = str_remove(sensor_filename, pattern = "-Object Temperature-Celsius")) %>% 
  mutate(sensor_filename = str_remove(sensor_filename, pattern = "^s")) %>% 
  mutate(sensorID = str_remove(sensor_filename, pattern = ".csv")) #%>% 
  # mutate(UID = paste(year, location, sensor, sep = "_")) %>% 
  # mutate(sensor_filename_new = paste0(UID,".csv")) %>% 
  # mutate(new_dir = paste("renamed_files", year, location, experiment, sep = "/")) %>% 
  # mutate(new_path = paste(new_dir, sensor_filename_new, sep = "/"))
  

# Check which data streams are missing from metadata table
anti_join(meta_data,sensors)
anti_join(sensors,meta_data)

# filter metadata to only change stream files with a metadata entry
meta_data_available <- select(meta_data, uniq_ID) %>% 
  inner_join(sensors)

# create new copy for each data stream renamed with the uniq_ID
new_directories <- as.vector(unique(meta_data_available$new_dir))

for (i in 1:length(new_directories)) {
  dir.create(new_directories[i], recursive = T)
}

file.copy(meta_data_available$value, meta_data_available$new_path)

