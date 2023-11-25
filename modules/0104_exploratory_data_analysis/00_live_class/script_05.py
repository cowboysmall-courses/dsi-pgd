#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat Oct  7 10:42:06 2023

@author: jerry
"""


# %%

import pandas as pd


# %%

salary1 = pd.read_csv("../../../data/0104_exploratory_data_analysis/data_management/basic_salary - 1.csv")
salary2 = pd.read_csv("../../../data/0104_exploratory_data_analysis/data_management/basic_salary - 2.csv")


# %%

frames = [salary1, salary2]
append1 = pd.concat(frames)
append1


# %%

append2 = pd.concat([salary1, salary2])
append2


# %%

append3 = pd.concat([salary1, salary2], ignore_index = True)
append3
