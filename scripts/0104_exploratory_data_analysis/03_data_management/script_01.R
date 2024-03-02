
salary_data <- read.csv("./data/0104_exploratory_data_analysis/03_data_management/basic_salary.csv", header = TRUE)

dim(salary_data)
names(salary_data)

str(salary_data)
levels(salary_data$Grade)
object.size(salary_data)

is.na(salary_data$ms)
sum(is.na(salary_data$ms))

head(salary_data)
tail(salary_data)

summary(salary_data)

names(salary_data)[names(salary_data) == "ba"] <- "Basic Allowance"
names(salary_data)

names(salary_data)[names(salary_data) == "Basic Allowance"] <- "Basic_Allowance"
names(salary_data)

salary_data$Category <- ifelse(salary_data$Basic_Allowance < 14000, "Low", ifelse(salary_data$Basic_Allowance < 19000, "Medium", "High"))
head(salary_data)
class(salary_data$Category)

salary_data$Level <- cut(salary_data$Basic_Allowance, breaks = c(0, 14000, 19000, Inf), labels = c("Low", "Medium", "High"))
head(salary_data)
class(salary_data$Level)
