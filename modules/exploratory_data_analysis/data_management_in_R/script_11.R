
library(tidyr)

emp_id <- c(101, 102, 103, 104)
location <- c("Mumbai", "Delhi", "Delhi", "Mumbai")
address <- c("4 Churchgate", "12 Rohini", "8 Pitampura", "21 Andheri")
date <- c("2016-10-09", "2010-11-01", "2009-09-23", "1990-02-30")


emp_data <- data.frame(emp_id, location, address, date)
emp_data

sep_data1 <- separate(emp_data, date, into = c("Year", "Month", "Day"))
class(sep_data1$Year)

sep_data2 <- separate(emp_data, date, into = c("Year", "Month", "Day"), convert = TRUE)
class(sep_data2$Year)

sep_data3 <- separate(emp_data, address, into = c("Sector", "Area"), sep = " ", convert = TRUE)
sep_data3

unite(sep_data1, date, c(Year, Month, Day), sep = "-")

