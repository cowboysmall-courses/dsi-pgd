
# %% 0 - import libraries
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns

from sklearn.decomposition import PCA
from sklearn.preprocessing import scale

import warnings
warnings.filterwarnings("ignore", category = FutureWarning)



# %% 1 -
plt.figure(figsize = (8, 6))
plt.style.use("ggplot")

sns.set_style("darkgrid")
sns.set_context("paper")



# %% 1 - import data and check the head
data = pd.read_csv("./data/0604_unsupervised_multivariate_methods/04_case_study/Sporting Goods Sales Data.csv")
data.head()
#   Region	City_Code  Sales_B1	 Growth_B1  Sales_B2  Growth_B2	 Sales_B3  Growth_B3  Sales_B4  Growth_B4  Sales_B5  Growth_B5
# 0	  EAST	      281	  45.46	      5.87	   52.71	   5.79	    40.18	    4.70	 56.87	     4.71	  31.81	      3.14
# 1	  EAST	      282	  46.15	      6.38	   53.54	   4.97	    41.68	    4.11	 57.26	     5.17	  31.63	      4.59
# 2	  EAST	      283	  21.83	      3.71	   26.66	   1.78	    20.68	    1.79	 29.28	     1.73	  16.32	      2.77
# 3	  EAST	      284	  49.64	      7.04	   59.05	   4.98	    43.00	    4.70	 54.31	     3.12	  27.33	      3.10
# 4	  EAST	      285	  37.55	      5.32	   40.22	   3.99	    34.75	    3.30	 42.96	     3.74	  25.48	      3.58



# %% 1 - 
data.info()
# <class 'pandas.core.frame.DataFrame'>
# RangeIndex: 384 entries, 0 to 383
# Data columns (total 12 columns):
#  #   Column     Non-Null Count  Dtype  
# ---  ------     --------------  -----  
#  0   Region     384 non-null    object 
#  1   City_Code  384 non-null    int64  
#  2   Sales_B1   384 non-null    float64
#  3   Growth_B1  384 non-null    float64
#  4   Sales_B2   384 non-null    float64
#  5   Growth_B2  384 non-null    float64
#  6   Sales_B3   384 non-null    float64
#  7   Growth_B3  384 non-null    float64
#  8   Sales_B4   384 non-null    float64
#  9   Growth_B4  384 non-null    float64
#  10  Sales_B5   384 non-null    float64
#  11  Growth_B5  384 non-null    float64
# dtypes: float64(10), int64(1), object(1)
# memory usage: 36.1+ KB



# %% 1 - 
data.shape
# (384, 12)



# %% 1 - 
data_copy = data.drop(['Region', 'City_Code'], axis = 1)
data_corr = data_copy.corr()
data_corr
# 	        Sales_B1	Growth_B1	Sales_B2   Growth_B2	Sales_B3   Growth_B3	Sales_B4   Growth_B4	Sales_B5   Growth_B5
# Sales_B1	1.000000	0.903556	0.976693	0.850452	0.767583	0.815407	0.825901	0.831460	0.693205	0.735340
# Growth_B1	0.903556	1.000000	0.887854	0.908348	0.850162	0.881359	0.804373	0.864016	0.658215	0.850659
# Sales_B2	0.976693	0.887854	1.000000	0.839793	0.755173	0.802752	0.757887	0.780232	0.646526	0.724352
# Growth_B2	0.850452	0.908348	0.839793	1.000000	0.801383	0.839072	0.772158	0.820676	0.621128	0.827219
# Sales_B3	0.767583	0.850162	0.755173	0.801383	1.000000	0.908143	0.859009	0.867161	0.831428	0.849335
# Growth_B3	0.815407	0.881359	0.802752	0.839072	0.908143	1.000000	0.827739	0.896368	0.741791	0.842484
# Sales_B4	0.825901	0.804373	0.757887	0.772158	0.859009	0.827739	1.000000	0.895053	0.920734	0.720545
# Growth_B4	0.831460	0.864016	0.780232	0.820676	0.867161	0.896368	0.895053	1.000000	0.790791	0.804726
# Sales_B5	0.693205	0.658215	0.646526	0.621128	0.831428	0.741791	0.920734	0.790791	1.000000	0.590880
# Growth_B5	0.735340	0.850659	0.724352	0.827219	0.849335	0.842484	0.720545	0.804726	0.590880	1.000000



# %% 1 - 
g = sns.pairplot(data_copy, diag_kind = 'kde', markers = 'o')
for i, j in zip(*plt.np.triu_indices_from(g.axes, 1)):
    g.axes[i, j].annotate(f"Corr: {data_corr.iloc[i, j]:.2f}", (0.5, 0.9), xycoords = 'axes fraction', ha = 'center', fontsize = 20)

plt.show()



# %% 1 - 
ax = sns.heatmap(data_corr)
ax.set(title = 'Heatmap')
plt.show()



# %% 1 - 
corr = data_copy.corr()
plt.figure(figsize = (10, 8))

sns.heatmap(corr, annot=True, fmt=".2f", cmap="coolwarm")

plt.xticks(rotation = 45, ha = "right")
plt.yticks(rotation=0)
plt.tight_layout()



# %% 1 - 
data_std = scale(data_copy)
data_std
# array([[-0.34311864,  0.18753282, -0.26516421, ...,  0.26467259,
#         -0.32366989, -0.3411622 ],
#        [-0.3305818 ,  0.36125416, -0.25132221, ...,  0.47418084,
#         -0.3314662 ,  0.28284119],
#        [-0.77245969, -0.54822814, -0.69960276, ..., -1.09257652,
#         -0.99458585, -0.50039065],
#        ...,
#        [-0.3011475 , -0.3574753 , -0.20829529, ..., -0.61890569,
#         -0.22015219, -0.48748023],
#        [-0.54806858, -0.3642879 , -0.46112018, ..., -0.83296847,
#         -0.82696514,  0.32587591],
#        [-0.49083521, -0.85138891, -0.40375094, ..., -0.4868244 ,
#         -0.71478487, -0.10016779]])



