# Packages ----------------------------------------------------------------
library(psych)
library(tidyverse)
library(qualtRics)
library(jsonlite)
library(here)
library(sjlabelled)


# Data --------------------------------------------------------------------
pilot_data <-
  fetch_survey(
    surveyID = "SV_1B4wQ0QzRnlNEZU",
    verbose  = T,
    force_request = T,
    label = F,
    convert = F,
    add_var_labels = F
  ) %>%
  rename_with(tolower) %>%
  mutate(id = 1:n()) %>%
  sjlabelled::var_labels(
    id = "Blinded participant ID"
  ) %>%
  filter(finished==1, status == 0, `duration (in seconds)` > 0) %>%
  select(-session_id)

pilot2_data <-
  fetch_survey(
    surveyID = "SV_6JVjAWrPoHnjah8",
    verbose  = T,
    force_request = T,
    label = F,
    convert = F,
    add_var_labels = F
  ) %>%
  rename_with(tolower) %>%
  mutate(id = 1:n()) %>%
  filter(finished==1) %>%
  select(-session_id)


# Self-report -------------------------------------------------------------

## meta data ----

vars01_meta <-
  pilot_data %>%
  rename(
    meta_duration       = `duration (in seconds)`,
    meta_start          = startdate,
    meta_end            = enddate,
    meta_recorded       = recordeddate,
    meta_finished       = finished,
    meta_feedback       = feedback_tasks
  ) %>%
  separate(meta_resolution, into = c("meta_resolution_width", "meta_resolution_height"), sep = "x") %>%
  mutate(
    meta_resolution_height = as.numeric(meta_resolution_height),
    meta_resolution_width  = as.numeric(meta_resolution_width),
    meta_resolution_ratio  = meta_resolution_width / meta_resolution_height) %>%
  mutate(
    meta_task_duration        = timestamp_tasks - timestamp_consent,
    meta_ace_duration         = timestamp_ace - timestamp_tasks,
    meta_dems_duration        = timestamp_dems - timestamp_ace,

    meta_task_duration_z        = scale(meta_task_duration) %>% as.numeric(),
    meta_ace_duration_z         = scale(meta_ace_duration) %>% as.numeric(),
    meta_dems_duration_z        = scale(meta_dems_duration) %>% as.numeric()
  ) %>%
  select(id, starts_with("meta_"))

## Unpredictability ----

vars03_unp <-
  pilot_data %>%
  select(prolific_pid,starts_with("unp")) %>%
  # Tidy labels
  mutate(across(matches("(unp\\d\\d)"), ~set_label(x = ., label = str_replace_all(get_label(.), "^.*-\\s", "")))) %>%
  # Create composites
  mutate(
    pcunp_mean               = across(matches("unp\\d\\d")) %>% rowMeans(., na.rm = T),
    pcunp_missing            = across(matches("unp\\d\\d")) %>% is.na() %>% rowSums(., na.rm = T),
  ) %>%
  var_labels(
    pcunp_mean                = "Mean score of the Perceived Unpredictability Scale. Higher scores mean more perceived unpredictability prior to age 13.",
  )



## Violence ----

vars04_vio <-
  pilot_data %>%
  select(prolific_pid,matches("violence\\d\\d"), aces_fighting1, aces_fighting2) %>%
  # Recode variables
  mutate(across(matches("violence(01|03)"), ~ 6 - .)) %>%
  # Tidy labels
  mutate(across(matches("violence\\d\\d|aces_fighting\\d"), ~set_label(x = ., label = str_replace_all(get_label(.), "^.*-\\s", "")))) %>%
  mutate(across(matches("violence(01|03)"), ~set_label(x = ., label = str_c(get_label(.), " (recoded)")))) %>%
  # Create composites
  mutate(
    nvs_mean           = across(matches("violence\\d\\d$")) %>% rowMeans(., na.rm = T),
    nvs_missing        = across(matches("violence\\d\\d$")) %>% is.na() %>% rowSums(., na.rm = T),
    fighting_mean      = across(matches("aces_fighting\\d")) %>% rowMeans(., na.rm = T),
    vio_comp           = across(c(nvs_mean, fighting_mean)) %>% scale %>% rowMeans(., na.rm = F)
  ) %>%
  var_labels(
    nvs_mean           = "Mean score of the Neighborhood Violence Scale (NVS). Higher scores mean more neighborhood violence prior to age 13.",
    fighting_mean      = "Mean score of the two fighting exposure items. Higher scores mean more fighting exposure prior to age 13.",
    vio_comp           = "Violence Exposure: Composite measure consisting of the unweighted average of the NVS (nvs_mean) and fighting average (fighting_mean).
                          Both measures were standardized before averaging. Higher scores mean more violence exposure prior to age 13."
  )


