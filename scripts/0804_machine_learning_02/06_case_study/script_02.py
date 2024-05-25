
# %% 0 - import libraries
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

from mlxtend.frequent_patterns import apriori
from mlxtend.frequent_patterns import association_rules



# %% 1 - import data and check the head
data = pd.read_excel("./data/0804_machine_learning_02/06_case_study/Online Retail.xlsx")
data.head()


# %% 1 - 
sns.countplot(x = "Description", data = data, order = data["Description"].value_counts().iloc[:10].index)
plt.xticks(rotation = 90)
# ([0, 1, 2, 3, 4, 5, 6, 7, 8, 9],
#  [Text(0, 0, 'WHITE HANGING HEART T-LIGHT HOLDER'),
#   Text(1, 0, 'REGENCY CAKESTAND 3 TIER'),
#   Text(2, 0, 'JUMBO BAG RED RETROSPOT'),
#   Text(3, 0, 'PARTY BUNTING'),
#   Text(4, 0, 'LUNCH BAG RED RETROSPOT'),
#   Text(5, 0, 'ASSORTED COLOUR BIRD ORNAMENT'),
#   Text(6, 0, 'SET OF 3 CAKE TINS PANTRY DESIGN '),
#   Text(7, 0, 'PACK OF 72 RETROSPOT CAKE CASES'),
#   Text(8, 0, 'LUNCH BAG  BLACK SKULL.'),
#   Text(9, 0, 'NATURAL SLATE HEART CHALKBOARD ')])


# %% 1 - 
data["Description"] = data["Description"].str.strip()
data.dropna(axis = 0, subset = ["InvoiceNo"], inplace = True)


# %% 1 - 
data["InvoiceNo"] = data["InvoiceNo"].astype("str")


# %% 1 - 
data = data[~data["InvoiceNo"].str.contains("C")]
data.shape


# %% 1 - 
basket_stacked = (data[data["Country"] == "France"]
                  .groupby(["InvoiceNo", "Description"])["Quantity"]
                  .sum().reset_index().fillna(0)
                  .set_index("InvoiceNo"))

basket_stacked.head()


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
basket_sets.drop("POSTAGE", inplace = True, axis = 1)


# %% 1 - 
basket_sets.shape
# (392, 1562)


# %% 1 - 
frequent_items = apriori(basket_sets, min_support = 0.07, use_colnames = True)
frequent_items.head()
#     support                        itemsets
# 0  0.071429   (4 TRADITIONAL SPINNING TOPS)
# 1  0.096939    (ALARM CLOCK BAKELIKE GREEN)
# 2  0.102041     (ALARM CLOCK BAKELIKE PINK)
# 3  0.094388      (ALARM CLOCK BAKELIKE RED)
# 4  0.081633  (BAKING SET 9 PIECE RETROSPOT)


# %% 1 - 
frequent_items.tail()
#      support                                           itemsets
# 46  0.104592  (PLASTERS IN TIN WOODLAND ANIMALS, PLASTERS IN...
# 47  0.102041  (SET/20 RED RETROSPOT PAPER NAPKINS, SET/6 RED...
# 48  0.102041  (SET/6 RED SPOTTY PAPER PLATES, SET/20 RED RET...
# 49  0.122449  (SET/6 RED SPOTTY PAPER PLATES, SET/6 RED SPOT...
# 50  0.099490  (SET/6 RED SPOTTY PAPER PLATES, SET/20 RED RET...


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
#                                           antecedents  \
# 2                          (ALARM CLOCK BAKELIKE RED)   
# 3                        (ALARM CLOCK BAKELIKE GREEN)   
# 16                    (SET/6 RED SPOTTY PAPER PLATES)   
# 18                    (SET/6 RED SPOTTY PAPER PLATES)   
# 19                      (SET/6 RED SPOTTY PAPER CUPS)   
# 20  (SET/6 RED SPOTTY PAPER PLATES, SET/20 RED RET...   
# 21  (SET/6 RED SPOTTY PAPER PLATES, SET/6 RED SPOT...   
# 22  (SET/20 RED RETROSPOT PAPER NAPKINS, SET/6 RED...   

#                              consequents  antecedent support  \
# 2           (ALARM CLOCK BAKELIKE GREEN)            0.094388   
# 3             (ALARM CLOCK BAKELIKE RED)            0.096939   
# 16  (SET/20 RED RETROSPOT PAPER NAPKINS)            0.127551   
# 18         (SET/6 RED SPOTTY PAPER CUPS)            0.127551   
# 19       (SET/6 RED SPOTTY PAPER PLATES)            0.137755   
# 20         (SET/6 RED SPOTTY PAPER CUPS)            0.102041   
# 21  (SET/20 RED RETROSPOT PAPER NAPKINS)            0.122449   
# 22       (SET/6 RED SPOTTY PAPER PLATES)            0.102041   

#     consequent support   support  confidence      lift  leverage  conviction  \
# 2             0.096939  0.079082    0.837838  8.642959  0.069932    5.568878   
# 3             0.094388  0.079082    0.815789  8.642959  0.069932    4.916181   
# 16            0.132653  0.102041    0.800000  6.030769  0.085121    4.336735   
# 18            0.137755  0.122449    0.960000  6.968889  0.104878   21.556122   
# 19            0.127551  0.122449    0.888889  6.968889  0.104878    7.852041   
# 20            0.137755  0.099490    0.975000  7.077778  0.085433   34.489796   
# 21            0.132653  0.099490    0.812500  6.125000  0.083247    4.625850   
# 22            0.127551  0.099490    0.975000  7.644000  0.086474   34.897959   

#     zhangs_metric  
# 2        0.976465  
# 3        0.979224  
# 16       0.956140  
# 18       0.981725  
# 19       0.993343  
# 20       0.956294  
# 21       0.953488  
# 22       0.967949  


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
rules2[ (rules2["lift"] >= 4) & (rules2["confidence"] >= 0.5)]
#                         antecedents                         consequents  \
# 1   (PLASTERS IN TIN CIRCUS PARADE)  (PLASTERS IN TIN WOODLAND ANIMALS)   
# 7        (PLASTERS IN TIN SPACEBOY)  (PLASTERS IN TIN WOODLAND ANIMALS)   
# 11    (RED RETROSPOT CHARLOTTE BAG)            (WOODLAND CHARLOTTE BAG)   

#     antecedent support  consequent support   support  confidence      lift  \
# 1             0.115974            0.137856  0.067834    0.584906  4.242887   
# 7             0.107221            0.137856  0.061269    0.571429  4.145125   
# 11            0.070022            0.126915  0.059081    0.843750  6.648168   

#     leverage  conviction  zhangs_metric  
# 1   0.051846    2.076984       0.864580  
# 7   0.046488    2.011670       0.849877  
# 11  0.050194    5.587746       0.913551  


