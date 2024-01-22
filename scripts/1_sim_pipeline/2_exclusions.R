# 1. Libraries ---------------------------------------------------------------

library(tidyverse)

source('scripts/0_custom_functions/codebooks.R')
source('scripts/0_custom_functions/binom_test.R')

# 2. Load data ---------------------------------------------------------------

load("data/dvs_sim.RData")
load("data/ivs_sim.RData")


# 3. Exclusions -----------------------------------------------------------

full_data <- full_join(ivs_sim, dvs_sim) |>
  mutate(
    ex_brows_int       = ifelse(brows_int == 0, FALSE, TRUE),
    ex_acc_ospan_sec   = ifelse(ospan_sec_acc*100 < gbinom(45, 0.50), TRUE, FALSE),
    ex_acc_rspan_sec   = ifelse(rspan_sec_acc*100 < gbinom(45, 0.50), TRUE, FALSE),
  )

clean_data <- full_data |>
  filter(ex_brows_int == FALSE & ex_acc_ospan_sec == FALSE & ex_acc_rspan_sec == FALSE)

save(full_data, clean_data, file = "data/full_data.Rdata")

