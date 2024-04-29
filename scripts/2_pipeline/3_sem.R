
# Libraries ---------------------------------------------------------------

library(tidyverse)
library(lavaan)

# 2. Load data ------------------------------------------------------------

clean_data <- read_csv("data/liss_data/clean_data.csv") %>%
  mutate(
    across(c(ends_with('cap'), binding_number_acc, updating_number_acc), ~scale(x = .) |> as.numeric())
  ) |>
  mutate(nohouse_encr = as.character(nohouse_encr))



# 3. Model specification(s) --------------------------------------------------

## 3.1 Starting specification (does not converge) ----
mod_meas01 <-
  '
   # Measurement Model

   ## Latent factors
   wmc_l      =~ 1*binding_number_acc + rspan_cap + ospan_cap + updating_number_acc
   upd_l      =~ 1*updating_number_acc

   ## Covariances
    updating_number_acc ~~ 0*updating_number_acc
    updating_number_acc ~~ binding_number_acc

   rspan_cap ~ 0
   ospan_cap ~ 0
   binding_number_acc ~ 0
   updating_number_acc ~ 0
'


fit_meas01 <- lavaan::sem(
  model = mod_meas01,
  data = clean_data,
  estimator = "MLR", # Robust SEs in case of non-normal data
  missing = "ML",    # FIML for missing data
  cluster = 'nohouse_encr', # Clustering within
  se = "robust",
  orthogonal = TRUE,
  auto.cov.lv.x = FALSE,
  auto.cov.y = TRUE,
  std.lv = FALSE,
  fixed.x = FALSE
)

fit = lavaan::summary(fit_meas01, fit.measures = TRUE, standardized = TRUE)



## 3.2 Remove covariance ----

mod_meas02 <-
  '
   # Measurement Model

   ## Latent factors
   wmc_l      =~ 1*binding_number_acc + rspan_cap + ospan_cap + updating_number_acc
   upd_l      =~ 1*updating_number_acc

   ## Covariances
    updating_number_acc ~~ 0*updating_number_acc

   rspan_cap ~ 0
   ospan_cap ~ 0
   binding_number_acc ~ 0
   updating_number_acc ~ 0
'

fit_meas02 <- lavaan::sem(
  model = mod_meas02,
  data = clean_data,
  estimator = "MLR", # Robust SEs in case of non-normal data
  missing = "ML",    # FIML for missing data
  cluster = 'nohouse_encr', # Clustering within
  se = "robust",
  orthogonal = TRUE,
  auto.cov.lv.x = FALSE,
  auto.cov.y = FALSE,
  std.lv = F)

fit02 <- lavaan::summary(fit_meas02, fit.measures = TRUE, standardized = TRUE)

lavaan::modificationIndices(fit_meas02) |> View()



## 3.3 Add covariance between rspan and ospan

mod_meas03 <-
  '
   # Measurement Model

   ## Latent factors
   wmc_l      =~ 1*binding_number_acc + rspan_cap + ospan_cap + updating_number_acc
   upd_l      =~ 1*updating_number_acc

   # Covariances
   updating_number_acc ~~ 0*updating_number_acc
   rspan_cap ~~ ospan_cap

   rspan_cap ~ 0
   ospan_cap ~ 0
   binding_number_acc ~ 0
   updating_number_acc ~ 0

'

fit_meas03 <- lavaan::sem(
  model = mod_meas03,
  data = clean_data,
  estimator = "MLR", # Robust SEs in case of non-normal data
  missing = "ML",    # FIML for missing data
  cluster = 'nohouse_encr', # Clustering within
  orthogonal = TRUE,
  std.lv = FALSE,
  fixed.x = FALSE
)

fit03 = lavaan::summary(fit_meas03, fit.measures = TRUE, standardized = TRUE)

semPlot::semPaths(fit_meas03)
