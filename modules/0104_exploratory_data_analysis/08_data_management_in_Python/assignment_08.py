#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Oct  2 17:18:26 2023

Jerry Kiely
Data Science Institute
Data Management in Python
EDA T8 Assignment

@author: jerry
"""


import pandas as pd



# 1 - Import Premiums data and name it as Premium.
Premium = pd.read_csv("../../../data/eda/assignment/Premiums.csv")



# 2 - Check number of rows, columns in the data.
Premium.shape
# (4744, 10)



# 3 - Display first 10 rows and last 5 rows.
Premium.head(10)
#          POLICY_NO PRODUCT   BRANCH_NAME  ... Premium  Sub_Plan Vintage_Period
# 0  A-2007073196522  TRAVEL          Pune  ...   525.0    Silver             14
# 1  A-2007080402998  TRAVEL         Anand  ...   325.0    Silver             30
# 2  A-2007081314381  TRAVEL    Chennai II  ...   300.0  Standard              4
# 3  A-2007082123389  TRAVEL        Baroda  ...   300.0  Standard             30
# 4  A-2007082123394  TRAVEL        Baroda  ...   300.0  Standard             30
# 5  A-2007083135582  TRAVEL  Bangalore II  ...   498.0  Standard            446
# 6  A-2007090540083  TRAVEL       Andheri  ...   364.0    Silver              5
# 7  A-2007090540188  TRAVEL       Andheri  ...   365.0    Silver              5
# 8  A-2007090540273  TRAVEL       Andheri  ...   364.0    Silver              8
# 9  A-2007090540347  TRAVEL       Andheri  ...   363.0    Silver              8

Premium.tail(5)
#             POLICY_NO PRODUCT  BRANCH_NAME  ... Premium  Sub_Plan Vintage_Period
# 4739  I-2008090517429  TRAVEL     Bareilly  ...   407.0  Standard              5
# 4740  I-2008090617490  TRAVEL  Bangalore I  ...   584.0  Standard             13
# 4741  I-2008090617503  TRAVEL  Bangalore I  ...   549.0  Standard             14
# 4742  I-2008091917750  TRAVEL        Patna  ...  1198.0      Gold             18
# 4743  I-2008092017751  TRAVEL  Gandhinagar  ...   549.0  Standard            365



# 4 - Describe (summarize) all variables.
Premium.info()
# <class 'pandas.core.frame.DataFrame'>
# RangeIndex: 4744 entries, 0 to 4743
# Data columns (total 10 columns):
#  #   Column          Non-Null Count  Dtype  
# ---  ------          --------------  -----  
#  0   POLICY_NO       4744 non-null   object 
#  1   PRODUCT         4744 non-null   object 
#  2   BRANCH_NAME     4744 non-null   object 
#  3   REGION          4744 non-null   object 
#  4   ZONE_NAME       4744 non-null   object 
#  5   Plan            4744 non-null   object 
#  6   Sum_Assured     4744 non-null   float64
#  7   Premium         4744 non-null   float64
#  8   Sub_Plan        4744 non-null   object 
#  9   Vintage_Period  4744 non-null   int64  
# dtypes: float64(2), int64(1), object(7)
# memory usage: 370.8+ KB



# 5 - Display top 5 and bottom 5 policies in terms of premium amount.
Premium_srt = Premium.sort_values(by = ['Premium'], ascending = [0])
Premium_srt.head()
#             POLICY_NO PRODUCT  ...  Sub_Plan Vintage_Period
# 184   F-2007091248143  TRAVEL  ...      Gold            180
# 858   I-2007092056819  TRAVEL  ...  Platinum             24
# 201   F-2007110802074  TRAVEL  ...  Standard            180
# 1178  I-2007102386800  TRAVEL  ...  Platinum            182
# 1715  I-2007120729531  TRAVEL  ...  Platinum            182

Premium_srt.tail()
#             POLICY_NO PRODUCT  ...  Sub_Plan Vintage_Period
# 4440  I-2008081198209  TRAVEL  ...  Standard              7
# 2625  I-2008032592387  TRAVEL  ...  Standard             91
# 4034  I-2008070373490  TRAVEL  ...      Gold             91
# 3043  I-2008042419344  TRAVEL  ...    Silver              5
# 3459  I-2008052243807  TRAVEL  ...  Standard             21



# 6 - Calculate the sum for variable ‘Sum_Assured’ by ‘Region’ variable.
Premium.groupby('REGION')['Sum_Assured'].sum()
# REGION
# Andhra Pradesh I                8.136750e+08
# Andhra Pradesh II               2.781500e+08
# Delhi I                         1.886412e+09
# Delhi II                        2.641320e+09
# Gujarat I                       3.810417e+08
# Gujarat II                      4.332400e+08
# Haryana And Himachal Pradesh    4.069583e+08
# Karnatka                        2.359892e+09
# Kerala                          4.148100e+08
# MP And Chattishgarh             9.368000e+07
# Mumbai I                        2.167774e+09
# Mumbai II                       1.300088e+09
# Punjab And Jammu  Kashmir       9.206533e+08
# ROM and Goa                     2.057798e+09
# Rajasthan                       3.405000e+07
# Rest of East                    1.000000e+07
# Tamilnadu                       1.207567e+09
# UP AND UTRANCHAL                3.453164e+08
# West Bengal                     3.924500e+08
# Name: Sum_Assured, dtype: float64



# 7 - Create a subset of policies of Asia Standard Plan with Sum_Assured < = 50,000. 
#     Keep variables Policy_No, Zone_name, Plan and Sum_Assured in the subset data.
Premium_sub = Premium.loc[(Premium.Plan == 'Asia Standard Plan') & (Premium.Sum_Assured <= 50000), ['POLICY_NO', 'ZONE_NAME', 'Plan', 'Sum_Assured']]
Premium_sub.head(10)
#           POLICY_NO ZONE_NAME                Plan  Sum_Assured
# 3   A-2007082123389     North  Asia Standard Plan      25000.0
# 4   A-2007082123394     North  Asia Standard Plan      25000.0
# 11  A-2007091348784     South  Asia Standard Plan      25000.0
# 12  A-2007091348862     South  Asia Standard Plan      25000.0
# 19  A-2007100469681     South  Asia Standard Plan      25000.0
# 20  A-2007100469711     South  Asia Standard Plan      25000.0
# 21  A-2007100469809     South  Asia Standard Plan      25000.0
# 22  A-2007100469862     South  Asia Standard Plan      25000.0
# 23  A-2007100469872     South  Asia Standard Plan      25000.0
# 24  A-2007100872484     South  Asia Standard Plan      25000.0



# 8 - Export the subsetted data into an xlsx file.
Premium_sub.to_excel("./Premiums_sub.xlsx")











# 9 - Import Premiums and Claims data and name it as Premium and Claim respectively.
Premium = pd.read_csv("../../../data/exploratory_data_analysis_assignment/Premiums.csv")
Claim = pd.read_csv("../../../data/exploratory_data_analysis_assignment/Claims.csv")



# 10 - Merge ‘Premium’ data set with ‘Claims’ data set.
Premium_join = pd.merge(Premium, Claim, how = 'outer')
Premium_join.info()
# <class 'pandas.core.frame.DataFrame'>
# Int64Index: 4744 entries, 0 to 4743
# Data columns (total 12 columns):
#  #   Column          Non-Null Count  Dtype   
# ---  ------          --------------  -----   
#  0   POLICY_NO       4744 non-null   object  
#  1   PRODUCT         4744 non-null   object  
#  2   BRANCH_NAME     4744 non-null   object  
#  3   REGION          4744 non-null   object  
#  4   ZONE_NAME       4744 non-null   object  
#  5   Plan            4744 non-null   object  
#  6   Sum_Assured     4744 non-null   float64 
#  7   Premium         4744 non-null   float64 
#  8   Sub_Plan        4744 non-null   object  
#  9   Vintage_Period  4744 non-null   int64   
#  10  Premium_Type    4724 non-null   category
#  11  Claim_Status    4744 non-null   object  
# dtypes: category(1), float64(2), int64(1), object(8)
# memory usage: 449.5+ KB



# 11 - Create a subset of Policy No., Region and Sub plan of the policy holders 
#      whose claim status is Yes.
Premium_join_sub = Premium_join.loc[(Premium_join.Claim_Status == 'Yes'), ['POLICY_NO', 'REGION', 'Sub_Plan']]
Premium_join_sub.head(10)
#             POLICY_NO                        REGION  Sub_Plan
# 11    A-2007091348784                     Mumbai II  Standard
# 57    A-2007120324565                   West Bengal    Silver
# 88    A-2007120729700                     Mumbai II    Silver
# 127   A-2008042923302                     Tamilnadu  Standard
# 221   F-2008030676001  Haryana And Himachal Pradesh      Gold
# 265   F-2008051035054                   West Bengal  Standard
# 1386  I-2007110700839                     Gujarat I  Standard
# 2438  I-2008030473710                      Delhi II      Gold
# 2710  I-2008040300838                      Mumbai I      Gold
# 2716  I-2008040399961                   ROM and Goa  Standard



# 12 - Create a subset of data for all the regions in South zone except Mumbai 
#      with claim status “No”. Keep only Policy No, Zone, Region, Premium and 
#      Claim status in the subset and sort the subsetted data by Premium descending. 
Premium_join_sub = Premium_join.loc[(Premium_join.ZONE_NAME == 'South') & (Premium_join.REGION != 'Mumbai I') & (Premium_join.REGION != 'Mumbai II') & (Premium_join.Claim_Status == 'No'), ['POLICY_NO', 'ZONE_NAME', 'REGION', 'Premium', 'Claim_Status']].sort_values(by = ['Premium'], ascending = [0])
Premium_join_sub.head(10)
#             POLICY_NO ZONE_NAME             REGION  Premium Claim_Status
# 858   I-2007092056819     South           Karnatka  14082.0           No
# 2205  I-2008020563431     South   Andhra Pradesh I  11536.0           No
# 213   F-2007121335640     South             Kerala  10028.0           No
# 1202  I-2007102588732     South  Andhra Pradesh II   9531.0           No
# 2070  I-2008011856904     South           Karnatka   9143.0           No
# 180   F-2007090337885     South             Kerala   8998.0           No
# 720   I-2007090743303     South        ROM and Goa   8847.0           No
# 2212  I-2008020663604     South           Karnatka   8022.0           No
# 722   I-2007090843522     South             Kerala   7082.0           No
# 2791  I-2008041005742     South          Tamilnadu   6428.0           No



# 13 - Calculate average Premium amount by sub plan. 
Premium_join.groupby('Sub_Plan')['Premium'].mean()
# Sub_Plan
# Gold        1426.193425
# Platinum    1458.205013
# Silver      1040.597258
# Standard    1043.343641
# Name: Premium, dtype: float64


# 14 - Derive a new column named ‘Premium type’ with 3 categories - 
#      Low (Premium <5000), Medium (Premium between 5000 and 10000) and 
#      High (Premium >10000).
Premium_labels = ['Low', 'Medium', 'High']
Premium_bins = [0, 5000, 10000, 19650]
Premium_join['Premium_Type'] = pd.cut(Premium_join['Premium'], Premium_bins, labels = Premium_labels)
Premium_join.head(10)
#          POLICY_NO PRODUCT  ... Claim_Status Premium_Type
# 0  A-2007073196522  TRAVEL  ...           No          Low
# 1  A-2007080402998  TRAVEL  ...           No          Low
# 2  A-2007081314381  TRAVEL  ...           No          Low
# 3  A-2007082123389  TRAVEL  ...           No          Low
# 4  A-2007082123394  TRAVEL  ...           No          Low
# 5  A-2007083135582  TRAVEL  ...           No          Low
# 6  A-2007090540083  TRAVEL  ...           No          Low
# 7  A-2007090540188  TRAVEL  ...           No          Low
# 8  A-2007090540273  TRAVEL  ...           No          Low
# 9  A-2007090540347  TRAVEL  ...           No          Low

# [10 rows x 12 columns]
