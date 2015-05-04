library("shiny")
library("plyr")
library("dplyr")
library("stringr")
library("stringi")
library("readr")
source("utils.R")

categories <- get_data_real() %>% .$category %>% unique %>% sort