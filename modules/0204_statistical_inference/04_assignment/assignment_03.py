#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sun Nov 12 14:57:00 2023

@author: jerry

 BACKGROUND: 
   In a randomized control trial, 32 patients were divided 
   into two groups: A and B. Group A received test drug 
   whereas group B received placebo. The variable of 
   interest was Numerical Pain Rating Scale (NPRS) before 
   treatment and after 3 days of treatment. (Higher number 
   indicates more pain)

"""

import pandas as pd
import statsmodels.api as sm

from scipy import stats
from statsmodels.formula.api import ols




# 1 - Import NPRS DATA and name it as pain_nprs. Find 
#     median NPRS before and after treatment.
data = pd.read_csv("../../../data/si/assignment/NPRS DATA.csv")

data.head()
data.info()
data.describe(include = 'all')

data.NPRS_before.median()
# 7

data.NPRS_after.median()
# 5







