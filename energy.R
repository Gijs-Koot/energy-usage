library(dplyr)
library(jsonlite)
library(ggplot2)
library(readr)

usage <- fromJSON("data/agg.json") %>% tibble %>%
  mutate(
    date = parse_datetime(date),
    gas = gas_high + gas_low,
    elec = elec_high + elec_low
  ) %>%
  select(-gas_high, -gas_low, -elec_high, -elec_low)

usage %>%
  ggplot(aes(x = date, y = gas)) +
  geom_point()

usage %>%
  ggplot(aes(x = date, y = elec)) +
  geom_point()

library(lubridate)

usage %>%
  group_by(date = floor_date(date, "day")) %>%
  summarise(gas = sum(gas)) %>%
  ggplot(aes(x = date, y = gas)) +
  geom_line()

usage %>%
  group_by(hour = hour(date)) %>%
  summarise(gas = sum(gas)) %>%
  ggplot(aes(x = hour, y = gas)) +
  geom_line()

weather <- readr::read_csv(
  "./data/uurgeg_260_2021-2030.zip",
  skip = 30,
  col_select = c(
    date = YYYYMMDD,
    hour = HH,
    temp = "T",
    radiation = Q
  ),
  col_types = cols(YYYYMMDD = col_date(format = "%Y%m%d"))
  ) %>%
  mutate(
    date = parse_datetime(paste(date, sprintf("%02d", hour - 1))),
    temp = temp * .1
  ) %>%
  select(-hour)

df <- usage %>%
  left_join(weather, by = c("date")) %>%
  filter(date < parse_datetime("2023-02-27"))

df %>% ggplot(aes(x = log(gas + 1), y = temp, color = radiation)) +
  geom_point() + geom_smooth(color = "purple")
