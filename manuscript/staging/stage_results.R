
# 1. Libraries ---------------------------------------------------------------

library(tidyverse)
library(lavaan)
library(haven)

source('scripts/0_custom_functions/corr_plot.R')

# 2. Load data ------------------------------------------------------------

clean_data <- read_csv("data/liss_data/clean_data.csv")
descr <- read_sav(file = "data/liss_data/wm/L_Cognitieve_Vaardigheden_v2_1.0p.sav") |> as_tibble()

load("analysis_objects/confirmatory_results.RData")
load("analysis_objects/exploratory_results.RData")


# 3. Descriptives table -------------------------------------------------------

table1 <- descr |>
  filter(nomem_encr %in% unique(clean_data$nomem_encr)) |>
  select(p_leeftijd, geslacht) |>
  mutate(geslacht = ifelse(geslacht == 1, "Male", "Female")) |>
  summarise(
    age_m = mean(p_leeftijd, na.rm = T),
    age_sd = sd(p_leeftijd, na.rm = T),
    sex = sum(geslacht == 'Female')/n()*100
  ) |>
  transmute(
    `Mean age (SD)` = paste0(round(age_m, 1), " (", round(age_sd, 1), ")"),
    `Sex (% Female)` = round(sex, 1) |> as.character()) |>
  pivot_longer(everything(), names_to = "cat", values_to = "stat") |>
  bind_rows(
    descr |>
      filter(nomem_encr %in% unique(clean_data$nomem_encr)) |>
      select(oplmet) |>
      mutate(
        oplmet = case_when(
          oplmet == 1 ~ "primary school",
          oplmet == 2 ~ "vmbo (intermediate secondary education)",
          oplmet == 3 ~ "havo/vwo (higher secondary education)",
          oplmet == 4 ~ "mbo (intermediate vocational education)",
          oplmet == 5 ~ "hbo (higher vocational education)",
          oplmet == 6 ~ "wo (university)",
          oplmet == 7 ~ "other",
          TRUE ~ "missing"
        ),
        oplmet = factor(oplmet, levels = c("primary school", "vmbo (intermediate secondary education)", "havo/vwo (higher secondary education)",
                                           "mbo (intermediate vocational education)", "hbo (higher vocational education)", "wo (university)",
                                           "other", "missing")
        )
      ) |>
      group_by(oplmet) |>
      summarise(stat = round(n()/759*100, 1) |> as.character()) |>
      rename(cat = oplmet)
  ) |>
  bind_rows(
    clean_data |>
      select(n_waves_inr, n_waves_threat, n_waves_mat_dep) |>
      summarise(
        INR = paste0(round(mean(n_waves_inr, na.rm = T),1), " (", round(sd(n_waves_inr, na.rm = T), 1), ")"),
        `Perceived scarcity` = paste0(round(mean(n_waves_mat_dep, na.rm = T),1), " (", round(sd(n_waves_mat_dep, na.rm = T), 1), ")"),
        Threat = paste0(round(mean(n_waves_threat, na.rm = T),1), " (", round(sd(n_waves_threat, na.rm = T), 1), ")"),
      ) |>
      pivot_longer(everything(), names_to = "cat", values_to = "stat")
  ) |>
  add_row(.before = 3, cat = "Highest completed education (%)") |>
  add_row(.before = 12, cat = "Mean number of waves (SD)") |>
  flextable() |>
  set_header_labels(cat = "Category", stat = "Statistic") |>
  padding(i = c(4:11, 13:15), j = 1, padding.left = 10)



# 4. Correlation Table ----------------------------------------------------

