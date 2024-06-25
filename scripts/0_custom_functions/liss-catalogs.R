library(tidyverse)
library(haven)

#script number 1 of the liss scripts for unzupping the data and working with them

source("scripts/0-functions.R")

liss_health <-
  unzip_read_sav("liss/health/ch07a_2p_EN.zip") |>
  var_lookup(collapse = ", ")

liss_neigh <-
  unzip_read_sav("liss/neighborhood-perceptions/sr20a_EN_1.0p.zip") |>
  var_lookup(collapse = ", ")

liss_saftey <-
  unzip_read_sav("liss/personal-saftey/oc17a_EN_1.0p.zip") |>
  var_lookup(collapse = ", ")

liss_safteymonitor <-
  unzip_read_sav("liss/saftey-monitor/ic13a_EN_1.0p.zip") |>
  var_lookup(collapse = ", ")

liss_crime08 <-
  unzip_read_sav("liss/conventional-computer-crime/ac08a_2.0p_EN.zip") |>
  var_lookup(collapse = ", ")

liss_crime10 <-
  unzip_read_sav("liss/conventional-computer-crime/ac10b_1.0p_EN.zip") |>
  var_lookup(collapse = ", ")

liss_crime12 <-
  unzip_read_sav("liss/conventional-computer-crime/ac12c_EN_1.0p.zip") |>
  var_lookup(collapse = ", ")

liss_crime14 <-
  unzip_read_sav("liss/conventional-computer-crime/ac14d_EN_1.0p.zip") |>
  var_lookup(collapse = ", ")

liss_crime16 <-
  unzip_read_sav("liss/conventional-computer-crime/ac16e_EN_1.0p.zip") |>
  var_lookup(collapse = ", ")

liss_crime18 <-
  unzip_read_sav("liss/conventional-computer-crime/ac18f_EN_1.0p.zip") |>
  var_lookup(collapse = ", ")

liss_lifehistory12 <-
  unzip_read_sav("liss/life-history/cb12a_EN_1.0p.zip") |>
  var_lookup(collapse = ", ")

liss_lifehistory13 <-
  unzip_read_sav("liss/life-history/cb13b_EN_1.0p.zip") |>
  var_lookup(collapse = ", ")

liss_victims18a <-
  unzip_read_sav("liss/victims/oo18a_EN_1.1p.zip") |>
  var_lookup(collapse = ", ")

liss_victims18b <-
  unzip_read_sav("liss/victims/oo18b_EN_1.0p.zip") |>
  var_lookup(collapse = ", ")

liss_victims19 <-
  unzip_read_sav("liss/victims/oo19c_EN_1.0p.zip") |>
  var_lookup(collapse = ", ")

liss_victims20 <-
  unzip_read_sav("liss/victims/oo20d_EN_1.0p.zip") |>
  var_lookup(collapse = ", ")

liss_victims21 <-
  unzip_read_sav("liss/victims/oo21e_EN_1.0.zip") |>
  var_lookup(collapse = ", ")

liss_finacialdistress <-
  unzip_read_sav("liss/financial-distress/qj18a_EN_1.0p.zip") |>
  var_lookup(collapse = ", ")

liss_lifeevents <-
  unzip_read_sav("liss/life-events/th20a_EN_1.0p.zip") |>
  var_lookup(collapse = ", ")

liss_events <-
  unzip_read_sav("liss/events-in-life/ot19a_EN_1.0.zip") |>
  var_lookup(collapse = ", ")

liss_background <-
  unzip_read_sav("liss/background/avars_200711_EN_3.0p.zip") |>
  var_lookup(collapse = ", ")

liss_expectations <-
  unzip_read_sav("liss/expectations/am08a_1p_EN.zip") |>
  var_lookup(collapse = ", ")

liss_socialexcl18 <-
  unzip_read_sav("liss/social-exclusion/og18a_EN_1.0p.zip") |>
  var_lookup(collapse = ", ")

liss_socialexcl20b <-
  unzip_read_sav("liss/social-exclusion/og20b_EN_1.0p.zip") |>
  var_lookup(collapse = ", ")

liss_socialexcl20c <-
  unzip_read_sav("liss/social-exclusion/og20c_EN_1.0p.zip") |>
  var_lookup(collapse = ", ")

liss_socialexcl21d <-
  unzip_read_sav("liss/social-exclusion/og18a_EN_1.0p.zip") |>
  var_lookup(collapse = ", ")

liss_socialexcl21e <-
  unzip_read_sav("liss/social-exclusion/og18a_EN_1.0p.zip") |>
  var_lookup(collapse = ", ")

