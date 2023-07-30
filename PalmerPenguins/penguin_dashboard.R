library(tidyverse)
library(palmerpenguins)
library(shiny)
library(DT)

penguins <- palmerpenguins::penguins

#total missing values in each column
#View(rbind(colSums(is.na(penguins))))

#remove rows with missing values in sex column
penguins <- penguins[-which(is.na(penguins$sex)),]

#glimpse(penguins)

##--AGGREGATE DATA PER ISLAND----------

#total species per island
species_count <- penguins %>% 
  group_by(island, species) %>% 
  summarise(total = n())

#pivot the data wider
species_count_wide <- species_count %>% 
  pivot_wider(names_from = 'species',
              values_from = 'total',
              #substitue NA with 0
              values_fill = 0)

gender_count <- penguins %>% 
  group_by(island,sex) %>% 
  summarise(total = n())

#gender count to wide form
gender_count_wide <- gender_count %>% 
  pivot_wider(names_from = 'sex',
              values_from = 'total')

#combining gender count & species count dataframes
island_summary <- left_join(species_count_wide, gender_count_wide, by = 'island')

##AGGREGATE DATA PER SPECIES----

island_count <- penguins %>% 
  group_by(species, island) %>% 
  summarise(total = n())

#species per island count in wide format
