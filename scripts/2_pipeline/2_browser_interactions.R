library(tidyverse)
library(jsonlite)


edit_function <- function(data){
  new_data <- data %>%
    mutate(recall = as.character(recall)) %>%
    mutate(recall = replace(recall, recall=="NULL", NA)) %>%
    mutate(recall = replace(recall, recall=="list()", NA)) %>%
    return(new_data)
}

# 1. Parse task data ---------------------------------------------------------

task_data <- read_delim("data/liss_data/wm/L_Cognitieve_Vaardigheden_v2_JSON.csv", delim = ";") |>
  rename(
    tasks_start                   = JSON1,
    data_ospan_practice           = JSON2,
    data_ospan                    = JSON3,
    data_rspan_practice           = JSON4,
    data_rspan                    = JSON5,
    data_bind_upd_number_practice = JSON6,
    data_bind_upd_number01        = JSON7,
    data_bind_upd_number02        = JSON8,
    data_bind_upd_number03        = JSON9,
    tasks_browser                 = JSON10
  )

## 1.1 Rotation Span Task ----

rspan_data <- task_data |>
  mutate(n = 1:n())

rspan_data <- rspan_data[nchar(rspan_data$data_rspan)!=1,]

rspan_data01 <- rspan_data |>
  filter(n < 62) |>
  select(nomem_encr, data_rspan) |>
  drop_na(data_rspan) %>%
  mutate(across(c(matches("data_rspan")), ~str_replace_all(., "\\{\\\"trials\\\"\\:", ""))) |>
  mutate(across(c(matches("data_rspan")), ~str_replace_all(., "\\}$", ""))) |>
  mutate(data_rspan = map(data_rspan, jsonlite::fromJSON)) |>
  unnest(data_rspan)

rspan_data02 <- rspan_data |>
  filter(n > 61) |>
  select(nomem_encr, data_rspan) |>
  drop_na(data_rspan) %>%
  filter(str_length(data_rspan) > 10) |>
  # Fix a number of invalid JSON strings
  mutate(across(c(matches("data_rspan")), ~str_replace_all(., "^\\\"", ""))) |>
  mutate(across(c(matches("data_rspan")), ~str_replace_all(., "\\\\", ""))) |>
  mutate(across(c(matches("data_rspan")), ~str_replace_all(., "\\\"\\}", "}"))) |>
  mutate(across(c(matches("data_rspan")), ~str_replace_all(., "\\\"<div\\\">", "\\\"<div>"))) |>
  mutate(data_rspan = map(data_rspan, jsonlite::fromJSON)) |>
  unnest(data_rspan)

rspan_data <- bind_rows(rspan_data01, rspan_data02)
rspan_data <- rspan_data |>
  # Generate unique trial ids
  pull(nomem_encr) |>
  unique() |>
  map_dfr(function(x){
    data <- rspan_data |>
      filter(nomem_encr == x)

    trial_lenghts <- data |>
      drop_na(set_size) |>
      pull(set_size)

    trial_lengths <- (trial_lenghts * 2)
    trial_ids <- rep(1:12, times = trial_lengths)

    data |>
      filter(variable != "recall") |>
      mutate(trial_id = trial_ids)
  })


## 1.2 Operation Span Task

ospan_data <- task_data |>
  mutate(n = 1:n())

ospan_data <- ospan_data[nchar(ospan_data$data_ospan)!=1,]

ospan_data01 <- ospan_data |>
  filter(n < 62) |>
  select(nomem_encr, data_ospan) |>
  drop_na(data_ospan) %>%
  mutate(across(c(matches("data_ospan")), ~str_replace_all(., "\\{\\\"trials\\\"\\:", ""))) |>
  mutate(across(c(matches("data_ospan")), ~str_replace_all(., "\\}$", ""))) |>
  mutate(data_ospan = map(data_ospan, jsonlite::fromJSON)) |>
  unnest(data_ospan)

