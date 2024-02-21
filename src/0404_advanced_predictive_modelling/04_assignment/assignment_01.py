#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Feb 21 15:49:46 2024

@author: jerry

    BACKGROUND:
    
      The Data for a Study of Risk Factors Associated with Low Infant Birth Weight.
      Data were collected at Baystate Medical Center, Springfield, Massachusetts.
    
    Description of variables:
    
      LOW   – Low Birth Weight (0 means Not low and 1 means low)
      AGE   - Age of the Mother in Years
      LWT   - Weight in Pounds at the Last Menstrual Period
      RACE  - Race (1 = White, 2 = Black, 3 = Other)
      SMOKE - Smoking Status During Pregnancy (1 = Yes, 0 = No)
      PTL   - History of Premature Labor (0 = None, 1 = One, etc.)
      HT    - History of Hypertension (1 = Yes, 0 = No)
      UI    - Presence of Uterine Irritability (1 = Yes, 0 = No)
      FTV   - Number of Physician Visits During the First Trimester (0 = None, 1 = One, 2 = Two, etc.)
    
    Consider LOW as dependent variable and remaining variables listed above as
    independent variables.

"""



# %% 0 - Import libraries
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

from scipy.stats import chi2_contingency
from statsmodels.formula.api import logit
from sklearn.metrics import roc_curve, roc_auc_score



# %% 1 - Import BIRTH WEIGHT data.
data = pd.read_csv("../../../data/0404_advanced_predictive_modelling/assignment/BIRTH WEIGHT.csv")

data.head()
#    SR NO  ID  LOW  AGE  LWT  RACE  SMOKE  PTL  HT  UI  FTV
# 0      1  85    0   19  182     2      0    0   0   0    0
# 1      2  86    0   33  155     3      0    0   0   0    3
# 2      3  87    0   20  105     1      1    0   0   0    1
# 3      4  88    0   21  108     1      1    0   0   1    2
# 4      5  89    0   18  107     1      1    0   0   1    0


data.info()
# RangeIndex: 189 entries, 0 to 188
# Data columns (total 11 columns):
#  #   Column  Non-Null Count  Dtype
# ---  ------  --------------  -----
#  0   SR NO   189 non-null    int64
#  1   ID      189 non-null    int64
#  2   LOW     189 non-null    int64
#  3   AGE     189 non-null    int64
#  4   LWT     189 non-null    int64
#  5   RACE    189 non-null    int64
#  6   SMOKE   189 non-null    int64
#  7   PTL     189 non-null    int64
#  8   HT      189 non-null    int64
#  9   UI      189 non-null    int64
#  10  FTV     189 non-null    int64
# dtypes: int64(11)
# memory usage: 16.4 KB


# we engineer some features - converting numerical and other data into
# categorical data with two or more levels - for example, in the case of two 
# levels, the new value is 0 if below the mean / median or 1 if above 

data.AGE.describe()
# count    189.000000
# mean      23.238095
# std        5.298678
# min       14.000000
# 25%       19.000000
# 50%       23.000000
# 75%       26.000000
# max       45.000000
# Name: AGE, dtype: float64

# construct a factor (0, 1) -> below / above median AGE
data['AGE_F'] = np.where(data.AGE <= 23, 0, 1)


data.LWT.describe()
# count    189.000000
# mean     129.814815
# std       30.579380
# min       80.000000
# 25%      110.000000
# 50%      121.000000
# 75%      140.000000
# max      250.000000
# Name: LWT, dtype: float64

# construct a factor (0, 1) -> below / above median FTL
data['LWT_F'] = np.where(data.LWT <= 121.0, 0, 1)


data.PTL.describe()
# count    189.000000
# mean       0.195767
# std        0.493342
# min        0.000000
# 25%        0.000000
# 50%        0.000000
# 75%        0.000000
# max        3.000000
# Name: PTL, dtype: float64

data['PTL_F'] = np.where(data.PTL == 0, 0, 1)


data.FTV.describe()
# count    189.000000
# mean       0.793651
# std        1.059286
# min        0.000000
# 25%        0.000000
# 50%        0.000000
# 75%        1.000000
# max        6.000000
# Name: FTV, dtype: float64

data['FTV_F'] = np.where(data.FTV == 0, 0, 1)


data.RACE.describe()
# count    189.000000
# mean       1.846561
# std        0.918342
# min        1.000000
# 25%        1.000000
# 50%        1.000000
# 75%        3.000000
# max        3.000000
# Name: RACE, dtype: float64

data['RACE_F'] = np.where(data.RACE == 1, 0, 1)


data['AGE_F']  = data['AGE_F'].astype('category')
data['LWT_F']  = data['LWT_F'].astype('category')
data['PTL_F']  = data['PTL_F'].astype('category')
data['FTV_F']  = data['FTV_F'].astype('category')
data['RACE_F'] = data['RACE_F'].astype('category')

#data['LOW']    = data['LOW'].astype('category')
data['RACE']   = data['RACE'].astype('category')
data['SMOKE']  = data['SMOKE'].astype('category')
data['HT']     = data['HT'].astype('category')
data['UI']     = data['UI'].astype('category')


data.info()
# RangeIndex: 189 entries, 0 to 188
# Data columns (total 16 columns):
#  #   Column  Non-Null Count  Dtype
# ---  ------  --------------  -----
#  0   SR NO   189 non-null    int64
#  1   ID      189 non-null    int64
#  2   LOW     189 non-null    int64
#  3   AGE     189 non-null    int64
#  4   LWT     189 non-null    int64
#  5   RACE    189 non-null    category
#  6   SMOKE   189 non-null    category
#  7   PTL     189 non-null    int64
#  8   HT      189 non-null    category
#  9   UI      189 non-null    category
#  10  FTV     189 non-null    int64
#  11  AGE_F   189 non-null    category
#  12  LWT_F   189 non-null    category
#  13  PTL_F   189 non-null    category
#  14  FTV_F   189 non-null    category
#  15  RACE_F  189 non-null    category
# dtypes: category(9), int64(7)
# memory usage: 13.2 KB



# %% 2 - Cross tabulate dependent variable with each independent variable.
#        (below I use the symbols '~=' to denote 'approximately equal to')
pd.crosstab(data.LOW, data.AGE)
# AGE  14  15  16  17  18  19  20  21  22  ...  29  30  31  32  33  34  35  36  45
# LOW                                      ...                                    
# 0     1   1   6   7   8  13  10   7  11  ...   6   6   4   5   3   0   2   2   1
# 1     2   2   1   5   2   3   8   5   2  ...   1   1   1   1   0   1   0   0   0

# [2 rows x 24 columns]

table = pd.crosstab(data.LOW, data.AGE_F)
table
# AGE_F   0   1
# LOW          
# 0      72  58
# 1      35  24

chi2_contingency(table, correction = False)
# Chi2ContingencyResult(statistic=0.256143120497356, pvalue=0.6127823515893642, dof=1, expected_freq=array([[73.5978836, 56.4021164],
#        [33.4021164, 25.5978836]]))

# p-value ~= 0.61
# fail to reject the null hypothesis that LOW and AGE_F are not associated


pd.crosstab(data.LOW, data.LWT)
# LWT  80   85   89   90   91   92   94   ...  200  202  215  229  235  241  250
# LOW                                     ...                                   
# 0      0    1    0    3    0    0    0  ...    0    1    1    1    1    1    1
# 1      1    1    1    0    1    1    1  ...    1    0    0    0    0    0    0

# [2 rows x 75 columns]

table = pd.crosstab(data.LOW, data.LWT_F)
table
# LWT_F   0   1
# LOW          
# 0      61  69
# 1      35  24

chi2_contingency(table, correction = False)
# Chi2ContingencyResult(statistic=2.49616501766413, pvalue=0.1141238973738551, dof=1, expected_freq=array([[66.03174603, 63.96825397],
#        [29.96825397, 29.03174603]]))

# p-value ~= 0.11
# fail to reject the null hypothesis that LOW and LWT_F are not associated


pd.crosstab(data.LOW, data.PTL)
# PTL    0   1  2  3
# LOW               
# 0    118   8  3  1
# 1     41  16  2  0

table = pd.crosstab(data.LOW, data.PTL_F)
table
# PTL_F    0   1
# LOW           
# 0      118  12
# 1       41  18

chi2_contingency(table, correction = False)
# Chi2ContingencyResult(statistic=13.75904750190647, pvalue=0.0002078174533940797, dof=1, expected_freq=array([[109.36507937,  20.63492063],
#        [ 49.63492063,   9.36507937]]))

# p-value ~= 0.0002
# reject the null hypothesis that LOW and PTL_F are not associated


pd.crosstab(data.LOW, data.FTV)
# FTV   0   1   2  3  4  6
# LOW                     
# 0    64  36  23  3  3  1
# 1    36  11   7  4  1  0

table = pd.crosstab(data.LOW, data.FTV_F)
table
# FTV_F   0   1
# LOW          
# 0      64  66
# 1      36  23

chi2_contingency(table, correction = False)
# Chi2ContingencyResult(statistic=2.2626287154095186, pvalue=0.132528930132142, dof=1, expected_freq=array([[68.78306878, 61.21693122],
#        [31.21693122, 27.78306878]]))

# p-value ~= 0.13
# fail to reject the null hypothesis that LOW and FTV_F are not associated


pd.crosstab(data.LOW, data.RACE)
# RACE   1   2   3
# LOW             
# 0     73  15  42
# 1     23  11  25

table = pd.crosstab(data.LOW, data.RACE_F)
table
# RACE_F   0   1
# LOW           
# 0       73  57
# 1       23  36

chi2_contingency(table, correction = False)
# Chi2ContingencyResult(statistic=4.787224655128904, pvalue=0.028671588978578095, dof=1, expected_freq=array([[66.03174603, 63.96825397],
#        [29.96825397, 29.03174603]]))

# p-value ~= 0.03
# reject the null hypothesis that LOW and RACE_F are not associated


table = pd.crosstab(data.LOW, data.SMOKE)
table
# SMOKE   0   1
# LOW          
# 0      86  44
# 1      29  30

chi2_contingency(table, correction = False)
# Chi2ContingencyResult(statistic=4.923705434361292, pvalue=0.026490642530502487, dof=1, expected_freq=array([[79.1005291, 50.8994709],
#        [35.8994709, 23.1005291]]))

# p-value ~= 0.03
# reject the null hypothesis that LOW and SMOKE are not associated


table = pd.crosstab(data.LOW, data.HT)
table
# HT     0  1
# LOW        
# 0    125  5
# 1     52  7

chi2_contingency(table, correction = False)
# Chi2ContingencyResult(statistic=4.387954942213776, pvalue=0.036193702173236975, dof=1, expected_freq=array([[121.74603175,   8.25396825],
#        [ 55.25396825,   3.74603175]]))

# p-value ~= 0.04
# reject the null hypothesis that LOW and HT are not associated


table = pd.crosstab(data.LOW, data.UI)
table
# UI     0   1
# LOW         
# 0    117  13
# 1     45  14

chi2_contingency(table, correction = False)
# Chi2ContingencyResult(statistic=6.246610169491525, pvalue=0.012443121218919044, dof=1, expected_freq=array([[111.42857143,  18.57142857],
#        [ 50.57142857,   8.42857143]]))

# p-value ~= 0.01
# reject the null hypothesis that LOW and UI are not associated



# from looking at the results of the Chi-squared tests, it appears that the
# factor variables / features with an association with LOW are:
# - SMOKE
# - RACE_F
# - PTL_F
# - HT
# - UI
# While this is a good first step, and can help with understanding the data, it 
# should not incline us to exclude features from a model - we need to build a 
# model with all independent variables to get a  better understanding of which 
# features are actually important with respect to prediction.



# %% 3 - Develop a model to predict if birth weight is low or not using the given variables.

# we start with the basic independent variables:
    
model1 = logit('LOW ~ AGE + LWT + RACE + SMOKE + PTL + HT + UI + FTV', data = data).fit()
# Optimization terminated successfully.
#          Current function value: 0.531508
#          Iterations 6

model1.summary()
# """
#                            Logit Regression Results                           
# ==============================================================================
# Dep. Variable:                    LOW   No. Observations:                  189
# Model:                          Logit   Df Residuals:                      179
# Method:                           MLE   Df Model:                            9
# Date:                Wed, 21 Feb 2024   Pseudo R-squ.:                  0.1439
# Time:                        16:58:20   Log-Likelihood:                -100.45
# converged:                       True   LL-Null:                       -117.34
# Covariance Type:            nonrobust   LLR p-value:                 9.832e-05
# ==============================================================================
#                  coef    std err          z      P>|z|      [0.025      0.975]
# ------------------------------------------------------------------------------
# Intercept      0.4428      1.198      0.370      0.712      -1.906       2.792
# RACE[T.2]      1.2935      0.528      2.448      0.014       0.258       2.329
# RACE[T.3]      0.8766      0.441      1.988      0.047       0.012       1.741
# SMOKE[T.1]     0.9304      0.402      2.312      0.021       0.142       1.719
# HT[T.1]        1.8548      0.696      2.666      0.008       0.491       3.218
# UI[T.1]        0.8310      0.467      1.780      0.075      -0.084       1.746
# AGE           -0.0298      0.037     -0.804      0.421      -0.102       0.043
# LWT           -0.0151      0.007     -2.178      0.029      -0.029      -0.002
# PTL            0.5355      0.346      1.549      0.121      -0.142       1.213
# FTV            0.0620      0.172      0.360      0.719      -0.276       0.400
# ==============================================================================



