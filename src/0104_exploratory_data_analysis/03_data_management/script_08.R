
library(sqldf)


salary_data <- read.csv.sql("./data/0104_exploratory_data_analysis/data_management/basic_salary.csv", sql = "select * from file", header = TRUE)
salary_data

sorted_sd1 <- sqldf("select * from salary_data order by ba desc")
sorted_sd1

sorted_sd2 <- sqldf("select * from salary_data order by First_Name desc, ba")
sorted_sd2

rename_sd1 <- sqldf("select First_Name, Grade, Location, ba as Basic_Salary from salary_data")
rename_sd1

subset_sd1 <- sqldf("select First_Name, ba from salary_data")
subset_sd1

subset_sd2 <- sqldf("select * from salary_data where ba > 15000")
subset_sd2

subset_sd3 <- sqldf("select First_Name, ba from salary_data where Location = 'MUMBAI' and Grade = 'GR1'")
subset_sd3

subset_sd4 <- sqldf("select First_Name, Last_Name, Grade, Location, ba, ms, sum(ba + ms) as ts from salary_data group by First_Name")
subset_sd4

subset_sd5 <- sqldf("select First_Name, Last_Name, Grade, Location, ba, ms, ba + ms as ts from salary_data order by First_Name")
subset_sd5


sqldf("select * from subset_sd5 where ts > (select median(ts) from subset_sd5)")
sqldf("select First_Name, Grade, ts from subset_sd5 order by ts desc limit 3")

sqldf("select * from salary_data where ba > 14000 and First_Name like 'r%'")
sqldf("select * from salary_data where ba between 16000 and 17000")
sqldf("select * from salary_data where ba between 17000 and 18000")

sqldf("select Location, sum(ba) as sum_of_ba from salary_data group by Location")
sqldf("select Location, count(*) as no_of_employees from salary_data group by Location")


aggregate_sd1 <- sqldf("select Location, sum(ts) as total_salary from subset_sd5 group by Location")
sqldf("select Location, total_salary, (total_salary * 100 / (select sum(total_salary) from aggregate_sd1)) as percent_share from aggregate_sd1")
