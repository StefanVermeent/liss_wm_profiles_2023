library(flextable)
library(tidyverse)
library(patchwork)

load("data/pilot_full_data.RData")
source("scripts/0_custom_functions/binom_test.R")
source("scripts/0_custom_functions/corr_plot.R")
clean_data <- read_csv("data/liss_data/clean_data.csv")

# set up flextable for tables
set_flextable_defaults(
  font.family = "Times",
  font.size = 10,
  font.color = "black",
  line_spacing = 1,
  padding.bottom = 1,
  padding.top = 1,
  padding.left = 1,
  padding.right = 1
)

# 1. Pilot Study ----------------------------------------------------------

pilot_demo <-
  list(
    m_age = pilot_full_data$dems_age |> mean(na.rm = T) |> round(1),
    sd_age = pilot_full_data$dems_age |> sd(na.rm = T) |> round(1),
    max_age = pilot_full_data$dems_age |> max(na.rm = T) |> round(1),
    min_age = pilot_full_data$dems_age |> min(na.rm = T) |> round(1)
  )

pilot_exclusions <-
  list(
    acc_ospan_sec_n = pilot_full_data |> filter(ospan_sec_acc*100 < gbinom(45, 0.50)) |> nrow(),
    acc_rspan_sec_n = pilot_full_data |> filter(rspan_sec_acc*100 < gbinom(45, 0.50)) |> nrow()
  )

pilot_clean <- pilot_full_data |>
  filter(
    ospan_sec_acc*100 > gbinom(45, 0.50),
    (rspan_sec_acc*100 > gbinom(45, 0.50) | is.na(rspan_sec_acc))
  )

pilot_table1 <- pilot_clean |>
  select(ospan_cap, rspan_cap, binding_number, updating_number, pcunp_mean, vio_comp, ses_subj_comp) |>
  corr_table(
    stats = c("mean", "sd", "median", "min", "max", "skew", "kurtosis"),
    numbered = TRUE,
    c.names = c(
      "Operation Span Task",
      "Rotation Span Task",
      "Binding Task",
      "Updating Task",
      "Unpredictability",
      "Threat",
      "Material deprivation"
    )
  ) |>
  add_row(Variable = "WM tasks", .before = 1) |>
  add_row(Variable = "Adversity", .before = 6) |>
  flextable() |>
  set_header_labels(Variable = "") |>
  bold(i = c(1, 6)) |>
  border(i = 1, border.bottom = fp_border_default(), part = "header") |>
  border(i = 16, border.bottom = fp_border_default(), part = "body") |>
  border(i = 9, border.bottom = fp_border_default(), part = "body") |>
  border(i = 1, border.top = fp_border_default(style = "none", width = 0), part = "header") |>
  add_header_row(
    values = " ",
    colwidths = 8
  ) |>
  flextable::compose(
    i = 1, j = 1,
    as_paragraph(as_b("Table S1. "), "Bivariate correlations between WM tasks and adversity measures in the Pilot."),
    part = "header"
  ) |>
  add_footer_row(
    values = " ",
    colwidths = 8
  ) |>
  add_footer_row(
    values = " ",
    colwidths = 8
  ) |>
  flextable::compose(
    i = 1, j = 1,
    as_paragraph(as_i("Note: "), "The upper diagonal presents sample sizes for each bivariate comparison. The measures of unpredictability, threat, and material deprivation differ from those in the main study."),
    part = "footer"
  ) |>
  autofit()

save(pilot_demo, pilot_exclusions, pilot_table1, file = "supplement/staged_results.RData")



# 2. IV histograms --------------------------------------------------------

## 2.1 Perceived deprivation (mean) ----

hist_data <- clean_data |>
  select(inr_m, live_off_income_m, finan_trouble_m, curr_situation_m, p_scar_m,
         inr_cv, live_off_income_cv, finan_trouble_cv, curr_situation_cv, p_scar_cv,
         neigh_thr_m, neigh_thr02_m, vict_sum, threat_comp)

inr_m_hist <- hist_data |>
  select(inr_m) |>
  ggplot(aes(inr_m)) +
  geom_histogram() +
  theme_classic() +
  scale_x_continuous(breaks = seq(0, 6, 1)) +
  labs(
    x = "Income-to-needs ratio (mean)",
    y = "Frequency"
  )

live_off_income_m_hist <- hist_data |>
  select(live_off_income_m) |>
  ggplot(aes(live_off_income_m)) +
  geom_histogram() +
  theme_classic() +
  scale_x_continuous(breaks = seq(0, 11, 1)) +
  labs(
    x = "How hard or how easy it is for you to\nlive off the income of your household?",
    y = "Frequency"
  )


finan_trouble_m_hist <- hist_data |>
  select(finan_trouble_m) |>
  ggplot(aes(finan_trouble_m)) +
  geom_histogram() +
  theme_classic() +
 # scale_x_continuous(breaks = seq(0, 6, 1)) +
  xlim(c(0,6)) +
  labs(
    x = "With which of the following issues are you\nor are you not confronted at present?",
    y = "Frequency"
  )

