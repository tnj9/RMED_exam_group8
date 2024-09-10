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
library(lubridate)
library(dplyr)

# Import data
data <- read_delim(here("DATA", "exam_dataset.txt"))
joindata <- read_delim(here("DATA", "exam_joindata.txt"))

#explore data
head(data)
tail(data)
summary(data)

# Changing variable name "1gender" since it starts with a number
data <- data %>% 
  rename(gender = '1gender')

# Changing variable name "BMI kg/m2" to BMI
data <- data %>%
  rename(BMI = `BMI kg/m2`)

#checking if two variables (gender) are duplicates
data$preOp_gender==data$gender

#confirmed that preOp_gender== gender
#deleting preOp_gender since it is a duplicate
data$preOp_gender = NULL

# Separate the preOp_ASA_Mallampati into: ASA_score and Mallampati_score
data <- data %>%
  separate(preOp_ASA_Mallampati, into = c("ASA_score", "Mallampati_score"), sep = "_")

# View the updated data
colnames(data)

# Combine year and month into a single column as a date format.
data$year_month <- dmy(paste("01", data$month, data$year, sep = "-"))

# Remove year and month columns
data$year <- NULL
data$month <- NULL

#changing the column order and renaming 3 variables
data<- data %>%
  rename(age=preOp_age) %>%
  rename (smoking=preOp_smoking) %>%
  rename(date=year_month) %>%
  select(patient_id,BMI,age,smoking,gender, date, everything())

# Looking for duplicate rows
data %>%
  group_by_all() %>%
  filter(n()>1) %>%
  ungroup()

# remove duplicate rows
data <- data %>%
  distinct(.keep_all = T)

#check that the duplicate has been removed
data %>%
  filter(patient_id==48)

#arranging the patient ID
data <- data %>%
  arrange(patient_id)

#joining dataset inton main dataset
combined_data<- data %>%
  full_join(joindata, join_by("patient_id"))

