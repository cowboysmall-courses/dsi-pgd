
# %% 0 - import libraries
import pandas as pd
import numpy as np
import hoggorm
import math
import statistics

from patsy import dmatrices
from statsmodels.formula.api import ols
from statsmodels.stats.outliers_influence import variance_inflation_factor
from sklearn.decomposition import PCA
from sklearn.preprocessing import scale

import warnings
warnings.filterwarnings("ignore", category = FutureWarning)



# %% 1 - import data and check the head
data = pd.read_csv("./data/0604_unsupervised_multivariate_methods/01_data_reduction_methods/pcrdata.csv")
data.head()
#    SRNO  SALES    AD  PRO  SALEXP  ADPRE  PROPRE
# 0     1  20.11  1.98  0.9    0.31   2.02     0.0
# 1     2  15.10  1.94  0.0    0.30   1.99     1.0
# 2     3  18.68  2.20  0.8    0.35   1.93     0.0
# 3     4  16.05  2.00  0.0    0.35   2.20     0.8
# 4     5  21.30  1.69  1.3    0.30   2.00     0.0


# %% 2 - build model
model_lm = ols('SALES ~ AD + PRO + SALEXP + ADPRE + PROPRE', data = data).fit()
model_lm.summary()
# """
#                             OLS Regression Results                            
# ==============================================================================
# Dep. Variable:                  SALES   R-squared:                       0.909
# Model:                            OLS   Adj. R-squared:                  0.906
# Method:                 Least Squares   F-statistic:                     273.2
# Date:                Mon, 15 Apr 2024   Prob (F-statistic):           2.09e-69
# Time:                        12:21:06   Log-Likelihood:                -226.08
# No. Observations:                 143   AIC:                             464.2
# Df Residuals:                     137   BIC:                             481.9
# Df Model:                           5                                         
# Covariance Type:            nonrobust                                         
# ==============================================================================
#                  coef    std err          t      P>|t|      [0.025      0.975]
# ------------------------------------------------------------------------------
# Intercept    -10.8147      6.531     -1.656      0.100     -23.730       2.101
# AD             4.6762      1.410      3.316      0.001       1.888       7.464
# PRO            7.7886      1.263      6.168      0.000       5.292      10.286
# SALEXP        22.4089      0.770     29.089      0.000      20.886      23.932
# ADPRE          3.1856      1.244      2.560      0.012       0.725       5.646
# PROPRE         3.4970      1.370      2.553      0.012       0.789       6.205
# ==============================================================================
# Omnibus:                        8.788   Durbin-Watson:                   2.153
# Prob(Omnibus):                  0.012   Jarque-Bera (JB):                4.669
# Skew:                           0.233   Prob(JB):                       0.0969
# Kurtosis:                       2.247   Cond. No.                         206.
# ==============================================================================

# Notes:
# [1] Standard Errors assume that the covariance matrix of the errors is correctly specified.
# """


# %% 3 - 
y, X = dmatrices('SALES ~ AD + PRO + SALEXP + ADPRE + PROPRE', data = data, return_type = "dataframe")
vif  = pd.Series([variance_inflation_factor(X.values, i) for i in range(X.shape[1])], index = X.columns)
vif
# Intercept    4226.760949
# AD             36.159771
# PRO            31.846727
# SALEXP          1.076284
# ADPRE          24.781948
# PROPRE         42.346468
# dtype: float64


# %% 4 - 
data2 = data.drop(["SRNO", "SALES"], axis = 1)
std_X = scale(data2)
X     = pd.DataFrame(std_X, index = data2.index, columns = data2.columns)


# %% 5 - 
pca   = PCA().fit(X)
names = [f"PC{i}" for i in range(1, 6)]

SD      = list(np.std(pca.transform(X), axis = 0))
VarProp = list(pca.explained_variance_ratio_)
CumProp = [np.sum(VarProp[:i]) for i in range(1, 6)]

summary = pd.DataFrame(list(zip(SD, VarProp, CumProp)), index = names, columns = ["Standard Deviation", "Proportion of Variance", "Cumulative Proportion"])
summary
#      Standard Deviation  Proportion of Variance  Cumulative Proportion
# PC1            1.301556                0.338810               0.338810
# PC2            1.131848                0.256216               0.595026
# PC3            1.070535                0.229209               0.824235
# PC4            0.933433                0.174259               0.998494
# PC5            0.086770                0.001506               1.000000


# %% 6 - 
model_pcr = hoggorm.pcr.nipalsPCR(std_X, y)

data["pred_pcr"] = model_pcr.Y_predCal()[3]
data.head()
#    SRNO  SALES    AD  PRO  SALEXP  ADPRE  PROPRE    pcrpred
# 0     1  20.11  1.98  0.9    0.31   2.02     0.0  21.290481
# 1     2  15.10  1.94  0.0    0.30   1.99     1.0  18.169735
# 2     3  18.68  2.20  0.8    0.35   1.93     0.0  21.271485
# 3     4  16.05  2.00  0.0    0.35   2.20     0.8  17.621109
# 4     5  21.30  1.69  1.3    0.30   2.00     0.0  22.979205


# %% 7 - 
test = pd.read_csv('./data/0604_unsupervised_multivariate_methods/01_data_reduction_methods/pcrdata_test.csv')


# %% 8 - 
test2  = test.drop(["SRNO","SALES"], axis = 1)
std_X2 = scale(test2)

test["pred_pcr"] = model_pcr.Y_predict(std_X2, numComp = 3)
test["resi_pcr"] = test["SALES"] - test["pred_pcr"]

RMSE_pcr = math.sqrt(statistics.mean(test["resi_pcr"] ** 2))


# %% 9 - 
test["pred_lm"] = model_lm.predict(test)
test["resi_lm"] = test["SALES"] - test["pred_lm"]

RMSE_lm = math.sqrt(statistics.mean(test["resi_lm"] ** 2))


# %% 10 - 
test.head()
#    SRNO  SALES    AD   PRO  SALEXP  ADPRE  PROPRE   pred_pcr  resi_pcr  \
# 0     1  28.93  2.75  1.00    0.72   1.97    0.02  22.564800  6.365200   
# 1     2  25.96  1.73  1.06    0.89   2.77    0.02  21.752214  4.207786   
# 2     3  31.25  2.19  1.26    0.79   1.22    0.42  26.662886  4.587114   
# 3     4  25.05  1.82  1.45    0.83   2.23    0.15  24.720419  0.329581   
# 4     5  27.32  2.38  1.01    0.74   1.01    0.07  25.930267  1.389733   

#      pred_lm    resi_lm  
# 0  32.313678  -3.383678  
# 1  34.369246  -8.409246  
# 2  32.298212  -1.048212  
# 3  35.217508 -10.167508  
# 4  28.226159  -0.906159  


# %% 11 - 
RMSE_lm
# 9.11168217987875


# %% 12 - 
RMSE_pcr
# 3.013561685358926
