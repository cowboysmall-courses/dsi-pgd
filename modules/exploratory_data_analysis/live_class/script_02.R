
# 1
insurance_data <- read.csv("../../../data/live_class/Data Set for Insurance Claims.csv", header = TRUE)

# 2
dim(insurance_data)

# 3
str(insurance_data)

# 4
head(insurance_data)

# 5
summary(insurance_data)

# 6 
plot(
  insurance_data$Claims,
  insurance_data$ClaimAmount,
  main = "Scatter Plot",
  xlab = "Claims",
  ylab = "Claim Amount",
  col = "cadetblue"
)
# looks like a strong positive correlation


# 7 
cor(insurance_data$Claims, insurance_data$ClaimAmount)
# 0.9128782


# 8
model <- lm(ClaimAmount ~ Claims, data = insurance_data)
model
abline(model, col = "cadetblue")

