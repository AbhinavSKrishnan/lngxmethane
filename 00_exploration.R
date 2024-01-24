#############################################
# Title: LNG Infrastructure and Methane Plume Exploration
# Author: Abhinav S. Krishnan
# Date: 16 January 2024
# Inputs: GFW Offshore Infrastructure Dataset, Carbon Mapper Methane Plume Dataset
# Outputs: 
#############################################

# ============================================================================ #
# =============================== Description ================================ #
# ============================================================================ #

  # SEE CARBON MAPPER PRODUCT GUIDE FOR DATA STRUCTURE INFORMATION

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
    p_dir_in_base <- "~/Documents/Professional/SkyTruth/lngxmethane/data"
  
  # ========================================================================== #
  # Load Data
  # ========================================================================== #

    in.infra <- read_csv(file = file.path(p_dir_in_base, "offshore_infrastructure_v20231106.csv"), col_types = cols(structure_id = 'c'))
    
    in.methane <- read_csv(file = file.path(p_dir_in_base, "export_2020-01-01_2021-01-01.csv"))

  # ============================================================================ #
  # ================================= Processing ================================== #
  # ============================================================================ #
  
    # The infrastructure data is bounded from 2017 to 2020, so I downloaded the methane plume data for 2020 alone to experiment on
    
    # All non-2020 observations in the infrastructure dataset need to be removed
    clean.infra <- in.infra %>% 
      filter(composite_date > '2020-01-01' & composite_date < '2020-12-31')
    
    # Identify the range of latitudes and longitudes available in the in.methane dataset
    range(in.methane$plume_latitude)
    range(in.methane$plume_longitude)
    
    # Keep infrastructure that exists within the methane latitude and longitude ranges
    clean.infra <- clean.infra %>% 
      filter(lat < 41 & lat > 30 & lon > -123 & lon < -100)
  
# ============================================================================ #
# ================================= Export ================================== #
# ============================================================================ #
    
    write_csv(clean.infra, file = "clean_infra.csv")
    