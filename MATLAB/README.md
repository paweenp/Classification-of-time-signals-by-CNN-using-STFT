## MATLAB 

In this directory, you will find the following content as in Table below.

| Filename                	| Description                                                                                                                              	| Remarks 	|
|-------------------------	|------------------------------------------------------------------------------------------------------------------------------------------	|---------	|
| program.m               	| Main program of this experiment. You need to execute the experiment from this file. It will call other files as functions.               	|         	|
| genSpectrogramImages.m  	| This function is using for preprocessing. It performs Short-Time-Fourier-Transform (STFT) and generates Spectrogram Images into folder.  	|         	|
| createCNNlayers.m       	| This function create CNN layers. When you need to edit CNN layers, please look into this.                                                	|         	|
| performResizeImgs.m     	| Since the generated Spectrogram Images will be large. This function will resize images into the expected size.                           	|         	|
| performClassification.m 	| This function classifies between Train Images and Validate Images. Evaluation can be added in this function too.                         	|         	|
| Objects Folder          	| Contain object RAW data in xlsx extension                                                                                                	|         	|