## SES ----

vars05_ses <-
  pilot_data %>%
  select(prolific_pid,matches("ses\\d\\d")) %>%
  # Recode Variables
  mutate(across(matches("ses07"), ~ 6 - .)) %>%
  # Tidy labels
  mutate(across(matches("(ses\\d\\d)"), ~set_label(x = ., label = str_replace_all(get_label(.), "^.*-\\s", "")))) %>%
  mutate(across(matches("ses07"), ~set_label(x = ., label = str_c(get_label(.), " (recoded)")))) %>%
  # Create Composites
  mutate(
    ses_subj_comp           = across(matches("ses\\d\\d$")) %>% rowMeans(., na.rm = T),
    ses_subj_missing        = across(matches("ses\\d\\d$")) %>% is.na() %>% rowSums(., na.rm = T)
  ) %>%
  var_labels(
    ses_subj_comp             = "Subjective SES: Consisting of the average of the perceived SES items. Higher scores mean higher perceived SES",
   )


## Demographics ----

vars10_dems <-
  pilot_data %>%
  select(prolific_pid, matches("^dems_"))



## Admin ----

vars12_admin <-
  pilot_data %>%
  select(ends_with("id"))




# Binding-Updating Color --------------------------------------------------

bind_upd_color_practice <-
  pilot_data |>
  select(id, prolific_pid, data_bind_upd_color_practice) |>
  filter(!is.na(data_bind_upd_color_practice)) |>
  mutate(across(c(matches("data_bind_upd_color_practice")), ~map_if(., .p =  ~!is.na(.x), .f = jsonlite::fromJSON))) |>
  mutate(data_bind_upd_color_practice = pmap(list(data_bind_upd_color_practice), function(data_bind_upd_color_practice) {
    data_bind_upd_color_practice |> mutate(recall = as.character(recall))})) |>
  unnest(data_bind_upd_color_practice) |>
  select(id, prolific_pid, rt, stimulus, step_type, variable, nBind, nUpd, task, counterbalance, position, recall, stimuli, accuracy, time_elapsed) |>
  filter(variable == "recall") |>
  mutate(version = ifelse(nUpd == 0, "binding", "updating"))

bind_upd_color_data <-
  pilot_data |>
  select(id, prolific_pid, data_bind_upd_color01, data_bind_upd_color02, data_bind_upd_color03) |>
  filter(!is.na(data_bind_upd_color01), !is.na(data_bind_upd_color02), !is.na(data_bind_upd_color03)) |>
  mutate(across(c(matches("data_bind_upd_color(01|02|03)")), ~map_if(., .p =  ~!is.na(.x), .f = jsonlite::fromJSON))) |>
  mutate(data_bind_upd_color = pmap(list(data_bind_upd_color01, data_bind_upd_color02, data_bind_upd_color03), function(data_bind_upd_color01, data_bind_upd_color02, data_bind_upd_color03) {
    bind_rows(data_bind_upd_color01 |> mutate(recall = as.character(recall)), data_bind_upd_color02 |> mutate(recall = as.character(recall)), data_bind_upd_color03 |> mutate(recall = as.character(recall)))})) |>
  unnest(data_bind_upd_color) |>
  select(id, prolific_pid, rt, stimulus, step_type, variable, nBind, nUpd, task, counterbalance, position, recall, stimuli, accuracy, time_elapsed) |>
  mutate(version = ifelse(nUpd == 0, "binding", "updating"))

bind_upd_color_clean <- bind_upd_color_data |>
  filter(variable == "recall") |>
  mutate(task = str_replace_all(task, "_test\\d\\d", "")) |>
  group_by(prolific_pid, version, task) |>
  summarise(color_acc = sum(accuracy)/n()) |>
  ungroup()

# Binding-Updating Number -------------------------------------------------

bind_upd_number_practice <-
  pilot_data |>
  select(id, prolific_pid, data_bind_upd_number_practice) |>
  filter(!is.na(data_bind_upd_number_practice)) |>
  mutate(across(c(matches("data_bind_upd_number_practice")), ~map_if(., .p =  ~!is.na(.x), .f = jsonlite::fromJSON))) |>
  mutate(data_bind_upd_number_practice = pmap(list(data_bind_upd_number_practice), function(data_bind_upd_number_practice) {
    data_bind_upd_number_practice |> mutate(recall = as.character(recall))})) |>
  unnest(data_bind_upd_number_practice) |>
  select(id, prolific_pid, rt, stimulus, step_type, variable, nBind, nUpd, task, counterbalance, position, recall, stimuli, accuracy, time_elapsed) |>
  mutate(version = ifelse(nUpd == 0, "binding", "updating"))

