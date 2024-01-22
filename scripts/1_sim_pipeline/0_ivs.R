# 1. Load libraries ----------------------------------------------------------

library(tidyverse)

source('scripts/0_custom_functions/codebooks.R')

# 2. Functions ---------------------------------------------------------------

# INCOME-TO-NEEDS RATIO FOR DUTCH HOUSEHOLDS
# the information up until 2021 was derived from van den Brakel et al. 2023 (See main text).
# The information for 2022 was derived from https://www.cbs.nl/nl-nl/nieuws/2023/45/laagste-armoederisico-in-45-jaar-door-energietoeslag#:~:text=De%20lage%2Dinkomensgrens%20voor%20een,de%20grens%201%20830%20euro.
# At the moment of writing, there was no final data for 2023, so we used the same values as 2022.
inr_conv_table <-
  tibble(
    year            = rep(str_c(20, c("07", "08", "09", 10:23)), each = 8),
    adult           = rep(c(1, 1, 1, 1, 2, 2, 2, 2), 17),
    aantalki        = rep(c(0, 1, 2, 3, 0, 1, 2, 3), 17),
    eq_fct_pre2018  = rep(c(1, 1.33, 1.51, 1.76, 1.37, 1.67, 1.88, 2.06), 17),
    eq_fct_post2018 = rep(c(1, 1.32, 1.52, 1.73, 1.40, 1.69, 1.91, 2.09), 17)
  ) |>
  mutate(
    # `base` is the low-income threshold for a single-person household without children.
    # All other threshold are derived from the base by multiplying it with the equivalence factor.
    base = case_when(
      year %in% c("2007", "2008", "2009")                 ~ 870,
      year %in% c("2010", "2011", "2012", "2013", "2014") ~ 940,
      year %in% c("2015", "2016", "2017")                 ~ 1030,
      year == "2018"                                      ~ 1060,
      year == "2019"                                      ~ 1090,
      year == "2020"                                      ~ 1100,
      year == "2021"                                      ~ 1130,
      year == "2022"                                      ~ 1200,
      year == "2023"                                      ~ 1200
    ),
    threshold = ifelse(str_detect(year, "(18|19|20|21|22|23)$"), base*eq_fct_post2018, base*eq_fct_pre2018) |> plyr::round_any(x = _, 10, f = ceiling))


# 3. Stage 1: Simulate data for computational reproducibility ----------------

set.seed(4652757)

# These simulated data are a simplified version of the real data, without any meaningful covariances between conceptually related variables.
# Thus, they are purely meant for computational reproducibility.

## 3.1 Material deprivation ----

# Note: The variable *numbers* are identical to those in the LISS archive. However, the prefixes are standardized here as they are variable across waves.
core_income <-
  tibble(
    nomem_encr = rep(1:800, 16) |> as.character(),
    q_m    = rep(str_c(20, c("08", "09", 10:23)), each = 800),                            # Year of data collection
    q_378  = rep(sample(size = 800*16, x = 0:10, replace = T), 1),                        # How hard to live off your hh income
    q_245  = rep(sample(x = c(0,1), size = 800*16, prob = c(0.7, 0.3), replace = T), 1),  # Having trouble making ends meet
    q_246  = rep(sample(x = c(0,1), size = 800*16, prob = c(0.7, 0.3), replace = T), 1),  # Unable to quickly replace things that break
    q_247  = rep(sample(x = c(0,1), size = 800*16, prob = c(0.7, 0.3), replace = T), 1),  # having to lend money for necessary expenditures
    q_248  = rep(sample(x = c(0,1), size = 800*16, prob = c(0.7, 0.3), replace = T), 1),  # running behind in paying rent/mortgage or general utilities
    q_249  = rep(sample(x = c(0,1), size = 800*16, prob = c(0.7, 0.3), replace = T), 1),  # debt collector/bailiff at the door in the last month
    q_250  = rep(sample(x = c(0,1), size = 800*16, prob = c(0.7, 0.3), replace = T), 1),  # received financial support from family or friends in the last month
    q_252  = rep(runif(800*16, 1, 5), 1) |> floor(),                                                 # How would you describe the financial situation of your hh at this moment?
  ) |>
  # Simulate start dates for each participant (i.e., some participants starting at a later point in time)
  group_by(nomem_encr) |>
  mutate(
    startyear = sample(x = str_c(20, c("08", "09", 10:18)),
                       size = 1,
                       replace = TRUE,
                       prob = c(0.3, 0.2, 0.1, 0.1, 0.1, 0.05, 0.05, 0.05, 0.05, 0, 0))
  ) |>
  filter(as.numeric(q_m) >= startyear) |>
  group_by(nomem_encr, q_m) |>
  mutate(skipyear = ifelse(sample(c(0,1), size = 1, prob = c(0.2, 0.8)) == 0, TRUE, FALSE)) |>
  filter(skipyear == FALSE) |>
  ungroup() |>
  select(-c(startyear, skipyear)) |>
  # Introduce random missings for 5% of data
  mutate(across(-c(nomem_encr, q_m), ~ifelse(sample(c(0,1), size = n(), prob = c(0.05, 0.95), replace = T) == 0, NA, .)))

