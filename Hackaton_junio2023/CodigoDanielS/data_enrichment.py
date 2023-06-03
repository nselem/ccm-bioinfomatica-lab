"""
This code is used to enrich the data from the database
 - First, the data is normalized by rows
 - Second, the data is enriched using SMOTE
"""

# Import libraries
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
from imblearn.over_sampling import SMOTE
from sklearn.preprocessing import (Binarizer, LabelEncoder, MinMaxScaler,
                                   Normalizer, OneHotEncoder, OrdinalEncoder,
                                   PowerTransformer, QuantileTransformer,
                                   RobustScaler, StandardScaler)

# Import data
df_i = pd.read_csv('Hackaton_junio2023/CodigoDanielS/c23/biom_2016.tsv', sep='\t', header=0)

# Block to enrich the data -----------------------------------------------------
data_x = np.array(df_i.iloc[:,1:], dtype=float).T
data_y = [h.split('_')[-2] for h in df_i.head() if h.startswith("CAMDA")]

# Prepare the SMOTE algorithm
smote = SMOTE(sampling_strategy='auto', k_neighbors=5, random_state=42)

# Fit and transform the data
data_x, data_y = smote.fit_resample(data_x, data_y)

# Save the data into a dataframe
df_e = df_i.copy().iloc[:,:1]
idx = {k:0 for k in set(data_y)}
for i in range(len(data_y)):
  city = data_y[i]
  idx[city] += 1
  df_e[f"SMOTE_MetaSUB_gCSD16_{city}_{idx[city]:02d}"] = data_x[i]

# -----------------------------------------------------------------------------
def normalize_data(_df,prefix=""):
  # # take a sabple of the data with N columns and N rows
  # N = 10
  # df_i = df_i.iloc[:N,:N]

  # extract data from the database
  data = _df.iloc[:,1:].values
  data = np.array(data, dtype=float).T

  # Start the normalization process
  scaler = QuantileTransformer()
  df_norm = scaler.fit_transform(data)

  # Save into the original dataframe
  df_o = _df.copy()
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
  df_o.to_csv(f"Hackaton_junio2023/CodigoDanielS/dta_{prefix}_{scaler_name}.tsv", sep='\t', index=False)
  plt.savefig(f"Hackaton_junio2023/CodigoDanielS/dta_{prefix}_{scaler_name}.png")

  # Finish the program -----------------------------------------------------------
  plt.close()


if __name__ == "__main__":
  # normalize input data
  normalize_data(df_i, prefix="original")
  # normalize enrichment data
  normalize_data(df_e, prefix="enriched")
  pass
