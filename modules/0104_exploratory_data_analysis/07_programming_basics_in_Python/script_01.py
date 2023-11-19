#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sun Oct  1 11:58:23 2023

@author: jerry
"""


import pandas as pd
import numpy as np


x = pd.Series(['high', 'medium', 'low', 'low', 'medium', 'high', 'high', 'high', 'medium', 'low', 'low'])
x.str.isalpha()


c = pd.Categorical(x)
c.dtype
c.unique()


c = pd.Categorical(x, categories = ('low', 'medium', 'high'))
c.dtype
c.unique()



d = np.array([4, 24, 6, 4, 2, 7])
d > 5



X = np.array([2, 3, 4, 5, 6, 7]).reshape(3, 2)
X



Y = pd.DataFrame(X, index = ("X", "Y", "Z"), columns = ("A", "B"))
Y



a = np.arange(1, 25).reshape(3, 4, 2)
a



d = {'X': [1, 2, 3], 'Y': [41, 42, 43], 'Z': ['A', 'B', 'C']}
df = pd.DataFrame(d)
df
df.info()
