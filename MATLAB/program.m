% This program bahaves as following 
% 1. Read Data input from CSV or xlsx files.
% 2. Perform Short-Time Fourier Transform (STFT) and return as Spectrogram
% Images
% 3. Create Convolution Neural Network (CNN) 
% 4. Train Network with the Spectrogram Images (Randomly picked up train
% and validation data )
% 5. Plot the Graph showing the training and testing
% 6. Show Confusion Matrix and Evaluation.
% 7. Save the experiment result and export as csv file.

%% 1. - 2.
%Giving path of dataset folder
data_path = ".\..\Data";
list_obj = dir(data_path + '\*Data Object*.xlsx');
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
        disp("Found Spectrogram Images, Skip generating spectrogram images process ...");
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

disp("Select " + numTrain + " images for Training ...");
disp("Select " + numTest + " images for Testing ...");


% execute experiment multiple times
experiment_loop = 100; % number of experiment times ( for ex, 1 means the experiment will run only 1 time )
plot_conf_mat = false; % set this param to true to see confusion matrix
plot_train_graph = false; % if user wanna see the training graph, set this parameter to true, if not then false

% prepare cell to collect data for each experiment;
% collect result as following table, while cm represent confusion matrix
% and number is position,for ex cm11 means true positive for object 1.

% | Loop_number | Accuracy | Precision | Recall | F1-Score | CM-11 | CM-21
% ... | CM-33 |
% -----------------------------------------------------------------------------------
% | ...         | ...      |           |        |          |
% | ...         | ...      |           |        |          |

% More on Confusion Matrix
% | Object |   1   |   2   |   3   |
% |   1    | CM-11 | CM-12 | CM-13 |
% |   2    | CM-21 | CM-22 | CM-23 |
% |   3    | CM-31 | CM-32 | CM-33 |

result_filename = "experiment_result.csv";
entity_headers = ["Loop Number", ...
                  "Accuracy", ...
                  "Precision", ...
                  "Recall", ...
                  "F1-Score", ...
                  "CM-11", ...
                  "CM-21", ...
                  "CM-31", ...
                  "CM-12", ...
                  "CM-22", ...
                  "CM-32", ...
                  "CM-31", ...
                  "CM-32", ...
                  "CM-33"];
              
exp_result = cell( experiment_loop + 2, size(entity_headers, 2) ); % collect all result
All_CM = zeros(total_obj, total_obj); % collect average Confusion Matrix value

% Set Header for each entity
for i = 1:size(exp_result, 2)   
        exp_result{1, i} = entity_headers(i);
end
        
for loop = 1:experiment_loop
    
    disp("Run experiment with loop number = " + loop);
    
    % Set trainig options
    if plot_train_graph == true % Plot Train/Test graph
        options = trainingOptions('sgdm', ...
            'InitialLearnRate',0.01, ...
            'MaxEpochs',30, ...
            'MiniBatchSize',16, ...
            'Shuffle','every-epoch', ...
            'ValidationData',imdsTest, ...
            'ValidationFrequency',30, ...
            'Verbose',false, ...
            'Plots','training-progress');
    else % Without Plotting Train/Test graph
        options = trainingOptions('sgdm', ...
            'InitialLearnRate',0.01, ...
            'MaxEpochs',30, ...
            'MiniBatchSize',16, ...
            'Shuffle','every-epoch', ...
            'ValidationData',imdsTest, ...
            'ValidationFrequency',30, ...
            'Verbose',false);
    end
    % Train a model
    disp("Train model ....");
    
    %% 5.
    model = trainNetwork(imdsTrain,CNNlayers,options);
    
    %% 6.
    disp("Classify network with Test Data ...");
    [YPred, score] = classify(model, imdsTest);
    YTest = imdsTest.Labels;
    
    %Plot confusion matrix
    if plot_conf_mat== true
        plotconfusion(YTest,YPred);
    end
    
    cm = confusionmat(YTest,YPred);
    cm = cm';
    
    % computing accuracy percision and recall and F1Score
    accuracy = sum(YPred == YTest)/numel(YTest);
    precision = diag(cm)./sum(cm,2);
    overall_precision = mean(precision);
    recall= diag(cm)./sum(cm,1)';
    overall_recall = mean(recall);
    
    F_score=2*overall_recall*overall_precision/(overall_precision+overall_recall);
    overall_F_score = mean(F_score);
    
    disp("accuracy : " + accuracy);
    disp("overall_precision : " + overall_precision);
    disp("overall_recall : " + overall_recall);
    disp("F_score : " + overall_F_score);
    
    % Collect Experiment result
    disp("Write Result from Experiment Loop "+loop+" to Table ...");
    
    counter = 1;
    exp_result{loop + 1, counter} = loop;
    counter = counter + 1;
    
    exp_result{loop + 1, counter} = accuracy;
    counter = counter + 1;
    
    exp_result{loop + 1, counter} = overall_precision;
    counter = counter + 1;
    
    exp_result{loop + 1, counter} = overall_recall;
    counter = counter + 1;
    
    exp_result{loop + 1, counter} = overall_F_score;
    counter = counter + 1;
    % Collect Confusion matrix result
    % CM 11 - 31
    for kindex = 1:size(cm, 1)
        exp_result{loop + 1, counter} = cm(kindex,1);
        counter = counter + 1;
    end
    % CM 12 - 32
    for kindex = 1:size(cm, 1)
        exp_result{loop + 1, counter} = cm(kindex,2);
        counter = counter + 1;
    end
    % CM 13 - 33
    for kindex = 1:size(cm, 1)
        exp_result{loop + 1, counter} = cm(kindex,3);
        counter = counter + 1;
    end
    
    disp("-------------------------------------------------------------------------");
end
%% 7

% Overall Result from Experiment

All_Accuracy  = mean( cell2mat( exp_result( 2:end, 2) ) );
All_Precision = mean( cell2mat( exp_result( 2:end, 3) ) );
All_Recall    = mean( cell2mat( exp_result( 2:end, 4) ) );
All_F1Score   = mean( cell2mat( exp_result( 2:end, 5) ) );

% Over all Confusion Matrix Result from Experiment
counter = 6; % CM-11 start from column 6
for index = 1:total_obj
    for jindex = 1:total_obj
        All_CM(jindex, index) = mean( cell2mat( exp_result( 2:end, counter) ) );
        exp_result{end, counter} = All_CM(jindex, index);
        counter = counter + 1;
    end
end

exp_result{end, 1} = "Average";
exp_result{end, 2} = All_Accuracy;
exp_result{end, 3} = All_Precision;
exp_result{end, 4} = All_Recall;
exp_result{end, 5} = All_F1Score;


disp("Overall Experiment Result from " + experiment_loop + " loops");
disp("Accuracy  = " + All_Accuracy);
disp("Precision = " + All_Precision);
disp("Recall    = " + All_Recall);
disp("F1-Score  = " + All_F1Score);

% Show confusion Matrix ( Integer format )
confusionchart(ceil(All_CM));

% Write result to csv files
disp("Write result to file as " + result_filename);
writecell(exp_result, result_filename);

disp("Write file finish!, End of program");
