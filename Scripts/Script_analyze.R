#   T Are there any correlated measurements?

#   K Does the preoperative pain change with age of the patients?
#   T Do BMI and age have a linear relationship?

#Load libraries
library(here)
library(tidyverse)

data <- read.csv2(here("DATA", "clean_data.csv"))

#----- Does the age distribution depend on `treat`? --------------------------------------

# Set 'treat' as factor
data$treat <- factor(data$treat)

# Boxplot Age: vs. Treat
boxplot_treat <- ggplot(data, aes(x = treat, y = age, fill = treat)) +
  geom_boxplot(show.legend = FALSE) +
  scale_fill_manual(values = c("0" = "#FBADA7", "1" = "#64B8B8")) +
  scale_y_continuous(breaks = c(10, 20, 30, 40, 50, 60, 70, 80, 90), limits = c(10, 90)) +
  labs(title = "Box-plot") +
  theme_classic() 

# Histogram: Age vs. Treat
histogram_treat <- ggplot(data, aes(y = age, fill = treat)) +
  geom_histogram(binwidth = 10, position = "dodge", color = "black") +
  scale_fill_manual(values = c("0" = "#FBADA7", "1" = "#64B8B8")) +
  scale_y_continuous(breaks = c(10, 20, 30, 40, 50, 60, 70, 80, 90), limits = c(10, 90)) +
  labs(title = "Histogram") +
  theme_classic() 

# Combine plots 
Age_vs_treat_plot <- (boxplot_treat + histogram_treat) + plot_layout(guides = 'collect')
Age_vs_treat_plot

#----- Does the age distribution of the patients depend on their sex (`gender`)?--------

# Boxplot: Age vs. Gender
boxplot_gender <- ggplot(data, aes(x = gender, y = age, fill = gender)) +
  geom_boxplot(show.legend = FALSE) +
  scale_fill_manual(values = c("Female" = "#FBADA7", "Male" = "#64B8B8")) +
  scale_y_continuous(breaks = c(10, 20, 30, 40, 50, 60, 70, 80, 90), limits = c(10, 90)) +
  labs(title = "Box-plot") +
  theme_classic() 

# Histogram: Age vs. Gender
histogram_gender <- ggplot(data, aes(y = age, fill = gender)) +
  geom_histogram(binwidth = 10, position = "dodge", color = "black") +
  scale_fill_manual(values = c("Female" = "#FBADA7", "Male" = "#64B8B8")) +
  scale_y_continuous(breaks = c(0, 10, 20, 30, 40, 50, 60, 70, 80, 90), limits = c(10, 90)) +
  labs(title = "Histogram") +
  theme_classic() 

# Combine plots 
Age_vs_gender_plot <- (boxplot_gender + histogram_gender) + plot_layout(guides = 'collect')
Age_vs_gender_plot
