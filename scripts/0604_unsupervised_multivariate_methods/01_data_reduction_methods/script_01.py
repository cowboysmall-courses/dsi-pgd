
# %% 0 - import libraries
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

from sklearn.decomposition import PCA
from sklearn.preprocessing import scale



# %% 1 - import data and check the head
data = pd.read_csv("./data/0604_unsupervised_multivariate_methods/01_data_reduction_methods/Athleticsdata.csv")
data.head()
#      Country  100m_s  200m_s  400m_s  800m_min  1500m_min  5000m_min  \
# 0  Argentina   10.39   20.81   46.84      1.81       3.70      14.04   
# 1  Australia   10.31   20.06   44.84      1.74       3.57      13.28   
# 2    Austria   10.44   20.81   46.82      1.79       3.60      13.26   
# 3    Belgium   10.34   20.68   45.04      1.73       3.60      13.22   
# 4    Bermuda   10.28   20.58   45.91      1.80       3.75      14.68   

#    10000m_min  Marathon_min  
# 0       29.36        137.72  
# 1       27.66        128.30  
# 2       27.72        135.90  
# 3       27.45        129.95  
# 4       30.55        146.62  


# %% 2 - 
athletics = data.drop(["Country"], axis = 1)
X          = pd.DataFrame(scale(athletics), index = athletics.index, columns = athletics.columns)


# %% 3 - 
pca   = PCA().fit(X)
names = [f"PC{i}" for i in range(1, 9)]

SD      = list(np.std(pca.transform(X), axis = 0))
VarProp = list(pca.explained_variance_ratio_)
CumProp = [np.sum(VarProp[:i]) for i in range(1, 9)]

summary = pd.DataFrame(list(zip(SD, VarProp, CumProp)), index = names, columns = ["Standard Deviation", "Proportion of Variance", "Cumulative Proportion"])
summary
#      Standard Deviation  Proportion of Variance  Cumulative Proportion
# PC1            2.574068                0.828228               0.828228
# PC2            0.935501                0.109395               0.937624
# PC3            0.398207                0.019821               0.957445
# PC4            0.352195                0.015505               0.972950
# PC5            0.282863                0.010001               0.982951
# PC6            0.260302                0.008470               0.991421
# PC7            0.214848                0.005770               0.997191
# PC8            0.149910                0.002809               1.000000


# %% 4 - 
data = list(zip(pca.components_[0], pca.components_[1], pca.components_[2], pca.components_[3], pca.components_[4], pca.components_[5], pca.components_[6], pca.components_[7]))
rows = X.columns
col  = ["Comp"+str(i) for i in range(1, len(X.columns)+1)]

loadings = pd.DataFrame(data, index = rows, columns = col)
loadings
#                  Comp1     Comp2     Comp3     Comp4     Comp5     Comp6  \
# 100m_s        0.318293 -0.564684  0.326323 -0.128698 -0.267423  0.590449   
# 200m_s        0.336855 -0.462270  0.369020  0.256689  0.157078 -0.647587   
# 400m_s        0.355561 -0.249318 -0.561085 -0.649891  0.221457 -0.158447   
# 800m_min      0.368626 -0.013405 -0.530948  0.481745 -0.540354  0.011856   
# 1500m_min     0.372682  0.140200 -0.154640  0.406710  0.490808  0.143104   
# 5000m_min     0.364283  0.312458  0.189618 -0.030521  0.250168  0.155079   
# 10000m_min    0.366702  0.307018  0.181817 -0.081362  0.128320  0.231701   
# Marathon_min  0.341825  0.439947  0.260172 -0.300243 -0.492792 -0.329455   

#                  Comp7     Comp8  
# 100m_s       -0.154303  0.113210  
# 200m_s        0.128066 -0.101621  
# 400m_s        0.009292 -0.002585  
# 800m_min      0.237073 -0.040305  
# 1500m_min    -0.608456  0.143305  
# 5000m_min     0.592691  0.543015  
# 10000m_min    0.165205 -0.796334  
# Marathon_min -0.393327  0.160236  


# %% 5 - 
score     = PCA().fit_transform(X)
score_df  = pd.DataFrame(score, index = athletics.index, columns = col)

data = data.assign(performance = score_df.Comp1)
data.head()
#      Country  100m_s  200m_s  400m_s  800m_min  1500m_min  5000m_min  \
# 0  Argentina   10.39   20.81   46.84      1.81       3.70      14.04   
# 1  Australia   10.31   20.06   44.84      1.74       3.57      13.28   
# 2    Austria   10.44   20.81   46.82      1.79       3.60      13.26   
# 3    Belgium   10.34   20.68   45.04      1.73       3.60      13.22   
# 4    Bermuda   10.28   20.58   45.91      1.80       3.75      14.68   

#    10000m_min  Marathon_min  performance  
# 0       29.36        137.72     0.265654  
# 1       27.66        128.30    -2.466968  
# 2       27.72        135.90    -0.813415  
# 3       27.45        129.95    -2.058239  
# 4       30.55        146.62     0.747146  


# %% 6 - 
y = np.std(pca.transform(X), axis = 0) ** 2
x = np.arange(len(y)) + 1

plt.plot(x, y, "o-")
plt.xticks(x, [f"Comp.{i}" for i in x], rotation = 60)
plt.ylabel("Variance")

plt.show()


# %% 7 - 
data.sort_values(by = "performance").head(3)
#                                Country  100m_s  200m_s  400m_s  800m_min  \
# 52                                 USA    9.93   19.75   43.86      1.73   
# 20  Great Britain and Northern Ireland   10.11   20.21   44.93      1.70   
# 28                               Italy   10.01   19.72   45.26      1.73   

#     1500m_min  5000m_min  10000m_min  Marathon_min  performance  
# 52       3.53      13.20       27.43        128.22    -3.460450  
# 20       3.51      13.01       27.51        129.13    -3.050287  
# 28       3.60      13.23       27.52        131.08    -2.750446  


# %% 8 - 
data.sort_values(by = "performance").tail(3)
#           Country  100m_s  200m_s  400m_s  800m_min  1500m_min  5000m_min  \
# 35      Mauritius   11.19   22.45   47.70      1.88       3.83      15.06   
# 54  Western Samoa   10.82   21.86   49.00      2.02       4.24      16.28   
# 11    Cook Isands   12.18   23.20   52.94      2.02       4.24      16.70   

#     10000m_min  Marathon_min  performance  
# 35       31.77        152.23     4.299192  
# 54       34.71        161.83     7.297965  
# 11       35.38        164.70    10.653867


# %% 8 - 
score_df.corr().round()
#        Comp1  Comp2  Comp3  Comp4  Comp5  Comp6  Comp7  Comp8
# Comp1    1.0    0.0   -0.0    0.0   -0.0    0.0   -0.0    0.0
# Comp2    0.0    1.0   -0.0    0.0    0.0    0.0    0.0    0.0
# Comp3   -0.0   -0.0    1.0   -0.0    0.0    0.0    0.0    0.0
# Comp4    0.0    0.0   -0.0    1.0   -0.0    0.0    0.0    0.0
# Comp5   -0.0    0.0    0.0   -0.0    1.0   -0.0    0.0   -0.0
# Comp6    0.0    0.0    0.0    0.0   -0.0    1.0   -0.0   -0.0
# Comp7   -0.0    0.0    0.0    0.0    0.0   -0.0    1.0   -0.0
# Comp8    0.0    0.0    0.0    0.0   -0.0   -0.0   -0.0    1.0


