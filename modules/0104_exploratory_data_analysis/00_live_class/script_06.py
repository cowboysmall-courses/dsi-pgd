#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat Oct  7 10:51:40 2023

@author: jerry
"""


import pandas as pd


salary_data = pd.read_csv("../../../data/data_management/basic_salary.csv")


salary_data.groupby('Location')['ms'].sum()

salary_data.groupby('Location')[['ba', 'ms']].sum()

salary_data.groupby(['Location', 'Grade'])[['ba', 'ms']].sum()
