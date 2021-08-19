% Perform STFT and return Spectrogram Images
function genSpectrogramImages(save_dir, filetype, data, duration, win, overlap)

total_row = size(data, 1);

for idx = 1:total_row
        curr_data = data(idx, :);
        stft(curr_data, duration,'Window', win, 'OverlapLength', overlap);
        
        % Left out other metrics from image
        set(gca, 'Visible', 'off'); % Clear Text from graph
        colorbar('off'); % Disable colorbar
        
        % Create directory if not exist
        
        if ~exist(save_dir, 'dir')
            mkdir(save_dir)
        end
        
        % Save Spectrogram Image
        saveas(gcf, save_dir + "\" + idx + filetype);
end      

        