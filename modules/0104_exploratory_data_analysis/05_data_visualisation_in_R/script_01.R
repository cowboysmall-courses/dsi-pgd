
telecom <- read.csv("../../../data/0104_exploratory_data_analysis/data_visualisation/telecom.csv", header = TRUE)
telecom$Age_Group <- factor(telecom$Age_Group, levels = c("18-30", "30-45", ">45"))
head(telecom)


telecom1 <- aggregate(Calls ~ Age_Group, data = telecom, FUN = sum)
telecom1

barplot(
  telecom1$Calls, 
  main = "Total Calls ~ Age Group", 
  names.arg = telecom1$Age_Group, 
  xlab = "Age Group", 
  ylab = "Total Calls", 
  col = "darkorange"
)

telecom2 <- aggregate(Calls ~ Age_Group, data = telecom, FUN = mean)
telecom2

barplot(
  telecom2$Calls, 
  main = "Mean Calls ~ Age Group", 
  names.arg = telecom2$Age_Group, 
  xlab = "Age Group", 
  ylab = "Mean Calls", 
  col = "darkorange"
)

table1 <- table(telecom$Age_Group)
table1

barplot(
  table1, 
  main = "Horizontal Bar Chart", 
  xlab = "No. of Customers", 
  ylab = "Age Group", 
  col = "darkorange",
  horiz = TRUE
)

table2 <- table(telecom$Gender, telecom$Age_Group)
table2

barplot(
  table2, 
  main = "Stacked Bar Chart", 
  xlab = "Age Group", 
  ylab = "No. of Customers", 
  col = c("cadetblue", "orange"),
  legend = rownames(table2)
)

table3 <- prop.table(table2, 2)
table3

barplot(
  table3, 
  main = "Percentage Bar Chart", 
  xlab = "Age Group", 
  ylab = "Customer %", 
  col = c("cadetblue", "orange"),
  legend = rownames(table3)
)

telecom4 <- aggregate(Calls ~ Gender + Age_Group, data = telecom, FUN = sum)
telecom4

telecom5 <- xtabs(Calls ~ Gender + Age_Group, telecom4)
telecom5

barplot(
  telecom5, 
  main = "Multiple Bar Chart", 
  xlab = "Age Group", 
  ylab = "Total Calls", 
  col = c("cadetblue", "orange"),
  legend = rownames(table3),
  beside = TRUE
)

telecom6 <- aggregate(Calls ~ Age_Group, data = telecom, FUN = sum)
telecom6$pct <- round((telecom6$Calls / sum(telecom6$Calls)) * 100)
telecom6

pie(
  telecom6$Calls, 
  main = "Pie Chart With Percentage",
  labels = paste(telecom6$Age_Group, " (", telecom6$pct, "%)"),
  col = c("darkcyan", "orange", "yellowgreen")
)



