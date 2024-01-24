### Date: 2023-05-01 09:41:18

### Description: Crime Victimization Data Wave 4, shuffled ids


### For more information on this commit, see the README file, or go to https://github.com/StefanVermeent/liss_wm_profiles_2023/commit/82f126ec06653b3794b6bb710b8a04b4e697d630

### Below is the full code that was used to access the data:


readr::read_delim('data/ac14d_EN_1.0p.csv', col_select = NULL,  delim = ';') |>
 dplyr::filter() |>
 shuffle(data = _, shuffle_vars = 'nomem_encr', long_format = FALSE, seed = 3985843)