bind_upd_number_data <-
  pilot_data |>
  select(id, prolific_pid, data_bind_upd_number01, data_bind_upd_number02, data_bind_upd_number03) |>
  filter(!is.na(data_bind_upd_number01), !is.na(data_bind_upd_number02), !is.na(data_bind_upd_number03)) |>
  mutate(across(c(matches("data_bind_upd_number(01|02|03)")), ~map_if(., .p =  ~!is.na(.x), .f = jsonlite::fromJSON))) |>
  mutate(data_bind_upd_number = pmap(list(data_bind_upd_number01, data_bind_upd_number02, data_bind_upd_number03), function(data_bind_upd_number01, data_bind_upd_number02, data_bind_upd_number03) {
    bind_rows(data_bind_upd_number01 |> mutate(recall = as.character(recall)), data_bind_upd_number02 |> mutate(recall = as.character(recall)), data_bind_upd_number03 |> mutate(recall = as.character(recall)))})) |>
  unnest(data_bind_upd_number) |>
  select(id, prolific_pid, rt, stimulus, step_type, variable, nBind, nUpd, task, counterbalance, position, recall, stimuli, accuracy, time_elapsed) |>
  mutate(version = ifelse(nUpd == 0, "binding", "updating"))

bind_upd_number_clean <- bind_upd_number_data |>
  filter(variable == "recall") |>
  mutate(task = str_replace_all(task, "_test\\d\\d", "")) |>
  group_by(prolific_pid, version, task) |>
  summarise(number_acc = sum(accuracy)/n()) |>
  ungroup()

## Ospan ----

ospan_practice <-
  pilot_data %>%
  select(id, prolific_pid, data_ospan_practice) %>%
  filter(!is.na(data_ospan_practice)) |>
  mutate(across(c(starts_with("data_ospan_practice")), ~map_if(., .p =  ~!is.na(.x), .f = jsonlite::fromJSON))) %>%
  unnest(data_ospan_practice) |>
  select(id, prolific_pid, rt, response, task, set_size, variable, block, counterbalance, correct, step_number, recall, stimuli, accuracy, time_elapsed)

ospan_data <-
  pilot_data %>%
  select(id, prolific_pid, data_ospan) %>%
  filter(!is.na(data_ospan)) |>
  mutate(across(c(starts_with("data_ospan")), ~map_if(., .p =  ~!is.na(.x), .f = jsonlite::fromJSON))) %>%
  unnest(data_ospan) |>
  select(id, prolific_pid, rt, response, task, set_size, variable, block, counterbalance, correct, step_number, recall, stimuli, accuracy, time_elapsed)

ospan_data_letter_clean <-
  ospan_data |>
  filter(variable == "recall") |>
  select(id, prolific_pid, block, counterbalance, stimuli, set_size, accuracy) |>
  mutate(acc_prop = accuracy / set_size) |>
  group_by(prolific_pid) |>
  summarise(ospan_cap = mean(acc_prop))


ospan_data_math_clean <-
  ospan_data |>
  filter(variable == "math") |>
  select(id, prolific_pid, rt, block, counterbalance, correct) |>
  group_by(prolific_pid) |>
  summarise(ospan_math_acc = sum(correct) / n())

## Rspan ----

rspan_practice <-
  pilot2_data %>%
  select(id, prolific_pid, data_rspan_practice) %>%
  filter(!is.na(data_rspan_practice)) |>
  mutate(across(c(starts_with("data_rspan_practice")), ~map_if(., .p =  ~!is.na(.x), .f = jsonlite::fromJSON))) %>%
  unnest(data_rspan_practice) |>
  select(id, prolific_pid, rt, response, task, set_size, variable, block, correct, step_number, recall, stimuli, accuracy, time_elapsed)

rspan_data <-
  pilot2_data %>%
  select(id, prolific_pid, data_rspan) %>%
  filter(!is.na(data_rspan)) |>
  mutate(across(c(starts_with("data_rspan")), ~map_if(., .p =  ~!is.na(.x), .f = jsonlite::fromJSON))) %>%
  unnest(data_rspan) |>
  select(id, prolific_pid, rt, response, task, set_size, variable, block, correct, step_number, recall, stimuli, accuracy, time_elapsed)

rspan_data_arrow_clean <-
  rspan_data |>
  filter(variable == "recall") |>
  select(id, prolific_pid, block, stimuli, set_size, accuracy) |>
  mutate(acc_prop = accuracy / set_size) |>
  group_by(prolific_pid) |>
  summarise(rspan_cap = mean(acc_prop))


rspan_data_rotation_clean <-
  rspan_data |>
  filter(variable == "rotation") |>
  select(id, prolific_pid, rt, block, correct) |>
  group_by(prolific_pid) |>
  summarise(rspan_rotation_acc = sum(correct) / n())


# Combine All Data --------------------------------------------------------

