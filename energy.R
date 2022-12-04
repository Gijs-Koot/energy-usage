library(readxl)
library(dplyr)

fn <- "data/verbruik_01-06-2022_01-12-2022_40857840_2.xlsx"

energy <- read_xlsx(fn, skip = 1) %>%
  rename(
    date = Datum,
    low_el = `Meterstand laagtarief (El 1)`,
    high_el = `Meterstand hoogtarief (El 2)`,
    read = Meterstand
  ) %>% select(date, low_el, high_el, read) %>% mutate(el = low_el + high_el)

energy

library(rstan)

model <- stan_model("models/usage.stan")

sampling(model, data = list(
  N = 4, read = c(23, 24, 26, 38)
))

library(jsonlite)

usage <- fromJSON("data/agg.json")

library(readr)

usage %>%
  mutate(date = parse_date(date)) %>%
  ggplot(aes(x = date, y = gas_high)) +
  geom_point()