ospan_data02 <- ospan_data |>
  filter(n > 61) |>
  select(nomem_encr, data_ospan) |>
  drop_na(data_ospan) %>%
  filter(str_length(data_ospan) > 10) |>
  mutate(across(c(matches("data_ospan")), ~str_replace_all(., "^\\\"", ""))) |>
  #mutate(across(c(matches("data_ospan")), ~str_c('{"trials":', ., "}"))) |>
  mutate(across(c(matches("data_ospan")), ~str_replace_all(., "\\\\", ""))) |>
  mutate(across(c(matches("data_ospan")), ~str_replace_all(., "\\\"\\}", "}"))) |>
  mutate(across(c(matches("data_ospan")), ~str_replace_all(., "\\\"<div\\\">", "\\\"<div>"))) |>
  mutate(across(c(matches("data_ospan")), ~str_replace_all(., "<div style=\\\"", "<div style=\\\\\""))) |>
  mutate(across(c(matches("data_ospan")), ~str_replace_all(., "\\\">", "\\\\\">"))) |>
  mutate(across(c(matches("data_ospan")), ~str_replace_all(., "\\\"$", ""))) |>
  mutate(data_ospan = map(data_ospan, jsonlite::fromJSON)) |>
  unnest(data_ospan)

ospan_data <- bind_rows(ospan_data01, ospan_data02)
ospan_data <- ospan_data |>
  # Generate unique trial ids
  pull(nomem_encr) |>
  unique() |>
  map_dfr(function(x){
    data <- ospan_data |>
      filter(nomem_encr == x)

    trial_lenghts <- data |>
      drop_na(set_size) |>
      pull(set_size)

    trial_lengths <- (trial_lenghts * 2)
    trial_ids <- rep(1:9, times = trial_lengths)

    data |>
      filter(variable != "recall") |>
      mutate(trial_id = trial_ids)
  })



## 2.3 Binding-updating task ----

bind_upd_data <- task_data |>
  mutate(n = 1:n())

bind_upd_data <- bind_upd_data[nchar(bind_upd_data$data_bind_upd_number01)!=1,]
bind_upd_data <- bind_upd_data[nchar(bind_upd_data$data_bind_upd_number02)!=1,]
bind_upd_data <- bind_upd_data[nchar(bind_upd_data$data_bind_upd_number03)!=1,]

bind_upd_data01 <- bind_upd_data |>
  filter(n < 62) |>
  select(nomem_encr, data_bind_upd_number01, data_bind_upd_number02, data_bind_upd_number03) |>
  drop_na(data_bind_upd_number01, data_bind_upd_number02, data_bind_upd_number03) %>%
  filter(!is.na(data_bind_upd_number01), !is.na(data_bind_upd_number02), !is.na(data_bind_upd_number03)) |>
  mutate(across(c(matches("data_bind_upd_number(01|02|03)")), ~str_replace_all(., "\\{\\\"trials\\\"\\:", ""))) |>
  mutate(across(c(matches("data_bind_upd_number(01|02|03)")), ~str_replace_all(., "\\}$", ""))) |>
  mutate(across(c(matches("data_bind_upd_number(01|02|03)")), ~map_if(., .p =  ~!is.na(.x), .f = jsonlite::fromJSON)))

bind_upd_data01$data_bind_upd_number01 <- lapply(bind_upd_data01$data_bind_upd_number01, edit_function)
bind_upd_data01$data_bind_upd_number02 <- lapply(bind_upd_data01$data_bind_upd_number02, edit_function)
bind_upd_data01$data_bind_upd_number03 <- lapply(bind_upd_data01$data_bind_upd_number03, edit_function)

bind_upd_data01 <- bind_upd_data01 |>
  mutate(data_bind_upd = pmap(list(data_bind_upd_number01, data_bind_upd_number02, data_bind_upd_number03), function(data_bind_upd_number01, data_bind_upd_number02, data_bind_upd_number03) {
    bind_rows(data_bind_upd_number01, data_bind_upd_number02, data_bind_upd_number03)})) |>
  unnest(data_bind_upd) |>
  select(-starts_with("data"))



