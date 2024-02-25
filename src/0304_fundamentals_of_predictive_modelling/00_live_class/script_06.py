#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat Dec 16 10:05:34 2023

@author: jerry
"""


# %% 0 - import libraries

import pandas as pd
import numpy as np

from sklearn.model_selection import cross_val_score
from sklearn import linear_model



# %% 1 - import data and check the head
data = pd.read_csv("./data/0304_fundamentals_of_predictive_modelling/live_class/Motor_Claims.csv")
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



# %% 4 - calculate R squared
scores = cross_val_score(model, X, y, cv = 4, scoring = 'r2')
print("Mean 4-Fold R Squared: {}".format(np.mean(scores)))
# Mean 4-Fold R Squared: 0.7274652945788245



# %% 5 - calculate RMSE
RMSE = cross_val_score(model, X, y, cv = 4, scoring = 'neg_mean_squared_error')
np.sqrt(-(np.mean(RMSE)))
# 11461.732510880658
