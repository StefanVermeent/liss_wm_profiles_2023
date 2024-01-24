### Date: 2023-05-01 09:40:53

### Description: Crime Victimization Data Wave 5, shuffled ids


### For more information on this commit, see the README file, or go to https://github.com/StefanVermeent/liss_wm_profiles_2023/commit/598922e78bf7abcc1b5160e06355e32a73d02be5

### Below is the full code that was used to access the data:


readr::read_delim('data/ac16e_EN_1.0p.csv', col_select = NULL,  delim = ';') |>
 dplyr::filter() |>
 shuffle(data = _, shuffle_vars = 'nomem_encr', long_format = FALSE, seed = 3985843)
