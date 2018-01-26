clc, clearvars

% number of test images
NUM_IMAGES = 10;

% number of multispectral image bands
NUM_MSI_BANDS = 3;

% image dimensions
NUM_ROWS = 8192;
NUM_COLS_L0 = 8192;
NUM_COLS_L1 = 8160;

% create blank images to store the msi bands
msiL0 = zeros(NUM_ROWS, NUM_COLS_L0, NUM_MSI_BANDS);
msiL1 = zeros(NUM_ROWS, NUM_COLS_L1, NUM_MSI_BANDS);

for i = 1:NUM_IMAGES
    % read L0 and L1 pan images
    panImageNameL0 = strcat('../images/', num2str(i), '/L0/0/image.tif');
    panImageNameL1 = strcat('../images/', num2str(i), '/L1/0/image.tif');
    panL0 = imread(panImageNameL0);
    panL1 = imread(panImageNameL1);

    % read the MSI bands produced using DTW
    for b = 1:NUM_MSI_BANDS
        msiL0(:, :, b) = imresize(imread(strcat('../images/', num2str(i), '/L0/', num2str(b), '/image.tif')), 2);
        msiL1(:, :, b) = imresize(imread(strcat('../images/', num2str(i), '/L1/', num2str(b), '/image.tif')), 2);
    end

    % pansharp raw images
    pansharpL0 = pansharp_hcs(panL0, msiL0);
    pansharpL1 = pansharp_hcs(panL1, msiL1);
   
    % write sharpened images
    imwrite(uint16(pansharpL0), strcat('../images/', num2str(i), '/L0/pansharp_hcs.tif'));                            
    imwrite(uint16(pansharpL1), strcat('../images/', num2str(i), '/L1/pansharp_hcs.tif')); 

    % write thumbnails
    imwrite(32 * imresize(uint16(pansharpL0), 0.2), strcat('../images/', num2str(i), '/L0/pansharp_hcs_thumbnail.tif'));
    imwrite(32 * imresize(uint16(pansharpL1), 0.2), strcat('../images/', num2str(i), '/L1/pansharp_hcs_thumbnail.tif')); 
    
    fprintf('Pansharpening successful for raw image #%d.\n', i);
end