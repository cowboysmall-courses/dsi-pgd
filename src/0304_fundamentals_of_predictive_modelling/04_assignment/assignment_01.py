
# BACKGROUND: 
#   
#   The data for modeling contains information on Selling price of each house in million 
#   Rs. It also contains Carpet area in square feet, Distance from nearest metro station 
#   and Number of schools within 2 km distance. The data has 198 rows and 5 columns.



import numpy as np
import pandas as pd
import seaborn as sns
import statsmodels.api as sm

from patsy import dmatrices
from scipy import stats
from sklearn.model_selection import train_test_split
from statsmodels.stats.outliers_influence import variance_inflation_factor
from statsmodels.formula.api import ols
from statsmodels.graphics.regressionplots import influence_plot
from statsmodels.stats.diagnostic import lilliefors



# %% 1 - Import House Price Data. Check the structure of the data.
data = pd.read_csv("../../../data/0304_fundamentals_of_predictive_modelling/assignment/House Price Data.csv")

data.head()
#    Houseid  Price  Area  Distance  Schools
# 0        1  24.74  1036      3.22        2
# 1        2  20.15  1030      4.33        3
# 2        3  25.98  1046      1.94        3
# 3        4  20.10   950      2.45        2
# 4        5  23.03   952      2.47        2

data.info()
# Data columns (total 5 columns):
#  #   Column    Non-Null Count  Dtype  
# ---  ------    --------------  -----  
#  0   Houseid   198 non-null    int64  
#  1   Price     198 non-null    float64
#  2   Area      198 non-null    int64  
#  3   Distance  198 non-null    float64
#  4   Schools   198 non-null    int64  
# dtypes: float64(2), int64(3)
# memory usage: 7.9 KB



# %% 2 - Split the data into Training (80%) and Testing (20%) data sets
train, test = train_test_split(data, test_size = 0.2, random_state = 0)



# %% 3 - Build a regression model on training data to estimate selling price of a House.
model = ols('Price ~ Area + Distance + Schools', data = train).fit()
model.summary()
# """
#                             OLS Regression Results                            
# ==============================================================================
# Dep. Variable:                  Price   R-squared:                       0.797
# Model:                            OLS   Adj. R-squared:                  0.794
# Method:                 Least Squares   F-statistic:                     202.1
# Date:                Sat, 16 Dec 2023   Prob (F-statistic):           3.57e-53
# Time:                        16:00:24   Log-Likelihood:                -350.50
# No. Observations:                 158   AIC:                             709.0
# Df Residuals:                     154   BIC:                             721.3
# Df Model:                           3                                         
# Covariance Type:            nonrobust                                         
# ==============================================================================
#                  coef    std err          t      P>|t|      [0.025      0.975]
# ------------------------------------------------------------------------------
# Intercept     -8.6063      1.933     -4.452      0.000     -12.425      -4.788
# Area           0.0333      0.002     15.008      0.000       0.029       0.038
# Distance      -1.9165      0.190    -10.073      0.000      -2.292      -1.541
# Schools        1.5059      0.428      3.515      0.001       0.659       2.352
# ==============================================================================
# Omnibus:                        7.437   Durbin-Watson:                   1.986
# Prob(Omnibus):                  0.024   Jarque-Bera (JB):                7.606
# Skew:                          -0.537   Prob(JB):                       0.0223
# Kurtosis:                       2.977   Cond. No.                     1.14e+04
# ==============================================================================

# Notes:
# [1] Standard Errors assume that the covariance matrix of the errors is correctly specified.
# [2] The condition number is large, 1.14e+04. This might indicate that there are
# strong multicollinearity or other numerical problems.
# """



# %% 4 - List down significant variables and interpret their regression coefficients.
model.params
# Intercept   -8.606252
# Area         0.033306
# Distance    -1.916504
# Schools      1.505935
# dtype: float64

# ==============================================================================
#                  coef    std err          t      P>|t|      [0.025      0.975]
# ------------------------------------------------------------------------------
# Intercept     -8.6063      1.933     -4.452      0.000     -12.425      -4.788
# Area           0.0333      0.002     15.008      0.000       0.029       0.038
# Distance      -1.9165      0.190    -10.073      0.000      -2.292      -1.541
# Schools        1.5059      0.428      3.515      0.001       0.659       2.352
# ==============================================================================

# for every unit increase in Area, the Price increases by 0.033306
# for every unit increase in Distance, the Price decreases by 1.916504
# for every unit increase in Schools, the Price increases by 1.505935



# %% 5 - What is the R2 and adjusted R2 of the model? Give interpretation.
# R-squared:                       0.797
# Adj. R-squared:                  0.794

# R-squared gives the proportion of the variation in the dependent variable that is 
# explained by the predictors / independent variables. 

# Adjusted R-squared is the value of R-squared adjusted for the number of predictors 
# in the model.

