#----Main Script-------------------------####
# Date: 09.09.24
# Author: Eirik Røys,Tuva N Jensen, Kathrine Brun
# Filename: Script_main.R    
# Description:  
#               
#               
# Project: RMED_exam_group8
#-------------------------------------------###

#Load libraries
library(tidyverse)
library(here)

#Load data from .txt file
Data <- read_delim(here("DATA","exam_dataset.txt"))

#Inspect data
head(Data)


Duplicate
           