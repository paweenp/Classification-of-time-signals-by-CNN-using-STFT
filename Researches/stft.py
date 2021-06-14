#k= length of window
#fs= Sampling frequency
#n= Number of STFT calculated
#matrix= Initially empty numpy array

for i in range(0,n):
  t=data[start:end,:]   #start & end calculated with each iteration
  t=t.flatten()
  t=t-127.5
  array = np.empty(t.shape[0]//2, dtype=np.complex128)
  array.real = t[::2]
  array.imag = t[1::2]

  transform=(np.fft.fft(temp_array))
  line = 2*abs(transform)/k

  #Inserting row into numpy array
  if(i==0):
     matrix = np.hstack((matrix, line))
  else:
     matrix = np.vstack((matrix, line))