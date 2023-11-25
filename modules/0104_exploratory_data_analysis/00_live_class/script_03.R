
library(e1071)
library(dplyr)



# 1
bank_data <- read.csv("../../../data/0104_exploratory_data_analysis/live_class/Bank_Churn.csv", header = TRUE)

dim(bank_data)
str(bank_data)
summary(bank_data)

head(bank_data, 5)
tail(bank_data, 5)



# 2
f1 <- function(x) {
  c(
    count = length(x),
    skew = skewness(x, na.rm = TRUE, type = 2)
  )
}
aggregate(CreditScore ~ Exited, data = bank_data, FUN = f1)

boxplot(
  CreditScore ~ Exited, 
  data = bank_data,
  ylab = "Credit Score", 
  col = "cadetblue3"
)



# 3
f2 <- function(x) {
  c(
    count = length(x),
    mean = mean(x, na.rm = TRUE, type = 2)
  )
}
aggregate(CreditScore ~ Exited, data = bank_data, FUN = f2)

bank_data %>% 
  group_by(Exited) %>% 
  summarise(count = length(CreditScore), mean = mean(CreditScore)) %>% 
  as.data.frame()



# 4
Exited_Geo1 <- table(bank_data$Geography, bank_data$Exited)
colnames(Exited_Geo1) <- c("Stayed", "Exited")
Exited_Geo1

Exited_Geo2 <- round(prop.table(Exited_Geo1, 1) * 100, 2)
Exited_Geo2



# 5
round(cor(bank_data$CreditScore, bank_data$EstimatedSalary), 4)



# 6
bank_data$CreditScore_Cat <- ifelse(bank_data$CreditScore >= 650, 1, 0)
head(bank_data, 5)



# 7
Exited_Cat1 <- table(bank_data$CreditScore_Cat, bank_data$Exited)
colnames(Exited_Cat1) <- c("Stayed", "Exited")
Exited_Cat1

Exited_Cat2 <- round(prop.table(Exited_Cat1, 1) * 100, 2)
Exited_Cat2



# 8 
Top_300 <- head(bank_data[order(bank_data$CreditScore, decreasing = TRUE), ], 300)
table(Top_300$Geography)



# 9
bank_data %>% 
  group_by(Geography, Gender) %>% 
  summarise(n = length(CreditScore), mean = mean(CreditScore), median = median(CreditScore)) %>% 
  as.data.frame()



# 10
Geo_Dist <- bank_data %>%
  group_by(Geography) %>%
  summarise(Products = sum(NumOfProducts))

# Geo_Dist <- bank_data %>%
#   group_by(Geography) %>%
#   summarise(Products = sum(NumOfProducts), Count = length(NumOfProducts), Average = sum(NumOfProducts) / length(NumOfProducts))
# Geo_Dist

barplot(
  Geo_Dist$Products,
  names.arg = Geo_Dist$Geography,
  ylim = c(0, max(Geo_Dist$Products) + 500),
  col = c("steelblue", "orange3", "darkgreen"),
  xlab = "Geography",
  ylab = "Number of Products",
  main = "Number of Products by Geography"
)
