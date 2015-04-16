library("shiny")
library("plyr")
library("dplyr")
library("stringr")
library("stringi")
# devtools::install_github("jennybc/googlesheets")
library("googlesheets")

source("utils.R")

data <- get_data_sample()
data <- register_ss("KanguroProds") %>% get_via_csv()
data <- data %>% 
  mutate(name = to_title(name),
         category = to_title(category))
