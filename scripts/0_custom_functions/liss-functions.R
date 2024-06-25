# Unzipping data from liss downloads --------------------------------------
unzip_liss <- function(zip_path){

  zip_exdir <-
    ifelse(
      str_detect(zip_path, "\\/"),
      str_extract(zip_path, "^(.*\\/)+"),
      "."
    )

  zip_sav <- str_replace(zip_path, ".zip$", ".sav")
  zip_dta <- str_replace(zip_path, ".zip$", ".dta")

  unzip(zip_path, overwrite = TRUE,  exdir = zip_exdir)

  unlink(zip_dta)
}

# look up table ------------------------------------------------------------
var_lookup <- function (data, ...) {
  lp_data <-
    tibble::tibble(
      Variable = names(data),
      Label = purrr::map_chr(data,
                             function(x) {
                               extracted_label <- attr(x, which = "label")
                               if (is.null(extracted_label)) {
                                 extracted_label <- ""
                               }
                               extracted_label
                             }), Values = purrr::map_chr(data, function(x) {
                               extracted_values <- attr(x, which = "labels")
                               if (is.null(extracted_values)) {
                                 extracted_values <- ""
                               }
                               else {
                                 extracted_values <- paste(names(extracted_values),
                                                           "=", extracted_values, ...)
                               }
                               extracted_values
                             }))
  lp_table <- lp_data
  no_labels <- lp_table %>% dplyr::filter(Label == "")
  no_values <- lp_table %>% dplyr::filter(Values == "")
  if (nrow(no_labels) > 0) {
    message("The following variables have no labels:\n",
            paste(no_labels %>% dplyr::pull(Variable), collapse = "\n"))
  }
  if (nrow(no_values) > 0) {
    message("The following variables have no value labels:\n",
            paste(no_values %>% dplyr::pull(Variable), collapse = "\n"))
  }
  lp_table
}

