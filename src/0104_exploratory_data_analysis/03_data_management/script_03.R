
salary_data <- read.csv("../../../data/0104_exploratory_data_analysis/data_management/sal_data.csv", header = TRUE)
head(salary_data)

bonus_data <- read.csv("../../../data/0104_exploratory_data_analysis/data_management/bonus_data.csv", header = TRUE)
head(bonus_data)


left <- merge(salary_data, bonus_data, by = c("Employee_ID"), all.x = TRUE)
head(left)

right <- merge(salary_data, bonus_data, by = c("Employee_ID"), all.y = TRUE)
head(right)

inner <- merge(salary_data, bonus_data, by = c("Employee_ID"))
head(inner)

outer <- merge(salary_data, bonus_data, by = c("Employee_ID"), all = TRUE)
head(outer)


salary_01 <- read.csv("../../../data/0104_exploratory_data_analysis/data_management/basic_salary - 1.csv", header = TRUE)
salary_02 <- read.csv("../../../data/0104_exploratory_data_analysis/data_management/basic_salary - 2.csv", header = TRUE)
salary_rb <- rbind(salary_01, salary_02)
salary_rb


a1 <- aggregate(ms ~ Location, data = salary_data, FUN = sum)
a1

a2 <- aggregate(ms ~ Location + Grade, data = salary_data, FUN = sum)
a2

a3 <- aggregate(cbind(ba, ms) ~ Location, data = salary_data, FUN = sum)
a3

a4 <- aggregate(cbind(ba, ms) ~ Location + Grade, data = salary_data, FUN = sum)
a4


gb1 <- group_by(salary_data, Location)
ag1 <- summarize(gb1, Total = sum(ms, na.rm = TRUE))
ag1
