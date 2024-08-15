# Description -------------------------------------------------------------

# Author: Ben Steiger
# Date Created: 05/20/2024
# Last Updated: 05/20/2024
# Description: Subnational Jurisdiction - Collating all Top 100 Polygons

# Load libraries ----------------------------------------------------------

library(dplyr)
library(tidyverse)
library(stringr)
library(here)
library(snakecase)
library(sf)

# Load data ---------------------------------------------------------------

all_polygons <-
  st_read(
    "C:/Users/benjamin.steiger/OneDrive - World Resources Institute/Documents/2024_08_15_all_projects_TM_updated_intrv_hghana/2024_08_15_all_projects_TM_updated_intrv_hghana.shp"
  )

# Convert to snakecase -----------------------------------------------------------

# convert all columns to snake_case

names(all_polygons) <-
  to_snake_case(names(all_polygons))

# Make all polygons valid -------------------------------------------------

all_polygons <- st_make_valid(all_polygons)

# union all polygons together by project -----------------------------------

grouped_polygons <- all_polygons %>%
  group_by(project) %>%
  summarize(geometry = st_union(geometry))

# measure area ------------------------------------------------------------

#grouped_polygons <- grouped_polygons %>%
#  mutate(area_sqm = st_area(geometry))
#
## Convert the area from square meters to hectares (1 hectare = 10,000 square meters)
#grouped_polygons <- grouped_polygons %>%
#  mutate(area_ha = as.numeric(area_sqm) / 10000)
#
## select variables --------------------------------------------------------
#
#grouped_polygons <- grouped_polygons %>%
#  select(-area_sqm)

# drop geometry -----------------------------------------------------------

grouped_polygons_df <- grouped_polygons %>%
  st_drop_geometry()

# save data ----------------------------------------------------------

# shapefile

st_write(
  grouped_polygons,
  here(
    "Unified Database",
    "Data",
    "All",
    "Processed",
    "Subnational Jurisdiction",
    "project_polygons_08_13.shp"
  )
)

# csv

write_csv(
  grouped_polygons_df,
  file = here(
    "Unified Database",
    "Data",
    "All",
    "Processed",
    "Subnational Jurisdiction",
    "project_polygons_df.csv"
  )
)

