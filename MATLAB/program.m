% This program bahaves as following 
% 1. Read Data input from CSV or xlsx files.
% 2. Perform Short-Time Fourier Transform (STFT) and return as Spectrogram
% Images
% 3. Create Convolution Neural Network (CNN) 
% 4. Train Network with the Spectrogram Images (Randomly picked up train
% and validation data )
% 5. Plot the Graph showing the training and validation

%% 1. - 2.
data_path = "C:\workspace\FRA-UAS\semester2\CompInt\CompInt-Project-T3\Data";
list_obj = dir(data_path + '\*.xlsx');
total_obj = size(list_obj, 1);

window = hamming(256); % window_size = 64, 128, 256
overlap = 50; % 50 percent overlap between windows
duration = seconds(1e-3); % duration of 1ms
filetype = '.png'; % set file type here for JPG, PNG or other image filetype
folder_name = "SpectrogramImgs"; % folder of output sub-folders
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

imds = imageDatastore(folder_name, ...
    'LabelSource', ...
    'foldernames', ...
    'IncludeSubfolders', true, ...
    'FileExtensions', filetype);

% Create CNN layers
disp("Construct CNN Layers ...");
input = imread(imds.Files{1});
CNNlayers = createCNNlayers(size(input));

%% 4.
% data selection option
train_test_ratio = 0.8;

% Create labels
labelCount = countEachLabel(imds);

% Select 80 % For train and 20 % for test in each Object
[imdsTrain, imdsTest] = splitEachLabel(imds, train_test_ratio, 'randomize');
numTrain = size(imdsTrain.Files, 1);
numTest = size(imdsTest.Files, 1);

%% Temp Section !TODO Delete this line

disp("Select " + numTrain + " images for Training ...");
disp("Select " + numTest + " images for Testing ...");

% Set trainig options
options = trainingOptions('sgdm', ...
    'InitialLearnRate',0.01, ...
    'MaxEpochs',30, ...
    'MiniBatchSize',16, ...
    'Shuffle','every-epoch', ...
    'ValidationData',imdsTest, ...
    'ValidationFrequency',30, ...
    'Verbose',false, ...
    'Plots','training-progress');

% Train a model
disp("Train model ....");

model = trainNetwork(imdsTrain,CNNlayers,options);

%% 5.
disp("Classify network with Test Data ...");
[YPred, score] = classify(model, imdsTest);
YTest = imdsTest.Labels;

% Accuracy
accuracy = sum(YPred == YTest)/numel(YTest);
disp("accuracy : " + accuracy);

% Confusion Matrix
C_Matrix = confusionmat(YPred, YTest);

% Plot confusion matrix
plotconfusion(YTest,YPred)
cm = confusionmat(YTest,YPred);
cm = cm';

% Computing precision and recall and F1-Score
precision = diag(cm)./sum(cm, 2);
overall_precision = mean(precision);
recall= diag(cm)./sum(cm, 1)';

disp("End of Program");