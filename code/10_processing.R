#############################################
# Title: Data Processing
# Author: 
# Date: 
# Inputs: 
# Outputs: 
#############################################

# ============================================================================ #
# =============================== Description ================================ #
# ============================================================================ #



# ============================================================================ #
# ================================= Setup ==================================== #
# ============================================================================ #

  # Clear working environment
  rm(list = ls())
  
  # ========================================================================== #
  # Load Libraries
  # ========================================================================== #
  
    library(ggplot2)
    library(tidyverse)
    library(logr)
  
  # ========================================================================== #
  # Set Parameters
  # ========================================================================== #
  
    # Set export toggle
    p_export <- F
    
    # Set timestamp
    p_timestamp <- Sys.time()
    p_date <- date(p_timestamp)
    
    # Set output directory
    p_dir_out_base <- ""
    
    # Set input directory
    p_dir_in_base <- ""
  
  # ========================================================================== #
  # Load Data
  # ========================================================================== #

    in.cm2020 <- read_csv("data/cm_2020-01-01_2021-01-01.csv")
    in.cm2021 <- read_csv("data/cm_2021-01-01_2022-01-01.csv")
    in.cm2022 <- read_csv("data/cm_2022-01-01_2023-01-01.csv")
    in.cm2023 <- read_csv("data/cm_2023-01-01_2023-09-01.csv")
    
    in.infra <- read_csv("data/offshore_infrastructure_v20231106.csv")
    
    in.lng <- read_csv("data/GEM-GGIT-LNG-Terminals-2023-10/LNG Terminals 2023-12-18-Table 1.csv", col_types = cols(Longitude = col_double(), Latitude = col_double())) %>% janitor::clean_names()
    
# ============================================================================ #
# ================================= Processing ================================== #
# ============================================================================ #
  
    # Combine all Carbon Mapper methane data into one dataset
    all.cm <- bind_rows(in.cm2020, in.cm2021, in.cm2022, in.cm2023)
    
    
    filtered.cm <- all.cm %>% 
      # Restrict dataset to specified region
      filter(plume_latitude < 31 & plume_latitude > 26 & plume_longitude < -88 & plume_longitude > -97) %>% 
      # Restrict IPCC sector to "Oil & Gas" and "Other"
      filter(ipcc_sector %in% c("Oil & Gas (1B2)", "Other"))
    
    write_csv(filtered.cm, file = "data/cm_filtered.csv")
    
    # Restrict infrastructure dataset to specified region
    filtered.infra <- in.infra %>% filter(lat < 31 & lat > 26 & lon < -88 & lon > -97)
    
    write_csv(filtered.infra, file = "data/infra_filtered.csv")
    
    # Restrict LNG terminals to specified region
    filtered.lng <- in.lng %>% filter(latitude < 31 & latitude > 26 & longitude < -88 & longitude > -97) %>% 
      mutate(status_smpl = case_when(
        status == "Operating" ~ "active",
        status == "Proposed" ~ "proposed",
        .default = "inactive"
          ))
    
    write_csv(filtered.lng, file = "data/lng_filtered.csv")
    
    