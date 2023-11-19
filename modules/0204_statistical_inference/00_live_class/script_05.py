#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat Nov 11 09:45:16 2023

@author: jerry
"""


# %%

import pandas as pd

from scipy import stats



# %%

data = pd.read_csv("../../../data/si/intro_and_parametric_tests/Correlation test.csv")
data.info()



# %%

stats.pearsonr(data['aptitude'], data['job_prof'])
