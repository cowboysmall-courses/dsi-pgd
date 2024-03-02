
library(GGally)
library(car)



data <- read.csv("./data/0304_fundamentals_of_predictive_modelling/02_assumptions_in_mlr/ridge\ regression\ data.csv", header = TRUE)
head(data)
#                 MODEL RESALE.PRICE ENGINE.SIZE HORSE.POWER WEIGHT YEARS
# 1      Daihatsu Cuore         3870         846          32    650   2.9
# 2 Suzuki Swift 1.0 GL         4163         993          39    790   2.9
# 3  Fiat Panda Mambo L         3490         899          29    730   3.1
# 4      VW Polo 1.4 60         5714        1390          44    955   3.3
# 5 Opel Corsa 1.2i Eco         4950        1195          33    895   3.4
# 6    Subaru Vivio 4WD         5480         658          32    740   3.4



ggpairs(
    data[, c("RESALE.PRICE", "ENGINE.SIZE", "HORSE.POWER", "YEARS")],
    title = "Scatter Plot Matrix",
    columnLabels = c("RESALE.PRICE", "ENGINE.SIZE", "HORSE.POWER", "YEARS")
)


model <- lm(RESALE.PRICE ~ ENGINE.SIZE + HORSE.POWER + WEIGHT + YEARS, data = data)
summary(model)
# Call:
# lm(formula = RESALE.PRICE ~ ENGINE.SIZE + HORSE.POWER + WEIGHT + 
#     YEARS, data = data)
# 
# Residuals:
#     Min      1Q  Median      3Q     Max 
# -1105.0  -572.7  -102.5   326.6  1699.5 
# 
# Coefficients:
#               Estimate Std. Error t value Pr(>|t|)    
# (Intercept)  3173.3673   774.8996   4.095 0.000517 ***
# ENGINE.SIZE     0.4462     0.9693   0.460 0.650026    
# HORSE.POWER    24.6222    16.7241   1.472 0.155780    
# WEIGHT          4.0855     1.4984   2.727 0.012640 *  
# YEARS       -1028.7282   528.7602  -1.946 0.065218 .  
# ---
# Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
# 
# Residual standard error: 772 on 21 degrees of freedom
# Multiple R-squared:  0.7476,	Adjusted R-squared:  0.6995 
# F-statistic: 15.55 on 4 and 21 DF,  p-value: 4.668e-06


vif(model)
# ENGINE.SIZE HORSE.POWER      WEIGHT       YEARS 
#   15.759113   12.046734    9.113045   13.978640 