pilot_data_clean <-
  left_join(ospan_data_letter_clean, rspan_data_arrow_clean) |>
  left_join(
    bind_upd_color_clean |>
      pivot_wider(names_from = "version", values_from = 'color_acc') |>
      select(-task) |>
      rename(
        binding_color = binding,
        updating_color = updating
      )
  ) |>
  left_join(
    bind_upd_number_clean |>
      pivot_wider(names_from = "version", values_from = 'number_acc') |>
      select(-task) |>
      rename(
        binding_number = binding,
        updating_number = updating
      )
  ) |>
  left_join(vars03_unp |> select(prolific_pid, pcunp_mean)) |>
  left_join(vars04_vio |> select(prolific_pid, vio_comp)) |>
  left_join(vars05_ses |> select(prolific_pid, ses_subj_comp)) |>
  left_join(vars10_dems |> select(prolific_pid, dems_age)) |>
  mutate(id = 1:n()) |>
  select(-prolific_pid)


# Partial correlations, controlling for age
pilot_data_clean |>
  select(-id) |>
  cor(use = "pairwise.complete.obs") |>
  partial.r(x = c(1,2,3,4,5,6,7,8,9), y = c(10))



pilot_data_clean |>
  pivot_longer(c(ends_with('cap'), starts_with("binding"), starts_with("updating")), names_to = 'task', values_to = 'score') |>
  pivot_longer(c(pcunp_mean, vio_comp, ses_subj_comp), names_to = "adversity", values_to = "adv_value") |>
  ggplot(aes(adv_value, score)) +
  geom_point() +
  geom_smooth(method = "lm") +
  facet_grid(task~adversity)


# Timestamps --------------------------------------------------------------

overall_duration <-
  pilot_data |>
  select(prolific_pid, timestamp_tasks) |>
  mutate(timestamp_tasks = timestamp_tasks / 60)


task_duration <- list(bind_upd_color_data, bind_upd_color_practice, bind_upd_number_data, bind_upd_number_practice, ospan_data, ospan_practice) |>
  map_dfr(function(x){
    x |>
      group_by(prolific_pid, task) |>
      summarise(duration = ((max(time_elapsed) - min(time_elapsed))/1000)/60) |>
      ungroup()
  }) |>
  mutate(
    task = case_when(
      str_detect(task, "^bind_upd_color") ~ "bind_upd_color",
      str_detect(task, "^bind_upd_number") ~ "bind_upd_number",
      str_detect(task, "^ospan") ~ "ospan"
    )
  ) |>
  group_by(prolific_pid, task) |>
  summarise(duration = sum(duration)) |>
  group_by(prolific_pid) |>
  mutate(total_duration = sum(duration)) |>
  left_join(overall_duration) |>
  mutate(instruction_read_duration = (timestamp_tasks - total_duration)/3) |>
  bind_rows(
    rspan_data |>
      group_by(prolific_pid, task) |>
      summarise(duration = ((max(time_elapsed) - min(time_elapsed))/1000)/60) |>
      ungroup() |>
      mutate(task = "rspan") |>
      bind_rows(
        rspan_practice |>
          group_by(prolific_pid, task) |>
          summarise(duration = ((max(time_elapsed) - min(time_elapsed))/1000)/60) |>
          ungroup() |>
          mutate(task = "rspan")
      ) |>
      group_by(prolific_pid, task) |>
      summarise(duration = sum(duration))
  ) |>
  arrange(prolific_pid) |>
  mutate(instruction_read_duration = ifelse(is.na(instruction_read_duration), lag(instruction_read_duration, n = 1), instruction_read_duration)) |>
  mutate(duration = duration + instruction_read_duration) |>
  select(-c(total_duration, timestamp_tasks, instruction_read_duration))

# Experiment duration with Ospan, Rspan and Binding-updating with numbers
ospan_rspan_bindupdnum <-
  task_duration |>
  filter(task != "bind_upd_color") |>
  summarise(duration = sum(duration)) |>
  ungroup()

ospan_rspan_bindupdnum |>
  ggplot(aes(duration)) +
  geom_histogram() +
  geom_vline(xintercept = 25)

ospan_rspan_bindupdnum |>
  summarise(median_duration = median(duration))

# Experiment duration with Ospan, Rspan and Binding-updating with colors
ospan_rspan_bindupdcol <-
  task_duration |>
  filter(task != "bind_upd_number") |>
  summarise(duration = sum(duration)) |>
  ungroup() |>
  summarise(median_duration = median(duration))

# Experiment duration with Ospan, Binding-updating with numbers and colors
ospan_color_number <-
  task_duration |>
  filter(task != "rspan") |>
  summarise(duration = sum(duration)) |>
  ungroup() |>
  summarise(median_duration = median(duration))



