
# %% 0 - import libraries
import pandas as pd
import sklearn.preprocessing
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns

from sklearn.preprocessing import StandardScaler
from sklearn.cluster import KMeans
from sklearn.impute import SimpleImputer

import warnings
warnings.filterwarnings("ignore", category = FutureWarning)



# %% 1 -
plt.figure(figsize = (8, 6))
plt.style.use("ggplot")

sns.set_style("darkgrid")
sns.set_context("paper")




# %% 1 - import data and check the head
data = pd.read_csv("./data/0604_unsupervised_multivariate_methods/00_live_class/Customer Segments.csv")
print(data.head())
#    Cust_ID  Age  BillAmt_Product  BillAmt_Service  BillAmt_Pre  Vintage
# 0    82078   49         81128.27         48203.10     62975.45      5.0
# 1    57215   34         59480.20         17263.19     23633.58      5.0
# 2    66970   58         65363.07         30660.67     45888.87      6.0
# 3    77319   48         84073.28         47181.46     43186.04      7.0
# 4    29564   26         10541.03          3550.96     12753.15      1.0



# %% 1 - 
rows, cols = data.shape
print(f"Number of rows: {rows}")
print(f"Number of cols: {cols}")
# Number of rows: 24024
# Number of cols: 6



# %% 1 - 
data = data.dropna()
data.isna().sum()
# Age                0
# BillAmt_Product    0
# BillAmt_Service    0
# BillAmt_Pre        0
# Vintage            0
# dtype: int64



# %% 1 - 
rows, cols = data.shape
print(f"Number of rows: {rows}")
print(f"Number of cols: {cols}")
# Number of rows: 24019
# Number of cols: 6



# %% 1 - 
data = data.drop(['Cust_ID'], axis = 1)
print(data.head())
#    Age  BillAmt_Product  BillAmt_Service  BillAmt_Pre  Vintage
# 0   49         81128.27         48203.10     62975.45      5.0
# 1   34         59480.20         17263.19     23633.58      5.0
# 2   58         65363.07         30660.67     45888.87      6.0
# 3   48         84073.28         47181.46     43186.04      7.0
# 4   26         10541.03          3550.96     12753.15      1.0



# %% 1 - 
scaled = sklearn.preprocessing.scale(data)
scaled
# array([[ 0.75455685,  1.19283766,  1.83500523,  1.65449965,  0.55744769],
#        [-0.46048874,  0.46615231, -0.16445267, -0.47888889,  0.55744769],
#        [ 1.4835842 ,  0.66362929,  0.70134484,  0.727947  ,  0.97034198],
#        ...,
#        [ 1.40258116,  1.69774606,  1.41078288,  1.39765004,  1.38323626],
#        [-0.86550393, -1.2096167 , -0.99650746, -0.99302844, -1.09412947],
#        [ 1.64559028,  1.12742612,  0.92327304,  0.89124325,  0.55744769]])



# %% 1 - 
distortions = []

K = range(2, 10)
for i in  K:
    cluster = KMeans(n_clusters = i).fit(scaled)
    distortions.append(cluster.inertia_)

plt.figure(figsize = (8, 6))
plt.plot(K, distortions, 'bx-')
plt.title("Elbow Method")
plt.xlabel("K")
plt.ylabel("Distortion")
plt.show()



# %% 1 - 
# np.random.seed(123)
CL = KMeans(n_clusters = 4).fit(scaled)



# %% 1 - 
labels = CL.labels_
sizes = np.bincount(labels)
print(sizes)
# [3934 8057 8067 3961]



# %% 1 - 
segment = pd.DataFrame({'Segment': labels})

sales = pd.concat([data.reset_index(drop = True), segment], axis = 1)
sales['Segment'] = sales['Segment'] + 1
sales.head()
# Age	BillAmt_Product	BillAmt_Service	BillAmt_Pre	Vintage	Segment
# 0	49	81128.27	48203.10	62975.45	5.0	1
# 1	34	59480.20	17263.19	23633.58	5.0	3
# 2	58	65363.07	30660.67	45888.87	6.0	4
# 3	48	84073.28	47181.46	43186.04	7.0	1
# 4	26	10541.03	3550.96	12753.15	1.0	2



# %% 1 - 
cols = ['Age', 'BillAmt_Product', 'BillAmt_Service', 'BillAmt_Pre', 'Vintage']

analysis = sales.groupby('Segment')[cols].mean().reset_index().round(2)
analysis
# Segment	Age	BillAmt_Product	BillAmt_Service	BillAmt_Pre	Vintage
# 0	1	49.77	82333.62	40233.62	54972.35	6.46
# 1	2	26.99	12581.38	 3762.18	12597.52	1.00
# 2	3	37.40	42587.36	16023.76	30189.12	3.50
# 3	4	60.14	82375.20	39866.85	55156.91	6.54



# %% 1 - 
fig, axes = plt.subplots(nrows = 2, ncols = 3, figsize = (15, 8))
axe = axes.ravel()

for i, cols in enumerate(cols):
    analysis.plot.bar('Segment', cols, color = 'maroon', ax = axe[i], sharey = True)

fig.delaxes(axes.flatten()[5])

plt.tight_layout()
plt.show()







# %% 1 - 
CL = KMeans(n_clusters = 3).fit(scaled)


# %% 1 - 
labels = CL.labels_
sizes = np.bincount(labels)
print(sizes)
# [8067 7895 8057]


# %% 1 - 
segment = pd.DataFrame({'Segment': labels})

sales = pd.concat([data.reset_index(drop = True), segment], axis = 1)
sales['Segment'] = sales['Segment'] + 1
sales.head()
# 	Age	BillAmt_Product	BillAmt_Service	BillAmt_Pre	Vintage	Segment
# 0	49	81128.27	48203.10	62975.45	5.0	1
# 1	34	59480.20	17263.19	23633.58	5.0	3
# 2	58	65363.07	30660.67	45888.87	6.0	1
# 3	48	84073.28	47181.46	43186.04	7.0	1
# 4	26	10541.03	3550.96	12753.15	1.0	2



# %% 1 - 
cols = ['Age', 'BillAmt_Product', 'BillAmt_Service', 'BillAmt_Pre', 'Vintage']

analysis = sales.groupby('Segment')[cols].mean().reset_index().round(2)
analysis
# 	Segment	Age	BillAmt_Product	BillAmt_Service	BillAmt_Pre	Vintage
# 0	1	54.97	82354.48	40049.61	55064.95	6.5
# 1	2	26.99	12581.38	3762.18	12597.52	1.0
# 2	3	37.40	42587.36	16023.76	30189.12	3.5



# %% 1 - 
fig, axes = plt.subplots(nrows = 2, ncols = 3, figsize = (15, 8))
axe = axes.ravel()

for i, cols in enumerate(cols):
    analysis.plot.bar('Segment', cols, color = 'cadetblue', ax = axe[i], sharey = True)

fig.delaxes(axes.flatten()[5])

plt.tight_layout()
plt.show()