curr_situation_m_hist <- hist_data |>
  select(curr_situation_m) |>
  ggplot(aes(curr_situation_m)) +
  geom_histogram() +
  theme_classic() +
  scale_x_continuous(breaks = seq(0, 11, 1)) +
  labs(
    x = "How would you describe the financial situation\nof your household at this moment?",
    y = "Frequency"
  )


p_scar_m_hist <- hist_data |>
  select(p_scar_m) |>
  ggplot(aes(p_scar_m)) +
  geom_histogram() +
  theme_classic() +
  scale_x_continuous(breaks = seq(0, 11, 1)) +
  labs(
    x = "Material deprivation compositite",
    y = "Frequency"
  )


p_scar_m_combn_hist <- (live_off_income_m_hist + finan_trouble_m_hist) /
(curr_situation_m_hist + p_scar_m_hist)

## 2.2 INR (mean) ----

inr_m_hist <- hist_data |>
  select(inr_m) |>
  ggplot(aes(inr_m)) +
  geom_histogram() +
  theme_classic() +
  scale_x_continuous(breaks = seq(0, 11, 1)) +
  labs(
    x = "Income-to-needs ratio",
    y = "Frequency"
  )


## 2.3 Threat ----

nvs_hist <- hist_data |>
  select(neigh_thr02_m) |>
  ggplot(aes(neigh_thr02_m)) +
  geom_histogram() +
  theme_classic() +
  scale_x_continuous(breaks = seq(0, 11, 1)) +
  labs(
    x = "Neighborhood Violence Scale",
    y = "Frequency"
  )


neigh_hist <- hist_data |>
  select(neigh_thr_m) |>
  ggplot(aes(neigh_thr_m)) +
  geom_histogram() +
  theme_classic() +
  scale_x_continuous(breaks = seq(0, 11, 1)) +
  labs(
    x = "Neighborhood Safety",
    y = "Frequency"
  )

vict_hist <- hist_data |>
  select(vict_sum) |>
  ggplot(aes(vict_sum)) +
  geom_histogram() +
  theme_classic() +
  scale_x_continuous(breaks = seq(0, 11, 1)) +
  labs(
    x = "Crime victimization",
    y = "Frequency"
  )


threat_comp_hist <- hist_data |>
  select(threat_comp) |>
  ggplot(aes(threat_comp)) +
  geom_histogram() +
  theme_classic() +
  scale_x_continuous(breaks = seq(0, 11, 1)) +
  labs(
    x = "Threat composite",
    y = "Frequency"
  )

threat_combn_hist <-
  (nvs_hist + neigh_hist) /
  (vict_hist + threat_comp_hist)


## 2.4 Perceived deprivation (CV) ----

inr_cv_hist <- hist_data |>
  select(inr_cv) |>
  ggplot(aes(inr_cv)) +
  geom_histogram() +
  theme_classic() +
  scale_x_continuous(breaks = seq(0, 2, 0.2)) +
  labs(
    x = "Income-to-needs ratio (CV)",
    y = "Frequency"
  )

live_off_income_cv_hist <- hist_data |>
  select(live_off_income_cv) |>
  ggplot(aes(live_off_income_cv)) +
  geom_histogram() +
  theme_classic() +
  scale_x_continuous(breaks = seq(0, 2, 0.2)) +
  labs(
    x = "How hard or how easy it is for you to\nlive off the income of your household?",
    y = "Frequency"
  )


finan_trouble_cv_hist <- hist_data |>
  select(finan_trouble_cv) |>
  ggplot(aes(finan_trouble_cv)) +
  geom_histogram() +
  theme_classic() +
  scale_x_continuous(breaks = seq(0, 2, 0.2)) +
  labs(
    x = "With which of the following issues are you\nor are you not confronted at present?",
    y = "Frequency"
  )

curr_situation_cv_hist <- hist_data |>
  select(curr_situation_cv) |>
  ggplot(aes(curr_situation_cv)) +
  geom_histogram() +
  theme_classic() +
  scale_x_continuous(breaks = seq(0, 2, 0.2)) +
  labs(
    x = "How would you describe the financial situation\nof your household at this moment?",
    y = "Frequency"
  )


p_scar_cv_hist <- hist_data |>
  select(p_scar_cv) |>
  ggplot(aes(p_scar_cv)) +
  geom_histogram() +
  theme_classic() +
  labs(
    x = "Material deprivation compositite",
    y = "Frequency"
  )


p_scar_cv_combn_hist <- (live_off_income_cv_hist + finan_trouble_cv_hist) /
  (curr_situation_cv_hist + p_scar_cv_hist)

## 2.5 INR (CV) ----

inr_cv_hist <- hist_data |>
  select(inr_cv) |>
  ggplot(aes(inr_cv)) +
  geom_histogram() +
  theme_classic() +
  scale_x_continuous(breaks = seq(0, 2, 0.2)) +
  labs(
    x = "Income-to-needs ratio",
    y = "Frequency"
  )

save(pilot_demo, pilot_exclusions, pilot_table1,
     p_scar_m_combn_hist, inr_m_hist, threat_combn_hist, p_scar_cv_combn_hist, inr_cv_hist,
     file = "supplement/staged_results.RData")
