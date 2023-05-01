# Setup -------------------------------------------------------------------
## Libraries ----
library(tidyverse)
library(lmerTest)
library(parameters)
library(interactions)
library(future)
library(faux)
library(furrr)


## Set seed for reproducibility----
set.seed(9472958)

## Set ggplot2 theme ----
theme_set(
  theme_light() +
    theme(
      text = element_text(size = 12),
      axis.line = element_line(),
      title = element_text(size = 12),
      panel.border = element_blank(),
      panel.background = element_rect(color = NA),
      panel.grid = element_blank(),
      plot.background = element_rect(color = NA),
      plot.title = element_text(hjust = .5),
      plot.subtitle = element_text(hjust = .5),
      strip.background = element_rect(color = NA, fill = NA),
      strip.text = element_text(color = "black", hjust = 0.5, size = 10)
    )
)


# Simulation settings -----------------------------------------------------

n = c(700, 750, 800)
sim_adv_effects <- .1
sim_adv_effect_mean <- -.2
sigma <- c(.5,.6,.7,.8,.9,1)
task_cor <- c(.5, .6, .7)

## custom function for looking at betas
rnorm_fixed <- function(n, mean, sd, fixed_beta) {
  # force the mean and sd to be exactly as specified
  my_betas <- as.vector(mean + sd * scale(rnorm(n)))

  # difference between the mean of effects and the fixed beta differnence
  my_beta_diff <- my_betas[1] - (mean + fixed_beta)

  # Make the first value of the effects the fixed beta
  my_betas[1] <- mean + fixed_beta

  # randomly pick an effect to absorb the new value to keep the fixed mean
  random_replace <- sample(2:10, 1)

  # add the difference back to the vector
  my_betas[random_replace] <- my_betas[random_replace] + my_beta_diff

  # return the betas
  my_betas
}

## plan a multicore session
plan(multisession, workers = 5)

## Simulate the effect of adversity using the betas above
sim_mods <-
  furrr::future_map_dfr(1:500, function(a){
    furrr::future_map_dfr(n, function(b){
      furrr::future_map_dfr(sigma, function(c){
        furrr::future_map_dfr(task_cor, function(d) {
          # Generate simulation effects
          effect_sizes <- rnorm_fixed(n = 9, mean =  sim_adv_effect_mean, sd = .05, fixed_beta = .1)

          # Simulate data with effects
          data <- rnorm_multi(n = b,
                              mu = rep(0,9),
                              sd = rep(1,9),
                              r = d,
                              varnames = c("upd1", "upd2", "upd3", "span1", "span2", "span3", "main1", "main2", "main3"),
                              empirical = F) |>
            as_tibble() |>
            mutate(across(everything(), ~scale(.) |> as.numeric())) |>
            mutate(
              id        = 1:n(),
              adversity = rnorm(n()) |> scale() |> as.numeric(),
              upd1      = upd1  + adversity*effect_sizes[1]  + rnorm(n(), sd = c),
              upd2      = upd2  + adversity*effect_sizes[2]  + rnorm(n(), sd = c),
              upd3      = upd3  + adversity*effect_sizes[3]  + rnorm(n(), sd = c),
              span1     = span1 + adversity*effect_sizes[4]  + rnorm(n(), sd = c),
              span2     = span2 + adversity*effect_sizes[5]  + rnorm(n(), sd = c),
              span3     = span3 + adversity*effect_sizes[6]  + rnorm(n(), sd = c),
              main1     = main1 + adversity*effect_sizes[7]  + rnorm(n(), sd = c),
              main2     = main2 + adversity*effect_sizes[8]  + rnorm(n(), sd = c),
              main3     = main3 + adversity*effect_sizes[9]  + rnorm(n(), sd = c),
            ) |>
            pivot_longer(c(-id, -adversity), names_to = c("subtest"), values_to = c("score")) |>
            mutate(
              subtest1 = faux::contr_code_sum(subtest)
            )

          # Run model
          lmer(score ~ adversity*subtest1 + (1|id), data = data) |>
            broom.mixed::tidy() |>
            mutate(
              sim         = a,
              n           = b,
              sigma       = c,
              subtask_r   = d,
              mean_effect = sim_adv_effect_mean,
              beta_diff   = 0.1
            )

        },.options = furrr_options(seed = TRUE))
      },.options = furrr_options(seed = TRUE))
    },.options = furrr_options(seed = TRUE))
  },.options = furrr_options(seed = TRUE))

## collate results
sim_mod_df <-
  bind_rows(sim_mods)


## go pack to sequential
plan(sequential)

# Plot the power curves ---------------------------------------------------
power_curve <-
  sim_mod_df |>
  mutate(
    term = str_replace_all(term, "subtest1.(.*_mean)-intercept","\\1")
  ) |>
  select(term, n, subtask_r, estimate, p.value, mean_effect, sigma, beta_diff) |>
  filter(str_detect(term, "adversity:subtest1\\.upd1")) |>
  mutate(across(where(is.numeric), ~round(.x, 4))) |>
  group_by(term, sigma, subtask_r, n, mean_effect, beta_diff) |>
  summarize(power = sum((p.value<.05)/500), estimate = mean(estimate)) |>
  ggplot(aes(x =  sigma, y =  power)) +
  geom_line(aes(group = n)) +
  geom_point() +
  facet_grid(subtask_r~n) +
  geom_hline(aes(yintercept = .90), linetype = "dashed") +
  scale_x_continuous(breaks = seq(0.5, 1, by = .1) |> round(2)) +
  scale_y_continuous(breaks = seq(0.5, 1, by = .05)) +
  labs(
    title = "Power for Interaction (Beta = 0.1)",
    subtitle = "Rows plot power for different sample sizes",
    x = "\nResidual variance",
    y = "Power\n"
  )

# Save power analysis objects ---------------------------------------------
save(
  sim_mod_df,
  power_curve,
  file = "analysis_objects/power.Rdata"
)
