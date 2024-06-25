library(tidyverse)
library(haven)

liss_income_zips <- list.files("income", full.names = TRUE)

liss_income <-
  map_df(liss_income_zips, function(x){

    liss_wave <- str_extract(x, "ci\\d\\d")
    liss_sav <- str_remove(x, "income.") |> str_replace("zip$", "sav")

    print(liss_wave)
    print(liss_sav)

    unzip(x)
    liss_data <-
      read_sav(liss_sav) |>
      rename_with(~str_remove(.x, liss_wave)) |>
      rename_with(.cols = matches("_m$"), .fn =  ~paste("period")) |>
      mutate(
        wave = liss_wave
      ) |>
      select(
        wave, period, nomem_encr,
        matches("00([2-5]|[8:9])$|23[0-6]$|a24[3-9]$|25[0-3]$")
      ) |>
      rename_with(.cols = c(-wave, -period, -nomem_encr), .fn =  ~str_replace(.x, "^.", "income"))

    unlink(liss_sav)

    liss_data
  })


liss_income |>
  arrange(nomem_encr, wave) |>
  print(n = 100)