# now we build a model with the engineered features replacing the numeric 
# features:

model2 = logit('LOW ~ AGE_F + LWT_F + RACE_F + SMOKE + PTL_F + HT + UI + FTV_F', data = data).fit()
# Optimization terminated successfully.
#          Current function value: 0.534194
#          Iterations 6

model2.summary()
# """
#                            Logit Regression Results                           
# ==============================================================================
# Dep. Variable:                    LOW   No. Observations:                  189
# Model:                          Logit   Df Residuals:                      180
# Method:                           MLE   Df Model:                            8
# Date:                Wed, 21 Feb 2024   Pseudo R-squ.:                  0.1395
# Time:                        17:01:36   Log-Likelihood:                -100.96
# converged:                       True   LL-Null:                       -117.34
# Covariance Type:            nonrobust   LLR p-value:                 6.840e-05
# ===============================================================================
#                   coef    std err          z      P>|z|      [0.025      0.975]
# -------------------------------------------------------------------------------
# Intercept      -1.8420      0.519     -3.547      0.000      -2.860      -0.824
# AGE_F[T.1]     -0.0588      0.368     -0.160      0.873      -0.780       0.663
# LWT_F[T.1]     -0.3313      0.361     -0.918      0.359      -1.039       0.376
# RACE_F[T.1]     0.9479      0.400      2.370      0.018       0.164       1.732
# SMOKE[T.1]      0.8475      0.401      2.115      0.034       0.062       1.633
# PTL_F[T.1]      1.2119      0.460      2.636      0.008       0.311       2.113
# HT[T.1]         1.4555      0.654      2.226      0.026       0.174       2.737
# UI[T.1]         0.8383      0.471      1.781      0.075      -0.084       1.761
# FTV_F[T.1]     -0.2159      0.360     -0.600      0.549      -0.921       0.490
# ===============================================================================
# """



