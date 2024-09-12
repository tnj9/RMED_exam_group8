# Load libraries
library(here)
library(tidyverse)
library(ggplot2)
library(patchwork)
library(ggcorrplot)
library(dplyr)
library(styler)

data <- read.csv2(here("DATA", "clean_data.csv"))

#----- Are there any correlated measurements? --------------------------------------------

# Making correlation matrix
corr <- data %>%
  select(-gender, -date, -BMI_quartile, -patient_id) %>% # Removing values that are not numeric and patient_id
  cor()

print(corr)

# Making matrix of correlation p-values
p.mat <- data %>%
  select(-gender, -date, -BMI_quartile, -patient_id) %>% # Removing values that are not numeric and patient_id
  cor_pmat()

print(p.mat)

# Making plot
corr_plot <- ggcorrplot(corr,
  method = "circle",
  hc.order = T,
  title = "Correlation plot",
  outline.color = "white",
  p.mat = p.mat
)

corr_plot
# Conclusion: several measurements are correlated: e.g., pacu30min_swallowPain and pacu30min_throatpain

# Save plot
ggsave(here("Figures", "corr_plot.png"), plot = corr_plot, width = 15, height = 10)

#---- Ensure correct variable types ------------------------------------------------------
data <- data %>%
  mutate(
    ASA_score = as.factor(ASA_score),
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
    extubation_cough = as.factor(extubation_cough)
  )

#----- Does the age distribution depend on `treat`? --------------------------------------

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

ggsave(here("Figures", "Age_vs_Treat_Plot.png"), plot = Age_vs_treat_plot)

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
  scale_y_continuous(breaks = c(0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100), limits = c(0, 100)) +
  labs(title = "Histogram") +
  theme_classic() +
  coord_flip()

# Combine plots
Age_vs_gender_plot <- (boxplot_gender / histogram_gender) +
  plot_annotation(
    title = "Age vs. Gender",
    theme = theme(plot.title = element_text(hjust = 0.5, face = "bold"))
  )

# Display the plot
Age_vs_gender_plot

# Conclusion: The distribution of age does not appear to depend on gender.

# Save plot in folder Figures
ggsave(here("Figures", "Age_vs_gender_plot.png"), plot = Age_vs_gender_plot)

# ---- Do BMI and age have a linear relationship? -----------------------------------------

Regresssion_plot <- ggplot(data, aes(x = age, y = as.numeric(BMI))) +
  geom_point(alpha = 0.8, size = 2) +
  geom_smooth(method = "lm", color = "steelblue", se = TRUE, size = 2, fill = "lightblue") +
  labs(
    title = "BMI and age relationship",
    x = " Age of Patients",
    y = "BMI"
  ) +
  theme_classic()

# Display the plot
Regresssion_plot

# Conclusion: it appears to be a linear relationship between BMI and age.

# Save plot in folder Figures
ggsave(here("Figures", "Regresssion_plot.png"), plot = Regresssion_plot)

# ---- Does the preoperative pain change with age of the patients? -------------------

sum(data$preOp_pain == 1)
sum(data$preOp_pain != 1)

# Conclusion: Only two patients (out of 249) had preoperative pain -
# there is insufficient data to test for a relationship.

################################
###   Statistical analysis  ####
################################

# In the statistical analyis we are using logistic regression (GLM) because 'treat' is categorical (0 = Sugar, 1 = Licorice).

# ---- Q1: Does the treatment depend on the preoperative smoking? ------------
logistic_model <- glm(data$treat ~ data$smoking, family = binomial())
summary(logistic_model)
# Conclusion: # The likelihood of receiving licorice treatment do not depend on Preoperative smoking status (P > 0.05).

# ---- Q2: Does the treatment depend on the gender of the patient? ------------
logistic_model_treatment_gender <- glm(data$treat ~ data$gender, family = binomial())
summary(logistic_model_treatment_gender)
# Conclusion: # The likelihood of receiving licorice treatment does not depend on gender (P > 0.05).

# ---- Q3: Does the treatment depend on whether the patient had a preoperative pain? -------
logistic_model_treatment_preoppain <- glm(data$treat ~ data$preOp_pain, family = binomial())
summary(logistic_model_treatment_preoppain)
# Conclusion: # The likelihood of receiving licorice treatment does not depend on preoperative pain (P > 0.05).

# ---- Q4: According to the data, was the treatment with licorice gargle reducing the risk of post operative throat pain? ------

# Fit the logistic regression between 'treat' and throat pain reported at four time intervals after surgery (30min, 90min, 4hours and 1am)
model_pacu30min_throatPain <- glm(pacu30min_throatPain ~ treat, data = data, family = binomial)
model_pacu90min_throatPain <- glm(pacu90min_throatPain ~ treat, data = data, family = binomial)
model_postOp4hour_throatPain <- glm(postOp4hour_throatPain ~ treat, data = data, family = binomial)
model_pod1am_throatPain <- glm(pod1am_throatPain ~ treat, data = data, family = binomial)

# The summary from all four model show that licorice treatment significantly reduces throat pain after surgery at all time points (P < 0.05)
summary(model_pacu30min_throatPain)
summary(model_pacu90min_throatPain)
summary(model_postOp4hour_throatPain)
summary(model_pod1am_throatPain)

# To estimate the effect size we can also calculate the odds ratio from the logistic regression models (from the log-odds)
odds_ratio_pacu30min <- (exp(coef(model_pacu30min_throatPain)["treat1"]) - 1) * 100
odds_ratio_pacu90min <- (exp(coef(model_pacu90min_throatPain)["treat1"]) - 1) * 100
odds_ratio_postOp4hours <- (exp(coef(model_postOp4hour_throatPain)["treat1"]) - 1) * 100
odds_ratio_pod1am <- (exp(coef(model_pod1am_throatPain)["treat1"]) - 1) * 100

# Print the odds
odds_ratio_pacu30min
odds_ratio_pacu90min
odds_ratio_postOp4hours
odds_ratio_pod1am

# Conclusion: From the odds ratios we see that licorice treatment reduces the risk of throat pain by
# 65.4% after 30 minutes,
# 80.6% after 90 minutes,
# 70.3% after 4 hours and
# 66.8% on the first postoperative morning
