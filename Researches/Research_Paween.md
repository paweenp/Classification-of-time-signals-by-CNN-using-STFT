# Researches on Computational Intelligence Project T3: Classification of time signals by CNN using STFT
## Following topics are covered
1.  Classification of time sinals with STFT (Short Time Fourier Transform)
2.  Apply CNN (Convolutional Neural Network) to 1. 

# Short Time Fourier Transform (STFT)
Why uses STFT?
<br>Why not Fast Fourier Transform (FFT)?
<br>What is its benefit?
<br>What features does it provide?

# Comparison of FFT and STFT

FFT is used when you want to understand the frequency spectrum of a signal. For example, from the above FFT graph we can say that most of the energy in this female soprano's G5 note is concentrated in the 784 Hz and 1572 Hz frequencies.

STFT or "Short-Time Fourier Transform" uses a sliding-frame FFT to produce a 2D matrix of Frequency versus Time, often represented as a graph called a Spectrogram

FFT

![FFT](https://i.stack.imgur.com/Wd9BW.jpg?raw=true)

STFT

![STFT](https://i.stack.imgur.com/AltPA.png?raw=true)

The STFT is used when you want to know at what time a particular frequency event occurs in the signal. For example, from the above graph we can say that a large portion of the energy in this vocal phrase occurred between 0.05 and 0.15 seconds, in the frequency range of 100 Hz to 1500 Hz.

References: https://stackoverflow.com/questions/23369742/stft-fft-work-flow-order

## STFT Window and Overlap
What is windows and why do we need it?
What is the overlap?


Window indicates how many samples we will analyse. Without Window the STFT will be the same as FFT.

Overlaps occur when there is a merge between wave in windows.

※ hop size indicates how often we analyse the data.

![Windows-with-overlaps](images/stft_window_hop.JPG?raw=true);

Why do we need overlap?

To preserve the data. Take a look at this below image.

Without overlap 

3 chunks of N sized window

![Window-wo-overlap](https://i.stack.imgur.com/QUigc.png)

Overlap of N sized window

![Window-w-overlap](https://i.stack.imgur.com/4apGY.png)

![STFT-overlapp](https://cnx.org/resources/b691181f1805e0416ac7d71841ccb883d1dca470/stftfigs.png?raw=true);



References: https://learn.flucoma.org/algorithms/stft/
<br>References2: https://dsp.stackexchange.com/questions/19311/stft-why-overlapping-the-window
<br>Reference3: https://cnx.org/contents/0sbTkzWQ@2.2:PmFjFoIu@5/Short-Time-Fourier-Transform