# from looking at the above model summaries, it appears that the independent
# variables / features of significance are:
# - LWT
# - RACE_F
# - SMOKE
# - PTL_F
# - HT
# - UI (at the 0.1 level of significance)
#
# while insignificant, the independent variables AGE and LWT negatively 
# influence the outcome, while all other independent variables positively 
# influence the outcome



# rebuilding the model, omitting the insignificant features:

model = logit('LOW ~ LWT + RACE_F + SMOKE + PTL_F + HT + UI', data = data).fit()
# Optimization terminated successfully.
#          Current function value: 0.524469
#          Iterations 6

model.summary()
# """
#                            Logit Regression Results                           
# ==============================================================================
# Dep. Variable:                    LOW   No. Observations:                  189
# Model:                          Logit   Df Residuals:                      182
# Method:                           MLE   Df Model:                            6
# Date:                Wed, 21 Feb 2024   Pseudo R-squ.:                  0.1552
# Time:                        17:05:22   Log-Likelihood:                -99.125
# converged:                       True   LL-Null:                       -117.34
# Covariance Type:            nonrobust   LLR p-value:                 2.281e-06
# ===============================================================================
#                   coef    std err          z      P>|z|      [0.025      0.975]
# -------------------------------------------------------------------------------
# Intercept      -0.4215      0.921     -0.458      0.647      -2.226       1.383
# RACE_F[T.1]     1.0190      0.396      2.572      0.010       0.242       1.796
# SMOKE[T.1]      0.9255      0.399      2.322      0.020       0.144       1.707
# PTL_F[T.1]      1.1120      0.451      2.464      0.014       0.228       1.996
# HT[T.1]         1.8445      0.704      2.619      0.009       0.464       3.225
# UI[T.1]         0.7843      0.469      1.673      0.094      -0.135       1.703
# LWT            -0.0139      0.007     -2.104      0.035      -0.027      -0.001
# ===============================================================================
# """



