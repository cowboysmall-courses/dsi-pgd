#!/usr/bin/env python
# coding: utf-8

# In[1]:


import pandas as pd
import numpy as np
import seaborn as sns

import matplotlib.pyplot as plt
from scipy.stats import shapiro
from scipy.stats import ttest_ind

import statsmodels.api as sm
from statsmodels.formula.api import ols

import warnings
warnings.filterwarnings("ignore", category=FutureWarning)


# In[2]:


df = pd.read_csv('Food Delivery App Survey.csv')
df.head()


# In[3]:


median_rating = df.groupby(['AGE'])['Q1','Q2','Q3'].agg(['median'])
median_rating


# In[4]:


df['Total_Score'] = df['Q1'] + df['Q2'] + df['Q3']
df.head()


# In[5]:


plt.figure(figsize=(5, 5))
sns.boxplot( y='Total_Score', data=df)
plt.title('Box-and-Whisker Plot for Total Score')
plt.ylabel('Total Score')
plt.show()


# In[6]:


statistic, p_value = shapiro(df['Total_Score'])
statistic, p_value


# In[7]:


model = ols('Total_Score ~ C(AGE)', data=df).fit()

anova_table = sm.stats.anova_lm(model, typ=2)
anova_table


# In[8]:


group1 = df[df['GENDER'] == 'Female']['Total_Score']
group2 = df[df['GENDER'] == 'Male']['Total_Score']

ttest_ind(group1,group2,nan_policy='omit',equal_var=False)


# In[9]:


model = ols('Total_Score ~ C(AGE)*C(GENDER)', data=df).fit()

anova_table2 = sm.stats.anova_lm(model, typ=1)
anova_table2


# In[10]:


df['Satisfied'] = np.where(df['Total_Score'] > 20, 'YES', 'NO')
df.head(
)


# In[11]:


satisfied_counts = df['Satisfied'].value_counts()
satisfied_counts / len(df['Satisfied'])

