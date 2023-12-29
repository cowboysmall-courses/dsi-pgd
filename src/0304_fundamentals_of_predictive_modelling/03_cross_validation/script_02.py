#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Dec 29 14:43:49 2023

@author: jerry
"""


# %% 0 - import libraries

import pandas as pd
import numpy as np

from sklearn.model_selection import train_test_split
from statsmodels.formula.api import ols



# %% 1 - import data and check the head
data = pd.read_csv("../../../data/0304_fundamentals_of_predictive_modelling/live_class/Motor_Claims.csv")
data.head()
#    vehage    CC  Length  Weight  claimamt
# 0       4  1495    4250    1023   72000.0
# 1       2  1061    3495     875   72000.0
# 2       2  1405    3675     980   50400.0
# 3       7  1298    4090     930   39960.0
# 4       2  1495    4250    1023  106800.0



# %% 2 - train test split
train, test = train_test_split(data, test_size = 0.2, random_state = 0)
train.shape
# (800, 5)
test.shape
# (200, 5)



# %% 3 - RMSE for training data
model = ols('claimamt ~ Length + CC + vehage', data = train).fit()
train = train.assign(resi = pd.Series(model.resid))
np.sqrt((train.resi ** 2).mean())
# 11569.182885388027



# %% 4 - RMSE for testing data
test = test.assign(pred = pd.Series(model.predict(test)))
test = test.assign(resi = pd.Series(test.claimamt - test.pred))
np.sqrt((test.resi ** 2).mean())
# 10949.77556791181
