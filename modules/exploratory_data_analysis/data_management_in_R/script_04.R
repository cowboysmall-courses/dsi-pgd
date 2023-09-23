
library(dplyr)

salary_data <- read.csv("../../../data/data_management/sal_data.csv", header = TRUE)
head(salary_data)

bonus_data <- read.csv("../../../data/data_management/bonus_data.csv", header = TRUE)
head(bonus_data)


inner_join(salary_data, bonus_data, by = "Employee_ID")
left_join(salary_data, bonus_data, by = "Employee_ID")
right_join(salary_data, bonus_data, by = "Employee_ID")
full_join(salary_data, bonus_data, by = "Employee_ID")
semi_join(salary_data, bonus_data, by = "Employee_ID")
anti_join(salary_data, bonus_data, by = "Employee_ID")