table2 <- clean_data |>
  select(inr_m, live_off_income_m, finan_trouble_m, curr_situation_m, p_scar_m,
         inr_cv, live_off_income_cv, finan_trouble_cv, curr_situation_cv, p_scar_cv,
         neigh_thr_m, neigh_thr02_m, vict_sum, threat_comp) |>
  corr_table(
    use = "pairwise.complete.obs",
    sample_size = F,
    method = "spearman",
    stats = list("mean", "sd", "min", "max", "skew", "kurtosis"),
    c.names = c(
      "INR (M)",
      "Living off income (M)",
      "Financial troubles (M)",
      "Current situation (M)",
      "Perceived scarcity (M)",
      "INR (CV)",
      "Living off income (CV)",
      "Financial troubles (CV)",
      "Current situation (CV)",
      "Perceived scarcity (CV)",
      "Neighborhood safety",
      "Neighborhood Violence Scale",
      "Crime victimization",
      "Threat"
    ),
    numbered = T
  )


save(table1, table2, file = "analysis_objects/tables.RData")



# 5. Figures -----------------------------------------------------------------

fig5 <- sem_reg_coef |>
  left_join(equivalence_tests |> select(lhs, rhs, eq_pvalue)) |>
  ungroup() |>
  add_row(rhs = "empty1", lhs = "wmc_l") |>
  add_row(rhs = "empty1", lhs = "upd_l") |>
  add_row(rhs = "empty2", lhs = "wmc_l") |>
  add_row(rhs = "empty2", lhs = "upd_l") |>
  mutate(
    eq_pvalue_discr = ifelse(eq_pvalue < .05, "eq", "non-eq"),
    lhs = case_when(
      lhs == "wmc_l" ~ "WM capacity",
      lhs == "upd_l" ~ "WM updating",
      TRUE ~ lhs
    ),
    rhs = case_when(
      rhs == "inr_m" ~ "INR (M)",
      rhs == "p_scar_m" ~ "Perceived\nscarcity (M)",
      rhs == "inr_cv" ~ "INR (CV)",
      rhs == "p_scar_cv" ~ "Perceived\nscarcity (CV)",
      rhs == "threat_comp" ~ "Threat",
      TRUE ~ rhs
      ),
    sig_star = case_when(
      pvalue_adj >= 0.05 ~ "",
      pvalue_adj < 0.05 & pvalue_adj >= 0.01 ~ "*",
      pvalue_adj < 0.01 & pvalue_adj >= 0.001 ~  "**",
      pvalue_adj < 0.001 ~ "***"
    ),
    sig_pos = ifelse(est.std < 0, ci.lower - 0.03, ci.upper + 0.01),
    rhs = factor(rhs, levels = c("empty1", "INR (M)", "Perceived\nscarcity (M)", "INR (CV)", "Perceived\nscarcity (CV)", "Threat", "empty2"))
  ) |>
  ggplot(aes(x = rhs, y = est.std)) +
  geom_rect(
    aes(
      xmin = "empty1", xmax = "empty2", ymin = -0.1, ymax = 0.1
    ),
    fill = "#F2F3F5",
    inherit.aes = T
  ) +
  geom_hline(aes(yintercept = 0), size = 0.7) +
  geom_errorbar(aes(ymin = ci.lower, ymax = ci.upper, color = rhs), width = 0.2, size = 1) +
  geom_point(aes(color = rhs, shape = eq_pvalue_discr), fill = "white", size = 3, stroke = 1.5) +
  geom_text(
    aes(y = sig_pos, label = sig_star),
    color = "black"
  ) +
  facet_wrap(~lhs) +
  scale_shape_manual(values = c(16,21)) +
  coord_cartesian(xlim = c(2,6)) +
  scale_x_discrete(labels = c("INR (M)", "Perceived\nscarcity (M)", "INR (CV)", "Perceived\nscarcity (CV)", "Threat")) +
  ggsci::scale_color_uchicago(breaks = c("INR (M)", "Perceived\nscarcity (M)", "INR (CV)", "Perceived\nscarcity (CV)", "Threat")) +
  theme_classic() +
  theme(
    legend.position = "bottom",
    legend.text = element_text(size = 10),
    panel.spacing.x = unit(2, "lines"),
    panel.spacing.y = unit(2, "lines"),
    axis.line.x = element_blank(),
    axis.text.x = element_blank(),
    axis.ticks.x = element_blank(),
    axis.text.y = element_text(size = 12),
    strip.background = element_rect(color = 'white'),
    strip.text.y = element_text(face = "bold", size = 11),
    strip.text.x = element_text(face = "bold", size = 13)
  ) +
  guides(shape = 'none', size = 'none') +
  labs(
    color = "",
    x = "",
    y = "Standardized regression coefficient"
  )

