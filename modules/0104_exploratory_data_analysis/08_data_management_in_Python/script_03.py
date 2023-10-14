#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Oct  2 16:39:01 2023

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

salary_1 = pd.read_csv("../../../data/data_management/basic_salary - 1.csv")
salary_2 = pd.read_csv("../../../data/data_management/basic_salary - 2.csv")

frames = [salary_1, salary_2]
append = pd.concat(frames)
append


salary_data = pd.read_csv("../../../data/data_management/basic_salary.csv")

A = salary_data.groupby('Location')['ms'].sum()
A

B = salary_data.groupby('Location')['ba', 'ms'].sum()
B

C = salary_data.groupby(['Location', 'Grade'])[['ba', 'ms']].sum()
C
