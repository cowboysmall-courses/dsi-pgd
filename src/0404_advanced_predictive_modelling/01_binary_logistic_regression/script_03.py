#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat Feb 17 17:28:39 2024

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
data = pd.read_csv("../../../data/0404_advanced_predictive_modelling/live_class/BANK LOAN.csv")



# %% 2 - 
X_train, X_test = train_test_split(data, test_size = 0.3)
X_train.shape
# (490, 8)
X_test.shape
# (210, 8)



# %% 2 - 
model = logit("DEFAULTER ~ EMPLOY + ADDRESS + DEBTINC + CREDDEBT", data = X_train).fit()

threshold = 0.3

predicted_values = model.predict()
predicted_class = np.zeros(predicted_values.shape)
predicted_class[predicted_values > threshold] = 1

print(classification_report(X_train["DEFAULTER"], predicted_class))
# Optimization terminated successfully.
#          Current function value: 0.412806
#          Iterations 7
#               precision    recall  f1-score   support

#            0       0.88      0.78      0.83       367
#            1       0.51      0.67      0.58       123

#     accuracy                           0.76       490
#    macro avg       0.69      0.73      0.70       490
# weighted avg       0.79      0.76      0.77       490



# %% 2 - 
threshold = 0.3

predicted_values = model.predict(X_test)
predicted_class = np.zeros(predicted_values.shape)
predicted_class[predicted_values > threshold] = 1

print(classification_report(X_test["DEFAULTER"], predicted_class))
#               precision    recall  f1-score   support

#            0       0.93      0.85      0.89       150
#            1       0.69      0.83      0.76        60

#     accuracy                           0.85       210
#    macro avg       0.81      0.84      0.82       210
# weighted avg       0.86      0.85      0.85       210




# %% 2 - 
X = data[["EMPLOY", "ADDRESS", "DEBTINC", "CREDDEBT"]]
y = data.DEFAULTER

threshold = 0.3

predicted_prob = cross_val_predict(LogisticRegression(), X, y, cv = 4, method = "predict_proba")

predicted = predicted_prob[:,1]
predicted_class = np.zeros(predicted.shape)
predicted_class[predicted > threshold] = 1

print(classification_report(y, predicted_class))
#               precision    recall  f1-score   support

#            0       0.90      0.80      0.85       517
#            1       0.57      0.75      0.65       183

#     accuracy                           0.79       700
#    macro avg       0.74      0.77      0.75       700
# weighted avg       0.81      0.79      0.80       700
