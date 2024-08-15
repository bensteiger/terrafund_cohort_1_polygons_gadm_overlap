# Description -------------------------------------------------------------

# Author: Ben Steiger
# Date Created: 05/20/2024
# Last Updated: 05/20/2024
# Description: Subnational Jurisdiction - Group Results by Project

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
    "project_gadm_intersect.csv"
  )
)

# Group data -------------------------------------------------------

grouped_project_gadm_int <- intersection_result_df %>%
  group_by(project) %>%
  mutate(
    level_0_list = paste(unique(country), collapse = ","),
    level_1_list = paste(unique(name_1), collapse = ","),
    level_2_list = paste(unique(name_2), collapse = ",")
  ) %>%
  slice(1) %>%
  ungroup()

# select variables --------------------------------------------------------

grouped_project_gadm_int_filtered <- grouped_project_gadm_int %>%
  select(project, country, level_0_list, level_1_list, level_2_list)

# save data ---------------------------------------------------------------

write_csv(
  grouped_project_gadm_int_filtered,
  file = here(
    "Unified Database",
    "Data",
    "All",
    "Processed",
    "Subnational Jurisdiction",
    "project_gadm_intersect_grouped_results.csv"
  )
)
