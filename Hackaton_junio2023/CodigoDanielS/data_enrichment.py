"""
This code is used to enrich the data from the database
 - First, the data is normalized by rows
 - Second, the data is enriched using SMOTE
"""

# Import libraries
import pandas as pd
import numpy as np
from sklearn.preprocessing import MinMaxScaler
from sklearn.preprocessing import StandardScaler
from sklearn.preprocessing import RobustScaler
from sklearn.preprocessing import Normalizer
from sklearn.preprocessing import QuantileTransformer
from sklearn.preprocessing import PowerTransformer
from sklearn.preprocessing import OneHotEncoder
from sklearn.preprocessing import OrdinalEncoder
from sklearn.preprocessing import LabelEncoder
from sklearn.preprocessing import Binarizer

import matplotlib.pyplot as plt


# Import data
df_i = pd.read_csv('Hackaton_junio2023/CodigoDanielS/c23/biom_2016.tsv', sep='\t', header=0)

# # take a sabple of the data with N columns and N rows
# N = 10
# df_i = df_i.iloc[:N,:N]

# extract data from the database
data = df_i.iloc[:,1:].values
data = np.array(data, dtype=float).T

# Start the normalization process
scaler = PowerTransformer()
df_norm = scaler.fit_transform(data)

# Save into the original dataframe
df_o = df_i.copy()
df_o.iloc[:,1:] = df_norm.T

# Block of prints manhattan like plot -----------------------------------------
city1 = df_o.iloc[1:,1]
city2 = df_o.iloc[1:,2]
city3 = df_o.iloc[1:,3]
plt.scatter(range(len(city1)), city1, label='city1', s=1)
plt.scatter(range(len(city2)), city2, label='city2', s=1)
plt.scatter(range(len(city3)), city3, label='city3', s=1)
cityb1 = df_o.iloc[1:,-1]
cityb2 = df_o.iloc[1:,-2]
cityb3 = df_o.iloc[1:,-3]
plt.scatter(range(len(cityb1)), cityb1, label='cityb1', s=1)
plt.scatter(range(len(cityb2)), cityb2, label='cityb2', s=1)
plt.scatter(range(len(cityb3)), cityb3, label='cityb3', s=1)
plt.legend()

# Block to save the data into a file ------------------------------------------
scaler_name = scaler.__class__.__name__
df_o.to_csv(f"Hackaton_junio2023/CodigoDanielS/gen_{scaler_name}.tsv", sep='\t', index=False)
plt.savefig(f"Hackaton_junio2023/CodigoDanielS/gen_{scaler_name}.png")

# Finish the program -----------------------------------------------------------
plt.close()
pass
