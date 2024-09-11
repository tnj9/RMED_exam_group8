#   - Are there any correlated measurements?
#   - Does the age distribution depend on `treat`?
#   - Does the age distribution of the patients depend on their sex (`gender`)?
#   - Does the preoperative pain change with age of the patients?
#   - Do BMI and age have a linear relationship?

data <- read.csv2(here("DATA", "clean_data.csv"))
