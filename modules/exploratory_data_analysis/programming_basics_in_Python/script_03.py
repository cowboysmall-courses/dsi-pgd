#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat Sep 30 12:42:45 2023

@author: jerry
"""

import os

os.getcwd()
os.listdir(".")
os.listdir("/")



salary_data = pd.read_csv("../../../data/data_management/basic_salary.csv")
salary_data.head()

salary_data.to_csv("./basic_salary_local.csv")

