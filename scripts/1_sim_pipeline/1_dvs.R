# 1. Libraries ----------------------------------------------------------------

library(tidyverse)


# 2. Stage 1: Simulate data for computational reproducibility ----------------

dvs_sim <-
  tibble(
    nomem_encr = 1:800 |> as.character(),
    rspan_cap     = rnorm(800, 0.75, 0.15) %>% ifelse(. > 1, 1, .),
    rspan_sec_acc = rnorm(800, 0.88, 0.11) %>% ifelse(. > 1, 1, .),
    rspan_sec_rt  = rnorm(800, 0.88, 0.11) %>% ifelse(. < 0, 300, .),
    ospan_cap     = rnorm(800, 0.75, 0.15) %>% ifelse(. > 1, 1, .),
    ospan_sec_acc = rnorm(800, 0.88, 0.11) %>% ifelse(. > 1, 1, .),
    ospan_sec_rt  = rnorm(800, 1500, 476)  %>% ifelse(. < 0, 300, .),
    bu_bind_acc   = rnorm(800, 0.88, 0.11) %>% ifelse(. > 1, 1, .),
    bu_upd_acc    = rnorm(800, 0.70, 0.11) %>% ifelse(. > 1, 1, .),
    brows_int     = sample(c(0, 1), size = 800, replace = T, prob = c(0.95, 0.05))
  ) |>
  sjlabelled::var_labels(
    rspan_cap     = "Rspan Capacity. Average number of arrows recalled in the correct serial position on each trial (Proportion).",
    rspan_sec_acc = "Rspan Accuracy on secondary rotation task. Average accuracy across trials (Proportion)",
    rspan_sec_rt  = "Rspan RT on secondary rotation task. Average RT across trials (RT in miliseconds)",
    ospan_cap     = "Ospan Capacity. Average number of letters recalled in the correct serial position on each trial. (Proportion)",
    ospan_sec_acc = "Ospan Accuracy on secondary math task. Average accuracy across trials (Proportion)",
    ospan_sec_rt  = "Ospan RT on secondary math task. Average RT across trials (RT in miliseconds)",
    bu_bind_acc   = "Binding-Updating, Binding accuracy. Average amount of numbers recalled in the correct location across trials that did not involve an updating component (Proportion)",
    bu_upd_acc    = "Binding-Updating, Updating accuracy. Average amount of numbers recalled in the correct location across trials that involved an updating component (Proportion)",
    brows_int     = "Tracks whether or not the participant left the experiment browser tab and interacted with other tabs DURING one of the tasks."
  ) |>
  sjlabelled::val_labels(
    brows_int     = c("No" = 0, "Yes" = 1),
  )

create_codebook(dvs_sim)

save(dvs_sim, file = "data/dvs_sim.RData")
