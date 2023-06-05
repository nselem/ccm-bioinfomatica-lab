"""
This code is used to classify data by city using 5-folds cross validation
"""

# Import libraries
import pandas as pd
from random import sample
from sklearn.ensemble import RandomForestClassifier
from matplotlib import pyplot as plt

# Load the dataset
VERSION = "original"
SCALER = "QuantileTransformer"
df = pd.read_csv(f"Hackaton_junio2023/CodigoDanielS/dta_{VERSION}_{SCALER}.tsv", sep='\t', header=0)

# 5-folds column selection
cols = {c:"_".join(c.split("_")[-3:-1]) for c in df.columns[1:]}
cols = {k:[c for c in cols if cols[c]==k] for k in set(cols.values())}
cols = {k:sample(v,len(v)) for k,v in cols.items()}
cols = [c for k in cols for c in cols[k]]
cols = {i:cols[i::5] for i in range(5)}

def cmPlot(cm,f1,acc):
  # sort rows/columns row names alphabetically
  cm = cm.sort_index(axis=0).sort_index(axis=1)

  # plot the confusion matrix
  fig, ax = plt.subplots(figsize=(10,10))
  ax.matshow(cm, cmap=plt.cm.Blues, alpha=0.3)
  for i in range(cm.shape[0]):
      for j in range(cm.shape[1]):
          ax.text(x=j, y=i, s=cm.iloc[i, j], va='center', ha='center', size='xx-large')

  # set x/y labels
  ax.set_xlabel('Predicted Label', fontsize=18)
  ax.set_ylabel('True Label', fontsize=18)

  # show ticks every 1 unit
  ax.set_xticks(range(len(cm.columns)))
  ax.set_yticks(range(len(cm.index)))

  # set tick labels
  ax.set_xticklabels(list(cm.columns), rotation=90, fontsize=16)
  ax.set_yticklabels(list(cm.index), fontsize=16)

  # set title
  ax.set_title(f"Confusion Matrix (F1={f1:.2f}, ACC={acc:.2f})", fontsize=20)


def id2city(_id,short=False):
  """
  This function is used to convert the id to city
  """
  if short:
    return _id.split("_")[-2]
  else:
    return "_".join(_id.split("_")[-3:-1])


def ids2cities(_ids,short=False):
  return [id2city(_id,short=short) for _id in _ids]


def classify(_df, groups, fold):
  """
  This function is used to classify the data by city using 5-folds cross validation
  """

  # Select the data
  train = [groups[i] for i in groups if i!=fold]
  train = [c for train_fold in train for c in train_fold]
  test = groups[fold]

  # Train the model
  model = RandomForestClassifier(n_estimators=100, max_depth=25, random_state=42)
  model.fit(_df[train][1:].T, ids2cities(train))

  # Predict the data
  pred = model.predict(_df[test][1:].T)

  # Data class correction
  SHORT = True
  pred = [p.split("_")[-1] if SHORT else p for p in pred]
  real = ids2cities(test,short=SHORT)

  # Confusion matrix
  cm = pd.crosstab(real, pred, rownames=['Actual'], colnames=['Predicted'])

  # fill missing columns with 0
  for city in set(cm.index).difference(cm.columns):
    cm[city] = 0
  # sort rows/columns row names alphabetically
  cm = cm.sort_index(axis=0).sort_index(axis=1)
  
  # F1 score multiclass
  f1 = 0
  for city in cm.index:
    tp = cm.loc[city,city]
    fp = cm.loc[city,:].sum() - tp
    fn = cm.loc[:,city].sum() - tp
    f1 += tp/(tp+0.5*(fp+fn))
  f1 /= len(cm.index)

  # Accuracy
  acc = cm.values.diagonal().sum()/cm.values.sum()

  # plot confusion matrix
  cmPlot(cm, f1, acc)

  return cm, f1, acc


if __name__ == "__main__":
  N = 5
  c_acc = 0
  c_f1 = 0
  # Run the classification
  for fold in range(N):
    cm, f1, acc = classify(df, cols, fold)
    print(f"Fold {fold+1}: F1 score = {f1:.3f}\tAccuracy = {acc:.3f}")
    #print(cm)
    c_acc += acc
    c_f1 += f1
  # Print the average
  print(f"Average: F1 score = {c_f1/N:.3f}\tAccuracy = {c_acc/N:.3f}")
pass