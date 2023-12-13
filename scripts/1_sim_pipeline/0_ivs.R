# 1. Load libraries ----------------------------------------------------------

library(tidyverse)

# 2. Functions ---------------------------------------------------------------

# INCOME-TO-NEEDS RATIO FOR DUTCH HOUSEHOLDS
# the information up until 2021 was derived from van den Brakel et al. 2023 (See main text).
# The information for 2022 was derived from https://www.cbs.nl/nl-nl/nieuws/2023/45/laagste-armoederisico-in-45-jaar-door-energietoeslag#:~:text=De%20lage%2Dinkomensgrens%20voor%20een,de%20grens%201%20830%20euro.
# At the moment of writing, there was no final data for 2023, so we used the same values as 2022.
inr_conv_table <- tibble(
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
core_income <- tibble(
  nomem_encr = rep(1:800, 16) |> as.character(),
  q_m    = rep(str_c(20, c("08", "09", 10:23)), each = 800),                            # Year of data collection
  q_378  = rep(sample(size = 800*16, x = 0:10, replace = T), 1),                        # How hard to live off your hh income
  q_245  = rep(sample(x = c(0,1), size = 800*16, prob = c(0.7, 0.3), replace = T), 1),  # Having trouble making ends meet
  q_246  = rep(sample(x = c(0,1), size = 800*16, prob = c(0.7, 0.3), replace = T), 1),  # Unable to quickly replace things that break
  q_247  = rep(sample(x = c(0,1), size = 800*16, prob = c(0.7, 0.3), replace = T), 1),  # having to lend money for necessary expenditures
  q_248  = rep(sample(x = c(0,1), size = 800*16, prob = c(0.7, 0.3), replace = T), 1),  # running behind in paying rent/mortgage or general utilities
  q_249  = rep(sample(x = c(0,1), size = 800*16, prob = c(0.7, 0.3), replace = T), 1),  # debt collector/bailiff at the door in the last month
  q_250  = rep(sample(x = c(0,1), size = 800*16, prob = c(0.7, 0.3), replace = T), 1),  # received financial support from family or friends in the last month
  q_252  = rep(runif(800*16, 1, 5), 1),                                                 # How would you describe the financial situation of your hh at this moment?
  q_253  = rep(sample(x = 1:3, size = 800*16, replace = T), 1),                         # Was expenditure larger, equal, or lower than hh income?
  q_255  = rep(runif(800*16, 1, 3), 1),                                                 # Disregarding large expenditures, was your hh expenditure more than, equal to, or less than your hh income?
  )

## 3.2 Threat ----

crime_waves <- tibble(
  nomem_encr = rep(1:800, 6) |> as.character(),
  q_m    = rep(c(2008, 2010, 2012, 2014, 2016, 2018), each = 800),                                        # Year of data collection
  q_011  = rep(sample(x = c(1,2,3,4), size = 4800, prob = c(.55, .2, .2, .05), replace = T), 1),          # avoid certain areas in your place of residence
  q_012  = rep(sample(x = c(1,2,3,4), size = 4800, prob = c(.55, .2, .2, .05), replace = T), 1),          # do not respond to a call at the door
  q_013  = rep(sample(x = c(1,2,3,4), size = 4800, prob = c(.55, .2, .2, .05), replace = T), 1),          # leave valuable items at home to avoid theft
  q_014  = rep(sample(x = c(1,2,3,4), size = 4800, prob = c(.55, .2, .2, .05), replace = T), 1),          # make a detour to avoid unsafe areas
  q_094  = rep(sample(x = c(1,2,3), size = 4800, prob = c(0.2, 0.75, 0.05), replace = T), 1),             # Burglary
  q_095  = rep(sample(x = c(1,2,3), size = 4800, prob = c(0.2, 0.75, 0.05), replace = T), 1),             # theft from car
  q_096  = rep(sample(x = c(1,2,3), size = 4800, prob = c(0.2, 0.75, 0.05), replace = T), 1),             # theft of wallet or purse
  q_097  = rep(sample(x = c(1,2,3), size = 4800, prob = c(0.2, 0.75, 0.05), replace = T), 1),             # wreckage of car or other private property
  q_099  = rep(sample(x = c(1,2,3), size = 4800, prob = c(0.2, 0.75, 0.05), replace = T), 1),             # intimidation by any other means
  q_100  = rep(sample(x = c(1,2,3), size = 4800, prob = c(0.2, 0.75, 0.05), replace = T), 1),             # maltreatment requiring medical attention
  q_101  = rep(sample(x = c(1,2,3), size = 4800, prob = c(0.2, 0.75, 0.05), replace = T), 1)              # maltreatment not requring medical attention
) |>
  # Simulate frequencies for experienced crimes
  mutate(
    q_102 = ifelse(q_094 == 1, sample(x = c(1,2,3), size = 1, prob = c(0.80, 0.10, 0.10), replace = T), NA), # burglary frequency
    q_103 = ifelse(q_095 == 1, sample(x = c(1,2,3), size = 1, prob = c(0.80, 0.10, 0.10), replace = T), NA), # theft from car frequency
    q_104 = ifelse(q_096 == 1, sample(x = c(1,2,3), size = 1, prob = c(0.80, 0.10, 0.10), replace = T), NA), # theft from wallet or purse frequency
    q_105 = ifelse(q_097 == 1, sample(x = c(1,2,3), size = 1, prob = c(0.80, 0.10, 0.10), replace = T), NA), # wreckage of car frequency
    q_107 = ifelse(q_099 == 1, sample(x = c(1,2,3), size = 1, prob = c(0.80, 0.10, 0.10), replace = T), NA), # intimidation by other means frequency
    q_108 = ifelse(q_100 == 1, sample(x = c(1,2,3), size = 1, prob = c(0.80, 0.10, 0.10), replace = T), NA), # maltreatment med attention frequency
    q_109 = ifelse(q_101 == 1, sample(x = c(1,2,3), size = 1, prob = c(0.80, 0.10, 0.10), replace = T), NA) # maltreatment no med attention frequency
  )



# 3.3 Basic demographic variables ---------------------------------------------

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


# 3.4 Monthly income data -------------------------------------------------

income_hh <-
  tibble(
    nomem_encr = rep(1:800, 192) |> as.character(),
    wave       = rep((str_c(20, c("08", "09", 10:23)) |> map(function(x) str_c(x, 1:12)) |> unlist()), each = 800)
    ) |>
  right_join(demo |> select(nomem_encr, nohouse_encr, aantalki, partner)) |>
  mutate(nettohh_f    = rnorm(n(), 2000, 500))


# 4. Clean data -----------------------------------------------------------

## 4.2 Material Deprivation

inr <-
  income_hh |>
  separate(col = wave, into = c("year", "month"), sep = 4) |>
  mutate(adult = ifelse(partner == 1, 2, 1)) |>
  left_join(inr_conv_table) |>
  mutate(inr = nettohh_f / threshold) |>
  group_by(nomem_encr, year) |>
  summarise(inr = mean(inr, na.rm = T)) |>
  ungroup()

mat_dep <- core_income |>
  rename(
    year      = q_m,
    dep01      = q_378,
    dep02      = q_245,
    dep03      = q_246,
    dep04      = q_247,
    dep05      = q_248,
    dep06      = q_249,
    dep07      = q_250,
    dep08      = q_252,
    dep09      = q_253,
    dep10     = q_255
  ) |>
  # Recode variables so that higher scores are higher deprivation
  mutate(
    dep01      = 10 - dep01,
    dep08      = 5 - dep08,
    dep09      = ifelse(!is.na(dep10), dep10, dep09) # Disregard big expenditures such as purchase of car or house
  ) |>
  # Create dummies
  mutate(
    dep09_d1   = ifelse(dep09 == 2, 1, 0),
    dep09_d2   = ifelse(dep09 == 1, 1, 0)
  ) |>
  select(-dep09, -dep10) |>
  left_join(inr) |>
  sjlabelled::var_labels(
    year = "Year of data collection",
    dep01 = "Can you indicate, on a scale from 0 to 10, how hard or how easy it is for you to live off the income of your household? (RECODED)",
    dep02 = "having trouble making ends meet",
    dep03 = "unable to quickly replace things that break",
    dep04 = "having to lend money for necessary expenditures",
    dep05 = "running behind in paying rent/mortgage or general utilities",
    dep06 = "debt collector/bailiff at the door in the last month",
    dep07 = "received financial support from family or friends in the last month",
    dep08 = "How would you describe the financial situation of your household at this moment? (RECODED)",
    dep09_d1 = "Think about the last 12 months. Was your household expenditure more than, equal to,
    or less than your household income? (DUMMY-CODED)",
    dep09_d2 = "Think about the last 12 months. Was your household expenditure more than, equal to,
    or less than your household income? (DUMMY-CODED)",
    inr = "Income-To-Needs Ratio. Calculated by dividing the average monthly household income per year by the government threshold for low household income (corrected for household composition)."
  ) |>
  sjlabelled::val_labels(
    dep01 = c("very easy" = 0, "very hard" = 10),
    dep02 = c("No" = 0, "Yes" = 1),
    dep03 = c("No" = 0, "Yes" = 1),
    dep04 = c("No" = 0, "Yes" = 1),
    dep05 = c("No" = 0, "Yes" = 1),
    dep06 = c("No" = 0, "Yes" = 1),
    dep07 = c("No" = 0, "Yes" = 1),
    dep08 = c("We have a lot of money to spare" = 1,
             "We have a little bit of money to spare" = 2,
             "We are just managing to make ends meet" = 3,
             "We are somewhat eating into savings" = 4,
             "We are accumulating debts" = 5),
    dep09_d1 = c("expenditure was lower than the income" = 0, "expenditure was approximately equal to the income" = 1),
    dep09_d2 = c("expenditure was lower than the income" = 0, "expenditure was higher than the income" = 1)
  )


## 4.2 Threat

crime_waves |>
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
    vict07      = q_101,
    vict_fr01   = q_102,
    vict_fr02   = q_103,
    vict_fr03   = q_104,
    vict_fr04   = q_105,
    vict_fr05   = q_107,
    vict_fr06   = q_108,
    vict_fr07   = q_109
  ) %>%
  # Rescale neighorhood safety items
  mutate(
    neigh_thr01 = (neigh_thr01 - 1) %>% ifelse(. == 3, NA, .),
    neigh_thr02 = (neigh_thr02 - 1) %>% ifelse(. == 3, NA, .),
    neigh_thr03 = (neigh_thr03 - 1) %>% ifelse(. == 3, NA, .),
    neigh_thr04 = (neigh_thr04 - 1) %>% ifelse(. == 3, NA, .),
  ) |>
  mutate(neigh_thr_sum = across(starts_with("neigh_thr")) |> rowSums(x = _, na.rm = T)) |>
  mutate(across(matches("vict_fr"), (\(x) ifelse(is.na(x) | x == 3, 0, x)))) |>
  group_by(nomem_encr) |>
  summarise(
    across(matches('vict_fr'), sum),
    neigh_thr_m   = mean(neigh_thr_sum, na.rm = T)
    ) |>
  sjlabelled::var_labels(
    nomem_encr    = "Participant identifier",
    vict_fr01     = "Summed frequency across waves of falling victim to: burglary or attempted burglary (of your home, shed or garage)",
    vict_fr02     = "Summed frequency across waves of falling victim to: theft from your car",
    vict_fr03     = "Summed frequency across waves of falling victim to: theft of your wallet or purse, handbag, or other personal possession (in the street, from a wardrobe, etc.)",
    vict_fr04     = "Summed frequency across waves of falling victim to: wreckage of your car or other private property (garden, bicycle, etc.)",
    vict_fr05     = "Summed frequency across waves of falling victim to: intimidation by any other means (e.g. by letter, telephone, or face-to-face)",
    vict_fr06     = "Summed frequency across waves of falling victim to: maltreatment of such serious nature that it required medical attention",
    vict_fr07     = "Summed frequency across waves of falling victim to: maltreatment that did not require medical attention",
    neigh_thr_m   = "Average summed score across waves for four items (How often does it happen that you): (1) avoid certain areas in your place of residence because you perceive them as unsafe?; (2) do not respond to a call at the door because you feel that it is unsafe?; (3) leave valuable items at home to avoid theft or robbery in the street?; (4) make a detour, by car or on foot, to avoid unsafe areas?"
  )
