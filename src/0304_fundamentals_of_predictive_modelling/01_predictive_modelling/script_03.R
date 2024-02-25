
data <- read.csv("./data/0304_fundamentals_of_predictive_modelling/predictive_modelling/RESTAURANT\ SALES\ DATA.csv", header = TRUE)

head(data)
#   RESTAURANT NOH LOCATION  SALES
# 1          1 155  highway 131.27
# 2          2  93  highway  68.14
# 3          3 128  highway 114.95
# 4          4 114  highway 102.93
# 5          5 158  highway 131.77
# 6          6 173  highway 152.30

str(data)
# 'data.frame':	 16 obs. of  4 variables:
# $ RESTAURANT: int  1 2 3 4 5 6 7 8 9 10 ...
# $ NOH       : int  155 93 128 114 158 173 178 215 152 197 ...
# $ LOCATION  : chr  "highway" "highway" "highway" "highway" ...
# $ SALES     : num  131.3 68.1 115 102.9 131.8 ...


data$LOCATION <- as.factor(data$LOCATION)

levels(data$LOCATION)
# "mall"    "highway" "street" 


model <- lm(SALES ~ NOH + LOCATION, data = data)
summary(model)
# Call:
#   lm(formula = SALES ~ NOH + LOCATION, data = data)
# 
# Residuals:
#   Min       1Q   Median       3Q      Max 
# -18.4620  -3.3293   0.0556   5.2483  15.6290 
# 
# Coefficients:
#   Estimate Std. Error t value Pr(>|t|)    
# (Intercept)     2.18923    8.59214   0.255    0.803    
# NOH             0.83828    0.05618  14.920 4.13e-09 ***
# LOCATIONmall   37.05241    5.81407   6.373 3.54e-05 ***
# LOCATIONstreet  7.15367    6.73141   1.063    0.309    
# ---
# Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
# 
# Residual standard error: 9.398 on 12 degrees of freedom
# Multiple R-squared:  0.9701,	Adjusted R-squared:  0.9627 
# F-statistic:   130 on 3 and 12 DF,  p-value: 2.05e-09


data$LOCATION <- relevel(data$LOCATION, ref = "mall")

model <- lm(SALES ~ NOH + LOCATION, data = data)
summary(model)
# Call:
#   lm(formula = SALES ~ NOH + LOCATION, data = data)
# 
# Residuals:
#   Min       1Q   Median       3Q      Max 
# -18.4620  -3.3293   0.0556   5.2483  15.6290 
# 
# Coefficients:
#   Estimate Std. Error t value Pr(>|t|)    
# (Intercept)      39.24164   10.50204   3.737 0.002840 ** 
# NOH               0.83828    0.05618  14.920 4.13e-09 ***
# LOCATIONhighway -37.05241    5.81407  -6.373 3.54e-05 ***
# LOCATIONstreet  -29.89874    6.12294  -4.883 0.000377 ***
# ---
# Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
# 
# Residual standard error: 9.398 on 12 degrees of freedom
# Multiple R-squared:  0.9701,	Adjusted R-squared:  0.9627 
# F-statistic:   130 on 3 and 12 DF,  p-value: 2.05e-09


