% This program behaves as folloing
% 1. Create Image Data Store of Testing Data
% 2. Read CNN model into program
% 3. Classify each Image Data Store and return value
% 4. Generate result csv file 

%% 1.
disp("Start Program");

disp("Load images into Image Data storage.");

data_path = ".\..\Data";
list_obj = dir(data_path + '\T File*.xlsx');
total_obj = size(list_obj, 1);
folder_name = "TObjects"; % folder of output sub-folders
filetype = ".png";
model_filename = 'CNNmodel.mat';

imds = imageDatastore(folder_name, ...
    'LabelSource', ...
    'foldernames', ...
    'IncludeSubfolders', true, ...
    'FileExtensions', filetype);


countLabel = countEachLabel(imds);
numLabel = size(countLabel, 1);
numAllFiles = size(imds.Files, 1);
numEachObject = numAllFiles / numLabel;

% Distinguish objects by each label
% Structure of objects using cell type
% | {n images of object 1} | label string |
% | {n images of object 2} | label string |
% ...
objects = cell(numLabel, 2); 

for index = 1:numLabel
    
    begin = numEachObject * (index - 1) + 1;
    until = numEachObject * (index);
    
    objects{index, 1} = imds.Files(begin:until);
    objects{index, 2} = imds.Labels(begin:until);
    
end

%% 2
disp("Load CNN Model ...");
 model = load(model_filename,'-mat');
 model = model.model;
 
 
%% 3 Classification
% 
result_filename = "classified_result.csv";

% Classified Result contains results as following structure
% | T1    | Label    |
% | 1.png | Object 1 |
% | 2.png | Object 1 |
% | ...   | ...      |
% | 50.png| Object 1 |
% | T2    | Label    |
% | 1.png | Object 1 |
% | 2.png | Object 2 |
% | ...   | ...      |

headers = { 'Object', ...
                'Image', ...
                'Classified Result', ...
                'Classified Result as number', ...
                'Score-obj1', ...
                'Score-obj2', ...
                'Score-obj3'};
            
% Cell             
%classified_result = cell(numAllFiles + 1, size(headers, 2));
% for index = 1:size(headers, 2)
%     classified_result{1,index} = headers(index);
% end

% Table
classified_result = table('Size', [numAllFiles size(headers, 2)], ...
                          'VariableTypes', {'string', 'string', 'string', 'double', 'double', 'double'});
classified_result.Properties.VariableNames = headers;

disp("Begin Classification Process");
for item = 1:numLabel
    
    tmp_object = cell2table(objects{item, 1});
    [YPred, scores] = classify(model, tmp_object);
    
    begin = (item - 1)*size(YPred, 1) + 1;
    until = item * size(YPred, 1);
    
    counter = 1;
    classified_result{begin:until, counter} = objects{item, 2};
    counter = counter + 1;
    
    classified_result{begin:until, counter} = objects{item, 1};
    counter = counter + 1;
    
    classified_result{begin:until, counter} = YPred;
    counter = counter + 1;
    
    classified_result{begin:until, counter:counter+2} = scores;  
end
 
 disp("Write File to " + result_filename + "...");
 writetable(classified_result, result_filename);
 
 disp("End of Program");
 
 