bind_upd_data02 <- bind_upd_data |>
  filter(n > 61) |>
  select(nomem_encr, data_bind_upd_number01, data_bind_upd_number02, data_bind_upd_number03) %>%
  mutate(across(matches("data_bind_upd_number(01|02|03)"), ~ifelse(str_length(.) < 10, NA, .))) |>
  drop_na(data_bind_upd_number01, data_bind_upd_number02, data_bind_upd_number03) %>%
  filter(!is.na(data_bind_upd_number01), !is.na(data_bind_upd_number02), !is.na(data_bind_upd_number03)) |>
  mutate(across(c(matches("data_bind_upd_number(01|02|03)")), ~str_replace_all(., "^\\\"", ""))) |>
  #mutate(across(c(matches("data_ospan")), ~str_c('{"trials":', ., "}"))) |>
  mutate(across(c(matches("data_bind_upd_number(01|02|03)")), ~str_replace_all(., "\\\\", ""))) |>
  mutate(across(c(matches("data_bind_upd_number(01|02|03)")), ~str_replace_all(., "\\\"$", ""))) |>
  mutate(across(c(matches("data_bind_upd_number(01|02|03)")), ~map_if(., .p =  ~!is.na(.x), .f = jsonlite::fromJSON)))

bind_upd_data02$data_bind_upd_number01 <- lapply(bind_upd_data02$data_bind_upd_number01, edit_function)
bind_upd_data02$data_bind_upd_number02 <- lapply(bind_upd_data02$data_bind_upd_number02, edit_function)
bind_upd_data02$data_bind_upd_number03 <- lapply(bind_upd_data02$data_bind_upd_number03, edit_function)

bind_upd_data02 <- bind_upd_data02 |>
  mutate(data_bind_upd = pmap(list(data_bind_upd_number01, data_bind_upd_number02, data_bind_upd_number03), function(data_bind_upd_number01, data_bind_upd_number02, data_bind_upd_number03) {
    bind_rows(data_bind_upd_number01, data_bind_upd_number02, data_bind_upd_number03)})) |>
  unnest(data_bind_upd) |>
  select(-starts_with("data"))

bind_upd_data <- bind_rows(bind_upd_data01, bind_upd_data02)
bind_upd_data <- bind_upd_data |>
  # Generate unique trial ids
  pull(nomem_encr) |>
  unique() |>
  map_dfr(function(x){
    data <- bind_upd_data |>
      filter(nomem_encr == x)

    trial_lengths <- data |>
      select(nomem_encr, nBind, nUpd, task) |>
      distinct() |>
      mutate(nTot = nBind + nUpd)

    trial_lengths <- (trial_lengths |> pull(nTot) * 2)

    trial_ids <- rep(1:18, times = trial_lengths)

    data |>
      filter(is.na(variable)) |>
      mutate(trial_id = trial_ids)
  })


# 3. Browser interactions -------------------------------------------------

browser_int <- task_data |>
  select(nomem_encr, tasks_browser) |>
  drop_na(tasks_browser) %>%
  mutate(tasks_browser = str_replace_all(tasks_browser, pattern = "\\\\\"", "\"")) |>
  mutate(tasks_browser = str_replace_all(tasks_browser, pattern = "^\"", "")) |>
  mutate(tasks_browser = str_replace_all(tasks_browser, pattern = "\\\"$", ""))

browser_int <- browser_int[nchar(browser_int$tasks_browser)!=1,]

timestamps <- c('ospan_data', 'rspan_data') |>
  map(function(x){
    eval(as.symbol(x)) %>%
      select(nomem_encr, task, time_elapsed, set_size)
  })



browser_int <-
  inner_join(
    browser_int |>
      mutate(tasks_browser = map(tasks_browser, jsonlite::fromJSON)) %>%
      unnest(tasks_browser) |>
      select(nomem_encr, event, blur_time = time) |>
      filter(event == 'blur'),
    reduce(
      c("ospan_data", "rspan_data", "bind_upd_data") %>% map(function(x) {
        eval(as.symbol(x)) %>%
          select(nomem_encr, task, time_elapsed, trial_id) %>%
          group_by(nomem_encr, task, trial_id) %>%
          summarise(
            "time_start" := min(time_elapsed),
            "time_end"   := max(time_elapsed)
          )
        }
      ),
      bind_rows),
    relationship = "many-to-many") |>
  mutate(
    event_during_task = ifelse(blur_time > time_start & blur_time < time_end, TRUE, FALSE)
  ) |>
  select(nomem_encr, task, event_during_task) |>
  mutate(
    task = ifelse(str_detect(task, "bind_upd"), "bind_upd", task)
  ) |>
  select(-task) |>
  distinct()

write_csv(browser_int, "data/liss_data/browser_interactions.csv")


