#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sun Oct  1 11:58:23 2023

@author: jerry
"""

" ".join(["One", "Two", "Three"])
"One Two Three".split()


print("Name is %s and score is %d" % ("Jerry", 100))
print("Name is %s and grade is %c" % ("Jerry", "A"))


print("Test {}".format("String"))
print("Test - {2}, {1}, {0}...".format("Three", "Two", "One"))


"Welcome to the world of Python"[11:14]


"He is a data scientist. He works with data".replace("He", "Jerry")


l1 = ["Mumbai", "Delhi", "Mumbai", "Kolkata", "Delhi"]
l2 = [w.replace(w, w[:3]) for w in l1]
l2


d1 = ["12-10-2014", "01-05-2000", "26-06-2015"]
d2 = [d.split('-') for d in d1]
d2
