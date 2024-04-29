# 1. Libraries ---------------------------------------------------------------

library(tidyverse)

source('scripts/0_custom_functions/codebooks.R')
source('scripts/0_custom_functions/binom_test.R')

# 2. Load data ---------------------------------------------------------------

full_data <- read_csv("data/liss_data/full_data.csv")
browser_int <- read_csv("data/liss_data/browser_interactions.csv")


# 3. Exclusions -----------------------------------------------------------

clean_data <- full_data |>
  mutate(
  #  ex_brows_int       = ifelse(brows_int == 0, FALSE, TRUE),
    ex_acc_ospan_sec   = ifelse(ospan_math_acc*100 < gbinom(45, 0.50), TRUE, FALSE),
    ex_acc_rspan_sec   = ifelse(rspan_rotation_acc*100 < gbinom(45, 0.50), TRUE, FALSE),
  ) |>
  left_join(browser_int) |>
  mutate(event_during_task = ifelse(is.na(event_during_task), FALSE, event_during_task))

clean_data <- clean_data |>
  filter(ex_acc_ospan_sec == FALSE & ex_acc_rspan_sec == FALSE & event_during_task == FALSE)


write_csv(clean_data, "data/liss_data/clean_data.csv")
