# some trials?
unzip_read_sav("liss/background/avars_200711_EN_3.0p.zip") |>
  select(nomem_encr, nohouse_encr, aantalhh, positie, gebjaar, leeftijd, lftdhhh, oplcat, doetmee)

unzip_read_sav("liss/background/avars_202209_EN_1.0p.zip") |>
  select(nomem_encr, nohouse_encr, aantalhh, positie, gebjaar, leeftijd, lftdhhh, oplcat, doetmee) |>
  filter(nohouse_encr == 583404)

liss_background <-
  map(
    list.files("liss/background", pattern = ".zip$", full.names = T),
    unzip_read_sav
  )

liss_health <-
  map(
    list.files("liss/health", pattern = ".zip$", full.names = T),
    function(x){
      unzip_read_sav(x) |>
        select(nomem_encr, starts_with("ch")) |>
        rename_with(.cols = c(starts_with("ch")), ~str_replace(.x, "^ch\\d\\d[a-n]","q")) |>
        rename_with(.cols = c(matches("^q_m$")), ~c("wave")) |>
        select(-any_of(c("q256","q258")))
    }
  )


liss_background_data <- list_rbind(liss_background)
liss_health_data <- reduce(liss_health, bind_rows)

liss_health_data |> var_lookup(collapse = ", ") |> View()

liss_health[[10]]$q016

d2 <- liss_health |>
  map(function(x){
    x |>
      select(matches("q0(16|17|19)$"))
  })
d

glue::glue(
  "d2[[1]] |> sjlabelled::var_labels(",
  glue::glue_data(
    d[[1]],
    "{Variable} = '{str_trim(Label)}',"
  ) |> paste(collapse = " "),
  ")"
) |>
  rlang::parse_expr() |>
  rlang::eval_tidy() |>
  var_lookup(collapse = ", ")
