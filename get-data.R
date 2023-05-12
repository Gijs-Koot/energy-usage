library(httr)
library(stringr)
library(readr)

get_data <- function(start_date, end_date) {

  str_glue(
    "https://api-digital.enecogroup.com/",
    "dxpweb/nl/eneco/customers/40857840/accounts/2/usages"
  )

  query <- list(
    aggregation = "Day",
    interval = "Hour",
    start = format(start_date, "%Y-%m-%d"),
    end = format(end_date, "%Y-%m-%d"),
    addBudget = "false",
    addWeather = "false",
    extrapolate = "false"
  )

  apikey <- read_file("./apikey")
  authorization <- read_file("./authorization")

  headers <- c(
    "Accept" = "application/json",
    "apikey" = apikey,
    "authorization" = authorization
  )

  response <- GET(url, query = query, add_headers(headers))

  if (response$status == 200) {
    return(content(response, as = "text"))
  } else if (response$status == 401) {
    stop("Not authorized!")
  }

  stop(str_glue("Unable to process, code {response$status}"))

}

split_date_range <- function (start_date, end_date)
{

  # generate a list of pairs at most a month apart

  ranges <- c()

  while(current)

}
