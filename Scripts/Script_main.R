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

#explore data
head(data)
tail(data)
summary(data)


# Changing variable name "1gender" since it starts with a number
data <- data %>% 
  rename(gender = '1gender')

#checking if two variables (gender) are duplicates
data$preOp_gender==data$gender

#confirmed that preOp_gender== gender
#deleting preOp_gender since it is a duplicate
data$preOp_gender = NULL

# Separate the preOp_ASA_Mallampati into: ASA_score and Mallampati_score
Data <- Data %>%
  separate(preOp_ASA_Mallampati, into = c("ASA_score", "Mallampati_score"), sep = "_")

# View the updated data
colnames(Data)
