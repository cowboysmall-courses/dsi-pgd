#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat Feb  3 09:15:46 2024

@author: jerry
"""




# %% 0 - import libraries
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
import statsmodels.formula.api as smf

from sklearn.metrics import classification_report, roc_curve, roc_auc_score
from statsmodels.stats.outliers_influence import variance_inflation_factor




# %% 0 - ignore warnings
import warnings
warnings.filterwarnings("ignore")





# %% 1 - import data and check the head
data = pd.read_csv("../../../data/0404_advanced_predictive_modelling/case_study/ICU Mortality.csv")
data.rename(columns = {'INF': 'INF_C'}, inplace = True)
data.head()
#    SR NO  ID  STA  AGE  SEX  RACE  SER  ...  FRA  PO2  PH  PCO  BIC  CRE  LOC
# 0      1   8    0   27    1     1    0  ...    0    0   0    0    0    0    0
# 1      2  12    0   59    0     1    0  ...    0    0   0    0    0    0    0
# 2      3  14    0   77    0     1    1  ...    0    0   0    0    0    0    0
# 3      4  28    0   54    0     1    0  ...    1    0   0    0    0    0    0
# 4      5  32    0   87    1     1    1  ...    0    0   0    0    0    0    0

# [5 rows x 22 columns]





# %% 2 - Table of STA
df = data.copy()
df['STA'].replace({0: 'Lived', 1: 'Died'}, inplace = True)

count = df['STA'].value_counts().reset_index()
per   = df['STA'].value_counts(normalize = True).reset_index()

table = pd.merge(count, per, on = ['index'])
table.columns = ['Vital Status', 'Count', 'Proportion']
table['Percentage'] = table['Proportion'] * 100

table
#   Vital Status  Count  Proportion  Percentage
# 0        Lived    160         0.8        80.0
# 1         Died     40         0.2        20.0




# %% 3 - Box Plot of STA vs. Age
sns.set(style = "whitegrid")

plt.figure(figsize = (6, 6))

sns.boxplot(x = 'STA', y = 'AGE', data = data)
plt.title('Boxplot of AGE by Vital Status')
plt.xlabel('Vital Status')
plt.ylabel('Age')
plt.show()




# %% 4 - Table
df = data.copy()
df['SEX'].replace({0: 'Male', 1: 'Female'}, inplace = True)

table = df.groupby('SEX')['STA'].agg(['count', 'sum']).reset_index()
table.columns = ['SEX', 'Total Count', 'Death Count']
table['Death Rate (%)'] = round((table['Death Count'] / table['Total Count']) * 100, 2)

table
#       SEX  Total Count  Death Count  Death Rate (%)
# 0  Female           76           16           21.05
# 1    Male          124           24           19.35




# %% 5 - Collapse LOC
data['LOC'] = np.where(data['LOC'] > 0, 1, 0)




# %% 6 - Build Model
model = smf.logit('STA ~ AGE + SEX + SER + CAN + CRN  + INF_C + CPR + SYS + HRA + PRE + TYP + FRA + PO2 + PH + PCO + BIC + CRE + LOC', data = data).fit()
model.summary()
# """
#                            Logit Regression Results                           
# ==============================================================================
# Dep. Variable:                    STA   No. Observations:                  200
# Model:                          Logit   Df Residuals:                      181
# Method:                           MLE   Df Model:                           18
# Date:                Sat, 03 Feb 2024   Pseudo R-squ.:                  0.3485
# Time:                        10:37:43   Log-Likelihood:                -65.199
# converged:                      False   LL-Null:                       -100.08
# Covariance Type:            nonrobust   LLR p-value:                 4.957e-08
# ==============================================================================
#                  coef    std err          z      P>|z|      [0.025      0.975]
# ------------------------------------------------------------------------------
# Intercept     -3.7910      1.858     -2.040      0.041      -7.434      -0.148
# AGE            0.0437      0.016      2.735      0.006       0.012       0.075
# SEX           -0.3125      0.481     -0.649      0.516      -1.256       0.631
# SER           -0.4591      0.571     -0.805      0.421      -1.578       0.659
# CAN          -20.3059   4.28e+04     -0.000      1.000    -8.4e+04    8.39e+04
# CRN            0.0171      0.770      0.022      0.982      -1.492       1.527
# INF_C         -0.0083      0.534     -0.016      0.988      -1.055       1.039
# CPR            1.0175      0.932      1.092      0.275      -0.809       2.844
# SYS           -0.0141      0.008     -1.811      0.070      -0.029       0.001
# HRA           -0.0031      0.009     -0.338      0.735      -0.021       0.015
# PRE            0.6321      0.607      1.042      0.298      -0.557       1.821
# TYP            1.9318      0.956      2.020      0.043       0.057       3.806
# FRA            0.8281      0.988      0.838      0.402      -1.108       2.764
# PO2            0.2138      0.776      0.275      0.783      -1.308       1.735
# PH             2.0639      1.085      1.901      0.057      -0.063       4.191
# PCO           -2.4211      1.180     -2.051      0.040      -4.735      -0.107
# BIC           -0.8013      0.856     -0.936      0.349      -2.480       0.877
# CRE            0.5011      0.933      0.537      0.591      -1.327       2.330
# LOC            4.3062      1.081      3.984      0.000       2.188       6.425
# ==============================================================================
# """