# %% 1 - 
X   = pd.DataFrame(data_std, index = data_copy.index, columns = data_copy.columns)
pca = PCA().fit(X)

names    = ["PC" + str(i) for i in range(1, 11)]
std_dev  = list(np.std(pca.transform(X), axis = 0))
var_prop = list(pca.explained_variance_ratio_)
cum_prop = [np.sum(var_prop[:i]) for i in range(1, 11)]

summary  = pd.DataFrame(list(zip(std_dev, var_prop, cum_prop)), index = names, columns = ['Standard Deviation', 'Proportion of Variance', 'Cumulative Proportion'])
summary
#       Standard Deviation  Proportion of Variance  Cumulative Proportion
# PC1             2.881143                0.830098               0.830098
# PC2             0.813931                0.066248               0.896347
# PC3             0.661980                0.043822               0.940168
# PC4             0.395870                0.015671               0.955840
# PC5             0.379456                0.014399               0.970238
# PC6             0.349616                0.012223               0.982461
# PC7             0.269060                0.007239               0.989701
# PC8             0.237440                0.005638               0.995339
# PC9             0.187720                0.003524               0.998862
# PC10            0.106657                0.001138               1.000000



# %% 1 - 
rows     = X.columns
cols     = ["Comp" + str(i) for i in range(1, len(X.columns) + 1)]
loadings = pd.DataFrame(list(zip(pca.components_[0], pca.components_[1], pca.components_[2], pca.components_[3], pca.components_[4], pca.components_[5], pca.components_[6], pca.components_[7], pca.components_[8], pca.components_[9])), index = rows, columns = cols)
loadings.round(2)
#           Comp1	Comp2	Comp3	Comp4	Comp5	Comp6	Comp7	Comp8	Comp9	Comp10
# Sales_B1	 0.32	-0.23	-0.47	-0.11	-0.05	-0.22	 0.07	-0.02	-0.19	 -0.72
# Growth_B1	 0.33	-0.27	 0.01	 0.06	-0.01	 0.07	-0.79	-0.32	 0.29	  0.05
# Sales_B2	 0.31	-0.32	-0.47	-0.37	-0.01	-0.04	 0.18	 0.20	 0.07	  0.61
# Growth_B2	 0.32	-0.31	 0.06	 0.55	 0.43	 0.47	 0.25	 0.17	 0.02	 -0.04
# Sales_B3	 0.32	 0.20	 0.31	-0.43	 0.12	 0.27	-0.29	 0.44	-0.46	 -0.07
# Growth_B3	 0.33	 0.01	 0.24	-0.19	-0.54	 0.42	 0.36	-0.44	 0.04	 -0.04
# Sales_B4	 0.32	 0.39	-0.16	 0.30	 0.14	-0.22	-0.00	-0.43	-0.54	  0.29
# Growth_B4	 0.33	 0.13	 0.08	 0.44	-0.57	-0.28	-0.05	 0.50	 0.11	  0.05
# Sales_B5	 0.28	 0.66	-0.19	-0.12	 0.27	 0.07	 0.08	 0.03	 0.58	 -0.12
# Growth_B5	 0.30	-0.21	 0.58	-0.16	 0.29	-0.58	 0.23	-0.10	 0.14	 -0.01



# %% 1 - 
score    = PCA().fit_transform(X)
score_df = pd.DataFrame(score, index = data.index, columns = cols)

data = data.assign(Performance = score_df.Comp1)
data['Performance'] = data['Performance'].round(3)
data.head()
#   Region	City_Code	Sales_B1	Growth_B1	Sales_B2	Growth_B2	Sales_B3	Growth_B3	Sales_B4	Growth_B4	Sales_B5	Growth_B5	Performance
# 0	  EAST	      281	   45.46	     5.87	   52.71	     5.79	  40.18	         4.70	   56.87	     4.71	   31.81	     3.14	      0.000
# 1	  EAST	      282	   46.15	     6.38	   53.54	     4.97	  41.68	         4.11	   57.26	     5.17	   31.63	     4.59	      0.146
# 2	  EAST	      283	   21.83	     3.71	   26.66	     1.78	  20.68	         1.79	   29.28	     1.73	   16.32	     2.77	     -2.730
# 3	  EAST	      284	   49.64	     7.04	   59.05	     4.98	  43.00	         4.70	   54.31	     3.12	   27.33	     3.10	     -0.196
# 4	  EAST	      285	   37.55	     5.32	   40.22	     3.99	  34.75	         3.30	   42.96	     3.74	   25.48	     3.58	     -0.999



# %% 1 - 
y = np.std(pca.transform(X), axis = 0) ** 2
x = np.arange(len(y)) + 1

plt.plot(x, y, "o-")
plt.xticks(x, ["Comp." + str(i) for i in x], rotation = 60)
plt.ylabel("Variance")
plt.show()



# %% 1 - 
data_pr = data.groupby('Region')['Performance'].mean().reset_index()
colors  = sns.color_palette("pastel")

plt.figure(figsize = (8, 6))
sns.barplot(data = data_pr, x = 'Region', y = 'Performance', palette = colors)
plt.title('Average Performance by Region')
plt.xlabel('Region')
plt.ylabel('Average Performance')
plt.xticks(rotation = 0)
plt.show()
