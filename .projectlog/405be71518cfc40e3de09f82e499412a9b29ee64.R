### Date: 2023-05-01 09:22:26

### Description: LISS background variables March 2023, shuffled ids


### For more information on this commit, see the README file, or go to https://github.com/StefanVermeent/liss_wm_profiles_2023/commit/405be71518cfc40e3de09f82e499412a9b29ee64

### Below is the full code that was used to access the data:


readr::read_delim('data/avars_202303_EN_1.0p.csv', col_select = NULL,  delim = ';') |>
 dplyr::filter() |>
 shuffle(data = _, shuffle_vars = 'nomem_encr', long_format = FALSE, seed = 3985843)
