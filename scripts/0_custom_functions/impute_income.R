
impute_income <- function(month_data, year_data) {

  imputed_data <- unique(month_data$nomem_encr) |>
    map(function(x){

      month_data_i <- month_data |>
        filter(nomem_encr == x) |>
        group_by(year) |>
        mutate(all_missing = ifelse(all(is.na(nettohh_f)), TRUE, FALSE))

      if(any(month_data_i$all_missing)) {
        missing_years <- month_data_i |>
          filter(all_missing) |>
          pull(year) |>
          unique()

        year_data_i <- year_data |>
          filter(nomem_encr == x, year %in% missing_years) |>
          select(nomem_encr, year, net_inc_y)

        if(nrow(year_data_i) == 0) {return(month_data_i)}

        message("data imputed for ", x)
        return(month_data_i |> left_join(year_data_i))

      } else
      {
        return(month_data_i)
      }

    })

  return(imputed_data |> bind_rows())
}
