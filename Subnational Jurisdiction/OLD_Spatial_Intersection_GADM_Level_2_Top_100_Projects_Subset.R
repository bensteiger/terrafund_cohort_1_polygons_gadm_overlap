# Description -------------------------------------------------------------

# Author: Ben Steiger
# Date Created: 05/22/2024
# Last Updated: 05/22/2024
# Description: Subnational Jurisdiction - Spatial Intersection of GADM Level 2
#     and Project Polygons - 4 Countries I forgot

# Load libraries ----------------------------------------------------------

library(dplyr)
library(tidyverse)
library(stringr)
library(here)
library(snakecase)
library(sf)

# Load data ---------------------------------------------------------------

project_data <- st_read(
  here(
    "Unified Database",
    "Data",
    "All",
    "Processed",
    "Subnational Jurisdiction",
    "project_polygons.shp"
  )
)

gadm_level_2 <- st_read(
  here(
    "Unified Database",
    "Data",
    "All",
    "Processed",
    "Subnational Jurisdiction",
    "merged_gadm_level_2.shp"
  )
)

intersection_result_df <- read_csv(
  here(
    "Unified Database",
    "Data",
    "All",
    "Processed",
    "Subnational Jurisdiction",
    "project_gadm_intersect.csv"
  )
)

# check if CRS' are the same ----------------------------------------------

if (st_crs(project_data) != st_crs(gadm_level_2)) {
  gadm_level_2 <- st_transform(gadm_level_2, st_crs(project_data))
}

# subset gadm_data to new countries ---------------------------------------

gadm_level_2_sub <- gadm_level_2 %>%
  filter(country %in% c("Malawi", "Mali", "Mozambique", "Nigeria"))

# spatial intersection - subset ----------------------------------------------------

# see where the project polygons intersect with the GADM level 2 shapefiles

intersection_result_sub <-
  st_intersection(project_data, gadm_level_2_sub)

# drop geometry -----------------------------------------------------------

intersection_result_sub_df <- intersection_result_sub %>%
  st_drop_geometry()

# bind data ---------------------------------------------------------------

intersection_result_all_df <-
  rbind(intersection_result_df,
        intersection_result_sub_df) %>%
  arrange(project, country)

# save data ---------------------------------------------------------------

# shapefile

st_write(
  intersection_result_sub,
  here(
    "Unified Database",
    "Data",
    "All",
    "Processed",
    "Subnational Jurisdiction",
    "project_gadm_intersect_sub.shp"
  )
)

# csv

write_csv(
  intersection_result_all_df,
  file = here(
    "Unified Database",
    "Data",
    "All",
    "Processed",
    "Subnational Jurisdiction",
    "project_gadm_intersect_all.csv"
  )
)
