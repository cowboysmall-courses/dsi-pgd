
salary_data <- read.csv("../../../data/data_management/basic_salary.csv", header = TRUE)
head(salary_data)

s1 <- salary_data[5:10, ]
s1

s2 <- salary_data[c(1, 3, 5), ]
s2

s3 <- salary_data[, 1:4]
head(s3)

s4 <- salary_data[c(1, 5, 8), c(1, 2)]
head(s4)

s5 <- salary_data[c(1, 5, 8), c("First_Name", "Last_Name")]
head(s5)

s6 <- subset(salary_data, Location == "MUMBAI" & ba > 15000)
head(s6)

s7 <- subset(s6, select = c(Location, First_Name, ba))
head(s7)

s8 <- subset(salary_data, Grade == "GR1" & ba > 15000, select = c(First_Name, Grade, Location))
head(s8)

s9 <- subset(salary_data, !(Grade == "GR1") & !(Location == "MUMBAI"))
head(s9)

s10 <- subset(salary_data, Grade != "GR1" & Location != "MUMBAI")
head(s10)


attach(salary_data)

t1 <- salary_data[order(ba), ]
head(t1)

t2 <- salary_data[order(-ba), ]
head(t2)

t3 <- salary_data[order(ba, decreasing = TRUE), ]
head(t3)

t4 <- salary_data[order(Grade), ]
head(t4)

t5 <- salary_data[order(Grade, decreasing = TRUE), ]
head(t5)

t6 <- salary_data[order(Grade, ba), ]
head(t6)

t7 <- salary_data[order(Grade, decreasing = TRUE, ms), ]
head(t7)
