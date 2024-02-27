
library(gmodels)


data <- read.csv("./data/0304_fundamentals_of_predictive_modelling/00_misc/basic_recovery_data.csv", header = TRUE)

head(data)
#   Gender Resting.HR X2.mins X4.mins X6.mins X8.mins X10.mins
# 1   Male         65      90      83      80      70       65
# 2   Male         80     120     110     100      90       80
# 3   Male         62      90      86      79      69       62
# 4   Male         65      90      84      77      73       65
# 5   Male         75      99      90      85      84       75
# 6   Male         80     120     110     103      90       80

str(data)
# 'data.frame':	50 obs. of  7 variables:
# $ Gender    : chr  "Male" "Male" "Male" "Male" ...
# $ Resting.HR: int  65 80 62 65 75 80 70 70 88 77 ...
# $ X2.mins   : int  90 120 90 90 99 120 110 110 124 110 ...
# $ X4.mins   : int  83 110 86 84 90 110 105 100 107 95 ...
# $ X6.mins   : int  80 100 79 77 85 103 100 80 105 85 ...
# $ X8.mins   : int  70 90 69 73 84 90 93 70 103 84 ...
# $ X10.mins  : int  65 80 62 65 75 80 70 70 100 80 ...


data$Recovery_Time <- ifelse(
  data$X2.mins <= data$Resting.HR, 2, ifelse(
    data$X4.mins <= data$Resting.HR, 4, ifelse(
      data$X6.mins <= data$Resting.HR, 6, ifelse(
        data$X8.mins <= data$Resting.HR, 8, ifelse(
          data$X10.mins <= data$Resting.HR, 10, 12)
        )
      )
    )
  )

data$Recovery <- ifelse(
  data$X2.mins <= data$Resting.HR, '2 Mins', ifelse(
    data$X4.mins <= data$Resting.HR, '4 Mins', ifelse(
      data$X6.mins <= data$Resting.HR, '6 Mins', ifelse(
        data$X8.mins <= data$Resting.HR, '8 Mins', ifelse(
          data$X10.mins <= data$Resting.HR, '10 Mins', '>10 Mins')
      )
    )
  )
)

head(data)
#   Gender Resting.HR X2.mins X4.mins X6.mins X8.mins X10.mins Recovery_Time Recovery
# 1   Male         65      90      83      80      70       65            10  10 Mins
# 2   Male         80     120     110     100      90       80            10  10 Mins
# 3   Male         62      90      86      79      69       62            10  10 Mins
# 4   Male         65      90      84      77      73       65            10  10 Mins
# 5   Male         75      99      90      85      84       75            10  10 Mins
# 6   Male         80     120     110     103      90       80            10  10 Mins

str(data)
# 'data.frame':	50 obs. of  9 variables:
# $ Gender       : chr  "Male" "Male" "Male" "Male" ...
# $ Resting.HR   : int  65 80 62 65 75 80 70 70 88 77 ...
# $ X2.mins      : int  90 120 90 90 99 120 110 110 124 110 ...
# $ X4.mins      : int  83 110 86 84 90 110 105 100 107 95 ...
# $ X6.mins      : int  80 100 79 77 85 103 100 80 105 85 ...
# $ X8.mins      : int  70 90 69 73 84 90 93 70 103 84 ...
# $ X10.mins     : int  65 80 62 65 75 80 70 70 100 80 ...
# $ Recovery_Time: num  10 10 10 10 10 10 10 8 11 11 ...
# $ Recovery     : chr  "10 Mins" "10 Mins" "10 Mins" "10 Mins" ...


wilcox.test(Recovery_Time ~ Gender, data = data)
#         Wilcoxon rank sum test with continuity correction
# 
# data:  Recovery_Time by Gender
# W = 362, p-value = 0.2217
# alternative hypothesis: true location shift is not equal to 0


CrossTable(data$Recovery, data$Gender, chisq = TRUE)
# Pearson's Chi-squared test 
# ------------------------------------------------------------
# Chi^2 =  9.041461     d.f. =  4     p =  0.06007146 
