### Date: 2024-03-30 16:25:37

### Description: access to all income waves in LISS archive


### For more information on this commit, see the README file, or go to https://github.com/StefanVermeent/liss_wm_profiles_2023/commit/71d70ab79326ada925a66e4e695c2e1ae703389a

### Below is the full code that was used to access the data:


purrr::map(.x = list.files('data/liss_data/crime', pattern = '.sav', full.names = TRUE), function(x) {haven::read_sav(file = x, col_select = NULL) |>
 dplyr::filter() |>
 shuffle(data = _, shuffle_vars = 'NULL', long_format = FALSE, seed = 3985843)})