# in the case of R-squared, the value 0.797 implies that 79% - 80% of the variation in 
# Price is explained by the model (and 20% - 21% is unexplained variation)



# %% 6 - Is there a multicollinearity problem? If yes, do the necessary steps to remove it.
y, X = dmatrices('Price ~ Area + Distance + Schools', data = train, return_type = "dataframe")
pd.Series([variance_inflation_factor(X.values, i) for i in range(X.shape[1])], index = X.columns)
# Intercept    116.312936
# Area           1.569294
# Distance       1.055975
# Schools        1.631114
# dtype: float64

# as all calculated values of vif for each predictor are less than 5, there does not 
# appear to be a multicolinearity problem



# %% 7 - Are there any influential observations in the data?
influence = model.get_influence()
influence.summary_frame()
#      dfb_Intercept  dfb_Area  ...  student_resid    dffits
# 131       0.356091 -0.391085  ...      -1.540450 -0.425236
# 173       0.000168 -0.000555  ...       0.019284  0.002136
# 26        0.075654 -0.015935  ...      -0.804566 -0.163596
# 61       -0.059823  0.097184  ...      -1.076761 -0.149354
# 145      -0.015229  0.002613  ...      -0.608542 -0.082478
# ..             ...       ...  ...            ...       ...
# 67       -0.001200 -0.022123  ...       0.241596  0.055881
# 192       0.005931 -0.009491  ...       0.283316  0.034042
# 117      -0.075854  0.149698  ...       1.207080  0.205397
# 47       -0.003956 -0.000854  ...       0.197919  0.020719
# 172      -0.071516  0.058758  ...       0.933468  0.114178

# We can see from the above summary that there are many influential observations in 
# the data.

fig = influence_plot(model, criterion = 'Cooks')



# %% 8 - Can we assume that errors follow ‘Normal’ distribution?
train = train.assign(pred = pd.Series(model.fittedvalues))
train = train.assign(resi = pd.Series(model.resid))

train.head()
#      Houseid  Price  Area  Distance  Schools       pred      resi
# 131      132  33.41  1345      2.07        3  36.740684 -3.330684
# 173      174  27.76  1066      1.93        3  27.716678  0.043322
# 26        27  24.00  1139      4.21        3  25.778371 -1.778371
# 61        62  23.01  1006      2.09        3  25.411689 -2.401689
# 145      146  19.52   990      3.39        2  20.881406 -1.361406

fig = sm.graphics.qqplot(train.resi, line = '45', fit = True)

# The q-q plot appears to be reasonably normal, but deviating from normality at the tails.
# We should perform the standard tests for normality to confirm.

stats.shapiro(train.resi)
# ShapiroResult(statistic=0.9755853414535522, pvalue=0.006665823049843311)

# as the p-value is 0.006665823049843311 we reject the null hypothesis that the residuals 
# are drawn from normally distributed data. 

lilliefors(train.resi)
# (0.06475925533004229, 0.15433881296699287)

# as the p-value is 0.15433881296699287 we fail to reject the null hypothesis that the 
# residuals are drawn from normally distributed data.

# the above tests give conflicting results, but looking at the q-q plot we can see that
# both the tails deviate from normality, and hence the Shapiro-Wilk test will likely give 
# a p-value < 0.05 as it is concerned primarily with tails. We accept the outcome of the 
# Kolmogorov-Smirnov test.



# %% 9 - Is there a Heteroscedasticity problem? Check using residual vs. predictor plots.
train.plot.scatter(x = 'pred', y = 'resi')

# residuals appear to be reasonably randomly distributed, which would indicate 
# homoscedasticity, and hence no heteroscedasticity problem.



# %% 10 - Calculate the RMSE for the Training and Testing data.
RMSE_train = np.sqrt((train.resi ** 2).mean())
RMSE_train
# 2.224293038804313

test = test.assign(pred = pd.Series(model.predict(test)))
test = test.assign(resi = pd.Series(test.Price - test.pred))

test.head()
#      Houseid  Price  Area  Distance  Schools       pred      resi
# 18        19  27.94  1111      2.69        2  26.252961  1.687039
# 168      169  21.44   950      2.45        2  21.350688  0.089312
# 63        64  25.03  1033      3.21        3  24.164461  0.865539
# 175      176  17.11   916      3.15        2  18.876738 -1.766738
# 71        72  20.68   967      3.64        2  19.636247  1.043753

RMSE_test = np.sqrt((test.resi ** 2).mean())
RMSE_test
# 2.116735309570193

((RMSE_train - RMSE_test) / RMSE_train) * 100
# 4.835591684984935

# the difference between the train and test RMSE is around 4% - 5% - which is acceptable 
# (a difference of around 10% is usually the ideal). Also of note is that the test RMSE 
# is less than the train RMSE, which would indicate that the 
# error has decreased going from train to test.