# from looking at the improved model summary, it appears that all the
# independent variables / features are significant.
# - LWT
# - RACE_F
# - SMOKE
# - PTL_F
# - HT
# - UI (at the 0.1 level of significance)
#
# the independent variable LWT continues to negatively influence the outcome,
# while all other independent variables positively influence the outcome



# comparing with a model that uses all of the significant features, but the
# non-engineered versions:

model3 = logit('LOW ~ LWT + RACE + SMOKE + PTL + HT + UI', data = data).fit()
# Optimization terminated successfully.
#          Current function value: 0.533364
#          Iterations 6

model3.summary()
# """
#                            Logit Regression Results                           
# ==============================================================================
# Dep. Variable:                    LOW   No. Observations:                  189
# Model:                          Logit   Df Residuals:                      181
# Method:                           MLE   Df Model:                            7
# Date:                Wed, 21 Feb 2024   Pseudo R-squ.:                  0.1409
# Time:                        17:09:19   Log-Likelihood:                -100.81
# converged:                       True   LL-Null:                       -117.34
# Covariance Type:            nonrobust   LLR p-value:                 2.580e-05
# ==============================================================================
#                  coef    std err          z      P>|z|      [0.025      0.975]
# ------------------------------------------------------------------------------
# Intercept     -0.1320      0.953     -0.138      0.890      -2.000       1.736
# RACE[T.2]      1.3489      0.524      2.576      0.010       0.323       2.375
# RACE[T.3]      0.8950      0.434      2.063      0.039       0.045       1.746
# SMOKE[T.1]     0.9316      0.399      2.336      0.019       0.150       1.713
# HT[T.1]        1.8478      0.693      2.665      0.008       0.489       3.207
# UI[T.1]        0.8484      0.465      1.826      0.068      -0.062       1.759
# LWT           -0.0156      0.007     -2.272      0.023      -0.029      -0.002
# PTL            0.4952      0.341      1.450      0.147      -0.174       1.164
# ==============================================================================
# """



