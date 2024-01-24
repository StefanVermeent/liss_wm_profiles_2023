
# 1. Libraries and Data ------------------------------------------------------

library(lavaan)
library(tidyverse)
library(lavaan.survey)

# 2. Load data ------------------------------------------------------------

load("data/full_data_sim.RData")

# 2. Specify Clustering Design -----------------------------------------------

# Some children are clustered within families.
# We account for this using the lavaan.survey package

cluster_design <- survey::svydesign(ids=~nohouse_encr, prob=~1, data = clean_data_sim)


# 3. Model specification(s) --------------------------------------------------

## 3.1 Measurement Model ----
mod_meas <-
  '
  # Measurement Model

  ## Latent factors
  wmc_l      =~ 1*bu_bind_acc + rspan_cap + ospan_cap + bu_upd_acc
  upd_l      =~ 1*bu_upd_acc

  ## Covariances
  bu_upd_acc ~~ 0*bu_upd_acc
'


fit_meas1 <- lavaan::sem(
  model = mod_meas,
  data = clean_data_sim,
  estimator = "MLR", # Robust SEs in case of non-normal data
  missing = "ML",    # FIML for missing data
  orthogonal = TRUE,
  auto.cov.lv.x = FALSE,
  auto.cov.y = FALSE,
  std.lv = FALSE,
  fixed.x = FALSE
)

fit_meas1_cluster <- lavaan.survey::lavaan.survey(lavaan.fit = fit_meas1, survey.design = cluster_design, estimator = "MLR")
summary(fit_meas1_cluster, fit.measures = TRUE, standardized = TRUE)

## 3.2 Full Structural model

mod_full <-
  '
  # Measurement Model

  ## Latent factors
  wmc_l      =~ 1*bu_bind_acc + rspan_cap + ospan_cap + bu_upd_acc
  upd_l      =~ 1*bu_upd_acc

  ## Covariances
  bu_upd_acc ~~ 0*bu_upd_acc

  mat_dep        ~~ threat

  # Structural Model
  wmc_l ~ mat_dep + unp + threat + age + interrupt + leave
  upd_l ~ mat_dep + unp + threat + age + interrupt + leave
'




# Check model soundness ---------------------------------------------------

mod_full_pop <-
  '
  # Measurement Model

  ## Latent factors
  wmc_l      =~ 1*bu_bind_acc + 0.7*rspan_cap + 0.7*ospan_cap + 0.7*bu_upd_acc
  upd_l      =~ 1*bu_upd_acc

  ## Covariances
  bu_upd_acc ~~ 0*bu_upd_acc

  mat_dep        ~~ 0.3*threat

  # Structural Model
  wmc_l ~ 0.1*mat_dep + 0.1*unp + 0.1*threat + 0.1*age + 0.1*interrupt + 0.1*leave
  upd_l ~ 0.1*mat_dep + 0.1*unp + 0.1*threat + 0.1*age + 0.1*interrupt + 0.1*leave
'


sim_data <- lavaan::simulateData(
  model = mod_full_pop,
  sample.nobs = 800
) |>
  mutate(across(everything(), scale))


mod_full_sample <-
  '
  # Measurement Model

  ## Latent factors
  wmc_l      =~ 1*bu_bind_acc + rspan_cap + ospan_cap + bu_upd_acc
  upd_l      =~ 1*bu_upd_acc

  ## Covariances
  bu_upd_acc ~~ 0*bu_upd_acc

  mat_dep        ~~ threat

  # Structural Model
  wmc_l ~ mat_dep + unp + threat + age + interrupt + leave
  upd_l ~ mat_dep + unp + threat + age + interrupt + leave
'

fit_meas2 <- lavaan::sem(
  model = mod_full_sample,
  data = sim_data,
  estimator = "MLR", # Robust SEs in case of non-normal data
  missing = "ML",    # FIML for missing data
  orthogonal = TRUE,
  auto.cov.lv.x = FALSE,
  auto.cov.y = FALSE,
  std.lv = FALSE,
  fixed.x = FALSE
)

summary(fit_meas2, fit.measures = T)
