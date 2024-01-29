library(flextable)
library(tidyverse)

load("data/pilot_full_data.RData")
source("scripts/0_custom_functions/binom_test.R")
source("scripts/0_custom_functions/corr_plot.R")


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
    m_age = pilot_data_full$dems_age |> mean(na.rm = T) |> round(1),
    sd_age = pilot_data_full$dems_age |> sd(na.rm = T) |> round(1),
    max_age = pilot_data_full$dems_age |> max(na.rm = T) |> round(1),
    min_age = pilot_data_full$dems_age |> min(na.rm = T) |> round(1)
  )

pilot_exclusions <-
  list(
    acc_ospan_sec_n = pilot_data_full |> filter(ospan_sec_acc*100 < gbinom(45, 0.50)) |> nrow(),
    acc_rspan_sec_n = pilot_data_full |> filter(rspan_sec_acc*100 < gbinom(45, 0.50)) |> nrow()
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

