library("shiny")
library("plyr")
library("dplyr")
library("stringr")
library("stringi")
library("readr")
library("d3wordcloud")
library("tm")
library("htmlwidgets")
source("utils.R")

categories <- get_data_real() %>% .$category %>% unique %>% sort