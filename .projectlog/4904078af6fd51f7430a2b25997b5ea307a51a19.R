### Date: 2023-05-01 09:33:43

### Description: LISS background variables March 2023, shuffled ids


### For more information on this commit, see the README file, or go to https://github.com/StefanVermeent/liss_wm_profiles_2023/commit/4904078af6fd51f7430a2b25997b5ea307a51a19

### Below is the full code that was used to access the data:


readr::read_delim('data/avars_202302_EN_1.0p.csv', col_select = NULL,  delim = ';') |>
 dplyr::filter() |>
 shuffle(data = _, shuffle_vars = 'nomem_encr', long_format = FALSE, seed = 3985843)