save(fig5, file = "analysis_objects/fig5.RData")



fig6 <- lm_reg_coef_expl |>
  left_join(equivalence_tests_lm_expl |> select(term, task, eq_pvalue)) |>
  ungroup() |>
  mutate(
    eq_pvalue_discr = ifelse(eq_pvalue < .05, "eq", "non-eq"),
    task = case_when(
      task == "rspan" ~ "Rotation Span Task",
      task == "Ospan" ~ "Operation Span Task",
      task == "binding" ~ "Binding Task",
      task == "updating" ~ "Updating Task",
      TRUE ~ task
    ),
    term = case_when(
      term == "inr_m" ~ "INR (M)",
      term == "p_scar_m" ~ "Perceived\nscarcity (M)",
      term == "inr_cv" ~ "INR (CV)",
      term == "p_scar_cv" ~ "Perceived\nscarcity (CV)",
      term == "threat_comp" ~ "Threat"
    ),
    sig_star = case_when(
      pvalue_adj >= 0.05 ~ "",
      pvalue_adj < 0.05 & pvalue_adj >= 0.01 ~ "*",
      pvalue_adj < 0.01 & pvalue_adj >= 0.001 ~  "**",
      pvalue_adj < 0.001 ~ "***"
    ),
    sig_pos = ifelse(estimate < 0, conf.low - 0.03, conf.high + 0.01),
    term = factor(term, levels = c("INR (M)", "Perceived\nscarcity (M)", "INR (CV)", "Perceived\nscarcity (CV)", "Threat"))
  ) |>
  ggplot(aes(x = term, y = estimate)) +
  geom_rect(
    aes(
      xmin = "INR (M)", xmax = "Threat", ymin = -0.1, ymax = 0.1
    ),
    fill = "#F2F3F5",
    inherit.aes = T
  ) +
  geom_hline(aes(yintercept = 0), size = 0.7) +
  geom_errorbar(aes(ymin = conf.low, ymax = conf.high, color = term), width = 0.2, size = 1) +
  geom_point(aes(color = term, shape = eq_pvalue_discr), fill = "white", size = 3, stroke = 1.5) +
  geom_text(
    aes(y = sig_pos, label = sig_star),
    color = "black"
  ) +
  facet_wrap(~task) +
  scale_shape_manual(values = c(16,21)) +
  coord_cartesian(xlim = c(2,5)) +
  scale_x_discrete(labels = c("INR (M)", "Perceived\nscarcity (M)", "INR (CV)", "Perceived\nscarcity (CV)", "Threat")) +
  ggsci::scale_color_uchicago(breaks = c("INR (M)", "Perceived\nscarcity (M)", "INR (CV)", "Perceived\nscarcity (CV)", "Threat")) +
  theme_classic() +
  theme(
    legend.position = "bottom",
    legend.text = element_text(size = 10),
    panel.spacing.x = unit(2, "lines"),
    panel.spacing.y = unit(2, "lines"),
    axis.line.x = element_blank(),
    axis.text.x = element_blank(),
    axis.ticks.x = element_blank(),
    axis.text.y = element_text(size = 12),
    strip.background = element_rect(color = 'white'),
    strip.text.y = element_text(face = "bold", size = 11),
    strip.text.x = element_text(face = "bold", size = 13)
  ) +
  guides(shape = 'none', size = 'none') +
  labs(
    color = "",
    x = "",
    y = "Standardized regression coefficient"
  )

save(fig6, file = "analysis_objects/fig6.RData")