# because the model that uses the engineered features seems to have more
# significant features I will retain it for the purpose of this assignment.



# %% 4 - Generate three classification tables with cut-off values 0.4, 0.3 and 0.55.
data['pred_prob'] = model.predict()

pred1 = np.where(data.pred_prob <= 0.4,  0, 1)
pred2 = np.where(data.pred_prob <= 0.3,  0, 1)
pred3 = np.where(data.pred_prob <= 0.55, 0, 1)

table1 = pd.crosstab(pred1, data.LOW)
table2 = pd.crosstab(pred2, data.LOW)
table3 = pd.crosstab(pred3, data.LOW)

table1
# LOW      0   1
# row_0         
# 0      107  27
# 1       23  32

table2
# LOW     0   1
# row_0        
# 0      97  20
# 1      33  39

table3
# LOW      0   1
# row_0         
# 0      122  41
# 1        8  18



# %% 5 - Calculate sensitivity,specificity and mis-classification rate for all three tables above. What is the recommended cut-off value?
sensitivity1 = (table1.iloc[1, 1] / (table1.iloc[0, 1] + table1.iloc[1, 1])) * 100
specificity1 = (table1.iloc[0, 0] / (table1.iloc[0, 0] + table1.iloc[1, 0])) * 100
accuracy1    = ((table1.iloc[0, 0] + table1.iloc[1, 1]) / data.shape[0]) * 100
misclass1    = ((table1.iloc[0, 1] + table1.iloc[1, 0]) / data.shape[0]) * 100
falsepos1    = (table1.iloc[1, 0] / (table1.iloc[0, 0] + table1.iloc[1, 0])) * 100