## 3.2 Threat ----

# Measures from the Crime victimization waves (LISS archive data)
crime_waves <-
  tibble(
    nomem_encr = rep(1:800, 6) |> as.character(),
    q_m    = rep(c(2008, 2010, 2012, 2014, 2016, 2018), each = 800),                                         # Year of data collection
    q_011  = rep(sample(x = c(1,2,3,4), size = 4800, prob = c(.55, .2, .2, .05), replace = T), 1),           # avoid certain areas in your place of residence
    q_012  = rep(sample(x = c(1,2,3,4), size = 4800, prob = c(.55, .2, .2, .05), replace = T), 1),           # do not respond to a call at the door
    q_013  = rep(sample(x = c(1,2,3,4), size = 4800, prob = c(.55, .2, .2, .05), replace = T), 1),           # leave valuable items at home to avoid theft
    q_014  = rep(sample(x = c(1,2,3,4), size = 4800, prob = c(.55, .2, .2, .05), replace = T), 1),           # make a detour to avoid unsafe areas
    q_094  = rep(sample(x = c(1,2,3), size = 4800, prob = c(0.05, 0.9, 0.05), replace = T), 1),              # Burglary
    q_095  = rep(sample(x = c(1,2,3), size = 4800, prob = c(0.05, 0.9, 0.05), replace = T), 1),              # theft from car
    q_096  = rep(sample(x = c(1,2,3), size = 4800, prob = c(0.05, 0.9, 0.05), replace = T), 1),              # theft of wallet or purse
    q_097  = rep(sample(x = c(1,2,3), size = 4800, prob = c(0.05, 0.9, 0.05), replace = T), 1),              # wreckage of car or other private property
    q_099  = rep(sample(x = c(1,2,3), size = 4800, prob = c(0.05, 0.9, 0.05), replace = T), 1),              # intimidation by any other means
    q_100  = rep(sample(x = c(1,2,3), size = 4800, prob = c(0.05, 0.9, 0.05), replace = T), 1),              # maltreatment requiring medical attention
    q_101  = rep(sample(x = c(1,2,3), size = 4800, prob = c(0.05, 0.9, 0.05), replace = T), 1)               # maltreatment not requring medical attention
  )

# Measures from the current data collection
crime_current <-
  tibble(
    nomem_encr   = 1:800 |> as.character(),
    q_001        = sample(x = c(1:5), size = 800, replace = T),
    q_002        = sample(x = c(1,2), size = 800, replace = T),
    q_003        = sample(x = c(1,2), size = 800, replace = T),
    VC1          = rnorm(800, 4, 1) |> round(),
    VC2          = rnorm(800, 4, 1) |> round(),
    VC3          = rnorm(800, 4, 1) |> round(),
    VC4          = rnorm(800, 4, 1) |> round(),
    VC5          = rnorm(800, 4, 1) |> round(),
    VC6          = rnorm(800, 4, 1) |> round(),
    VC7          = rnorm(800, 4, 1) |> round()
  )


## 3.3 Basic demographic variables ----

demo <-
  tibble(
    nomem_encr   = 1:800 |> as.character(),                                                                # Participant number
    nohouse_encr = sample(x = 1:750, size = 800, replace = T),                                             # Household number
    wave         = "202310",                                                                               # Wave
    age          = runif(800, 20, 60),                                                                     # Year of birth
    sted         = sample(x = c(1:5), size = 800, prob = c(0.2, 0.3, 0.2, 0.15, 0.15), replace = T),       # Urban character of place of residence
    aantalki     = sample(x = c(0:4), size = 800, prob = c(0.2, 0.3, 0.3, 0.1, 0.1), replace = T),         # Number of children living at home
    partner      = sample(x = c(0,1), size = 800, prob = c(0.6, 0.4), replace = T),                        # Household head lives with partner
    )


## 3.4 Monthly income data ----

