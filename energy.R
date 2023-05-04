library(dplyr)
library(jsonlite)
library(ggplot2)
library(readr)
library(tidyr)
library(lubridate)

usage <- fromJSON("data/agg.json") %>%
  tibble() %>%
  mutate(
    date = parse_datetime(date),
    gas = gas_high + gas_low,
    elec = elec_high + elec_low
  ) %>%
  select(-gas_high, -gas_low, -elec_high, -elec_low) %>%
    filter(
      date > parse_datetime("2022-11-01"),
    date < parse_datetime("2023-05-01"))

usage %>%
  ggplot(aes(x = date, y = gas)) +
  geom_point() + geom_smooth()

usage %>%
  group_by(date = floor_date(date, "day")) %>%
  summarise(gas = sum(gas)) %>%
  ggplot(aes(x = date, y = gas)) +
  geom_line() + geom_smooth()

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
  geom_point() +
  geom_smooth(color = "purple")


daily <- df %>%
  group_by(date = date(date)) %>%
  summarise(temp = mean(temp), gas = sum(gas),
            elec = sum(elec), radiation = sum(radiation))

daily %>% ggplot(aes(x = date, y = temp)) +
  geom_point() +
  geom_smooth() +
  labs(title = "Daily average temperature", x = "day", y = "Temp (Celsius)")

daily %>% ggplot(aes(x = date, y = gas)) +
  geom_point() +
  geom_smooth()

daily %>% ggplot(aes(x = temp, y = gas)) +
  geom_point() +
  geom_smooth()

daily %>% ggplot(aes(x = date, y = elec, color = weekdays(date))) +
  geom_point() +
  geom_smooth(se = FALSE)


model <- lm(
  gas ~ 1 + degrees.below.16, daily
)

daily <- daily %>%
  mutate(
    degrees.below.16 = (abs(16 - temp) + 16 - temp) / 2,
    is.weekend = weekdays(date) %in% c("Sunday", "Saturday")
  )

model <- lm(gas ~ 1 + degrees.below.16 + radiation + is.weekend, daily)

summary(model)
glance(model)

daily %>%
  mutate(pred = predict(model, daily)) %>%
  ggplot(aes(x = temp, y = pred)) +
  geom_line() +
  geom_point(aes(y = gas), color = "red")


daily %>%
  mutate(
    fitted = predict(model, daily),
    residual = gas - fitted
  ) %>%
  pivot_longer(c(gas, fitted, residual)) %>%
  ggplot(aes(x = date, y = value, color = name)) +
  geom_line() + geom_smooth()
