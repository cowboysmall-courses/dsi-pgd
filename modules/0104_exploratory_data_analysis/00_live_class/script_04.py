#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat Oct  7 10:30:26 2023

@author: jerry
"""


import pandas as pd


salary_data = pd.read_csv("../../../data/eda/data_management/sal_data.csv")
bonus_data = pd.read_csv("../../../data/eda/data_management/bonus_data.csv")


left_join = pd.merge(salary_data, bonus_data, how = 'left')
left_join


right_join = pd.merge(salary_data, bonus_data, how = 'right')
right_join 


inner_join = pd.merge(salary_data, bonus_data)
inner_join 


outer_join = pd.merge(salary_data, bonus_data, how = 'outer')
outer_join 