income_hh <-
  tibble(
    nomem_encr = rep(1:800, 192) |> as.character(),
    wave       = rep((str_c(20, c("08", "09", 10:23)) |> map(function(x) str_c(x, 1:12)) |> unlist()), each = 800)
    ) |>
  right_join(demo |> select(nomem_encr, nohouse_encr, aantalki, partner)) |>
  mutate(nettohh_f    = rnorm(n(), 2000, 500))


# 4. Create composites ----------------------------------------------------

## 4.1 Material Deprivation ----

inr <-
  income_hh |>
  separate(col = wave, into = c("year", "month"), sep = 4) |>
  mutate(adult = ifelse(partner == 1, 2, 1)) |>
  mutate(
    # If number of children is larger than 3, impute 3 for INR matching
    aantalki_real = aantalki,
    aantalki = ifelse(aantalki > 3, 3, aantalki)
  ) |>
  left_join(inr_conv_table) |>
  mutate(inr_m = nettohh_f / threshold) |>
  group_by(nomem_encr, year) |>
  summarise(inr_y = mean(inr_m, na.rm = T)) |>
  ungroup() |>
  # Recode and scale INR
  mutate(inr_y_c = (-1 * inr_y) |> scale() |> as.numeric()) |>
  select(nomem_encr, year, inr_y, inr_y_c)

mat_dep_y <- core_income |>
  rename(
    year       = q_m,
    dep01      = q_378,
    dep02      = q_245,
    dep03      = q_246,
    dep04      = q_247,
    dep05      = q_248,
    dep06      = q_249,
    dep07      = q_250,
    dep08      = q_252
  ) |>
  # Recode variables so that higher scores are higher deprivation
  mutate(
    dep01      = 10 - dep01,
    dep08      = 5 - dep08,
  ) |>
  left_join(inr) |>
  mutate(
    finan_trouble   = across(matches("dep0(0|2|3|4|5|6|7)")) |> rowSums(x = _, na.rm = T),
    live_off_income = dep01,
    curr_situation  = dep08,
  ) |>
  mutate(p_scar_y   = across(c(finan_trouble, live_off_income, curr_situation)) |> scale() |> rowMeans(x = _, na.rm = T)) |>
  rowwise() |>
  mutate(mat_dep_y  = mean(c(p_scar_y, inr_y_c), na.rm = T)) |>
  ungroup() |>
  select(nomem_encr, year, p_scar_y, inr_y, inr_y_c, mat_dep_y, finan_trouble, live_off_income, curr_situation) |>
  sjlabelled::var_labels(
    nomem_encr      = "Participant identifier",
    year            = "Year of data collection",
    p_scar_y        = "Perceived scarcity per year. Average of all standardized perceived scarcity measures",
    inr_y           = "Income-To-Needs Ratio per year. Calculated by dividing the average monthly household income per year by the government threshold for low household income (corrected for household composition).",
    inr_y_c         = "Income-To-Needs Ratio per year. Reverse-coded and scaled",
    mat_dep_y       = "Material deprivation per year. Average of p_scar_y and inr_y.",
    finan_trouble   = "Sum of 6 items indicating various financial problems.",
    live_off_income = "How hard is it to live off the household income?",
    curr_situation  = "How would you describe the financial situation of your hh at this moment?",
    )

mat_dep <- mat_dep_y |>
  group_by(nomem_encr) |>
  summarise(
    p_scar          = mean(p_scar_y, na.rm = T),
    inr_c           = mean(inr_y_c, na.rm = T),
    mat_dep         = mean(mat_dep_y, na.rm = T),
    finan_trouble   = mean(finan_trouble, na.rm = T),
    live_off_income = mean(live_off_income, na.rm = T),
    curr_situation  = mean(curr_situation, na.rm = T)
  ) |>
  sjlabelled::var_labels(
    nomem_encr      = "Participant identifier",
    p_scar          = "Perceived scarcity across years. Average of all standardized perceived scarcity measures",
    inr_c           = "Income-To-Needs Ratio across years; reverse coded and scaled. Calculated by dividing the average monthly household income per year by the government threshold for low household income (corrected for household composition).",
    mat_dep         = "Mean Material deprivation across years. p_scar and inr_c",
    finan_trouble   = "Mean financial troubles across years.",
    live_off_income = "Mean difficulties of living off of income across years.",
    curr_situation  = "Mean of self-reported current situation across years."
  )

## 4.2 Unpredictability ----

unpred <- mat_dep_y |>
  group_by(nomem_encr) |>
  summarise(
    unp = sd(mat_dep_y, na.rm = T)
  )

## 4.2 Threat ----

