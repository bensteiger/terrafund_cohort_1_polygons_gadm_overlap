# Description -------------------------------------------------------------

# Author: Ben Steiger
# Date Created: 05/20/2024
# Last Updated: 05/20/2024
# Description: Subnational Jurisdiction - Spatial Intersection of GADM Level 2
#     and Project Polygons

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
    "project_polygons_08_13.shp"
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


# st_make_valid -----------------------------------------------------------

project_data <- st_make_valid(project_data)

# check if CRS' are the same ----------------------------------------------

if (st_crs(project_data) != st_crs(gadm_level_2)) {
  gadm_level_2 <- st_transform(gadm_level_2, st_crs(project_data))
}


# spatial intersection ----------------------------------------------------

# see where the project polygons intersect with the GADM level 2 shapefiles

intersects_result <- st_join(project_data, gadm_level_2, join = st_intersects)

#intersects_result <- st_intersects(project_data, gadm_level_2)

#intersection_result <- st_intersection(project_data, gadm_level_2)

# drop geometry -----------------------------------------------------------

intersects_result_df <- intersects_result %>%
  st_drop_geometry()

# save data ---------------------------------------------------------------

# shapefile

st_write(
  intersects_result,
  here(
    "Unified Database",
    "Data",
    "All",
    "Processed",
    "Subnational Jurisdiction",
    "project_gadm_intersect.shp"
  )
)

# csv

write_csv(
  intersects_result_df,
  file = here(
    "Unified Database",
    "Data",
    "All",
    "Processed",
    "Subnational Jurisdiction",
    "project_gadm_intersect.csv"
  )
)