print("Sensitivity for cut-off 0.4 is :", round(sensitivity1, 2))
# Sensitivity for cut-off 0.4 is : 54.24
print("Specificity for cut-off 0.4 is :", round(specificity1, 2))
# Specificity for cut-off 0.4 is : 82.31
print("Accuracy for cut-off 0.4 is :", round(accuracy1, 2))
# Accuracy for cut-off 0.4 is : 73.54
print("Mis-Classification for cut-off 0.4 is :", round(misclass1, 2))
# Mis-Classification for cut-off 0.4 is : 26.46
print("The sum of Sensitivity and Specificity for cut-off 0.4 is :", round(sensitivity1 + specificity1, 2))
# The sum of Sensitivity and Specificity for cut-off 0.4 is : 136.54
print("The difference of Sensitivity and Specificity for cut-off 0.4 is :", abs(round(sensitivity1 - specificity1, 2)))
# The difference of Sensitivity and Specificity for cut-off 0.4 is : 28.07
print("False Positive Rate for cut-off 0.4 is :", round(falsepos1, 2))
# False Positive Rate for cut-off 0.4 is : 17.69



sensitivity2 = (table2.iloc[1, 1] / (table2.iloc[0, 1] + table2.iloc[1, 1])) * 100
specificity2 = (table2.iloc[0, 0] / (table2.iloc[0, 0] + table2.iloc[1, 0])) * 100
accuracy2    = ((table2.iloc[0, 0] + table2.iloc[1, 1]) / data.shape[0]) * 100
misclass2    = ((table2.iloc[0, 1] + table2.iloc[1, 0]) / data.shape[0]) * 100
falsepos2    = (table2.iloc[1, 0] / (table2.iloc[0, 0] + table2.iloc[1, 0])) * 100

print("Sensitivity for cut-off 0.3 is :", round(sensitivity2, 2))
# Sensitivity for cut-off 0.3 is : 66.1
print("Specificity for cut-off 0.3 is :", round(specificity2, 2))
# Specificity for cut-off 0.3 is : 74.62
print("Accuracy for cut-off 0.3 is :", round(accuracy2, 2))
# Accuracy for cut-off 0.3 is : 71.96
print("Mis-Classification for cut-off 0.3 is :", round(misclass2, 2))
# Mis-Classification for cut-off 0.3 is : 28.04
print("The sum of Sensitivity and Specificity for cut-off 0.3 is :", round(sensitivity2 + specificity2, 2))
# The sum of Sensitivity and Specificity for cut-off 0.3 is : 140.72
print("The difference of Sensitivity and Specificity for cut-off 0.3 is :", abs(round(sensitivity2 - specificity2, 2)))
# The difference of Sensitivity and Specificity for cut-off 0.3 is : 8.51
print("False Positive Rate for cut-off 0.3 is :", round(falsepos2, 2))
# False Positive Rate for cut-off 0.3 is : 25.38



sensitivity3 = (table3.iloc[1, 1] / (table3.iloc[0, 1] + table3.iloc[1, 1])) * 100
specificity3 = (table3.iloc[0, 0] / (table3.iloc[0, 0] + table3.iloc[1, 0])) * 100
accuracy3    = ((table3.iloc[0, 0] + table3.iloc[1, 1]) / data.shape[0]) * 100
misclass3    = ((table3.iloc[0, 1] + table3.iloc[1, 0]) / data.shape[0]) * 100
falsepos3    = (table3.iloc[1, 0] / (table3.iloc[0, 0] + table3.iloc[1, 0])) * 100

