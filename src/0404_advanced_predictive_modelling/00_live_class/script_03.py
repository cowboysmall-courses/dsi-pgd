#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat Feb 10 09:22:44 2024

@author: jerry
"""




# %% 0 - Import libraries
import pandas as pd
import numpy as np

from statsmodels.formula.api import logit
from sklearn.metrics import classification_report
from sklearn.model_selection import train_test_split, cross_val_predict
from sklearn.linear_model import LogisticRegression




# %% 1 - Import data and check the head
data = pd.read_csv("./data/0404_advanced_predictive_modelling/live_class/BANK LOAN.csv")
data.head()
#    SN  AGE  EMPLOY  ADDRESS  DEBTINC  CREDDEBT  OTHDEBT  DEFAULTER
# 0   1    3      17       12      9.3     11.36     5.01          1
# 1   2    1      10        6     17.3      1.36     4.00          0
# 2   3    2      15       14      5.5      0.86     2.17          0
# 3   4    3      15       14      2.9      2.66     0.82          0
# 4   5    1       2        0     17.3      1.79     3.06          1




# %% 2 - Convert Gender to factor
data['AGE'] = data['AGE'].astype('category')
data.dtypes
# SN              int64
# AGE          category
# EMPLOY          int64
# ADDRESS         int64
# DEBTINC       float64
# CREDDEBT      float64
# OTHDEBT       float64
# DEFAULTER       int64
# dtype: object




# %% 3 - Build Model
model = logit('DEFAULTER ~ AGE + EMPLOY + ADDRESS + DEBTINC + CREDDEBT + OTHDEBT', data = data).fit()
model.summary()
# """
#                            Logit Regression Results                           
# ==============================================================================
# Dep. Variable:              DEFAULTER   No. Observations:                  700
# Model:                          Logit   Df Residuals:                      692
# Method:                           MLE   Df Model:                            7
# Date:                Sat, 10 Feb 2024   Pseudo R-squ.:                  0.3120
# Time:                        09:28:35   Log-Likelihood:                -276.70
# converged:                       True   LL-Null:                       -402.18
# Covariance Type:            nonrobust   LLR p-value:                 1.733e-50
# ==============================================================================
#                  coef    std err          z      P>|z|      [0.025      0.975]
# ------------------------------------------------------------------------------
# Intercept     -0.7882      0.264     -2.985      0.003      -1.306      -0.271
# AGE[T.2]       0.2520      0.267      0.946      0.344      -0.270       0.774
# AGE[T.3]       0.6271      0.361      1.739      0.082      -0.080       1.334
# EMPLOY        -0.2617      0.032     -8.211      0.000      -0.324      -0.199
# ADDRESS       -0.0996      0.022     -4.459      0.000      -0.143      -0.056
# DEBTINC        0.0851      0.022      3.845      0.000       0.042       0.128
# CREDDEBT       0.5634      0.089      6.347      0.000       0.389       0.737
# OTHDEBT        0.0231      0.057      0.405      0.685      -0.089       0.135
# ==============================================================================
# """




# %% 4 - Finalize the model by excluding insignificant variables
model = logit('DEFAULTER ~ EMPLOY + ADDRESS + DEBTINC + CREDDEBT', data = data).fit()
model.summary()
# """
#                            Logit Regression Results                           
# ==============================================================================
# Dep. Variable:              DEFAULTER   No. Observations:                  700
# Model:                          Logit   Df Residuals:                      695
# Method:                           MLE   Df Model:                            4
# Date:                Sat, 10 Feb 2024   Pseudo R-squ.:                  0.3079
# Time:                        09:30:17   Log-Likelihood:                -278.37
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




# %% 5 - Split data into train and test
train, test = train_test_split(data, test_size = 0.3)
# train.shape
# test.shape




# %% 6 - Rebuild model with training data
model = logit('DEFAULTER ~ EMPLOY + ADDRESS + DEBTINC + CREDDEBT', data = train).fit()
model.summary()
# """
#                            Logit Regression Results                           
# ==============================================================================
# Dep. Variable:              DEFAULTER   No. Observations:                  490
# Model:                          Logit   Df Residuals:                      485
# Method:                           MLE   Df Model:                            4
# Date:                Sat, 10 Feb 2024   Pseudo R-squ.:                  0.3030
# Time:                        10:25:47   Log-Likelihood:                -197.60
# converged:                       True   LL-Null:                       -283.48
# Covariance Type:            nonrobust   LLR p-value:                 4.358e-36
# ==============================================================================
#                  coef    std err          z      P>|z|      [0.025      0.975]
# ------------------------------------------------------------------------------
# Intercept     -0.5476      0.301     -1.822      0.068      -1.137       0.041
# EMPLOY        -0.2557      0.034     -7.574      0.000      -0.322      -0.190
# ADDRESS       -0.0850      0.024     -3.574      0.000      -0.132      -0.038
# DEBTINC        0.0706      0.022      3.253      0.001       0.028       0.113
# CREDDEBT       0.6137      0.102      6.014      0.000       0.414       0.814
# ==============================================================================
# """




# %% 7 - Generate classification report for training data
predicted_values = model.predict()
threshold = 0.3

# predicted_class = np.zeros(predicted_values.shape)
# predicted_class[predicted_values > threshold] = 1
predicted_class = np.where(predicted_values > threshold, 1, 0)

print(classification_report(train['DEFAULTER'], predicted_class))
#               precision    recall  f1-score   support

#            0       0.89      0.78      0.83       360
#            1       0.55      0.75      0.63       130

#     accuracy                           0.77       490
#    macro avg       0.72      0.76      0.73       490
# weighted avg       0.80      0.77      0.78       490




# %% 8 - Generate classification report for testing data
predicted_values = model.predict(test)
threshold = 0.3

# predicted_class = np.zeros(predicted_values.shape)
# predicted_class[predicted_values > threshold] = 1
predicted_class = np.where(predicted_values > threshold, 1, 0)

print(classification_report(test['DEFAULTER'], predicted_class))
#               precision    recall  f1-score   support

#            0       0.91      0.81      0.86       157
#            1       0.57      0.75      0.65        53

#     accuracy                           0.80       210
#    macro avg       0.74      0.78      0.75       210
# weighted avg       0.82      0.80      0.80       210




# %% 9 - K-fold cross validation
X = data[['EMPLOY', 'ADDRESS', 'DEBTINC', 'CREDDEBT']]
y = data.DEFAULTER

predicted_values = cross_val_predict(LogisticRegression(), X, y, cv = 4, method = 'predict_proba')
threshold = 0.3

predicted_values = predicted_values[:, 1]

# predicted_class = np.zeros(predicted_values.shape)
# predicted_class[predicted_values > threshold] = 1
predicted_class = np.where(predicted_values > threshold, 1, 0)

print(classification_report(y, predicted_class))
#               precision    recall  f1-score   support

#            0       0.90      0.80      0.85       517
#            1       0.57      0.75      0.65       183

#     accuracy                           0.79       700
#    macro avg       0.74      0.77      0.75       700
# weighted avg       0.81      0.79      0.80       700
