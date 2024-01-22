
# 1. Libraries and Data ------------------------------------------------------

library(lavaan)
library(tidyverse)
library(lavaan.survey)

# 2. Load data ------------------------------------------------------------

load("data/full_data.RData")

# 2. Specify Clustering Design -----------------------------------------------

# Some children are clustered within families.
# We account for this using the lavaan.survey package

cluster_design <- survey::svydesign(ids=~nohouse_encr, prob=~1, data = data_clean)


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
  data = data_clean,
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

