#   T Are there any correlated measurements?

#Load libraries
library(here)
library(tidyverse)
library(ggplot2)
library(patchwork)

data <- read.csv2(here("DATA", "clean_data.csv"))

# Ensure correct variable types
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

# Display the plot
Age_vs_treat_plot

# Conclusion: the distribution of age does not appear to depend on treatment.


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

# Conclusion: The distribution of age does not appear to depend on gender.


# ---- Do BMI and age have a linear relationship? ----

ggplot(data,aes(x=age,y=as.numeric(BMI))) +
  geom_point(alpha=0.8, size = 2) + 
  geom_smooth(method="lm", color="steelblue",se=TRUE, size =1.5) + 
  labs(title="BMI and age relationship",
       x=" Age of Patients",
       y= "BMI") + 
  theme_classic()

# Conclusion: it appears to be a linear relationship between BMI and age. 


# ---- Does the preoperative pain change with age of the patients?

sum(data$preOp_pain == 1)
sum(data$preOp_pain != 1)

# Conclusion: Only two patients (out of 249) had preoperative pain -
# there is insufficient data to test for a relationship.


###############################
###   Statistical analysis ####
###############################

# ---- Does the treatment depend on the preoperative smoking? ----

# We are using logistic regression (GLM) because 'treat' is categorical (0 = Sugar, 1 = Licorice).

# Question: Does the treatment depend on the preoperative smoking?
logistic_model <- glm(data$treat ~ data$smoking, family = binomial())
summary(logistic_model)
# Conclusion: # The likelihood of receiving licorice treatment do not depend on Preoperative smoking status.
# P > 0.05


# ---- Does the treatment depend on the gender of the patient? ----




# ---- Does the treatment depend on whether the patient had a preoperative pain? ----




# ---- According to the data, was the treatment with licorice gargle reducing the risk of post operative throat pain? ----
  
# Coughing 30 minutes after PACU arrival
model_pacu30min_throatPain <- glm(pacu30min_throatPain ~ treat, data = data, family = binomial)
summary(model_pacu30min_throatPain)
# Conclusion: Licorice treatment significantly reduces throat pain 30 minutes after surgery.
# P < 0.05

# Coughing 90 minutes after PACU arrival
model_pacu90min_throatPain <- glm(pacu90min_throatPain ~ treat, data = data, family = binomial)
summary(model_pacu90min_throatPain)
# Conclusion: Licorice treatment significantly reduces throat pain 90 minutes after surgery.
# P < 0.05

# Coughing 4 hours after surgery
model_postOp4hour_throatPain <- glm(postOp4hour_throatPain ~ treat, data = data, family = binomial)
summary(model_postOp4hour_throatPain)
# Conclusion: Licorice treatment significantly reduces throat pain 4 hours after surgery.
# P < 0.05

# Coughing on the first postoperative morning
model_pod1am_throatPain <- glm(pod1am_throatPain ~ treat, data = data, family = binomial)
summary(model_pod1am_throatPain)
# Conclusion: Licorice treatment significantly reduces throat pain on the first postoperative morning.
# P < 0.05


