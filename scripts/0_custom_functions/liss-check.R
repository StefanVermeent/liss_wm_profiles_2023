# test whether the unzipping has worked
list.files("liss/background") |>
  str_extract("\\d\\d\\d\\d\\d\\d") |>
  as_tibble() |>
  mutate(
    year = str_extract(value, "^\\d\\d\\d\\d"),
    month = str_extract(value, "\\d\\d$")
  ) |>
  group_by(year) |>
  count(
  )

list.files("liss/background") |>
  str_extract("\\d\\d\\d\\d\\d\\d") |>
  str_subset("2015")
