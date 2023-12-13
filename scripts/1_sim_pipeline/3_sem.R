
# 1. Libraries and Data ------------------------------------------------------

library(lavaan)
library(tidyverse)

# Simulated dataset with standardized variables
data_clean <- tibble(
  id             = 1:800,
  family_id  = 1:800,
  ospan          = rnorm(800, 0, 1), # Operation Span
  rspan          = rnorm(800, 0, 1), # Rotation Span
  upd            = rnorm(800, 0, 1), # Updating
  bind           = rnorm(800, 0, 1), # Binding
  dep            = rnorm(800, 0, 1), # Material deprivation composite
  threat         = rnorm(800, 0, 1), # Threat composite
  age            = rnorm(800, 0, 1), # age
  noise          = rnorm(800, 0, 1), # Environmental noise
  interrupt      = sample(c(0,1), size = 800, prob = c(0.95, 0.05), replace = TRUE), # Was interrupted
  leave_computer = sample(c(0,1), size = 800, prob = c(0.95, 0.05), replace = TRUE)  # Left computer during tasks
)

# 2. Specify Clustering Design -----------------------------------------------

# Some children are clustered within families.
# We account for this using the lavaan.survey package

cluster_design <- survey::svydesign(ids=~family_id, prob=~1, data = data_clean)


# 3. Model specification(s) --------------------------------------------------

model1 <-
  '
  # Measurement Model

  ## Latent factors
  wmc_l      =~ 1*ospan + rspan + bind + upd
  upd_l      =~ 1*upd

  ## Covariances
  upd   ~~ 0*upd

  dep   ~~ threat

  # Structural Model
  wmc_l ~ dep + threat + age + interrupt + leave_computer
  upd_l ~ dep + threat + age + interrupt + leave_computer
'


sem_fit1 <- lavaan::sem(
  model = model1,
  data = data_clean,
  orthogonal = TRUE,
  auto.cov.lv.x = FALSE,
  auto.cov.y = FALSE,
  std.lv = FALSE,
  fixed.x = FALSE
)

sem_fit1_cluster <- lavaan.survey::lavaan.survey(lavaan.fit = sem_fit1, survey.design = cluster_design, estimator = "ML")

summary(sem_fit1_cluster, fit.measures = TRUE, standardized = TRUE)


