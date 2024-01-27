#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat Jan 27 09:09:36 2024

@author: jerry
"""




# %% 0 - import libraries
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns

from scipy.stats import chi2_contingency
from statsmodels.formula.api import logit




# %% 0 - import data and check the head
data = pd.read_csv("../../../data/0404_advanced_predictive_modelling/live_class/Email Campaign.csv")
data.head()
#    SN  Gender   AGE  ...  Bill_Service  Bill_Product  Success
# 0   1       1  <=45  ...         11.82          2.68        0
# 1   2       2  <=30  ...         10.31          1.32        0
# 2   3       1  <=30  ...          7.43          0.49        0
# 3   4       1  <=45  ...         13.68          1.85        0
# 4   5       2  <=30  ...          4.56          1.01        1

# [5 rows x 8 columns]




# %% 0 - convert Gender to factor
data['Gender'] = data['Gender'].astype('category')
data['AGE'] = data['AGE'].astype('category')
data.dtypes
# SN                    int64
# Gender             category
# AGE                category
# Recency_Service       int64
# Recency_Product       int64
# Bill_Service        float64
# Bill_Product        float64
# Success            category
# dtype: object




# %% 1 - summarize Bill_Service by Success
data.groupby('Success')['Bill_Service'].agg(['count', 'mean', 'median', 'std'])
#          count       mean  median       std
# Success                                    
# 0          503   9.188807   7.880  5.644067
# 1          180  15.287111  14.675  7.925569


# %% 1 - summarize Bill_Product by Success
data.groupby('Success')['Bill_Product'].agg(['count', 'mean', 'median', 'std'])
#          count      mean  median       std
# Success                                   
# 0          503  1.746740   1.310  1.465931
# 1          180  2.956167   1.965  3.282115


# %% 1 - summarize Bill_Service by Success
data.groupby('Success')['Bill_Service'].describe()
#          count       mean       std   min   25%     50%      75%    max
# Success                                                                
# 0        503.0   9.188807  5.644067  0.45  5.08   7.880  12.3050  32.99
# 1        180.0  15.287111  7.925569  1.36  9.23  14.675  20.0525  41.55


# %% 1 - summarize Bill_Product by Success
data.groupby('Success')['Bill_Product'].describe()
#          count      mean       std   min     25%    50%     75%    max
# Success                                                               
# 0        503.0  1.746740  1.465931  0.05  0.8200  1.310  2.1400  10.69
# 1        180.0  2.956167  3.282115  0.29  1.0275  1.965  3.3025  20.69




# %% 2 - set up plot environment
plt.figure(figsize = (8, 6))
sns.set_style("darkgrid")
sns.set_context("paper")


# %% 2 - Box Plot of Bill_Service by Success
sns.boxplot(data = data, x = 'Success', y = 'Bill_Service')


# %% 2 - Box Plot of Bill_Product by Success
sns.boxplot(data = data, x = 'Success', y = 'Bill_Product')


# %% 2 - Box Plot of Bill_Service by Success
data.boxplot(column = 'Bill_Service', by = 'Success')
plt.xlabel('Success')
plt.ylabel('Bill Service')
plt.title('Box Plot')
plt.suptitle('')


# %% 2 - Box Plot of Bill_Service by Success
data.boxplot(column = 'Bill_Product', by = 'Success')
plt.xlabel('Success')
plt.ylabel('Bill Product')
plt.title('Box Plot')
plt.suptitle('')


# %% 2 - Box Plot of Bill_Service by Success
sns.boxplot(data = data, x = 'Success', y = 'Bill_Service', width = 0.15)
plt.xlabel('Success')
plt.ylabel('Bill Service')
plt.title('Box Plot')


# %% 2 - Box Plot of Bill_Product by Success
sns.boxplot(data = data, x = 'Success', y = 'Bill_Product', width = 0.15)
plt.xlabel('Success')
plt.ylabel('Bill Product')
plt.title('Box Plot')




# %% 3 - test association between Gender and Success
chi2_contingency(pd.crosstab(data.Gender, data.Success))
# Chi2ContingencyResult(statistic=0.3807592682933615, 
#        pvalue=0.5371971687062078, 
#        dof=1, 
#        expected_freq=array([[229.03806735,  81.96193265],
#        [273.96193265,  98.03806735]]))

# we fail to reject the null hypothesis that the two attributes under test are 
# independent, or are not associated



# %% 4 - Fit model using all predictors
model = logit(formula = 'Success ~ Gender + AGE + Recency_Service + Recency_Product + Bill_Service + Bill_Product', data = data).fit()
model.summary()
# """
#                            Logit Regression Results                           
# ==============================================================================
# Dep. Variable:                Success   No. Observations:                  683
# Model:                          Logit   Df Residuals:                      675
# Method:                           MLE   Df Model:                            7
# Date:                Sat, 27 Jan 2024   Pseudo R-squ.:                  0.3070
# Time:                        12:58:29   Log-Likelihood:                -272.99
# converged:                       True   LL-Null:                       -393.91
# Covariance Type:            nonrobust   LLR p-value:                 1.516e-48
# ===================================================================================
#                       coef    std err          z      P>|z|      [0.025      0.975]
# -----------------------------------------------------------------------------------
# Intercept          -1.0215      0.279     -3.655      0.000      -1.569      -0.474
# Gender[T.2]        -0.2370      0.214     -1.107      0.268      -0.657       0.183
# AGE[T.<=45]         0.1572      0.267      0.588      0.556      -0.367       0.681
# AGE[T.<=55]         0.6727      0.366      1.839      0.066      -0.044       1.390
# Recency_Service    -0.2459      0.029     -8.352      0.000      -0.304      -0.188
# Recency_Product    -0.0909      0.022     -4.117      0.000      -0.134      -0.048
# Bill_Service        0.0929      0.019      5.013      0.000       0.057       0.129
# Bill_Product        0.5197      0.081      6.413      0.000       0.361       0.678
# ===================================================================================
# """




