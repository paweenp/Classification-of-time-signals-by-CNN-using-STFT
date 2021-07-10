%% Create a CNN mnodel and train

%% Read amd label Iamges

%   1.Read Images to Program
%   2.Label Images

image_path = "C:\workspace\FRA-UAS\semester2\CompInt\CompInt-Project-T3\MATLAB\DownsampledObjects";

% Create Image Data Store
imds = imageDatastore(image_path, ...
    'LabelSource', 'foldernames', ...
    'IncludeSubfolders', true ...
    ,'FileExtensions', '.jpg');

labelCount = countEachLabel(imds);

img = readimage(imds,10);

numFilesForEachObject = min(labelCount.Count);

numTrainFiles = ceil(0.66 * numFilesForEachObject); % train 80 % and test 20 %

[imdsTrain,imdsValidation] = splitEachLabel(imds,numTrainFiles,'randomize');

inputImg = imread(imds.Files{1});
ImgSize  = size(inputImg);

% Create CNN layers
ConvNetlayers = [
    imageInputLayer(ImgSize)
    
    convolution2dLayer(3,8,'Padding','same')
    batchNormalizationLayer
    reluLayer
    
    maxPooling2dLayer(2,'Stride',2)
    
    convolution2dLayer(3,16,'Padding','same')
    batchNormalizationLayer
    reluLayer
    
    maxPooling2dLayer(2,'Stride',2)
    
    convolution2dLayer(3,32,'Padding','same')
    batchNormalizationLayer
    reluLayer
    
    fullyConnectedLayer(3)
    softmaxLayer
    classificationLayer];

options = trainingOptions('sgdm', ...
    'InitialLearnRate',0.01, ...
    'MaxEpochs',4, ...
    'MiniBatchSize',16, ...
    'Shuffle','every-epoch', ...
    'ValidationData',imdsValidation, ...
    'ValidationFrequency',30, ...
    'Verbose',false, ...
    'Plots','training-progress');

% Train Network
net = trainNetwork(imdsTrain,ConvNetlayers,options);

%% Classify using Trained Network
[label,score] = classify(net,img);

h = figure;
h.Position(3) = 2*h.Position(3);
ax1 = subplot(1,2,1);
ax2 = subplot(1,2,2);
image(ax1,img);

title(ax1,{char(label),num2str(max(score),2)});
[~,idx] = sort(score,'descend');
classes = net.Layers(end).Classes;
classNamesTop = string(classes(idx));
scoreTop = score(idx);
barh(ax2,scoreTop)
xlim(ax2,[0 1])
title(ax2,'Classification')
xlabel(ax2,'Probability')
yticklabels(ax2,classNamesTop)
ax2.YAxisLocation = 'right';