threat <- crime_waves |>
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
  ) %>%
  # Rescale neighorhood safety items
  mutate(
    neigh_thr01 = (neigh_thr01 - 1) %>% ifelse(. == 3, NA, .),
    neigh_thr02 = (neigh_thr02 - 1) %>% ifelse(. == 3, NA, .),
    neigh_thr03 = (neigh_thr03 - 1) %>% ifelse(. == 3, NA, .),
    neigh_thr04 = (neigh_thr04 - 1) %>% ifelse(. == 3, NA, .)
  ) %>%
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
  mutate(neigh_thr_sum = across(starts_with("neigh_thr")) |> rowSums(x = _, na.rm = T)) |>
  group_by(nomem_encr) |>
  summarise(
    # Summing the neighborhood threat items
    neigh_thr_m = mean(neigh_thr_sum, na.rm = T),

    vict01      = ifelse(sum(vict01, na.rm = T) > 0, 1, 0),
    vict02      = ifelse(sum(vict02, na.rm = T) > 0, 1, 0),
    vict03      = ifelse(sum(vict03, na.rm = T) > 0, 1, 0),
    vict04      = ifelse(sum(vict04, na.rm = T) > 0, 1, 0),
    vict05      = ifelse(sum(vict05, na.rm = T) > 0, 1, 0),
    vict06      = ifelse(sum(vict06, na.rm = T) > 0, 1, 0),
    vict07      = ifelse(sum(vict07, na.rm = T) > 0, 1, 0),
  ) |>
  mutate(
    # Creating a variety sum score of the victimization items
    vict_sum    = across(starts_with("vict")) |> rowSums()
  ) |>
  select(-matches("vict\\d\\d")) |>
  # merge current neigh. crime data, collected in this study only
  full_join(crime_current) |>
  rename(
    noise         = q_001,
    interrupt     = q_002,
    leave         = q_003,
    neigh_thr_c01 = VC1,
    neigh_thr_c02 = VC2,
    neigh_thr_c03 = VC3,
    neigh_thr_c04 = VC4,
    neigh_thr_c05 = VC5,
    neigh_thr_c06 = VC6,
    neigh_thr_c07 = VC7
  ) |>
  # Rescale items
  mutate(
    interrupt     = ifelse(interrupt == 1, 0, 1),
    leave         = ifelse(leave == 1, 0, 1),
    neigh_thr_c01 = 7 - neigh_thr_c01,
    neigh_thr_c03 = 7 - neigh_thr_c03,
    neigh_thr_c_m = across(matches('neigh_thr_c')) |> rowMeans(na.rm = T)
  ) |>
  select(-matches("c\\d\\d$")) |>
  mutate(
    neigh_thr_comp = across(c(neigh_thr_m, neigh_thr_c_m)) |> scale() |> rowMeans(na.rm = T),
    threat         = across(c(neigh_thr_comp, vict_sum)) |> scale() |> rowMeans(na.rm = T)
  ) |>
  sjlabelled::var_labels(
    nomem_encr    = "Participant identifier",
    neigh_thr_m   = "Average summed score across waves for four items (How often does it happen that you): (1) avoid certain areas in your place of residence because you perceive them as unsafe?; (2) do not respond to a call at the door because you feel that it is unsafe?; (3) leave valuable items at home to avoid theft or robbery in the street?; (4) make a detour, by car or on foot, to avoid unsafe areas?",
    noise         = "How much noise was there around you during the memory tasks?",
    interrupt     = "Were you interrupted at any moment during the memory tasks?",
    leave         = "Did you leave your computer at any moment during the memory tasks?",
    neigh_thr_c_m = "Average across current neighborhood threat items (neigh_thr_c01 to neigh_thr_c07)",
    neigh_thr_comp = "Average of the two neighborhood crime items (separately standardized): neigh_thr_m and neigh_thr_c_m",
    threat        = "Neighborhood threat composite, consisting of the average of neigh_thr_comp and vict_sum (separately standardized)"
  ) |>
  sjlabelled::val_labels(
    noise         = c("No" = 0, "Yes" = 1),
    interrupt     = c("No" = 0, "Yes" = 1),
    leave         = c("No" = 0, "Yes" = 1)
  )


# 5. Combine IVs ----------------------------------------------------------

ivs_sim <-
  mat_dep |>
  left_join(unpred) |>
  left_join(threat) |>
  select(nomem_encr, mat_dep, unp, threat, noise, interrupt, leave)


# 5. Create codebooks -----------------------------------------------------

ivs_codebook <- create_codebook(mat_dep)

openxlsx::write.xlsx(ivs_codebook, file = "codebooks/codebook_ivs.xlsx")
save(ivs_sim, mat_dep_y, inr, mat_dep, threat, file = "data/ivs_sim.RData")

