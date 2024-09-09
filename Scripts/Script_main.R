#----Main Script-------------------------####
# Date: 09.09.24
# Author: Eirik Røys,Tuva N Jensen, Kathrine Brun
# Filename: Script_main.R    
# Description:  
#               
#               
# Project: RMED_exam_group8
#-------------------------------------------###

#load libraries
library(tidyverse)
library(readr)
library(here)
library(skimr)

read_tsv("exam_dataset.txt")
#Got ERROR

read_delim(here("DATA","exam_dataset.txt"))
#Chose delim as the others in the group. Downloaded library "here"and revised the code - worked! 

data<-read_delim(here("DATA","exam_dataset.txt"))
data

#exploring data
head(data)
tail(data)
summary(data)
glimpse(data)
skimr::skim(data)


