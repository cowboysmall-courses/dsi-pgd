
library(quantmod)
library(egcm)


getSymbols(c("tcs", "ibm"), from = "2016-11-01", to = "2017-11-01", env = .GlobalEnv, src = "yahoo")


summary(egcm(TCS[, 4], IBM[, 4]))
# IBM.Close[i] =   0.5982 TCS.Close[i] + 149.3228 + R[i], R[i] =   1.0000 R[i-1] + eps[i], eps ~ N(0,  1.5567^2)
#                 (0.7876)                (3.9889)                (0.0085)
# 
# R[2017-10-31] = -4.1976 (t = -0.364)
# 
# WARNING: TCS.Close and IBM.Close do not appear to be cointegrated.
# 
# Unit Root Tests of Residuals
#                                                     Statistic    p-value
#   Augmented Dickey Fuller (ADF)                        -0.952    0.90049
#   Phillips-Perron (PP)                                 -2.319    0.91531
#   Pantula, Gonzales-Farias and Fuller (PGFF)            0.988    0.80764
#   Elliott, Rothenberg and Stock DF-GLS (ERSD)          -0.899    0.61297
#   Johansen's Trace Test (JOT)                          -4.604    0.98910
#   Schmidt and Phillips Rho (SPR)                       -2.290    0.93539
# 
# Variances
#   SD(diff(TCS.Close))  =   0.200075
#   SD(diff(IBM.Close))  =   1.562664
#   SD(diff(residuals))  =   1.556654
#   SD(residuals)        =  11.546641
#   SD(innovations)      =   1.556654
# 
# Half life       = Infinite
# R[last]         =  -4.197552 (t=-0.36)
