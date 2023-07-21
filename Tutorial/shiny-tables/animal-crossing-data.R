library(tidyverse)
library(DT)

#Source- https://clarewest.github.io/blog/post/making-tables-shiny/

#fetch data
items <-
  readr::read_csv(
    'https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-05-05/items.csv'
  ) %>% select(-num_id,-sell_currency,-buy_currency,-games_id,-id_full) %>%
  unique() %>%
  head(100)  

villagers <-
  readr::read_csv(
    'https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-05-05/villagers.csv'
  ) %>% 
  select(-row_n) %>% 
  unique()

#show table
DT::datatable(villagers[,1:8])