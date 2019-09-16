library(shiny)
library(readxl)
library(tidyverse)
library(leaflet)
require(rgdal)
library(ggthemes)
library(shinythemes)
library(rworldmap)

#Set working directory
setwd("/Users/user/wasteproject/Data-project-2")

#Calling datasets

waste_postcodes_latlong <- read_csv("shiny_app/synth_waste.csv")

waste_new <- read_csv("shiny_app/synth_waste.csv")

wales_shape <-  readOGR("../Data-project-2/shapefile/Wales_lad_2011/wales_lad_2011.shp")

wales <- spTransform(wales_shape, CRS("+init=epsg:4326"))

#Set time periods for waste by time plot
period_breakdown <- waste_new %>%
  select(county_name, period_ID, tonnes.by.material, material, is.leaf.level) %>%
  drop_na(tonnes.by.material) %>%
  filter(is.leaf.level == FALSE)

#Set authority names, facility types and levels
all_authority_names <- unique(waste_new$county_name)

all_facility_types <- unique(waste_new$facility.type)

all_facility_levels <- unique(waste_new$level)

#Set up material groups for material map
waste_new %>%
  filter(is.leaf.level) %>%
  drop_na(tonnes.by.material) %>%
  group_by(waste.stream.type) %>%
  summarise(count = n(), total = sum(tonnes.by.material)) %>%
  arrange(desc(total))

comingled_recyclate <- waste_new %>%
  drop_na(latitude) %>%
  drop_na(longitude) %>%
  filter(is.leaf.level == FALSE) %>%
  filter(waste.stream.type == "Comingled recyclate")
comingled_recyclate

food_waste <- waste_new %>%
  drop_na(latitude) %>%
  drop_na(longitude) %>%
  filter(is.leaf.level == FALSE) %>%
  filter(waste.stream.type == "Food waste")
food_waste

green_waste <- waste_new %>%
  drop_na(latitude) %>%
  drop_na(longitude) %>%
  filter(is.leaf.level == FALSE) %>%
  filter(waste.stream.type == "Green waste")
green_waste

mixed_green_and_food_waste <- waste_new %>%
  drop_na(latitude) %>%
  drop_na(longitude) %>%
  filter(is.leaf.level == FALSE) %>%
  filter(waste.stream.type == "Mixed green and food waste")
mixed_green_and_food_waste

residual_waste <- waste_new %>%
  drop_na(latitude) %>%
  drop_na(longitude) %>%
  filter(is.leaf.level == FALSE) %>%
  filter(waste.stream.type == "Residual waste")
residual_waste

source_segregated_recyclate <- waste_new %>%
  drop_na(latitude) %>%
  drop_na(longitude) %>%
  filter(is.leaf.level == FALSE) %>%
  filter(waste.stream.type == "Source segregated recyclate")
source_segregated_recyclate

#Get populations for each authority and set wastes to each population
population_df <- data.frame(county_name = c("Isle of Anglesey", "Gwynedd", "Conwy",
                                            "Denbighshire", "Flintshire", "Wrexham", "Powys", "Ceredigion", "Pembrokeshire", 
                                            "Carmarthenshire", "Swansea", "Neath Port Talbot", "Bridgend", "The Vale of Glamorgan",
                                            "Cardiff", "Rhondda Cynon Taf", "Merthyr Tydfil", "Caerphilly", "Blaenau Gwent",
                                            "Torfaen", "Monmouthshire", "Newport"), 
                            population = c(69961, 124178, 117181, 95330, 155593, 136126, 132447, 72992, 125055,
                                           187568, 246466, 142906, 144876, 132165, 364248, 240131, 60183, 181019, 69713,
                                           93049, 94142, 153302),
                            area = c(711, 2535, 1126, 837, 
                                     437, 504, 5181, 1786, 1619, 2370, 380, 441, 251, 331, 141, 424, 111, 277, 109, 
                                     126, 849, 191))

sum_tonnes_by_material <- waste_new %>%
  drop_na(tonnes.by.material) %>%
  filter(is.leaf.level == FALSE) %>%
  group_by(county_name) %>%
  summarise(total_tonnes_by_material = sum(tonnes.by.material))
                                                                                                                      
pop_and_waste <- sum_tonnes_by_material %>%
  full_join(population_df, key = "county_name")

pop_and_waste <- pop_and_waste %>%
  mutate(tonnes_by_pop = total_tonnes_by_material/population)

#Create country map
countries <- read_csv("outputs/countries.csv")

countries_map <- joinCountryData2Map(countries, joinCode = "ISO3",
                                     nameJoinColumn = "ISO_code")




