### Date: 2024-04-04 09:20:20

### Description: access to all working memory measures of new study


### For more information on this commit, see the README file, or go to https://github.com/StefanVermeent/liss_wm_profiles_2023/commit/a0be5183db79da2d3f752565d29097b8c4a72186

### Below is the full code that was used to access the data:


haven::read_sav('data/liss_data/wm/L_Cognitieve_Vaardigheden_v2_1.0p.sav', col_select = NULL) |>
 dplyr::filter() |>
 shuffle(data = _, shuffle_vars = 'NULL', long_format = FALSE, seed = 3985843)
