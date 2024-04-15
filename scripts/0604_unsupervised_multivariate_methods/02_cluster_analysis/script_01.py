
# %% 0 - import libraries
import pandas as pd
import matplotlib.pyplot as plt
import sklearn.preprocessing


from sklearn.cluster import KMeans


# %% 1 - import data and check the head
data = pd.read_csv("./data/0604_unsupervised_multivariate_methods/02_cluster_analysis/K MEANS DATA.csv")
data.head()
#    Custid      nsv  n_brands  n_bills  growth  region
# 0    1001  2119456         7       14   -1.79  Mumbai
# 1    1002  1460163        12       42   -1.73  Mumbai
# 2    1003   147976         4        6    2.81  Mumbai
# 3    1004  1350474        13       30   -0.99   Delhi
# 4    1005  1414461        15       29   13.56   Delhi


# %% 2 - 
data_cl = data.drop(["Custid", "region"], axis = 1)

data_cl = sklearn.preprocessing.scale(data_cl)
data_cl
# array([[ 1.3415212 , -0.57045618, -0.27177323, -1.40755324],
#        [ 0.57976648,  0.03183071,  1.2604777 , -1.39462362],
#        [-0.93634948, -0.93182832, -0.70955921, -0.41628239],
#        ...,
#        [ 1.04097324,  0.03183071,  0.43962899, -1.08862262],
#        [-0.76570907, -0.57045618, -0.76428245, -0.19647886],
#        [ 1.55237455,  2.8023504 ,  2.13604966,  1.37016007]])


# %% 3 - 
CL = KMeans(n_clusters = 4)
CL.fit(data_cl)


# %% 4 - 
centroids = CL.cluster_centers_
centroids
# array([[-0.83149199, -0.84081608, -0.72104433, -0.53176571],
#        [-0.50167108,  0.09512837, -0.37738561,  0.05667815],
#        [ 1.0594337 ,  1.50599957,  1.62269348,  1.6235293 ],
#        [ 1.18689039, -0.02445287,  0.30461312, -0.62608288]])


# %% 5 - 
data = data.assign(segment = pd.DataFrame(CL.labels_))
data.head()
#    Custid      nsv  n_brands  n_bills  growth  region  segment
# 0    1001  2119456         7       14   -1.79  Mumbai        3
# 1    1002  1460163        12       42   -1.73  Mumbai        3
# 2    1003   147976         4        6    2.81  Mumbai        0
# 3    1004  1350474        13       30   -0.99   Delhi        3
# 4    1005  1414461        15       29   13.56   Delhi        2


# %% 6 - 
nsv      = data.groupby("segment")["nsv"].mean()
n_brands = data.groupby("segment")["n_brands"].mean()
n_bills  = data.groupby("segment")["n_bills"].mean()
growth   = data.groupby("segment")["growth"].mean()

pd.concat([nsv, n_brands, n_bills, growth], axis = 1)
#                   nsv   n_brands    n_bills     growth
# segment                                               
# 0        2.387294e+05   4.755556   5.790123   2.274099
# 1        5.241869e+05  12.525478  12.070064   5.004777
# 2        1.875311e+06  24.238095  48.619048  12.275762
# 3        1.985624e+06  11.532751  24.532751   1.836419


# %% 7 - 
error = []

for i in range(1, 10):
    CL = KMeans(n_clusters = i).fit(data_cl)
    error.append(CL.inertia_)

plt.plot(range(1, 10), error)
plt.title('Elbow method')
plt.xlabel('No of clusters')
plt.ylabel('Error')

plt.show()
