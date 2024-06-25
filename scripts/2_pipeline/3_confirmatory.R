
# Libraries ---------------------------------------------------------------

library(tidyverse)
library(lavaan)

# 2. Load data ------------------------------------------------------------

clean_data <- read_csv("data/liss_data/clean_data.csv") %>%
  mutate(
    inr_m = log(inr_m),
    inr_cv = log(inr_cv)
  ) |>
  mutate(
    across(c(ends_with('cap'), binding_number_acc, updating_number_acc), ~scale(x = .) |> as.numeric()),
    across(c(inr_m, inr_cv, threat_comp, p_scar_m, p_scar_cv), ~scale(x = .) |> as.numeric()),
    age = scale(age) |> as.numeric(),
    edu = scale(edu) |> as.numeric(),
    noise = scale(noise) |> as.numeric(),
    interrupt = case_when(
      interrupt == 1 ~ 0,
      interrupt == 2 ~ 1,
      TRUE ~ interrupt
    ),
    leave = case_when(
      leave == 1 ~ 0,
      leave == 2 ~ 1,
      TRUE ~ leave
    ),
    age_sq = age^2
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

fit = lavaan::summary(fit_meas01, standardized = TRUE)



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

fit_meas02_sum <- lavaan::summary(fit_meas02, fit.measures = TRUE, standardized = TRUE)

lavaan::modificationIndices(fit_meas02) |> View()

fitstats_meas02 <- fitMeasures(fit_meas02)[c("cfi.robust", "rmsea.robust", "rmsea.ci.lower.scaled", "rmsea.ci.upper.scaled")]

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

fit_meas03_sum  = lavaan::summary(fit_meas03, fit.measures = TRUE, standardized = TRUE)

fitstats_meas03 <- fitMeasures(fit_meas03)[c("cfi.robust", "rmsea.robust", "rmsea.ci.lower.scaled", "rmsea.ci.upper.scaled")]


# 4. Full model --------------------------------------------------------------

## 4.1 Add all predictors and covariates ----
mod_struc01 <-
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
   inr_m ~ 0
   inr_cv ~ 0
   threat_comp ~ 0
   p_scar_m ~ 0
   p_scar_cv ~ 0
   age ~ 0
   noise ~ 0

   # Structural model

   inr_m ~~ 1*inr_m + inr_cv + threat_comp + p_scar_m + p_scar_cv + age + age_sq + noise + leave + interrupt
   inr_cv ~~ 1*inr_cv + threat_comp + p_scar_m + p_scar_cv + age + age_sq + noise + leave + interrupt
   threat_comp ~~ 1*threat_comp + p_scar_m + p_scar_cv + age + age_sq + noise + leave + interrupt
   p_scar_m ~~ 1*p_scar_m + p_scar_cv + age + age_sq + noise + leave + interrupt
   p_scar_cv ~~ 1*p_scar_cv + age + age_sq + noise + leave + interrupt
   age ~~ 1*age + age_sq + noise + leave + interrupt
   age_sq ~~ noise + leave + interrupt
   noise ~~ 1*noise + leave + interrupt
   leave ~~ interrupt

   wmc_l ~ age + age_sq + noise + leave + interrupt + inr_m + inr_cv + threat_comp + p_scar_m + p_scar_cv
   upd_l ~ age + age_sq + noise + leave + interrupt + inr_m + inr_cv + threat_comp + p_scar_m + p_scar_cv
'


fit_struc01 <- lavaan::sem(
  model = mod_struc01,
  data = clean_data,
  estimator = "MLR", # Robust SEs in case of non-normal data
  missing = "ML",    # FIML for missing data
  cluster = 'nohouse_encr', # Clustering within
  orthogonal = TRUE,
  std.lv = FALSE,
  fixed.x = FALSE
)

fit_struc01_sum <- lavaan::summary(fit_struc01, fit.measures = TRUE, standardized = TRUE)

fitstats_struc01 <- fitMeasures(fit_struc01)[c("cfi.robust", "rmsea.robust", "rmsea.ci.lower.scaled", "rmsea.ci.upper.scaled")]

## 4.2 Extract regression coefficients ----

sem_reg_coef_covar <- standardizedsolution(fit_struc01) |>
  as_tibble() |>
  filter(op == "~", rhs %in% c("age", "age_sq", 'noise', "interrupt", "leave"))

sem_reg_coef <- standardizedsolution(fit_struc01) |>
  as_tibble() |>
  filter(op == "~", rhs %in% c("inr_m", 'inr_cv', "threat_comp", "p_scar_m", "p_scar_cv")) |>
  group_by(lhs) |>
  mutate(pvalue_adj = p.adjust(pvalue, method = "fdr")) |>
  ungroup()

equivalence_test_ml = function(sesoi, ml_effect, ml_se){
  p1 = 1 - pnorm( ml_effect, mean = -sesoi, sd = ml_se)
  p2 =     pnorm( ml_effect, mean =  sesoi, sd = ml_se)
  return(max(p1, p2))
}

equivalence_tests <- standardizedSolution(fit_struc01) |>
  as_tibble() |>
  filter(op == "~", rhs %in% c("inr_m", 'inr_cv', "threat_comp", "p_scar_m", "p_scar_cv")) |>
  select(lhs, rhs, est.std, se) |>
  mutate(
    eq_pvalue = pmap(list(lhs, rhs, est.std, se), function(lhs, rhs, est.std, se) {
      equivalence_test_ml(0.1, est.std, se)
    })
  ) |>
  unnest(eq_pvalue)

## 4.3 Extract factor loadings ----

sem_fact_loadings <- standardizedsolution(fit_struc01) |>
  as_tibble() |>
  filter(op == "=~")

sem_variances <- parameterEstimates(fit_struc01) |>
  as_tibble() |>
  filter(op == "~~")


save(fit_meas02_sum, fitstats_meas02, fit_meas03_sum, fitstats_meas03, fit_struc01, fit_struc01_sum, fitstats_struc01, sem_reg_coef_covar, sem_reg_coef, equivalence_tests, sem_fact_loadings, sem_variances, file = "analysis_objects/confirmatory_results.RData")

