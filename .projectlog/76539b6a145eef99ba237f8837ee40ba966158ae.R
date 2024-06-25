### Date: 2024-04-01 09:58:39

### Description: access to all background variable waves in LISS archive


### For more information on this commit, see the README file, or go to https://github.com/StefanVermeent/liss_wm_profiles_2023/commit/76539b6a145eef99ba237f8837ee40ba966158ae

### Below is the full code that was used to access the data:


purrr::map(.x = list.files('data/liss_data/background', pattern = '.sav', full.names = TRUE), function(x) {haven::read_sav(file = x, col_select = NULL) |>
 dplyr::filter() |>
 shuffle(data = _, shuffle_vars = 'NULL', long_format = FALSE, seed = 3985843)})
