#### Setup ####
library(tidyverse)
library(rvest)

urls <-
  c(
    "https://www.rba.gov.au/monetary-policy/rba-board-minutes/2025/2025-05-20.html",
    "https://www.rba.gov.au/monetary-policy/rba-board-minutes/2025/2025-04-01.html",
    "https://www.rba.gov.au/monetary-policy/rba-board-minutes/2025/2025-02-18.html",
    "https://www.rba.gov.au/monetary-policy/rba-board-minutes/2024/2024-12-10.html",
    "https://www.rba.gov.au/monetary-policy/rba-board-minutes/2024/2024-11-05.html",
    "https://www.rba.gov.au/monetary-policy/rba-board-minutes/2024/2024-09-24.html",
    "https://www.rba.gov.au/monetary-policy/rba-board-minutes/2024/2024-08-06.html",
    "https://www.rba.gov.au/monetary-policy/rba-board-minutes/2024/2024-06-18.html",
    "https://www.rba.gov.au/monetary-policy/rba-board-minutes/2024/2024-05-07.html",
    "https://www.rba.gov.au/monetary-policy/rba-board-minutes/2024/2024-03-19.html",
    "https://www.rba.gov.au/monetary-policy/rba-board-minutes/2024/2024-02-06.html"
  )

#### Get the files ####
# Get the date part
dest_files <-
  urls |>
  basename()

# Go through each file and get the content part
walk2(urls, dest_files, ~ {
  read_html(.x) |>
    html_element("#content") |>
    as.character() |>
    write_lines(.y)
  Sys.sleep(5)
})


#### Put them together into a dataset ####
html_files <- 
  c("2024-02-06.html", "2024-03-19.html", "2024-05-07.html", "2024-06-18.html", "2024-08-06.html", "2024-09-24.html", "2024-11-05.html", "2024-12-10.html", "2025-02-18.html", "2025-04-01.html", "2025-05-20.html")

minutes_tbl <-
  tibble(
    date = html_files |>
      str_remove("\\.html$") |>
      as.Date(),
    text = html_files |>
      map_chr( ~ read_html(.x) |>
                 html_text2() |>
                 str_squish())
  ) |>
  arrange(date)

#### Save ####
setwd('data')
write.csv(minutes_tbl, "minutes_tbl.csv",  fileEncoding = "UTF-8", row.names = FALSE)