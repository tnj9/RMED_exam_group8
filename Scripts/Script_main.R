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

# Separate the preOp_ASA_Mallampati into: ASA_score and Mallampati_score
Data <- Data %>%
  separate(preOp_ASA_Mallampati, into = c("ASA_score", "Mallampati_score"), sep = "_")

# View the updated data
colnames(Data)


