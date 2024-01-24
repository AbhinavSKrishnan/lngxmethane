#############################################
# Title: 
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
  
    library(rvest)
    library(RSelenium)
    library(httr)
    library(netstat)
    library(selectr)
    library(wdman)

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
    
    # Set base url
    p_url_base <- "https://globalenergyobservatory.org"
  
  # ========================================================================== #
  # Load Data
  # ========================================================================== #

    
# ============================================================================ #
# ================================= Scrape ================================== #
# ============================================================================ #

    
    
    url <- "https://globalenergyobservatory.org/list.php?db=Transmission&type=LNG_Ports&expand_article=1"
    
    table.ports <- read_html(url) %>% html_table() %>% as.data.frame()
    
    # Create character vector of nodes with <tr> tag using page source code
    v.nodes.tr <- read_html(url) %>% 
      html_nodes("tr") %>% 
      as.character()
    
    # Remove nodes without 'href' tag in them (rows of the table with ads in them)
    v.filtered.tr <- v.nodes.tr[(v.nodes.tr %like% "href")]
    
    # ========================================================================== #
    # Function: Scrape Page
    # ========================================================================== #
    
    scrape_page <- function(link_suffix) {
      
      # Create full url using base url and link suffix
      url.listing <- paste0(p_url_base, link_suffix)
      
      # Create character vector of nodes with <td> tag using page source code
      v.nodes.li <- read_html(url.listing) %>% 
        html_nodes("td") %>% 
        as.character() %>% view()
      
      # Filter <li> nodes to only nodes with links (designated by href)
      v.nodes.li.filtered <- v.nodes.li[!(v.nodes.li %like% "href")]
      
      # Clean data
      # Create empty vector 
      v.holding <- c()
      
      # Strip unnecessary characters from nodes
      for (i in 1:length(v.nodes.li.filtered)) {
        
        # NOTE: strong nodes don't match up with filtered nodes
        # v.holding[i] <- gsub(v.nodes.li.str[i], "", v.nodes.li.filtered[i])
        v.holding[i] <- gsub("<li>\\n|</li>|<strong>|</strong>|<br>\\n", "", v.nodes.li.filtered[i]) # Remove tags
        v.holding[i] <- str_trim(v.holding[i], side = "both") # Trim whitespace
        
      }
      
      # Remove "Overlays" and "Base Layers" elements
      v.holding <- v.holding[!(v.holding %like% "<label>")]
      
      # Split vector at colon to separate variables from values
      v.split <- str_split_fixed(v.holding, ":", n = 2)
      
      # subset columns of matrix
      v.variables <- v.split[,1]
      v.values <- v.split[,2]
      
      # Create datatable with variables and values
      dt.temp <- data.table(v.variables, v.values)
      
      # Melt values to wide
      # dt.temp.wide <- dcast(dt.temp, formula = ) # Doesn't work well
      dt.temp.wide <- pivot_wider(dt.temp, names_from = v.variables, values_from = v.values)
      
      return(dt.temp.wide)
      
    }
    
    # ========================================================================== #
    # Clean Data
    # ========================================================================== #
    
    # Create empty vector 
    tb.holding <- tibble()
    ls.holding <- ls()
    
    # Create a dataset with the name of the port and the geoid href
    for (current_row in v.filtered.tr) {
      
      temp_href <- str_extract(current_row, pattern = "geoid/(\\d+)")
      temp_geoid <- str_c("/", temp_href)
      
      temp_target <- str_extract(current_row, pattern = '>([A-Za-z0-9]+( [A-Za-z0-9]+)+)')
      temp_portname <- str_remove(temp_target, pattern = ">")
      
      
      
      tb.holding[[temp_portname]] <- 
      
    }
    
    
    