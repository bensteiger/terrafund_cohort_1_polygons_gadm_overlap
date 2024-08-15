# Description -------------------------------------------------------------

# Author: Ben Steiger
# Date Created: 05/20/2024
# Last Updated: 05/20/2024
# Description: Subnational Jurisdiction - Merge all level 2 GADM Shapefiles

# Load libraries ----------------------------------------------------------

library(dplyr)
library(tidyverse)
library(stringr)
library(here)
library(snakecase)
library(sf)

# Load data ---------------------------------------------------------------

# Set the path to the main folder containing the subfolders
folder_path <-
  "Unified Database/Data/All/Raw/Subnational Jurisdiction/GADM_Shapefiles"

# List all subdirectories within the main folder
subfolders <- list.dirs(folder_path, recursive = FALSE)

# Find all .shp files ending in "_2.shp" within those subdirectories
shapefiles <-
  list.files(subfolders, pattern = "_2\\.shp$", full.names = TRUE)

# Read all the shapefiles into a list
shapefiles_list <- lapply(shapefiles, st_read)

# Optional: Combine all shapefiles into a single `sf` object
combined_shapefiles <- do.call(rbind, shapefiles_list)

# Convert to snakecase -----------------------------------------------------------

# convert all columns to snake_case

names(combined_shapefiles) <-
  to_snake_case(names(combined_shapefiles))

# Make all shapefiles valid -------------------------------------------------

combined_shapefiles <- st_make_valid(combined_shapefiles)

# Save data ---------------------------------------------------------------

st_write(
  combined_shapefiles,
  here(
    "Unified Database",
    "Data",
    "All",
    "Processed",
    "Subnational Jurisdiction",
    "merged_gadm_level_2.shp"
  )
)
