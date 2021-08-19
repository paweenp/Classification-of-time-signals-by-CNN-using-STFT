% Downsample Images if required
function performResizeImgs(save_dir, filetype, resize_factor)

% List all images in path
imgs_path = save_dir + '\*' + filetype;
imgs_list = dir(imgs_path);

total_images = size(imgs_list, 1);

for idx = 1:total_images
    tmpImg = imread(imgs_list(idx).folder+"\"+imgs_list(idx).name);
    tmpImg = imresize(tmpImg, resize_factor, 'Colormap', 'original');
    imwrite(tmpImg, save_dir+"\"+imgs_list(idx).name);
end

end