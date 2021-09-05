% Create Convolutional Neural Network
function CNNlayers = createCNNlayers(input_size)
CNNlayers = [
    imageInputLayer(input_size)
    
    
    %creates a 2-D convolutional layer with 8 filters of size [3 3] and
    %at training time, the software calculates and sets the size of the 
    %padding so that the layer output has the same size as the input.
    convolution2dLayer(3,8,'Padding','same')
    batchNormalizationLayer
    reluLayer
    
    %creates a max pooling layer with pool size [2 2] and stride [2 2]
    %means each filter moves by 2 pixel.
    maxPooling2dLayer(2,'Stride',2)
    
    %We have to increase the number of filters so it will give more
    %complexity or strength & capability to our neural network
    convolution2dLayer(3,16,'Padding','same')
    batchNormalizationLayer
    reluLayer
    
    maxPooling2dLayer(2,'Stride',2)
    
    convolution2dLayer(3,32,'Padding','same')
    batchNormalizationLayer
    reluLayer
    
    maxPooling2dLayer(2,'Stride',2)
    
    convolution2dLayer(3,64,'Padding','same')
    batchNormalizationLayer
    reluLayer
    
    maxPooling2dLayer(2,'Stride',2)
    

    convolution2dLayer(3,128,'Padding','same')
    batchNormalizationLayer
    reluLayer
    
    
    %A fully connected layer multiplies the input by
    %a weight matrix and then adds a bias vector.
    % it is 3 because we have 3 type of spectrograms
    fullyConnectedLayer(3)
    softmaxLayer
    classificationLayer];


end