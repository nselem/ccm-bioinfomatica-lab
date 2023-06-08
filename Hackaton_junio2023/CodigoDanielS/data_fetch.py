"""
fetch data using internet
"""

# Import libraries
import os
import pandas as pd
import numpy as np
import requests
from io import StringIO
import json
from selenium import webdriver
import time
from selenium.common.exceptions import StaleElementReferenceException
from selenium.common.exceptions import TimeoutException
from selenium.webdriver.common.by import By

# load csv data
dta = pd.read_csv("Hackaton_junio2023/CodigoDanielS/missingAmr_species - missingAmr_species.csv", sep=",", header=0)

# driver load
driver = webdriver.Chrome()

def wait_for_element(driver, locator, timeout=60):
    start_time = time.time()
    while time.time() - start_time < timeout:
        try:
            element = driver.find_element(*locator)
            return element
        except StaleElementReferenceException:
            pass
        time.sleep(1)
    raise TimeoutException("Element not found")

# iterate over all rows
for i in range(len(dta)):
    # get the row
    row = dta.iloc[i]

    # get gene, species, and fasta
    gene = row["gene"]
    species = row["species"]
    fasta = row["fasta"]

    # if fasta is not empty then continue
    if type(fasta) == str and fasta != "":
        continue
    
    # search the gene and species in ncbi database
    search = f"{gene} {species}"\
      .replace(" ","%20")\
      .replace("(","%28")\
      .replace(")","%29")
    url = f"https://www.ncbi.nlm.nih.gov/gene/?term={search}#see-all"
    
    # load the url using selenium
    r = driver.get(url)
    time.sleep(20)

    # Wait for the page to load
    wait_for_element(driver, (By.ID, "gene-tabular-docsum"))
    
    # process line by line
    txt = r.text\
      .replace("\n","")\
      .replace(">",">\n")
    for line in txt.split("\n"):
      if "jig-nbcigrid" in line:
        print(line)
      pass
    pass
pass