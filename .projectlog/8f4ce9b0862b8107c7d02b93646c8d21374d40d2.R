### Date: 2023-05-01 09:34:57

### Description: LISS background variables January 2023, shuffled ids


### For more information on this commit, see the README file, or go to https://github.com/StefanVermeent/liss_wm_profiles_2023/commit/8f4ce9b0862b8107c7d02b93646c8d21374d40d2

### Below is the full code that was used to access the data:


readr::read_delim('data/avars_202301_EN_1.0p.csv', col_select = NULL,  delim = ';') |>
 dplyr::filter() |>
 shuffle(data = _, shuffle_vars = 'nomem_encr', long_format = FALSE, seed = 3985843)
