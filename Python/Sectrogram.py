# read excell file
import matplotlib.pyplot
import numpy as np
import matplotlip as matplotlip
import pandas as pd
import matplotlib.pyplot as plt
import openpyxl
#os is used to list the files in a directory
import os



#print(df)

for k in range(1,4):
    df = openpyxl.load_workbook("Data Object " + str(k)+".xlsx")

    sheet = df.active
    rows = sheet.max_row
    row = rows + 1
    columns = sheet.max_column
    col = columns + 1
    print(rows, columns)
    lista = []
    listb = []
    directory = "object" + str(k)
    parent_dir = "D:\FRA-UAS\Sem2\CompInt-Project-T3\Python"
    path = os.path.join(parent_dir, directory)
    os.mkdir(path)
    for j in range(1, row):
        for i in range(1, col):
            e = sheet.cell(row=j, column=i)
            lista.append(e.value)
            listb.append(e.value)
        plt.plot(lista)
        plt.title(str(j))
        plt.show()
        lista = []
        plt.specgram(listb)
        plt.title(str(j))
        plt.show()
        listb = []
        #plt_spec = plt.make_spectrum(lista)
        #plt_spec.plot()
        #plt_spec.show()








