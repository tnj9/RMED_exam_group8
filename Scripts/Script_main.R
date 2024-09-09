#----Main Script-------------------------####
# Date: 09.09.24
# Author: Eirik Røys,Tuva N Jensen, Kathrine Brun
# Filename: Script_main.R    
# Description:  
#               
#               
# Project: RMED_exam_group8
#-------------------------------------------###

# Load libraries
library(tidyverse)
library(tidyr)
library(here)

# Import data
data <- read_delim(here("DATA", "exam_dataset.txt"))

