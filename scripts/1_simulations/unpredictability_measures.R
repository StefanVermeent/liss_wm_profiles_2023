
# Libraries ---------------------------------------------------------------

library(tidyverse)


# Functions ---------------------------------------------------------------

# Compute rowwise SDs
RowSD <- function(x) {
  sqrt(rowSums((x - rowMeans(x))^2)/(dim(x)[2] - 1))
}

# Create waves of data in line with within-subject specified Means and SDs
create_wave <- function(data, names) {
  data <- map(names, function(x) {
    data <- data |>
      rowwise() |>
      mutate("{x}" := rnorm(1, mean, sd)) |>
      ungroup()
  }) |>
    reduce(left_join)
}


# Simulate data -----------------------------------------------------------

set.seed(3554)

data <-
  faux::rnorm_multi(n = 1000, vars = 2, mu = 0, sd = 1, r = -0.7, varnames = c("mean", "sd")) |>
  as_tibble() |>
  mutate(
    id = 1:1000,
    sd = (sd+abs(min(sd)))/2,
    mean = (mean+abs(min(mean)))
    ) %>% # make sure SDs are positive
  create_wave(data = ., names = str_c("wave", 1:100)) |> # Simulate 100 waves
  mutate(mat_dep = across(starts_with('wave')) %>% rowMeans) |> # Compute within-person mean level material deprivation
  mutate(unpred  = across(starts_with("wave")) %>% RowSD) |>  # compute within-person SD of material deprivation over time
  pivot_longer(starts_with('wave'), names_to = "wave", values_to = "value") |>
  group_by(id) |>
  mutate(prop_change = (value - lag(value, n = 1)) / lag(value, n = 1)) |>
  summarise(
    mat_dep = mean(value),
    unpred = sd(value),
    prop_change = mean(abs(prop_change), na.rm = T) # Unpredictability option 1: Average proportion of change
  ) |>
  mutate(sd_corrected = unpred / mat_dep) # Unpredictability option 2: within-subject SD divided by within-subject mean


ggplot(data, aes(prop_change, sd_corrected)) +
  geom_point()

ggplot(data, aes(prop_change, unpred)) +
  geom_point()