# %% 5 - Fit model using only the significant predictors
model = logit(formula = 'Success ~ Recency_Service + Recency_Product + Bill_Service + Bill_Product', data = data).fit()
model.summary()
# """
#                            Logit Regression Results                           
# ==============================================================================
# Dep. Variable:                Success   No. Observations:                  683
# Model:                          Logit   Df Residuals:                      678
# Method:                           MLE   Df Model:                            4
# Date:                Sat, 27 Jan 2024   Pseudo R-squ.:                  0.3008
# Time:                        12:58:54   Log-Likelihood:                -275.44
# converged:                       True   LL-Null:                       -393.91
# Covariance Type:            nonrobust   LLR p-value:                 4.224e-50
# ===================================================================================
#                       coef    std err          z      P>|z|      [0.025      0.975]
# -----------------------------------------------------------------------------------
# Intercept          -1.1578      0.248     -4.673      0.000      -1.643      -0.672
# Recency_Service    -0.2298      0.027     -8.426      0.000      -0.283      -0.176
# Recency_Product    -0.0739      0.019     -3.825      0.000      -0.112      -0.036
# Bill_Service        0.0918      0.018      4.974      0.000       0.056       0.128
# Bill_Product        0.5185      0.081      6.415      0.000       0.360       0.677
# ===================================================================================
# """




# %% 6 - 
data['pred_prob'] = model.predict()
data.head()
#    SN Gender   AGE  ...  Bill_Product  Success  pred_prob
# 0   1      1  <=45  ...          2.68        0   0.095042
# 1   2      2  <=30  ...          1.32        0   0.287900
# 2   3      1  <=30  ...          0.49        0   0.246703
# 3   4      1  <=45  ...          1.85        0   0.392590
# 4   5      2  <=30  ...          1.01        1   0.263444

# [5 rows x 9 columns]




# %% 7 - 
data['pred'] = np.where(data.pred_prob <= 0.5, 0, 1)
data.head()
#    SN Gender   AGE  Recency_Service  ...  Bill_Product  Success  pred_prob  pred
# 0   1      1  <=45               12  ...          2.68        0   0.095042     0
# 1   2      2  <=30                6  ...          1.32        0   0.287900     0
# 2   3      1  <=30                1  ...          0.49        0   0.246703     0
# 3   4      1  <=45                2  ...          1.85        0   0.392590     0
# 4   5      2  <=30                0  ...          1.01        1   0.263444     0

# [5 rows x 10 columns]




# %% 8 - Calculate Accuracy + 
pd.crosstab(data.pred, data.Success)
# Success    0   1
# pred            
# 0        467  88
# 1         36  92

# %% 8 - Calculate Accuracy + 
round(pd.crosstab(data.pred, data.Success, normalize = "all") * 100, 2)
# Success      0      1
# pred                 
# 0        68.37  12.88
# 1         5.27  13.47

# %% 8 - Calculate Accuracy + 
round((sum(data.pred == data.Success) / data.shape[0]) * 100, 2)
# 81.84

# %% 8 - Calculate Accuracy + 
round((sum(data.pred != data.Success) / data.shape[0]) * 100, 2)
# 18.16
