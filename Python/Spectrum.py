
import glob, os
import pandas as pd
import matplotlib.pyplot as plt

#Read all .CVV files from the directory
path_csv = glob.glob("*.csv")

#counting the number of CSV files
Num_Csv = len(path_csv)

#plottiing the spectrum of each object in the directory
def make_spec():
