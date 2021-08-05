# read excell file
import  numpy as np
import matplotlip as matplotlip
import matplotlib.pyplot as plt
import openpyxl
df = openpyxl.load_workbook("Data Object 2.xlsx")



sheet= df.active
rows = sheet.max_row
columns = sheet.max_column
print(rows, columns)

#import pandas as pd
#df = pd.read_excel('Data Object 2.xlsx')

print(df)
lista=[]
for j in range(1,3):
    for i in range(1,sheet.max_column+1):
        e=sheet.cell(row=j, column=i)
        lista.append(e.value)
    print(lista)
    print('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$')





