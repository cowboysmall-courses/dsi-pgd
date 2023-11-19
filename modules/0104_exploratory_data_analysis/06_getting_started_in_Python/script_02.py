#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat Sep 30 12:39:10 2023

@author: jerry
"""



# 1 - get started

import pandas as pd


s = pd.Series([8, 'data', 5.36, -23455788675342648, 'structures'])
s

s = pd.Series([8, 'data', 5.36, -23455788675342648, 'structures'], index = ['A', 'B', 'C', 'D', 'E'])
s

d = {'01': 'Jan', '02': 'Feb', '03': 'Mar', '04': 'Apr'}
d

m = pd.Series(d)
m
