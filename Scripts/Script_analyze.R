#   T Are there any correlated measurements?
#   K Does the preoperative pain change with age of the patients?
#   T Do BMI and age have a linear relationship?

#Load libraries
library(here)
library(tidyverse)
library(ggplot2)
library(patchwork)

data <- read.csv2(here("DATA", "clean_data.csv"))

# change variable types
data <- data %>%
  mutate(ASA_score = as.factor(ASA_score),
         Mallampati_score = as.factor(Mallampati_score),
         smoking = as.factor(smoking),
         preOp_pain = as.factor(preOp_pain),
         treat = as.factor(treat),
         pacu30min_throatPain = as.factor(pacu30min_throatPain),
         pacu90min_throatPain = as.factor(pacu90min_throatPain),
         postOp4hour_throatPain = as.factor(postOp4hour_throatPain),
         pod1am_throatPain = as.factor(pod1am_throatPain),
         pacu30min_cough = as.factor(pacu30min_cough),
         pacu90min_cough = as.factor(pacu90min_cough),
         postOp4hour_cough = as.factor(postOp4hour_cough),
         pod1am_cough = as.factor(pod1am_cough),
         extubation_cough = as.factor(extubation_cough))


#----- Does the age distribution depend on `treat`? --------------------------------------

# Set 'treat' as factor
data$treat <- factor(data$treat)

# Boxplot Age vs. Treat 
boxplot_treat <- ggplot(data, aes(x = treat, y = age, fill = treat)) +
  geom_boxplot() +
  scale_fill_manual(values = c("0" = "#E1E1E1", "1" = "#649CB8")) +
  scale_y_continuous(breaks = c(0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100), limits = c(0, 100)) +
  labs(title = "Box-plot") +
  theme_classic() +
  coord_flip()  

# Histogram Age vs. Treat 
histogram_treat <- ggplot(data, aes(y = age, fill = treat)) +
  geom_histogram(binwidth = 10, position = "dodge", color = "black") +
  scale_fill_manual(values = c("0" = "#E1E1E1", "1" = "#649CB8")) +
  scale_y_continuous(breaks = c(0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100), limits = c(0, 100)) +
  labs(title = "Histogram") +
  theme_classic() +
  coord_flip()  

# Combine plots 
Age_vs_treat_plot <- (boxplot_treat / histogram_treat) + 
  plot_annotation(
    title = "Age vs. Treatment",
    theme = theme(plot.title = element_text(hjust = 0.5, face = "bold"))
  )
Age_vs_treat_plot

#----- Does the age distribution of the patients depend on their sex (`gender`)?--------

# Boxplot: Age vs. Gender
boxplot_gender <- ggplot(data, aes(x = gender, y = age, fill = gender)) +
  geom_boxplot() +
  scale_fill_manual(values = c("Female" = "#FBADA7", "Male" = "#64B8B8")) +
  scale_y_continuous(breaks = c(0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100), limits = c(0, 100)) +
  labs(title = "Box-plot") +
  theme_classic() +
  coord_flip() 

# Histogram: Age vs. Gender
histogram_gender <- ggplot(data, aes(y = age, fill = gender)) +
  geom_histogram(binwidth = 10, position = "dodge", color = "black") +
  scale_fill_manual(values = c("Female" = "#FBADA7", "Male" = "#64B8B8")) +
  scale_y_continuous(breaks = c(0 ,10, 20, 30, 40, 50, 60, 70, 80, 90, 100), limits = c(0, 100)) +
  labs(title = "Histogram") +
  theme_classic() +
  coord_flip() 

# Combine plots 
Age_vs_gender_plot <- (boxplot_gender / histogram_gender)  + 
  plot_annotation(
    title = "Age vs. Gender",
    theme = theme(plot.title = element_text(hjust = 0.5, face = "bold"))
  )

# Display the plot
Age_vs_gender_plot

# ---- Do BMI and age have a linear relationship? ----

ggplot(data,aes(x=age,y=as.numeric(BMI))) +
  geom_point(alpha=0.5) + 
  geom_smooth(method="lm", color="blue",se=TRUE) + 
  labs(title="BMI and age relationship",
       x=" Age of Patients",
       y= "BMI") + 
  theme_classic()

# it appears to be a linear relationship between BMI and age. 

# ---- Does the treatment depend on the preoperative smoking? ----

#I choose linear regression analysis to decide if there is a dependent relationship between treatment and smoking status

#changing variables to factors
smoking<- as_factor(data$smoking)
treat<- as_factor(data$treat)

#performing the logistic model
logistic_model <- glm(treat ~ smoking, family = binomial())

# Check the summary of the model
summary(logistic_model)

#Conclusion: P- values indicates no dependent relationship

