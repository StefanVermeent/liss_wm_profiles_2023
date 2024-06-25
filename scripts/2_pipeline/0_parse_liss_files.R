
# Libraries and functions -------------------------------------------------

library(tidyverse)
library(haven)
library(glue)

source("scripts/0_custom_functions/liss-functions.R")


# LISS Background Variables -----------------------------------------------

walk(
    list.files("data/liss_data/background", pattern = ".zip$", full.names = T),
    unzip_liss
  )


# LISS Income Data --------------------------------------------------------

walk(
  list.files("data/liss_data/income", pattern = ".zip$", full.names = T),
  unzip_liss
)

# LISS Crime Data ---------------------------------------------------------

walk(
  list.files("data/liss_data/crime", pattern = ".zip$", full.names = T),
  unzip_liss
)