# %% 7 - VIF
vif_data = pd.DataFrame()

vif_data["Feature"] = model.model.exog_names[1:]
vif_data["VIF"]     = [variance_inflation_factor(model.model.exog, i) for i in range(1, model.model.exog.shape[1])]

vif_data
#    Feature       VIF
# 0      AGE  1.347618
# 1      SEX  1.096121
# 2      SER  1.927416
# 3      CAN  1.375821
# 4      CRN  1.319146
# 5    INF_C  1.332957
# 6      CPR  1.315199
# 7      SYS  1.171510
# 8      HRA  1.294332
# 9      PRE  1.167468
# 10     TYP  1.892265
# 11     FRA  1.259913
# 12     PO2  1.404664
# 13      PH  1.622939
# 14     PCO  1.744181
# 15     BIC  1.382282
# 16     CRE  1.260468
# 17     LOC  1.246863



# %% 8 - ROC Curve
data['predicted_prob'] = model.predict(data)

fpr, tpr, thresholds = roc_curve(data['STA'], data['predicted_prob'])

plt.figure(figsize = (8, 6))

plt.plot(fpr, tpr, label = 'ROC Curve')
plt.plot([0, 1], [0, 1], 'k--', label = 'Random Guess')

plt.xlim([0.0, 1.0])
plt.ylim([0.0, 1.05])
plt.xlabel('False Positive Rate (FPR)')
plt.ylabel('True Positive Rate (TPR)')
plt.title('Receiver Operating Characteristic (ROC) Curve')
plt.legend(loc = 'lower right')

plt.show()



# %% 9 - AUC Curve
auc_roc = roc_auc_score(data['STA'], data['predicted_prob'])
print(f'AUC ROC: {auc_roc}')
# AUC ROC: 0.85609375




# %% 10 - Optimal Threshold
optimal_threshold = round(thresholds[np.argmax(tpr - fpr)], 3)
print(f'Best Threshold is : {optimal_threshold}')
# Best Threshold is : 0.28



# %% 11 - Classification Report
data['predicted_class'] = (data['predicted_prob'] > optimal_threshold).astype(int)
print(classification_report(data['STA'], data['predicted_class']))
#               precision    recall  f1-score   support

#            0       0.91      0.89      0.90       160
#            1       0.60      0.65      0.63        40

#     accuracy                           0.84       200
#    macro avg       0.76      0.77      0.76       200
# weighted avg       0.85      0.84      0.85       200
