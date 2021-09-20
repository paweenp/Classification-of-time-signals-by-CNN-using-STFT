% This program bahaves as following 
% 1. Read Data input from CSV or xlsx files.
% 2. Perform Short-Time Fourier Transform (STFT) and return as Spectrogram
% Images
% 3. Create Convolution Neural Network (CNN) 
% 4. Train Network with the Spectrogram Images (Randomly picked up train
% and validation data )
% 5. Plot the Graph showing the training and validation

%% 1. - 2.
%Giving path of dataset folder
data_path = "/Users/md.rabiulislam/Downloads/CompInt-Project-T3-master 2/Data";
list_obj = dir(data_path + '\*.xlsx');
total_obj = size(list_obj, 1);


window = hamming(256); % window_size = 64, 128, 256
overlap = 50; % 50 percent overlap between windows
duration = seconds(1e-3); % duration of 1ms
filetype = '.jpg'; % set file type here for JPG, PNG or other image filetype
folder_name_one = "SpectrogramImgsOb1"; % folder of output sub-folders
folder_name_two = "SpectrogramImgsOb2"; % folder of output sub-folders
folder_name_three = "SpectrogramImgsOb3"; % folder of output sub-folders
subfolder_prefix = "object"; % name of output folder with index of object
resize_factor = 0.2;

for idx = 1:total_obj
    
    disp("Reading " + list_obj(idx).name + "...");
    
    full_path = [list_obj(idx).folder, '\', list_obj(idx).name];
    data = readmatrix(full_path);
    save_dir = folder_name + "\" + subfolder_prefix + idx;
    
    disp("Generate Spectrogram Images of object " + idx + "...");
    
    % If directory exist and is not empty then the program will skip from
    % this point
    folder = dir(save_dir + "\*" + filetype);
    if  ~isempty(folder)
        continue;
    end
    
    genSpectrogramImages(save_dir, ...
                        filetype, ...
                        data, ...
                        duration, ...
                        window, ...
                        overlap); 

    disp("Generating Spectrogram Images of object " + idx + " is done.");
    
    
    % Resize images's dimension if required
    if resize_factor ~= 1
        
        disp("Resizing Images of object " + idx + "...");
        
        performResizeImgs(save_dir, filetype, resize_factor);
        
        disp("Resizing Images of object " + idx + " is done! ");
    end
                 
end

%% 3.
disp("Construct Image Data Store ...");

imds_one = imageDatastore(folder_name_one, ...
    'LabelSource', ...
    'foldernames', ...
    'IncludeSubfolders', true, ...
    'FileExtensions', filetype);

imds_two = imageDatastore(folder_name_two, ...
    'LabelSource', ...
    'foldernames', ...
    'IncludeSubfolders', true, ...
    'FileExtensions', filetype);
imds_three = imageDatastore(folder_name_three, ...
    'LabelSource', ...
    'foldernames', ...
    'IncludeSubfolders', true, ...
    'FileExtensions', filetype);

% Create CNN layers
disp("Construct CNN Layers ...");
input_one = imread(imds_one.Files{1});
input_two = imread(imds_two.Files{1});
input_three = imread(imds_three.Files{1});

%CNNlayers = createCNNlayers(size(input_one)+size(input_two)+size(input_three));
CNNlayers = createCNNlayers(size(input_one));
%% 4.
% data selection option
train_test_ratio = 0.8; 

% Create labels
labelCount = countEachLabel(imds_one);
numFilesForObjectOne = labelCount.Count;
labelCount = countEachLabel(imds_two);
numFilesForObjectTwo = labelCount.Count;
labelCount = countEachLabel(imds_three);
numFilesForObjectThree = labelCount.Count;
numTrainFilesOb1 = ceil(train_test_ratio * numFilesForObjectOne * 0.8);
numTrainFilesOb2 = ceil(train_test_ratio * numFilesForObjectTwo * 0.8);
numTrainFilesOb3 = ceil(train_test_ratio * numFilesForObjectThree * 0.8);


disp("Select " + numTrainFiles + " images for Training Data  ...");

[imdsOneTrain, imdsValidation] = splitEachLabel(imds_one,numTrainFilesOb1, 'randomize');
[imdsTwoTrain, imdsValidationTwo] = splitEachLabel(imds_two,numTrainFilesOb2, 'randomize');
[imdsThreeTrain, imdsValidationThree] = splitEachLabel(imds_three,numTrainFilesOb3, 'randomize');

% Set trainig options
options = trainingOptions('sgdm', ...
    'InitialLearnRate',0.01, ...
    'MaxEpochs',6, ...
    'MiniBatchSize',16, ...
    'Shuffle','every-epoch', ...
    'ValidationData',imdsValidation, ...
    'ValidationFrequency',30, ...
    'Verbose',false, ...
    'Plots','training-progress');
optionsTwo = trainingOptions('sgdm', ...
    'InitialLearnRate',0.01, ...
    'MaxEpochs',6, ...
    'MiniBatchSize',16, ...
    'Shuffle','every-epoch', ...
    'ValidationData',imdsValidationTwo, ...
    'ValidationFrequency',30, ...
    'Verbose',false, ...
    'Plots','training-progress');
optionsThree = trainingOptions('sgdm', ...
    'InitialLearnRate',0.01, ...
    'MaxEpochs',6, ...
    'MiniBatchSize',16, ...
    'Shuffle','every-epoch', ...
    'ValidationData',imdsValidationThree, ...
    'ValidationFrequency',30, ...
    'Verbose',false, ...
    'Plots','training-progress');

% Train a model
disp("Train model ....");

model = trainNetwork(imdsOneTrain,CNNlayers,options);
modelTwo = trainNetwork(imdsTwoTrain,CNNlayers,optionsTwo);
modelThree = trainNetwork(imdsThreeTrain,CNNlayers,optionsThree);


%% 5.
disp("Classify network with Test Data ...");

[YPred, score] = classify(model, imdsValidation);
%[YPred, score] = classify(modelTwo,imdsValidationTwo);

%[YPred, score] = classify(modelThree,imdsValidationThree);


YTest = imdsValidation.Labels;

%finding accuracy 
accuracy = sum(YPred == YTest)/numel(YTest);





%Plot confusion matrix
plotconfusion(YTest,YPred)
cm = confusionmat(YTest,YPred);
cm = cm';

% computing percision and recall and F1Score
precision = diag(cm)./sum(cm,2);
overall_precision = mean(precision)
recall= diag(cm)./sum(cm,1)';
overall_recall = mean(recall);

F_score=2*overall_recall*overall_precision/(overall_precision+overall_recall);
overall_F_score = mean(F_score)

disp("accuracy : " + accuracy);
disp("overall_precision : " + overall_precision);
disp("overall_recall : " + overall_recall);
disp("F_score : " + overall_F_score);

disp("End of Program");
