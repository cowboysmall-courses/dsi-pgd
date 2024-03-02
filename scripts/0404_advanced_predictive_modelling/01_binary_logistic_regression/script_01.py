#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat Feb 17 16:07:09 2024

@author: jerry
"""




# %% 0 - Import libraries
import pandas as pd
import numpy as np

from sklearn.metrics import confusion_matrix, classification_report
from statsmodels.formula.api import logit




# %% 0 - 
data = pd.read_csv("./data/0404_advanced_predictive_modelling/01_binary_logistic_regression/BANK LOAN.csv")
data.info()
# <class 'pandas.core.frame.DataFrame'>
# RangeIndex: 700 entries, 0 to 699
# Data columns (total 8 columns):
#  #   Column     Non-Null Count  Dtype  
# ---  ------     --------------  -----  
#  0   SN         700 non-null    int64  
#  1   AGE        700 non-null    int64  
#  2   EMPLOY     700 non-null    int64  
#  3   ADDRESS    700 non-null    int64  
#  4   DEBTINC    700 non-null    float64
#  5   CREDDEBT   700 non-null    float64
#  6   OTHDEBT    700 non-null    float64
#  7   DEFAULTER  700 non-null    int64  
# dtypes: float64(3), int64(5)
# memory usage: 43.9 KB




# %% 0 - 
data['AGE'] = data['AGE'].astype('category')
data.info()
# <class 'pandas.core.frame.DataFrame'>
# RangeIndex: 700 entries, 0 to 699
# Data columns (total 8 columns):
#  #   Column     Non-Null Count  Dtype   
# ---  ------     --------------  -----   
#  0   SN         700 non-null    int64   
#  1   AGE        700 non-null    category
#  2   EMPLOY     700 non-null    int64   
#  3   ADDRESS    700 non-null    int64   
#  4   DEBTINC    700 non-null    float64 
#  5   CREDDEBT   700 non-null    float64 
#  6   OTHDEBT    700 non-null    float64 
#  7   DEFAULTER  700 non-null    int64   
# dtypes: category(1), float64(3), int64(4)
# memory usage: 39.2 KB




# %% 0 - 
model = logit('DEFAULTER ~ EMPLOY + ADDRESS + DEBTINC + CREDDEBT', data = data).fit()
model.summary()
# """
#                            Logit Regression Results                           
# ==============================================================================
# Dep. Variable:              DEFAULTER   No. Observations:                  700
# Model:                          Logit   Df Residuals:                      695
# Method:                           MLE   Df Model:                            4
# Date:                Sat, 17 Feb 2024   Pseudo R-squ.:                  0.3079
# Time:                        16:16:59   Log-Likelihood:                -278.37
# converged:                       True   LL-Null:                       -402.18
# Covariance Type:            nonrobust   LLR p-value:                 2.114e-52
# ==============================================================================
#                  coef    std err          z      P>|z|      [0.025      0.975]
# ------------------------------------------------------------------------------
# Intercept     -0.7911      0.252     -3.145      0.002      -1.284      -0.298
# EMPLOY        -0.2426      0.028     -8.646      0.000      -0.298      -0.188
# ADDRESS       -0.0812      0.020     -4.144      0.000      -0.120      -0.043
# DEBTINC        0.0883      0.019      4.760      0.000       0.052       0.125
# CREDDEBT       0.5729      0.087      6.566      0.000       0.402       0.744
# ==============================================================================
# """



# %% 0 - 
conf = model.conf_int()
conf['Odds Ratio'] = model.params
conf.columns = ['2.5%', '97.5%', 'Odds Ratio']

print(np.exp(conf))
#                2.5%     97.5%  Odds Ratio
# Intercept  0.276905  0.742255    0.453359
# EMPLOY     0.742617  0.828950    0.784597
# ADDRESS    0.887246  0.958093    0.921989
# DEBTINC    1.053295  1.132703    1.092278
# CREDDEBT   1.494635  2.104150    1.773397



# %% 0 - 
data = data.assign(pred = pd.Series(model.predict()))
data.head(10)
#    SN AGE  EMPLOY  ADDRESS  DEBTINC  CREDDEBT  OTHDEBT  DEFAULTER      pred
# 0   1   3      17       12      9.3     11.36     5.01          1  0.808347
# 1   2   1      10        6     17.3      1.36     4.00          0  0.198115
# 2   3   2      15       14      5.5      0.86     2.17          0  0.010063
# 3   4   3      15       14      2.9      2.66     0.82          0  0.022160
# 4   5   1       2        0     17.3      1.79     3.06          1  0.781808
# 5   6   3       5        5     10.2      0.39     2.16          0  0.216468
# 6   7   2      20        9     30.6      3.83    16.67          0  0.185632
# 7   8   3      12       11      3.6      0.13     1.24          0  0.014726
# 8   9   1       3        4     24.4      1.36     3.28          1  0.748213
# 9  10   2       0       13     19.7      2.78     2.15          0  0.815256



# %% 0 - 
predicted_values = model.predict()
threshold = 0.5
predicted_class = np.zeros(predicted_values.shape)
predicted_class[predicted_values > threshold] = 1

cm1 = confusion_matrix(data['DEFAULTER'], predicted_class)

print('Confusion Matrix : \n', cm1)
# Confusion Matrix : 
#  [[478  39]
#  [ 91  92]]



# %% 0 - 
sensitivity = cm1[1, 1] / (cm1[1, 0] + cm1[1, 1])
print('Sensitivity : ', sensitivity)
# Sensitivity :  0.5027322404371585



# %% 0 - 
specificity = cm1[0, 0] / (cm1[0, 0] + cm1[0, 1])
print('Specificity : ', specificity)
# Specificity :  0.9245647969052224




# %% 0 - 
print(classification_report(data['DEFAULTER'], predicted_class))
#               precision    recall  f1-score   support

#            0       0.84      0.92      0.88       517
#            1       0.70      0.50      0.59       183

#     accuracy                           0.81       700
#    macro avg       0.77      0.71      0.73       700
# weighted avg       0.80      0.81      0.80       700
