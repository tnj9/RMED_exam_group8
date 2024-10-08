#---- Tidy Script-----------------------------------
# Script_creation_date: 09.09.24
# last_modified_date: 10.09.24
# Author: Eirik Røys,Tuva N Jensen, Kathrine Brun
# Filename: Script_main.R
# Description:
#
#
# Project: RMED_exam_group8

#--------------------------------------------------

# Load libraries
library(tidyverse)
library(tidyr)
library(here)
library(lubridate)
library(dplyr)
library(skimr)

# Import data
data <- read_delim(here("DATA", "exam_dataset.txt"))
joindata <- read_delim(here("DATA", "exam_joindata.txt"))

# Join the two datasets
combined_data <- data %>%
  full_join(joindata, join_by("patient_id"), relationship = "many-to-many")

# Identify rows with any NA values
na_rows <- combined_data %>%
  filter(if_any(everything(), is.na))
print(na_rows)

# Only two patients have NA values - appear to missing postOp values
# Choosing to remove NA
combined_data <- combined_data %>%
  drop_na()

#############################
# Specifying variable types #
#############################

# Task: "Make necessary changes in variable types"
# Check against the specified variables in codebook

# check variable type
str(combined_data)

# change variable type to what is in the codebook
combined_data <- combined_data %>%
  mutate(preOp_ASA_Mallampati = as.factor(preOp_ASA_Mallampati),
         preOp_smoking = as.factor(preOp_smoking),
         preOp_pain = as.factor(preOp_pain),
         treat = as.factor(treat),
         pacu30min_cough = as.factor(pacu30min_cough),
         pacu90min_cough = as.factor(pacu90min_cough),
         postOp4hour_cough = as.factor(postOp4hour_cough),
         pod1am_cough = as.factor(pod1am_cough),
         extubation_cough = as.factor(extubation_cough))


# Explore the data
str(combined_data)
head(combined_data)
tail(combined_data)
summary(combined_data)

###########################
# Rearranging the dataset #
###########################

combined_data <- combined_data %>%
  # Renaming columns
  rename(gender = "1gender") %>%
  rename(BMI = `BMI kg/m2`) %>%
  rename(age = preOp_age) %>%
  rename(smoking = preOp_smoking) %>%
  # Combine month and year into a single column 'date' and convert to day-month-year format
  mutate(date = paste("01", month, year, sep = "-")) %>%
  mutate(date = dmy(date)) %>%
  # Split column 'preOp_ASA_Mallampati' into 'ASA_score' and 'Mallampati score'
  separate(preOp_ASA_Mallampati, into = c("ASA_score", "Mallampati_score"), sep = "_") %>%
  # Sort rows based on patient IDs
  arrange(patient_id) %>%
  #adding new coloumns to the dataset
  mutate(
    postop_cough_change_extubation = as.numeric(extubation_cough) - as.numeric(pod1am_cough),  
    postop_throatpain_change = as.numeric(pacu30min_throatPain) - as.numeric(pod1am_throatPain)) %>% 
  #cut BMI into quartiles (4 equal parts)
  mutate(BMI_quartile=cut(BMI,breaks = quantile (BMI, probs = seq(0, 1, by = 0.25), na.rm = TRUE), 
                          include.lowest = TRUE, 
                          labels = c("Q1", "Q2", "Q3", "Q4"))) %>% 
  
  # added column coding gender to "Male" and "Female" instead of "0"/"1"
  mutate(gender=factor(gender,levels=c(0,1),labels=c("Male", "Female"))) %>% 
  
  # Reordering columns and selecting which to keep
  select(patient_id, BMI, age, smoking, gender, date, everything(), -month, -year)


###########################
# Checking for duplicates #
###########################

# ---- Checking for Duplicate columns ------------------------------
# Two columns are referencing 'gender' - 
# checking if they are duplicate
unique(combined_data$preOp_gender == combined_data$gender)

# Confirmed that preOp_gender == gender
# deleting column preOp_gender since it is a duplicate 
combined_data$preOp_gender <- NULL

#---- Checking for duplicate rows -----------------------------
# Check for duplicate rows and remove them
combined_data <- combined_data %>%
  group_by_all() %>%
  filter(n() == 1) %>%
  ungroup()

# remove duplicate rows
combined_data <- combined_data %>%
  distinct(.keep_all = TRUE)

# comfirm that the duplicate has been removed
combined_data %>%
  filter(patient_id==48)

#arranging the patient ID
combined_data <- combined_data %>%
  arrange(patient_id)


###########################
#     Stratifying data    #
###########################

#---- Stratifying data -----------------------------

# Task: 
#Stratify your data by a categorical column and report min, max, mean and sd of a numeric column.
combined_data %>% 
  filter(gender == "Female") %>% 
  summarise(min(age), max(age), mean(age), sd(age))

# Task:
# Stratify your data by a categorical column and report min, max, mean and sd of a numeric column for a defined set of observations - use pipe!
combined_data %>% 
  filter(BMI < 25 ) %>% 
  filter(gender == "Female") %>% 
  filter(age > 50) %>% 
  filter(extubation_cough = TRUE) %>% 
  summarise(min(age), max(age), mean(age), sd(age))

# Create a table using two categorical columns (gender and BMI_quartile)
combined_data %>%
  count(gender, BMI_quartile) %>%
  arrange(gender, BMI_quartile)

write_csv2(combined_data, file = here("DATA", "clean_data.csv"))


