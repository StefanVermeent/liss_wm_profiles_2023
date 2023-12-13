
ospan_data03 <- ospan_data |>
  filter(variable == 'recall') |>
  mutate(acc_prop = accuracy / set_size) |>
  group_by(id, set_size) |>
  summarise(wm_cap = mean(acc_prop)) |>
  mutate(set_size = str_c("wm_cap_", set_size))

ospan_data_math03 <-
  ospan_data |>
  filter(variable == "math") |>
  select(id, rt, block, counterbalance, correct) |>
  group_by(id) |>
  summarise(acc_ospan_math = sum(correct) / n())

ospan_data03 |>
  ggplot(aes(wm_cap)) +
  geom_histogram() +
  facet_grid(set_size ~ .)

ospan_data_math03 |>
  ggplot(aes(acc_ospan_math)) +
  geom_density()


bind_upd_number_data03 <- bind_upd_number_data |>
  mutate(type = ifelse(nUpd > 0, "updating", "binding")) |>
  mutate(steps = ifelse(type == "binding", nBind, nUpd)) |>
  mutate(comb = str_c(nBind, nUpd, sep = "_")) |>
  group_by(id, comb) |>
  summarise(num_acc = sum(accuracy)/n()) |>
  ungroup() |>
  pivot_wider(names_from = 'comb', values_from = 'num_acc') |>
  select(-id) |>
  cor() |>
  corrplot::corrplot(method = "number")

bind_upd_color_data03 <- bind_upd_color_data |>
  mutate(type = ifelse(nUpd > 0, "updating", "binding")) |>
  mutate(steps = ifelse(type == "binding", nBind, nUpd)) |>
  mutate(type_steps = str_c(type, steps, sep = "_")) |>
  group_by(id, type_steps) |>
  summarise(num_acc = sum(accuracy)/n()) |>
  ungroup() |>
  pivot_wider(names_from = 'type_steps', values_from = 'num_acc') |>
  left_join(ospan_data02) |>
  select(-id) |>
  cor() |>
  corrplot::corrplot(method = "number")



# Timing ------------------------------------------------------------------

timing_no_outliers <-
  bind_rows(
    study_data |>
      select(id, data_bind_upd_number01, data_bind_upd_number02, data_bind_upd_number03) |>
      filter(!is.na(data_bind_upd_number01), !is.na(data_bind_upd_number02), !is.na(data_bind_upd_number03)) |>
      mutate(across(c(matches("data_bind_upd_number(01|02|03)")), ~map_if(., .p =  ~!is.na(.x), .f = jsonlite::fromJSON))) |>
      mutate(data_bind_upd_number = pmap(list(data_bind_upd_number01, data_bind_upd_number02, data_bind_upd_number03), function(data_bind_upd_number01, data_bind_upd_number02, data_bind_upd_number03) {
        bind_rows(data_bind_upd_number01 |> mutate(recall = as.character(recall)), data_bind_upd_number02 |> mutate(recall = as.character(recall)), data_bind_upd_number03 |> mutate(recall = as.character(recall)))})) |>
      unnest(data_bind_upd_number) |>
      select(id, rt, stimulus, step_type, variable, nBind, nUpd, task, counterbalance, position, recall, stimuli, accuracy, time_elapsed) |>
      group_by(id) |>
      mutate(time_elapsed = time_elapsed / 1000) |>
      mutate(time_elapsed2 = time_elapsed - lag(time_elapsed)) |>
      #  filter(time_elapsed2 < 30) |>
      summarise(
        task_time = sum(time_elapsed2,na.rm = T),
        start_time = min(time_elapsed)
      )|>
      mutate(task = "num"),

    study_data |>
      select(id, data_bind_upd_color01, data_bind_upd_color02, data_bind_upd_color03) |>
      filter(!is.na(data_bind_upd_color01), !is.na(data_bind_upd_color02), !is.na(data_bind_upd_color03)) |>
      mutate(across(c(matches("data_bind_upd_color(01|02|03)")), ~map_if(., .p =  ~!is.na(.x), .f = jsonlite::fromJSON))) |>
      mutate(data_bind_upd_color = pmap(list(data_bind_upd_color01, data_bind_upd_color02, data_bind_upd_color03), function(data_bind_upd_color01, data_bind_upd_color02, data_bind_upd_color03) {
        bind_rows(data_bind_upd_color01 |> mutate(recall = as.character(recall)), data_bind_upd_color02 |> mutate(recall = as.character(recall)), data_bind_upd_color03 |> mutate(recall = as.character(recall)))})) |>
      unnest(data_bind_upd_color) |>
      select(id, rt, stimulus, step_type, variable, nBind, nUpd, task, counterbalance, position, recall, stimuli, accuracy, time_elapsed) |>
      group_by(id) |>
      mutate(time_elapsed = time_elapsed / 1000) |>
      mutate(time_elapsed2 = time_elapsed - lag(time_elapsed)) |>
      # filter(time_elapsed2 < 30) |>
      summarise(
        task_time = sum(time_elapsed2, na.rm = T),
        start_time = min(time_elapsed)
      )|>
      mutate(task = "col"),

    study_data %>%
      select(id, data_ospan) %>%
      filter(!is.na(data_ospan)) |>
      mutate(across(c(starts_with("data_ospan")), ~map_if(., .p =  ~!is.na(.x), .f = jsonlite::fromJSON))) %>%
      unnest(data_ospan) |>
      select(id, rt, response, task, set_size, variable, block, counterbalance, correct, step_number, recall, stimuli, accuracy, time_elapsed) |>
      group_by(id) |>
      mutate(time_elapsed = time_elapsed / 1000) |>
      mutate(time_elapsed2 = time_elapsed - lag(time_elapsed)) |>
      # filter(time_elapsed2 < 30) |>
      summarise(
        task_time = sum(time_elapsed2, na.rm = T),
        start_time = min(time_elapsed)
      ) |>
      mutate(task = "ospan")
  ) |>
  arrange(id, start_time) |>
  group_by(id) |>
  mutate(
    practice_time = case_when(
      start_time == min(start_time) ~ start_time,
      start_time == max(start_time) ~ start_time - (lag(task_time) + lag(start_time)) + task_time,
      TRUE ~ start_time - (lag(task_time) + lag(start_time)) + task_time,
    )
  ) |>
  mutate(
    full_task_time = (task_time + practice_time)/60
  )




timing_no_outliers |>
  summarise(full_task_time = sum(full_task_time)) |>
  ggplot(aes(full_task_time/60)) +
  geom_histogram() +
  geom_vline(xintercept = 25)

timing_no_outliers |>
  summarise(full_task_time = sum(full_task_time)) |> ungroup() |> summarise(median = median(full_task_time/60))