print("Sensitivity for cut-off 0.55 is :", round(sensitivity3, 2))
# Sensitivity for cut-off 0.55 is : 30.51
print("Specificity for cut-off 0.55 is :", round(specificity3, 2))
# Specificity for cut-off 0.55 is : 93.85
print("Accuracy for cut-off 0.55 is :", round(accuracy3, 2))
# Accuracy for cut-off 0.55 is : 74.07
print("Mis-Classification for cut-off 0.55 is :", round(misclass3, 2))
# Mis-Classification for cut-off 0.55 is : 25.93
print("The sum of Sensitivity and Specificity for cut-off 0.55 is :", round(sensitivity3 + specificity3, 2))
# The sum of Sensitivity and Specificity for cut-off 0.55 is : 124.35
print("The difference of Sensitivity and Specificity for cut-off 0.55 is :", abs(round(sensitivity3 - specificity3, 2)))
# The difference of Sensitivity and Specificity for cut-off 0.55 is : 63.34
print("False Positive Rate for cut-off 0.55 is :", round(falsepos3, 2))
# False Positive Rate for cut-off 0.55 is : 6.15


# of the three cut-off values above, and based on the criteria of maximizing
# both sensitivity and specificity, it looks as if the cut-off value of 0.3
# is the best choice. But we can be more precise by calculating the optimal 
# cut-off value in code:

fpr, tpr, thresholds = roc_curve(data.LOW, data['pred_prob'])

threshold = thresholds[np.argmax(tpr - fpr)]
threshold = round(threshold, 2)
print("Best Threshold maximizing sensitivity and specificity is :", threshold)
# Best Threshold maximizing sensitivity and specificity is : 0.3



# see image_01_Python.png
plt.figure(figsize = (8, 6))

plt.plot(thresholds, tpr, label = 'TPR', color = 'blue')
plt.plot(thresholds, 1 - fpr, label = '1 - FPR', color = 'red')

plt.xlim([0.0, 1.0])
plt.ylim([0.0, 1.05])
plt.xlabel('Cut-off')
plt.title('TPR vs 1 - FPR Curve')
plt.legend(loc = 'right')

plt.show()



pred4  = np.where(data.pred_prob <= threshold,  0, 1)
table4 = pd.crosstab(pred4, data.LOW)
table4
# LOW     0   1
# row_0        
# 0      97  20
# 1      33  39

sensitivity4 = (table4.iloc[1, 1] / (table4.iloc[0, 1] + table4.iloc[1, 1])) * 100
specificity4 = (table4.iloc[0, 0] / (table4.iloc[0, 0] + table4.iloc[1, 0])) * 100
accuracy4    = ((table4.iloc[0, 0] + table4.iloc[1, 1]) / data.shape[0]) * 100
misclass4    = ((table4.iloc[0, 1] + table4.iloc[1, 0]) / data.shape[0]) * 100
falsepos4    = (table4.iloc[1, 0] / (table4.iloc[0, 0] + table4.iloc[1, 0])) * 100

print("Sensitivity for cut-off", threshold, "is :", round(sensitivity4, 2))
# Sensitivity for cut-off 0.3 is : 66.1
print("Specificity for cut-off", threshold, "is :", round(specificity2, 2))
# Specificity for cut-off 0.3 is : 74.62
print("Accuracy for cut-off", threshold, "is :", round(accuracy2, 2))
# Accuracy for cut-off 0.3 is : 71.96
print("Mis-Classification for cut-off", threshold, "is :", round(misclass2, 2))
# Mis-Classification for cut-off 0.3 is : 28.04
print("The sum of Sensitivity and Specificity for cut-off", threshold, "is :", round(sensitivity2 + specificity2, 2))
# The sum of Sensitivity and Specificity for cut-off 0.3 is : 140.72
print("The difference of Sensitivity and Specificity for cut-off", threshold, "is :", abs(round(sensitivity2 - specificity2, 2)))
# The difference of Sensitivity and Specificity for cut-off 0.3 is : 8.51
print("False Positive Rate for cut-off", threshold, "is :", round(falsepos2, 2))
# False Positive Rate for cut-off 0.3 is : 25.38



# %% 6 - Obtain ROC curve and report area under curve.

# see image_02_Python.png
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



roc_auc = roc_auc_score(data.LOW, data['pred_prob'])
print("Area under the curve is :", roc_auc)
# Area under the curve is : 0.7571056062581486
