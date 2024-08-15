# Description -------------------------------------------------------------

# Author: Ben Steiger
# Date Created: 05/20/2024
# Last Updated: 05/20/2024
# Description: Subnational Jurisdiction - Link to Unified Database

# Load libraries ----------------------------------------------------------

library(dplyr)
library(tidyverse)
library(stringr)
library(here)
library(snakecase)
library(sf)

# Load data ---------------------------------------------------------------

intersection_result_df <- read_csv(
  here(
    "Unified Database",
    "Data",
    "All",
    "Processed",
    "Subnational Jurisdiction",
    "project_gadm_intersect_grouped_results.csv"
  )
)

# added TM project IDs to polygon project names

polygons_project_id_mapping_df <- read_csv(
  here(
    "Unified Database",
    "Data",
    "All",
    "Processed",
    "Subnational Jurisdiction",
    "polygons_project_tm_id_mapping.csv"
  )
)

# Convert to snakecase -----------------------------------------------------------

# convert all columns to snake_case

names(polygons_project_id_mapping_df) <-
  to_snake_case(names(polygons_project_id_mapping_df))

# join by project ID ------------------------------------------------------

joined_polygon_ids <-
  left_join(intersection_result_df,
            polygons_project_id_mapping_df,
            by = "project") %>%
  filter(!is.na(tm_project_id))

# save data ---------------------------------------------------------------

write_csv(
  joined_polygon_ids,
  file = here(
    "Unified Database",
    "Data",
    "All",
    "Processed",
    "Subnational Jurisdiction",
    "joined_polygon_ids_final.csv"
  )
)

