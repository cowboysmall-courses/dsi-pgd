
library(data.table)

salary_data <- read.csv("./data/0104_exploratory_data_analysis/data_management/basic_salary.csv", header = TRUE)


dt1 <- data.table(salary_data)
setkey(dt1, Location)
ag2 <- dt1[, .(Total = sum(ms, na.rm = TRUE)), by = Location]
ag2


salary_data %>% select(First_Name, Grade, Location) %>% filter(Location == "MUMBAI")


n_distinct(salary_data$Grade, na.rm = TRUE)
distinct(salary_data, Grade)


salary_data %>% mutate(Rank = dense_rank(desc(ba))) %>% arrange(Rank) %>% head
