function downsampleImages()

images_path = "C:\workspace\FRA-UAS\semester2\CompInt\Code\CompInt-Project-T3\MATLAB\Objects";
output_path = "C:\workspace\FRA-UAS\semester2\CompInt\Code\CompInt-Project-T3\MATLAB\DownsampledObjects";

resize_ratio = 0.1;

images_group = dir(images_path);
images_group = images_group(3:end,:);

for idx = 1:size(images_group, 1)
    imgsPath = images_group(idx).folder+"\"+images_group(idx).name+"\*.jpg";
    listImages = dir(imgsPath);
    outputGroupPath = output_path + "\" + images_group(idx).name;
    
    if exist(outputGroupPath, 'dir') == 0
        mkdir(outputGroupPath);
    end
    
    for jdx = 1:size(listImages, 1)
        tmpImg = imread(listImages(jdx).folder+"\"+listImages(jdx).name);
        tmpImg = imresize(tmpImg, resize_ratio);
        imwrite(tmpImg, outputGroupPath+"\"+listImages(jdx).name);
    end
    
end

end