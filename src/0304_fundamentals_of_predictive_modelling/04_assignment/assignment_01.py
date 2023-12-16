
# BACKGROUND: 
#   
#   The data for modeling contains information on Selling price of each house in million 
#   Rs. It also contains Carpet area in square feet, Distance from nearest metro station 
#   and Number of schools within 2 km distance. The data has 198 rows and 5 columns.



import numpy as np
import pandas as pd
import statsmodels.api as sm

from patsy import dmatrices
from scipy import stats
from sklearn.model_selection import train_test_split
from statsmodels.stats.outliers_influence import variance_inflation_factor
from statsmodels.formula.api import ols
from statsmodels.graphics.regressionplots import influence_plot
from statsmodels.stats.diagnostic import lilliefors



np.random.seed(1024)



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
train, test = train_test_split(data, test_size = 0.2, random_state = 1024)



# %% 3 - Build a regression model on training data to estimate selling price of a House.
model = ols('Price ~ Area + Distance + Schools', data = train).fit()
model.summary()
# """
#                             OLS Regression Results                            
# ==============================================================================
# Dep. Variable:                  Price   R-squared:                       0.774
# Model:                            OLS   Adj. R-squared:                  0.770
# Method:                 Least Squares   F-statistic:                     176.0
# Date:                Sat, 16 Dec 2023   Prob (F-statistic):           1.52e-49
# Time:                        19:43:42   Log-Likelihood:                -347.86
# No. Observations:                 158   AIC:                             703.7
# Df Residuals:                     154   BIC:                             716.0
# Df Model:                           3                                         
# Covariance Type:            nonrobust                                         
# ==============================================================================
#                  coef    std err          t      P>|t|      [0.025      0.975]
# ------------------------------------------------------------------------------
# Intercept     -8.7665      1.978     -4.432      0.000     -12.674      -4.859
# Area           0.0341      0.002     15.226      0.000       0.030       0.039
# Distance      -1.8387      0.178    -10.311      0.000      -2.191      -1.486
# Schools        1.2026      0.391      3.073      0.003       0.429       1.976
# ==============================================================================
# Omnibus:                       10.434   Durbin-Watson:                   1.857
# Prob(Omnibus):                  0.005   Jarque-Bera (JB):               10.595
# Skew:                          -0.613   Prob(JB):                      0.00500
# Kurtosis:                       3.327   Cond. No.                     1.17e+04
# ==============================================================================

# Notes:
# [1] Standard Errors assume that the covariance matrix of the errors is correctly specified.
# [2] The condition number is large, 1.17e+04. This might indicate that there are
# strong multicollinearity or other numerical problems.
# """



# %% 4 - List down significant variables and interpret their regression coefficients.
model.params
# Intercept   -8.766467
# Area         0.034092
# Distance    -1.838697
# Schools      1.202569
# dtype: float64

# ==============================================================================
#                  coef    std err          t      P>|t|      [0.025      0.975]
# ------------------------------------------------------------------------------
# Intercept     -8.7665      1.978     -4.432      0.000     -12.674      -4.859
# Area           0.0341      0.002     15.226      0.000       0.030       0.039
# Distance      -1.8387      0.178    -10.311      0.000      -2.191      -1.486
# Schools        1.2026      0.391      3.073      0.003       0.429       1.976
# ==============================================================================

# for every unit increase in Area, the Price increases by 0.034092
# for every unit increase in Distance, the Price decreases by 1.838697
# for every unit increase in Schools, the Price increases by 1.202569



# %% 5 - What is the R2 and adjusted R2 of the model? Give interpretation.
# R-squared:                       0.774
# Adj. R-squared:                  0.770

# R-squared gives the proportion of the variation in the dependent variable that is 
# explained by the predictors / independent variables. 

# Adjusted R-squared is the value of R-squared adjusted for the number of predictors 
# in the model.

# in the case of R-squared, the value 0.774 implies that 77% - 78% of the variation in
# Price is explained by the model (and 22% - 23% is unexplained variation)



