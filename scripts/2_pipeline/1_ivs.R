
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



core_income01 <- core_income[1:11] |>
  map(function(x){
    x |>
      sjlabelled::remove_all_labels() |>
      as_tibble() |>
      select(nomem_encr, matches("(_m|012|021|030|244|245|246|247|248|249|250|252)$")) |>
      rename_with(
        .cols = -nomem_encr,
        ~str_replace_all(string = ., pattern = "ci\\d\\d[a-z]_|ci\\d\\d[a-z]", "q_")
      ) %>%
      #in wave 1 to 11, net income was asked for each employer separately
     mutate(net_inc_y = across(c(q_012, q_021, q_030)) %>% rowSums(na.rm = T))
  }) |>
  bind_rows() |>
  separate(col = q_m, into = c("year", "month"), sep = 4) |>
  left_join(background_parsed |> select(nomem_encr, year, month, nohouse_encr)) |>
  group_by(year, nohouse_encr) |>
  mutate(net_inc_y = sum(net_inc_y, na.rm = T))

# in wave 12 to 16, net income was asked across all employers
core_income02 <- core_income[12:16] |>
  map(function(x){
    x |>
      sjlabelled::remove_all_labels() |>
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
  select(-c(q_012, q_021, q_030)) |>
  mutate(net_inc_y = ifelse(net_inc_y <= 0, NA, net_inc_y))

# Sanity checks
assertthat::assert_that(all(core_income_parsed$q_244 %in% c(0:10, NA)))
assertthat::assert_that(all(core_income_parsed$q_245 %in% c(0, 1, NA)))
assertthat::assert_that(all(core_income_parsed$q_246 %in% c(0, 1, NA)))
assertthat::assert_that(all(core_income_parsed$q_247 %in% c(0, 1, NA)))
assertthat::assert_that(all(core_income_parsed$q_248 %in% c(0, 1, NA)))
assertthat::assert_that(all(core_income_parsed$q_249 %in% c(0, 1, NA)))
assertthat::assert_that(all(core_income_parsed$q_250 %in% c(0, 1, NA)))
assertthat::assert_that(all(core_income_parsed$q_252 %in% c(1:5, NA)))

write_csv(core_income_parsed, "data/liss_data/income/core_income_parsed.csv")


# TODO: Sanity checks:


## 1.4 Threat ----

crime_waves <- projectlog::read_data(file = "list.files('data/liss_data/crime', pattern = '.sav', full.names = TRUE)", read_fun = "haven::read_sav")

# Variable names for the 2008 wave differ from other waves
crime_waves01 <- crime_waves[[1]] |>
  sjlabelled::remove_all_labels() |>
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
      sjlabelled::remove_all_labels() |>
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

# Sanity checks
assertthat::assert_that(all(crime_waves_parsed$q_011 %in% c(1,2,3, NA)))
assertthat::assert_that(all(crime_waves_parsed$q_012 %in% c(1,2,3, NA)))
assertthat::assert_that(all(crime_waves_parsed$q_013 %in% c(1,2,3, NA)))
assertthat::assert_that(all(crime_waves_parsed$q_014 %in% c(1,2,3, NA)))

assertthat::assert_that(all(crime_waves_parsed$q_094 %in% c(1,2, NA)))
assertthat::assert_that(all(crime_waves_parsed$q_095 %in% c(1,2, NA)))
assertthat::assert_that(all(crime_waves_parsed$q_096 %in% c(1,2, NA)))
assertthat::assert_that(all(crime_waves_parsed$q_097 %in% c(1,2, NA)))
assertthat::assert_that(all(crime_waves_parsed$q_099 %in% c(1,2, NA)))
assertthat::assert_that(all(crime_waves_parsed$q_100 %in% c(1,2, NA)))
assertthat::assert_that(all(crime_waves_parsed$q_101 %in% c(1,2, NA)))

write_csv(crime_waves_parsed, "data/liss_data/crime/crime_waves_parsed.csv")

#TODO: Sanity checks


## 1.5 Working Memory data ----

wm_study <- projectlog::read_data(file = "data/liss_data/wm/L_Cognitieve_Vaardigheden_v2_1.0p.sav", read_fun = "haven::read_sav") |> as_tibble()




# 2. Compute variables ----------------------------------------------------


## 2.1 Material Deprivation ----

### 2.1.1 Income-to-needs ratio ----

wm_data <-
  wm_study %>%
  # Filter all participants with empty cognitive task strings, which indicates that they skipped the cognitive tasks
  filter(!if_all(c(ospan_cap, ospan_math_acc, rspan_cap, rspan_rotation_acc, binding_number_acc, updating_number_acc), ~ . == "")) |>
  mutate(across(matches("_acc$|_cap$"), as.numeric)) |>
  rename(
    noise = Q1,
    interrupt = Q2,
    leave = Q3,
    age = p_leeftijd,
    sex = geslacht,
    edu = oplcat
  ) |>
  select(nomem_encr, nohouse_encr, age, matches("_acc$|_cap$"), edu, noise, interrupt, leave)

# Store IDs of participants who participated in the new task
pp_ids <- wm_data |> pull(nomem_encr)


inr <-
  background_parsed |>
  mutate(adult = ifelse(partner == 1, 2, 1)) |>
  mutate(
    # If number of children is larger than 3, impute 3 for INR matching
    aantalki_real = aantalki,
    aantalki = ifelse(aantalki > 3, 3, aantalki),
    nettohh_f = ifelse(nettohh_f == 0, NA, nettohh_f) #Set household income to NA if it's 0
  ) |>
  impute_income(year_data = core_income_parsed) |>
  mutate(net_inc_m = net_inc_y / 12) |>
  mutate(nettohh_f = ifelse(is.na(nettohh_f), net_inc_m, nettohh_f)) |>
  left_join(inr_conv_table) |>
  mutate(inr_m = nettohh_f / threshold) |>
  group_by(nomem_encr, year) |>
  summarise(inr_y = mean(inr_m, na.rm = T)) |>
  group_by(nomem_encr) |>
  summarise(
    inr_m  = mean(inr_y, na.rm = T),
    inr_sd = sd(inr_y, na.rm = T),
    n_waves_inr = n()) |>
  ungroup() |>
  # Recode and scale INR
  mutate(
    inr_cv = inr_sd / inr_m
    ) |>
  select(nomem_encr, inr_m, inr_cv, n_waves_inr) |>
  filter(nomem_encr %in% pp_ids)

write_csv(inr, "data/liss_data/inr.csv")

### 2.1.2 Perceived scarcity ----

p_scar <- core_income_parsed |>
  rename(
    dep01      = q_244,
    dep02      = q_245,
    dep03      = q_246,
    dep04      = q_247,
    dep05      = q_248,
    dep06      = q_249,
    dep07      = q_250,
    dep08      = q_252
  ) %>%
  # Recode variables so that higher scores are higher deprivation
  mutate(
    dep01      = 11 - dep01,
    dep08      = 6 - dep08,
  #  across(matches("dep0(0|2|3|4|5|6|7)"), ~. + 1)
  ) |>
  mutate(
    finan_trouble   = across(matches("dep0(2|3|4|5|6|7)")) |> rowSums(x = _, na.rm = T),
    finan_trouble   = ifelse(is.na(dep02)&is.na(dep03)&is.na(dep04)&is.na(dep05)&is.na(dep06)&is.na(dep07), NA, finan_trouble+1), # all scores missing, set to NA
    live_off_income = dep01,
    curr_situation  = dep08,
  ) |>
  filter(nomem_encr %in% pp_ids) |>
  group_by(nomem_encr) |>
  summarise(
    # Perceived scarcity measures - Mean across time
    finan_trouble_m   = ifelse(any(!is.na(finan_trouble)), mean(finan_trouble, na.rm = T), NA),
    live_off_income_m = ifelse(any(!is.na(live_off_income)), mean(live_off_income, na.rm = T), NA),
    curr_situation_m  = ifelse(any(!is.na(curr_situation)), mean(curr_situation, na.rm = T), NA),

    # Perceived scarcity measures - SD across time
    finan_trouble_sd = sd(finan_trouble, na.rm = T),
    live_off_income_sd = sd(live_off_income, na.rm = T),
    curr_situation_sd = sd(curr_situation, na.rm = T),

    finan_trouble_cv = (finan_trouble_sd / finan_trouble_m) + 0.001,
    live_off_income_cv = live_off_income_sd / live_off_income_m,
    curr_situation_cv = curr_situation_sd / curr_situation_m,

    n_waves_mat_dep = length(unique(year))
  ) |>
  ungroup() |>
  rowwise() |>
  mutate(
    p_scar_m = mean(c(finan_trouble_m, live_off_income_m, curr_situation_m)),
  ) |>
  select(nomem_encr, finan_trouble_m, finan_trouble_cv, live_off_income_m, live_off_income_cv, curr_situation_m, curr_situation_cv, p_scar_m, n_waves_mat_dep)


## 2.2 Threat ----

# Note: warnings are caused by a difference in the following value label:
# wave 1:   I don’t know / prefer not to say
# wave 2-6: I don’t know - prefer not to say
threat <- crime_waves_parsed |>
  filter(nomem_encr %in% pp_ids) |>
  rename(
    year = q_m,
    neigh_thr01 = q_011,
    neigh_thr02 = q_012,
    neigh_thr03 = q_013,
    neigh_thr04 = q_014,
    vict01      = q_094,
    vict02      = q_095,
    vict03      = q_096,
    vict04      = q_097,
    vict05      = q_099,
    vict06      = q_100,
    vict07      = q_101
  ) |>
  # Rescale neighorhood safety items
  mutate(
    neigh_thr01 = (neigh_thr01 - 1) %>% ifelse(. == 3, NA, .),
    neigh_thr02 = (neigh_thr02 - 1) %>% ifelse(. == 3, NA, .),
    neigh_thr03 = (neigh_thr03 - 1) %>% ifelse(. == 3, NA, .),
    neigh_thr04 = (neigh_thr04 - 1) %>% ifelse(. == 3, NA, .)
  ) |>
  # Rescale Victimization items
  mutate(
    across(
      starts_with("vict"),
      ~ case_when(
        . == 1 ~ 1,
        . == 2 ~ 0,
        . == 3 ~ NA_real_
      )
    )
  ) |>
  mutate(
    neigh_thr_sum = across(starts_with("neigh_thr")) |> rowSums(x = _, na.rm = T)
    ) |>
  group_by(year) |>
  mutate(neigh_thr_rel = across(matches("neigh_thr\\d\\d")) |> performance::cronbachs_alpha()) |>
  group_by(nomem_encr) |>
  summarise(
    # Summing the neighborhood threat items
    neigh_thr_m     = mean(neigh_thr_sum, na.rm = T),
    neigh_thr_rel_m = mean(neigh_thr_rel, na.rm = T),

    vict01          = ifelse(sum(vict01, na.rm = T) > 0, 1, 0),
    vict02          = ifelse(sum(vict02, na.rm = T) > 0, 1, 0),
    vict03          = ifelse(sum(vict03, na.rm = T) > 0, 1, 0),
    vict04          = ifelse(sum(vict04, na.rm = T) > 0, 1, 0),
    vict05          = ifelse(sum(vict05, na.rm = T) > 0, 1, 0),
    vict06          = ifelse(sum(vict06, na.rm = T) > 0, 1, 0),
    vict07         = ifelse(sum(vict07, na.rm = T) > 0, 1, 0),
    n_waves_threat  = length(unique(year))
  ) |>
  left_join(wm_study |> select(nomem_encr, matches("VC\\d"))) %>%
  mutate(across(matches("VC\\d"), ~ifelse(. %in% c(-1, -2), NA, .))) %>%
  # Rescale neigh. violence items
  mutate(across(c(VC1, VC3), ~ 8 - .)) |>
  mutate(
    # Creating a variety sum score of the victimization items
    vict_sum      = across(starts_with("vict")) |> rowSums(),
    neigh_thr02_m = across(matches("VC\\d")) |> rowMeans(),
    neigh_thr02_rel_m = across(matches("VC\\d")) |> performance::cronbachs_alpha()
  )



# Sanity checks

threat %>% filter(if_any(matches("vict\\d\\d"), ~ !. %in% c(NA, 0, 1))) |> glue::glue_data("Subject {nomem_encr} has invalid data on one or more of the victimization items\n") # Check whether all victimization items are either 0 or 1
threat %>% filter(if_any(matches("VC\\d"), ~ !. %in% c(NA, 1:7))) |> glue::glue_data("Subject {nomem_encr} has invalid data on one or more of the newly collected neighborhood threat items\n") # Check whether all victimization items are either 0 or 1




# 3. Principal Component Analysis -------------------------------------------------

## 3.1 Threat ----

threat_pca_data <- threat |> drop_na(c(neigh_thr_m, vict_sum, neigh_thr02_m))

pca_threat_fit <- threat_pca_data |> select(neigh_thr_m, vict_sum, neigh_thr02_m) |>  as.matrix() |> factanal(factors = 1)

pca_threat_scores <- (threat_pca_data |> select(neigh_thr_m, vict_sum, neigh_thr02_m) |>  as.matrix() |> factanal(factors = 1, scores = "regression"))$scores |>
  as_tibble() |>
  bind_cols(threat_pca_data |> select(nomem_encr))

threat <- threat |>
  left_join(pca_threat_scores) |>
  rename(threat_comp = Factor1) |>
  select(nomem_encr, neigh_thr_m, neigh_thr_rel_m, neigh_thr02_m, neigh_thr02_rel_m, vict_sum, threat_comp, n_waves_threat)


## 3.2 Unpredictability in perceived scarcity

p_scar_pca_data <- p_scar |> drop_na(ends_with("cv"))

pca_p_scar_fit <- p_scar_pca_data |> select(ends_with("cv")) |>  as.matrix() |> factanal(factors = 1)

pca_p_scar_scores <- (p_scar_pca_data |> select(ends_with("cv")) |>  as.matrix() |> factanal(factors = 1, scores = "regression"))$scores |>
  as_tibble() |>
  bind_cols(p_scar_pca_data |> select(nomem_encr))

p_scar <- p_scar |>
  left_join(pca_p_scar_scores) |>
  rename(p_scar_cv = Factor1)


# 4. Combine data ---------------------------------------------------------

full_data <-
  left_join(inr, threat) |>
  left_join(p_scar) |>
  left_join(wm_data) |>
  select(nomem_encr, nohouse_encr, everything())

save(pca_p_scar_fit, pca_threat_fit, file = "analysis_objects/pca.RData")

write_csv(full_data, 'data/liss_data/full_data.csv')
