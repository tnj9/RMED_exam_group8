#   T Are there any correlated measurements?
#   E Does the age distribution depend on `treat`?
#   E Does the age distribution of the patients depend on their sex (`gender`)?
#   K Does the preoperative pain change with age of the patients?
#   T Do BMI and age have a linear relationship?

#Load libraries
library(here)
library(tidyverse)

data <- read.csv2(here("DATA", "clean_data.csv"))
