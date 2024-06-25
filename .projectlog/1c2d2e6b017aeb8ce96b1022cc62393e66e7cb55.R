### Date: 2024-04-03 16:13:42

### Description: Read subject IDs only of new data collection to filter IV data


### For more information on this commit, see the README file, or go to https://github.com/StefanVermeent/liss_wm_profiles_2023/commit/1c2d2e6b017aeb8ce96b1022cc62393e66e7cb55

### Below is the full code that was used to access the data:


haven::read_sav('data/liss_data/wm/L_Cognitieve_Vaardigheden_v2_1.0p.sav', col_select = 'nomem_encr') |>
 dplyr::filter() |>
 shuffle(data = _, shuffle_vars = 'NULL', long_format = FALSE, seed = 3985843)
