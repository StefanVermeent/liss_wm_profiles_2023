
# Libraries ---------------------------------------------------------------

library(tidyverse)
library(haven)
library(openxlsx)

devtools::load_all("D:/repositories/projectlog") #remotes::install_github("stefanvermeent/projectlog")

inr_conv_table <- openxlsx::read.xlsx("data/liss_data/low_income_cbs_2000_2022.xlsx", startRow = 5) |>
  as_tibble() |>
  rename(
    year  = `Lage-inkomensgrens`,
    a1_c0 = `Netto.maandbedrag.in.euro.(lopende.prijzen,.afgerond.op.10.euro)`,
    a2_c0 = X3,
    a2_c1 = X4,
    a2_c2 = X5,
    a2_c3 = X6,
    a1_c1 = X7,
    a1_c2 = X8,
    a1_c3 = X9
  ) |>
  pivot_longer(
    -year,
    names_to = c("adult", "aantalki"),
    names_sep = "_",
    values_to = "threshold"
  ) %>%
  mutate(across(c(adult, aantalki), ~str_remove(string = ., pattern = "^[a-z]") |> as.numeric())) |>
  filter(!year %in% c("Equivalentiefactor", "Tot 2018", "Vanaf 2018", "Bron: CBS"))

# 1. Read data ------------------------------------------------------------

## 1.1 IDs of participants selected for new study ----

pp_ids <- projectlog::read_data(file = "data/liss_data/wm/L_Cognitieve_Vaardigheden_v2_1.0p.sav", read_fun = "haven::read_sav", col_select = "nomem_encr") |>
  pull(nomem_encr)


## 1.2 Basic demographic variables ----

background_vars <- projectlog::read_data(file = "list.files('data/liss_data/background', pattern = '.sav', full.names = TRUE)", read_fun = "haven::read_sav")

# The first eight waves do not contain household-level income (but do contain person-level income), so
# are treated separately
background_vars01 <- background_vars[1:8] |>
  map(function(x){
    x |>
      as_tibble() |>
      select(nomem_encr, nohouse_encr, matches("positie"), wave, belbezig, leeftijd, matches('sted'), aantalki, partner, nettoink) |>
      # Compute household income by hand
      group_by(wave, nohouse_encr) |>
      mutate(
        nettohh_f = sum(nettoink, na.rm = T)
      ) |>
      ungroup()
  })

background_vars02 <- background_vars[9:length(background_vars)] |>
  map(function(x){
    x |>
      as_tibble() |>
      select(nomem_encr, matches("positie"), nohouse_encr, wave, belbezig, leeftijd, sted, aantalki, partner, nettohh_f)
  })


background_parsed <- bind_rows(background_vars01, background_vars02) |>
  separate(col = wave, into = c("year", "month"), sep = 4) |>
  mutate(across(c(year, month), as.character))

write_csv(background_parsed, "data/liss_data/background/background_parsed.csv")



## 1.3 Material deprivation ----

core_income <- projectlog::read_data(file = "list.files('data/liss_data/income', pattern = '.sav', full.names = TRUE)", read_fun = "haven::read_sav")


# in wave 1 to 11, net income was asked for each employer separately
core_income01 <- core_income[1:11] |>
  map(function(x){
    x |>
      as_tibble() |>
      select(nomem_encr, matches("(_m|012|021|030|244|245|246|247|248|249|250|252)$")) |>
      rename_with(
        .cols = -nomem_encr,
        ~str_replace_all(string = ., pattern = "ci\\d\\d[a-z]_|ci\\d\\d[a-z]", "q_")
      ) %>%
     mutate(net_inc_y = across(c(q_012, q_021, q_030)) %>% rowSums(na.rm = T))
  }) |>
  bind_rows() |>
  separate(col = q_m, into = c("year", "month"), sep = 4)

# in wave 12 to 16, net income was asked across all employers
core_income02 <- core_income[12:16] |>
  map(function(x){
    x |>
      as_tibble() |>
      select(nomem_encr, matches("(_m|339|244|245|246|247|248|249|250|252)$")) |>
      rename_with(
        .cols = -nomem_encr,
        ~str_replace_all(string = ., pattern = "ci\\d\\d[a-z]_|ci\\d\\d[a-z]", "q_")
      ) %>%
      rename(net_inc_y = q_339)
  }) |>
  bind_rows() |>
  separate(col = q_m, into = c("year", "month"), sep = 4)

core_income_parsed <- bind_rows(core_income01, core_income02) |>
  select(-c(q_012, q_021, q_030))


write_csv(core_income_parsed, "data/liss_data/income/core_income_parsed.csv")


# TODO: Sanity checks:


## 1.4 Threat ----

crime_waves <- projectlog::read_data(file = "list.files('data/liss_data/crime', pattern = '.sav', full.names = TRUE)", read_fun = "haven::read_sav")

# Variable names for the 2008 wave differ from other waves
crime_waves01 <- crime_waves[[1]] |>
  as_tibble() |>
  select(nomem_encr, ends_with("_m"), matches("(11|12|13|14|20|21|22|23|25|26|27)$")) |>
  rename(
    q_m   = ac08a_m,
    q_011 = ac08a11,
    q_012 = ac08a12,
    q_013 = ac08a13,
    q_014 = ac08a14,
    q_094 = ac08a20,
    q_095 = ac08a21,
    q_096 = ac08a22,
    q_097 = ac08a23,
    q_099 = ac08a25,
    q_100 = ac08a26,
    q_101 = ac08a27
  )

crime_waves02 <- crime_waves[-1] |>
  map(function(x){
    x |>
      as_tibble() |>
      select(nomem_encr, ends_with("_m"), matches("(011|012|013|014|094|095|096|097|099|100|101)$")) |>
      rename_with(
        .cols = -nomem_encr,
        ~str_replace_all(string = ., pattern = "ac\\d\\d[a-z]_|ac\\d\\d[a-z]", "q_")
      )
  })

crime_waves_parsed <- crime_waves01 %>%
  bind_rows(
    reduce(crime_waves02, bind_rows)
  )

write_csv(crime_waves_parsed, "data/liss_data/crime/crime_waves_parsed.csv")

#TODO: Sanity checks


## 1.5 Working Memory data ----

wm_study <- projectlog::read_data(file = "data/liss_data/wm/L_Cognitieve_Vaardigheden_v2_1.0p.sav", read_fun = "haven::read_sav") |> as_tibble()


