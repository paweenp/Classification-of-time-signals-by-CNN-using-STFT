%% Generate Spectogram Image and Save to files
function GenerateSpectrogramImages()

configFile = "userSettings.json";

% Read Config data to application
fid = fopen(configFile); % Opening the file
raw = fread(fid,inf); % Reading the contents
str = char(raw'); % Transformation
fclose(fid); % Closing the file
userSettings = jsondecode(str); % Using the jsondecode function to parse JSON from string

% List all file in dir
object_list = dir(convertCharsToStrings(userSettings.dataPath) + convertCharsToStrings(userSettings.fileType));

% Configuration for STFT Window
win = hamming(128);
d = seconds(1e-3);

dir_prefix = convertCharsToStrings(userSettings.outputDirPredix);

%% STFT
for index = userSettings.beginObjectNumber:userSettings.untilObjectNumber
    
    file_fullpath = object_list(index, 1).folder + "\" + object_list(index, 1).name;
    data = readmatrix(file_fullpath);
    
    
    for jindex = 1:size(data,1)
        stft(data(jindex,:), d, 'Window', win, 'OverlapLength', 50);
        set(gca, 'Visible', 'off'); % Clear Text from graph
        colorbar('off'); % Disable colorbar
        
        % Create directory if not exist
        save_dir = dir_prefix + index;
        if ~exist(save_dir, 'dir')
            mkdir(save_dir)
        end
        
        saveas(gcf, dir_prefix + index + "\" + jindex + convertCharsToStrings(userSettings.outputFiletype));
    end
    
end

end