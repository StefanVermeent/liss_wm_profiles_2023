
# Libraries ---------------------------------------------------------------

library(tidyverse)
library(lavaan)
library(bain)
library(flextable)

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


load('analysis_objects/confirmatory_results.RData')


# 2. Exploratory analysis 1: Associations with separate tasks --------------------------

# These results are presented in the main text.

lm_reg_coef_expl <- bind_rows(
  lm(rspan_cap ~ inr_cv + inr_m + threat_comp + p_scar_m + p_scar_cv + age + age_sq + noise + interrupt + leave, data = clean_data) |>
    broom::tidy(conf.int = T) |>
    mutate(task = "rspan", domain = "WMC"),
  lm(ospan_cap ~ inr_cv + inr_m + threat_comp + p_scar_m + p_scar_cv + age + age_sq + noise + interrupt + leave, data = clean_data) |>
    broom::tidy(conf.int = T) |>
    mutate(task = "Ospan", domain = "WMC"),
  lm(binding_number_acc ~ inr_cv + inr_m + threat_comp + p_scar_m + p_scar_cv + age + age_sq + noise + interrupt + leave, data = clean_data) |>
    broom::tidy(conf.int = T) |>
    mutate(task = "binding", domain = "WMC"),
  lm(updating_number_acc ~ inr_cv + inr_m + threat_comp + p_scar_m + p_scar_cv + age + age_sq + noise + interrupt + leave, data = clean_data) |>
    broom::tidy(conf.int = T) |>
    mutate(task = "updating", domain = "WMU"),
) |>
  filter(term %in% c("inr_cv", "inr_m", "threat_comp", "p_scar_m", "p_scar_cv")) |>
  group_by(domain) |>
  mutate(pvalue_adj = p.adjust(p.value, method = "fdr"))


equivalence_test_ml = function(sesoi, ml_effect, ml_se){
  p1 = 1 - pnorm( ml_effect, mean = -sesoi, sd = ml_se)
  p2 =     pnorm( ml_effect, mean =  sesoi, sd = ml_se)
  return(max(p1, p2))
}

equivalence_tests_lm_expl <- lm_reg_coef_expl |>
  as_tibble() |>
  select(task, term, estimate, std.error, conf.low, conf.high) |>
  mutate(
    eq_pvalue = pmap(list(task, term, estimate, std.error, conf.low, conf.high), function(task, term, estimate, std.error, conf.low, conf.high) {
      equivalence_test_ml(0.1, estimate, std.error)
    })
  ) |>
  unnest(eq_pvalue)

# 5. Exploratory analysis 2: Path constraints --------------------------------------------------------------

## 5.1 Constrain WMC regression paths to zero ----
mod_struc_expl02 <-
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


   wmc_l ~ age + age_sq + noise + leave + interrupt + 0*inr_m + 0*inr_cv + 0*threat_comp + 0*p_scar_m + 0*p_scar_cv
   upd_l ~ age + age_sq + noise + leave + interrupt + inr_m + inr_cv + threat_comp + p_scar_m + p_scar_cv
'


fit_struc_expl02 <- lavaan::sem(
  model = mod_struc_expl02,
  data = clean_data,
  estimator = "MLR", # Robust SEs in case of non-normal data
  missing = "ML",    # FIML for missing data
  cluster = 'nohouse_encr', # Clustering within
  orthogonal = TRUE,
  std.lv = FALSE,
  fixed.x = FALSE
)


anova_expl02 <- anova(fit_struc01, fit_struc_expl02) |>
  broom::tidy()

fitstats_expl02 <- fitMeasures(fit_struc_expl02)[c("cfi.robust", "rmsea.robust", "rmsea.ci.lower.scaled", "rmsea.ci.upper.scaled")]

## 5.2 Constrain WMU regression paths to zero ----
mod_struc_expl03 <-
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
   upd_l ~ age + age_sq + noise + leave + interrupt + 0*inr_m + 0*inr_cv + 0*threat_comp + 0*p_scar_m + 0*p_scar_cv
'


fit_struc_expl03 <- lavaan::sem(
  model = mod_struc_expl03,
  data = clean_data,
  estimator = "MLR", # Robust SEs in case of non-normal data
  missing = "ML",    # FIML for missing data
  cluster = 'nohouse_encr', # Clustering within
  orthogonal = TRUE,
  std.lv = FALSE,
  fixed.x = FALSE
)


