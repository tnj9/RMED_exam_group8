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

#---- Remaining tasks -----------------------------
# ✔ Remove unnecessary columns from your dataframe: `year, month` 
# ✔ Read and join the additional dataset to your main dataset.
# - Make necessary changes in variable types
# - Create a set of new columns:
# - a column showing whether severity of cough changed from "extubation" to "pod1am"
# - a column showing whether severity of throat pain changed from "pacu30min" to "pod1am"
# - a column cutting BMI into quartiles (4 equal parts); HINT: cut() function
# - a column coding gender to "Male" and "Female" instead of "0"/"1"
# ✔  Set the order of columns as: `patient_id, BMI, age, smoking, gender` and other columns
# ✔ Arrange patient_id column of your dataset in order of increasing number or alphabetically.
# - Connect above steps with pipe.
# ✔ Explore your data.
# - Explore and comment on the missing variables.
# - Stratify your data by a categorical column and report min, max, mean and sd of a numeric column.
# - Stratify your data by a categorical column and report min, max, mean and sd of a numeric column for a defined set of observations - use pipe!
# - Only for persons with BMI <25
# - Only for females
# - Only for persons older than 50 years of age
# - Only for persons who had experienced coughing at extubation
# - Use two categorical columns in your dataset to create a table (hint: ?count)
#----------------------------------------------

# Load libraries
library(tidyverse)
library(tidyr)
library(here)
library(lubridate)
library(dplyr)

# Import data
data <- read_delim(here("DATA", "exam_dataset.txt"))
joindata <- read_delim(here("DATA", "exam_joindata.txt"))

# Join the two datasets
data <- data %>%
  full_join(joindata, join_by("patient_id"), relationship = "many-to-many")

#############################
# Specifying variable types #
#############################

# Task: "Make necessary changes in variable types"
# Check against the specified variables in codebook
# data <- data %>%
#   mutate(
#     patient_id = as.numeric(patient_id),            
#     month = as.numeric(month),                     
#    ...

# Explore the data
str(data)
head(data)
tail(data)
summary(data)

###########################
# Rearranging the dataset #
###########################

data <- data %>%
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
  # Reordering columns and selecting which to keep
  select(patient_id, BMI, age, smoking, gender, date, everything(), -month, -year)

###########################
# Checking for duplicates #
###########################

# ---- Checking for Duplicate columns -----------------------------
# Two columns are referencing 'gender' - 
# checking if they are duplicate
unique(data$preOp_gender == data$gender)

# Confirmed that preOp_gender == gender
# deleting column preOp_gender since it is a duplicate 
data$preOp_gender <- NULL

#---- Checking for duplicate rows -----------------------------
data %>%
  group_by_all() %>%
  filter(n() > 1) %>%
  ungroup()

# remove duplicate rows
data <- data %>%
  distinct(.keep_all = TRUE)

# comfirm that the duplicate has been removed
data %>%
  filter(patient_id == 48)
data


