#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat Sep 30 09:46:34 2023

@author: jerry
"""



# 1 - basic variables / references

x = 20
x

y = 15
y

x + y
x * y



# 2 - strings and numbers

print("Welcome to Ask Analytics")

print(55)
print(4 * 5)

print("This is", "session no.", 3)

x = 14
print("He is %d years old" % x)
print("He is d years old" % x)



# 3 types

x = 10
x
type(x)

y = 15.2
type(y)

z = -32.54e100    
type(z)

x = int(-99999.75)
x
type(x)

y = float(25)
y
type(y)



# 4 - strings and slices

x = 'welcome to the Python world'
x

z = '3948'
z
type(z)

x = x + ", Jerry"
x

x[0]
x[2:5]
x[:3]

len(x)

a = 1567
a

y = str(a)
type(y)




# 5 - lists

list1 = ['python', 1998, 'list', 12]
list1

len(list1)


list2 = [2001, 2005, 2010, 2016]
list2

list3 = ["red", "blue", "white", "black"]
list3

list1[0]
list2[1:4]

list2[2] = 2006
list2

list2.append(2012)
list2

del list2[1]
list2

list2.remove(2012)
list2

list2.insert(1, 2019)
list2

list2.index(2016)

list2.sort()
list2

list2.reverse()
list2




# 6 - tuples

tuple1 = ('math', 'physics', 'chemistry')
tuple1
tuple1[0]

tuple1[0] = 'mathematics'

t1 = ('one', 'two', 'three')
t2 = (4, 5, 6)
t3 = t1 + t2
t3

del tuple1
tuple1




# 7 - dictionaries

dict1 = {'name': 'Ruchi', 'age': '18', 'class': 'Twelfth'}
dict1
dict1['name']

dict1['age'] = '19'
dict1

dict1['school'] = 'Kendriya Vidyalaya'
dict1

del dict1['name']
dict1

dict1.clear()
dict1

del dict1
dict1
