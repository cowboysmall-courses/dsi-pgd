
# Case Study 1
#
# The dataset is from the Swedish Insurance Company. There are 2 variables:
#
#  1 - number of claims
#  2 - the total payment for all the claims in thousands of Swedish Kronor
#      for various locations in Sweden.
#
# The objective is to predict the Total Claim Amount. Perform the following
# tasks:
#



# 1 - import the data in R
insurance_data <- read.csv("./data/0104_exploratory_data_analysis/00_live_class/Data Set for Insurance Claims.csv", header = TRUE)


# 2 - check the dimensions of the dataset
dim(insurance_data)
# 63  3


# 3 - check the data structure
str(insurance_data)
# 'data.frame': 63 obs. of  3 variables:
#  $ Loication  : int  1 2 3 4 5 6 7 8 9 10 ...
#  $ Claims     : int  108 19 13 124 40 57 23 14 45 10 ...
#  $ ClaimAmount: num  392.5 46.2 15.7 422.2 119.4 ...


# 4 - display first 6 rows of the data
head(insurance_data)
# Loication Claims ClaimAmount
# 1         1    108       392.5
# 2         2     19        46.2
# 3         3     13        15.7
# 4         4    124       422.2
# 5         5     40       119.4
# 6         6     57       170.9


# 5 - obtain descriptive statistics using summary function
summary(insurance_data)
# Loication        Claims       ClaimAmount
# Min.   : 1.0   Min.   :  0.0   Min.   :  0.00
# 1st Qu.:16.5   1st Qu.:  7.5   1st Qu.: 38.85
# Median :32.0   Median : 14.0   Median : 73.40
# Mean   :32.0   Mean   : 22.9   Mean   : 98.19
# 3rd Qu.:47.5   3rd Qu.: 29.0   3rd Qu.:140.00
# Max.   :63.0   Max.   :124.0   Max.   :422.20


# 6 - draw a scatter plot and interpret the same
plot(
  insurance_data$Claims,
  insurance_data$ClaimAmount,
  main = "Scatter Plot",
  xlab = "Claims",
  ylab = "Claim Amount",
  col = "cadetblue"
)
# looks like a strong positive correlation


# 7 - calculate the Karl Pearson’s correlation coefficient and comment on the same
cor(insurance_data$Claims, insurance_data$ClaimAmount)
# 0.9128782
# very strong positive correlation


# 8 - fit a line of regression of total claim amount on number of claims
model <- lm(ClaimAmount ~ Claims, data = insurance_data)
model
# Call:
#   lm(formula = ClaimAmount ~ Claims, data = insurance_data)
#
# Coefficients:
#   (Intercept)       Claims
# 19.994        3.414

abline(model, col = "cadetblue")


# 9 - interpret the results
# for each unit increase in number of claims, the claim amount increases by 3.414
