
# %% 0 - import libraries
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

from mlxtend.frequent_patterns import apriori
from mlxtend.frequent_patterns import association_rules

import warnings
warnings.filterwarnings("ignore", category = FutureWarning)



# %% 1 - import data and check the head
data = pd.read_excel("./data/0804_machine_learning_02/03_association_rule/Online Retail.xlsx")
data.head()
#   InvoiceNo StockCode                          Description  Quantity  \
# 0    536365    85123A   WHITE HANGING HEART T-LIGHT HOLDER         6   
# 1    536365     71053                  WHITE METAL LANTERN         6   
# 2    536365    84406B       CREAM CUPID HEARTS COAT HANGER         8   
# 3    536365    84029G  KNITTED UNION FLAG HOT WATER BOTTLE         6   
# 4    536365    84029E       RED WOOLLY HOTTIE WHITE HEART.         6   

#           InvoiceDate  Price  Customer ID         Country  
# 0 2010-12-01 08:26:00   2.55      17850.0  United Kingdom  
# 1 2010-12-01 08:26:00   3.39      17850.0  United Kingdom  
# 2 2010-12-01 08:26:00   2.75      17850.0  United Kingdom  
# 3 2010-12-01 08:26:00   3.39      17850.0  United Kingdom  
# 4 2010-12-01 08:26:00   3.39      17850.0  United Kingdom  


# %% 1 - 
sns.countplot(x = "Description", data = data, order = data["Description"].value_counts().iloc[:10].index)
plt.xticks(rotation = 90)


# %% 1 - 
data["Description"] = data["Description"].str.strip()


# %% 1 - 
data.dropna(subset = ["InvoiceNo"], axis = 0, inplace = True)
data["InvoiceNo"] = data["InvoiceNo"].astype("str")
data = data[~data["InvoiceNo"].str.contains("C")]


# %% 1 - 
basket = (data[data["Country"] == "France"]
                  .groupby(["InvoiceNo", "Description"])["Quantity"]
                  .sum().unstack().reset_index().fillna(0)
                  .set_index("InvoiceNo"))

basket.head()


# %% 1 - 
def encode_units(x):
    if x <= 0:
        return 0
    if x >= 1:
        return 1


# %% 1 - 
basket_sets = basket.map(encode_units)
basket_sets.drop("POSTAGE", axis = 1, inplace = True)


# %% 1 - 
frequent_items = apriori(basket_sets, min_support = 0.07, use_colnames = True)


# %% 1 - 
rules = association_rules(frequent_items, metric = "lift", min_threshold = 1)
rules.head()
#                     antecedents                   consequents  \
# 0  (ALARM CLOCK BAKELIKE GREEN)   (ALARM CLOCK BAKELIKE PINK)   
# 1   (ALARM CLOCK BAKELIKE PINK)  (ALARM CLOCK BAKELIKE GREEN)   
# 2    (ALARM CLOCK BAKELIKE RED)  (ALARM CLOCK BAKELIKE GREEN)   
# 3  (ALARM CLOCK BAKELIKE GREEN)    (ALARM CLOCK BAKELIKE RED)   
# 4    (ALARM CLOCK BAKELIKE RED)   (ALARM CLOCK BAKELIKE PINK)   

#    antecedent support  consequent support   support  confidence      lift  \
# 0            0.096939            0.102041  0.073980    0.763158  7.478947   
# 1            0.102041            0.096939  0.073980    0.725000  7.478947   
# 2            0.094388            0.096939  0.079082    0.837838  8.642959   
# 3            0.096939            0.094388  0.079082    0.815789  8.642959   
# 4            0.094388            0.102041  0.073980    0.783784  7.681081   

#    leverage  conviction  zhangs_metric  
# 0  0.064088    3.791383       0.959283  
# 1  0.064088    3.283859       0.964734  
# 2  0.069932    5.568878       0.976465  
# 3  0.069932    4.916181       0.979224  
# 4  0.064348    4.153061       0.960466  


# %% 1 - 
rules[ (rules["lift"] >= 6) & (rules["confidence"] >= 0.8)]


# %% 1 -
basket["ALARM CLOCK BAKELIKE GREEN"].sum()
# 340.0


# %% 1 -
basket["ALARM CLOCK BAKELIKE RED"].sum()
# 316.0





# %% 1 -
basket2 = (data[data["Country"] == "Germany"]
           .groupby(["InvoiceNo", "Description"])["Quantity"]
           .sum().unstack().reset_index().fillna(0)
           .set_index("InvoiceNo"))


# %% 1 -
basket2_sets = basket2.map(encode_units)
basket2_sets.drop("POSTAGE", inplace = True, axis = 1)


# %% 1 -
frequent_items2 = apriori(basket2_sets, min_support = 0.05, use_colnames = True)


# %% 1 -
rules2 = association_rules(frequent_items2, metric = "lift", min_threshold = 1)


# %% 1 -
rules2[(rules2["lift"] >= 4) & (rules2["confidence"] >= 0.5)]
#                         antecedents                         consequents  \
# 0   (PLASTERS IN TIN CIRCUS PARADE)  (PLASTERS IN TIN WOODLAND ANIMALS)   
# 6        (PLASTERS IN TIN SPACEBOY)  (PLASTERS IN TIN WOODLAND ANIMALS)   
# 10    (RED RETROSPOT CHARLOTTE BAG)            (WOODLAND CHARLOTTE BAG)   

#     antecedent support  consequent support   support  confidence      lift  \
# 0             0.115974            0.137856  0.067834    0.584906  4.242887   
# 6             0.107221            0.137856  0.061269    0.571429  4.145125   
# 10            0.070022            0.126915  0.059081    0.843750  6.648168   

#     leverage  conviction  zhangs_metric  
# 0   0.051846    2.076984       0.864580  
# 6   0.046488    2.011670       0.849877  
# 10  0.050194    5.587746       0.913551 