anova_expl03 <- anova(fit_struc01, fit_struc_expl03) |>
  broom::tidy()

fitstats_expl03 <- fitMeasures(fit_struc_expl03)[c("cfi.robust", "rmsea.robust", "rmsea.ci.lower.scaled", "rmsea.ci.upper.scaled")]


## 6. Robustness check using Bayes Factors

set.seed(35721)

bay_wmc_inr_cv <- bain(fit_struc01, hypothesis = 'wmc_l~inr_cv < 0.1      & wmc_l~inr_cv > -0.1', fraction = 1, standardize = TRUE)
bay_wmc_inr_m <- bain(fit_struc01, hypothesis  = 'wmc_l~inr_m < 0.1       & wmc_l~inr_m > -0.1', fraction = 1, standardize = TRUE)
bay_wmc_psc_cv <- bain(fit_struc01, hypothesis = 'wmc_l~p_scar_cv < 0.1   & wmc_l~p_scar_cv > -0.1', fraction = 1, standardize = TRUE)
bay_wmc_psc_m <- bain(fit_struc01, hypothesis  = 'wmc_l~p_scar_m < 0.1    & wmc_l~p_scar_m > -0.1', fraction = 1, standardize = TRUE)
bay_wmc_thr <- bain(fit_struc01, hypothesis    = 'wmc_l~threat_comp < 0.1 & wmc_l~threat_comp > -0.1', fraction = 1, standardize = TRUE)

bay_upd_inr_cv <- bain(fit_struc01, hypothesis = 'upd_l~inr_cv < 0.1      & upd_l~inr_cv > -0.1', fraction = 1, standardize = TRUE)
bay_upd_inr_m <- bain(fit_struc01, hypothesis  = 'upd_l~inr_m < 0.1       & upd_l~inr_m > -0.1', fraction = 1, standardize = TRUE)
bay_upd_psc_cv <- bain(fit_struc01, hypothesis = 'upd_l~p_scar_cv < 0.1   & upd_l~p_scar_cv > -0.1', fraction = 1, standardize = TRUE)
bay_upd_psc_m <- bain(fit_struc01, hypothesis  = 'upd_l~p_scar_m < 0.1    & upd_l~p_scar_m > -0.1', fraction = 1, standardize = TRUE)
bay_upd_thr <- bain(fit_struc01, hypothesis    = 'upd_l~threat_comp < 0.1 & upd_l~threat_comp > -0.1', fraction = 1, standardize = TRUE)

BF_expl04 <- list(bay_wmc_inr_cv, bay_wmc_inr_m, bay_wmc_psc_cv, bay_wmc_psc_m, bay_wmc_thr,
  bay_upd_inr_cv, bay_upd_inr_m, bay_wmc_psc_cv, bay_upd_psc_m, bay_upd_thr) |>
  map_dfr(function(x) {
    bf <- x$fit |>
      as_tibble() |>
      select(BF.c) |>
      drop_na() |>
      mutate(BF.c = round(BF.c, 1))
  }) |>
  mutate(
    Hypothesis = c("-0.1 < (WM capacity ~ INR CV) < 0.1", "-0.1 < (WM capacity ~ INR mean) < 0.1", "-0.1 < (WM capacity ~ Perc. scarcity CV) < 0.1", "-0.1 < (WM capacity ~ Perc. scarcity mean) < 0.1",
                   "-0.1 < (WM capacity ~ Threat) < 0.1",
                   "-0.1 < (WM updating ~ INR CV) < 0.1", "-0.1 < (WM updating ~ INR mean) < 0.1", "-0.1 < (WM updating ~ Perc. scarcity CV) < 0.1", "-0.1 < (WM updating ~ Perc. scarcity mean) < 0.1",
                   "-0.1 < (WM updating ~ Threat) < 0.1"
                   )
  )

save(lm_reg_coef_expl, equivalence_tests_lm_expl,
     anova_expl02, fitstats_expl02, anova_expl03, fitstats_expl03,
     BF_expl04,
     file = "analysis_objects/exploratory_results.RData")
