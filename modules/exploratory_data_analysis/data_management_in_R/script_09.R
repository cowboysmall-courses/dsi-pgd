
library(sqldf)


salary_data <- read.csv.sql("../../../data/data_management/sal_data.csv", sql = "select * from file", header = TRUE)
bonus_data <- read.csv.sql("../../../data/data_management/bonus_data.csv", sql = "select * from file", header = TRUE)

sqldf("select salary_data.*, bonus_data.Bonus from salary_data left join bonus_data on salary_data.Employee_ID = bonus_data.Employee_ID")
sqldf("select salary_data.*, bonus_data.Bonus from salary_data inner join bonus_data on salary_data.Employee_ID = bonus_data.Employee_ID")


