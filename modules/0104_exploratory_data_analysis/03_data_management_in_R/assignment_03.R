
# Jerry Kiely
# Data Science Institute
# Data Management in R
# EDA T4 Assignment


# 1
# Premiums <- read.csv(file.choose(), header = TRUE)
# Premiums <- read.csv("./Premiums.csv", header = TRUE)
Premiums <- read.csv("../../../data/exploratory_data_analysis_assignment/Premiums.csv", header = TRUE)
attach(Premiums)


# 2
dim(Premiums)


# 3
head(Premiums, n = 10)
tail(Premiums, n = 5)


# 4
summary(Premiums)
# str(Premiums)


# 5
sorted <- Premiums[order(-Premium), ]
head(sorted, n = 5)
tail(sorted, n = 5)


# 6
aggregate(Sum_Assured ~ REGION, Premiums, FUN = sum)


# 7
Premiums_sub <- subset(Premiums, Plan == "Asia Standard Plan" & Sum_Assured <= 50000, select = c("POLICY_NO", "ZONE_NAME", "Plan", "Sum_Assured"))


# 8
library(xlsx)
write.xlsx(Premiums_sub, "./Premiums_sub.xlsx", row.names = FALSE)
