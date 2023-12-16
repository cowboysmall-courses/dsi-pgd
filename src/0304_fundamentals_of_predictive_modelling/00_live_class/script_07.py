#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat Dec 16 10:20:18 2023

@author: jerry
"""


# %% 0 - import libraries

import pandas as pd
import numpy as np

from sklearn.model_selection import cross_val_score, RepeatedKFold
from sklearn import linear_model



# %% 1 - import data and check the head
data = pd.read_csv("../../../data/0304_fundamentals_of_predictive_modelling/live_class/Motor_Claims.csv")
data.head()
#    vehage    CC  Length  Weight  claimamt
# 0       4  1495    4250    1023   72000.0
# 1       2  1061    3495     875   72000.0
# 2       2  1405    3675     980   50400.0
# 3       7  1298    4090     930   39960.0
# 4       2  1495    4250    1023  106800.0



# %% 2 - prepare the data
X = data.drop(['claimamt'], axis = 1)
y = data.claimamt



# %% 3 - build the model
model = linear_model.LinearRegression()



# %% 4 - create 5 folds with 5 repeats
rkfold = RepeatedKFold(n_splits = 5, n_repeats = 5)



# %% 5 - calculate R squared
scores = cross_val_score(model, X, y, cv = rkfold)
print("Mean 5-Fold R Squared: {}".format(np.mean(scores)))
# Mean 5-Fold R Squared: 0.7309811303574905



# %% 6 - calculate RMSE
RMSE = cross_val_score(model, X, y, cv = rkfold, scoring = 'neg_mean_squared_error')
np.sqrt(-(np.mean(RMSE)))
# 11449.320269984284
