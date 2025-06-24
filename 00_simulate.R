#### Setup ####
library(tidyverse)
set.seed(853)

#### Simulate dataset ####
vocab <- c("the", "in", "to", "of", "that", "and", "had", "a", "was", "policy", "members", "on", "for", "be", "global", "rate", "inflation", "growth", "been", "at", "it", "by", "cash", "forecast", "than", "expected", "would", "this", "were", "more", "target", "meeting", "as", "monetary", "tariffs", "some", "also", "noted", "there", "developments", "domestic", "uncertainty", "australian", "reduction", "markets", "but", "could", "which", "economy", "their", "market", "they", "little", "lower", "trade", "range", "these", "an", "us", "time", "outlook", "not", "basis", "around", "or", "prices", "with", "might", "scenarios", "financial", "international", "impact", "higher", "still", "remained", "from", "baseline", "current", "have", "other", "consumption", "household", "labour", "per", "cent", "previous", "early", "expectations", "over", "including", "likely", "since", "demand", "data", "activity", "risks", "case", "conditions", "levels", "response", "australia")

analysis_dataset <-
  tibble(date = seq.Date(
    from = as.Date("2025-06-01"),
    to   = as.Date("2010-06-01"),
    by   = "-1 month"
  )) |>
  mutate(date = date + (3 - lubridate::wday(date)) %% 7) |>
  arrange(desc(date)) |>
  mutate(minutes = map_chr(seq_len(n()), ~ str_c(
    sample(vocab, 1000, replace = TRUE), collapse = " "
  )))

#### Save data ####
write_csv(analysis_dataset, "simulated_dataset.csv")