# %% 6 - Is there a multicollinearity problem? If yes, do the necessary steps to remove it.
y, X = dmatrices('Price ~ Area + Distance + Schools', data = train, return_type = "dataframe")
pd.Series([variance_inflation_factor(X.values, i) for i in range(X.shape[1])], index = X.columns)
# Intercept    125.926989
# Area           1.473086
# Distance       1.016718
# Schools        1.477310
# dtype: float64

# as all calculated values of vif for each predictor are less than 5, there does not 
# appear to be a multicolinearity problem



# %% 7 - Are there any influential observations in the data?
influence = model.get_influence()
influence.summary_frame()
#      dfb_Intercept  dfb_Area  ...  student_resid    dffits
# 78        0.063990 -0.009593  ...       0.744533  0.145472
# 156       0.014574 -0.001511  ...       0.576244  0.066814
# 87        0.065066 -0.051254  ...      -0.618008 -0.088658
# 127      -0.063735  0.098414  ...      -1.143198 -0.162791
# 91        0.153121 -0.115641  ...      -2.020089 -0.253939
# ..             ...       ...  ...            ...       ...
# 89       -0.050328  0.035983  ...       0.554452  0.075001
# 101      -0.002104  0.004266  ...      -0.097295 -0.012036
# 97       -0.352367  0.159502  ...      -3.060087 -0.565365
# 145      -0.020401  0.009515  ...      -0.743976 -0.097510
# 187       0.034430 -0.022163  ...       0.412415  0.048880

# [158 rows x 10 columns]

# We can see from the above summary that there are many influential observations in 
# the data.

fig = influence_plot(model, criterion = 'Cooks')



# %% 8 - Can we assume that errors follow ‘Normal’ distribution?
train = train.assign(pred = pd.Series(model.fittedvalues))
train = train.assign(resi = pd.Series(model.resid))

train.head()
#      Houseid  Price  Area  Distance  Schools       pred      resi
# 78        79  27.35   965      0.44        2  25.728640  1.621360
# 156      157  23.31   997      3.04        2  22.038979  1.271021
# 87        88  28.59  1177      2.73        3  29.948144 -1.358144
# 127      128  22.79  1006      2.09        3  25.295139 -2.505139
# 91        92  25.24  1149      2.38        3  29.637105 -4.397105

fig = sm.graphics.qqplot(train.resi, line = '45', fit = True)

# The q-q plot appears to be reasonably normal, but deviating from normality at the tails.
# We should perform the standard tests for normality to confirm.

stats.shapiro(train.resi)
# ShapiroResult(statistic=0.9728265404701233, pvalue=0.003282437566667795)

# as the p-value is 0.003282437566667795 we reject the null hypothesis that the residuals
# are drawn from normally distributed data. 

lilliefors(train.resi)
# (0.07050816939717353, 0.07657806581490464)

# as the p-value is 0.07657806581490464 we fail to reject the null hypothesis that the
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
# 2.187428448742535

test = test.assign(pred = pd.Series(model.predict(test)))
test = test.assign(resi = pd.Series(test.Price - test.pred))

test.head()
#      Houseid  Price  Area  Distance  Schools       pred      resi
# 166      167  23.44  1030      4.33        3  21.994672  1.445328
# 50        51  34.92  1072      0.10        3  31.204233  3.715767
# 86        87  17.25   928      3.81        2  18.270819 -1.020819
# 49        50  26.88  1028      2.23        3  25.787751  1.092249
# 73        74  31.84  1162      2.26        3  30.300948  1.539052

RMSE_test = np.sqrt((test.resi ** 2).mean())
RMSE_test
# 2.256526873750602

# both values of RMSE are consistent, which is a strong indicator of the stability of
# the model.

((RMSE_train - RMSE_test) / RMSE_train) * 100
# -3.1588884677708755

# the difference between the train and test RMSE is around 3% - 4% - which is acceptable
# (a difference of around 10% is usually the ideal). Also of note is that the test RMSE 
# is greater than the train RMSE, which would indicate that the error has increased going
# from train to test.
