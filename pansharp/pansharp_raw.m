clc, clearvars

% number of multispectral image bands
NUM_MSI_BANDS = 3;

% image dimensions
NUM_ROWS = 8192;
NUM_COLS = 8192;

% create blank images to store the msi bands
msi1 = zeros(NUM_ROWS, NUM_COLS, NUM_MSI_BANDS);
msi2 = zeros(NUM_ROWS, NUM_COLS, NUM_MSI_BANDS);

% read 2 raw images
panImageName1 = strcat('../images/raw1/L0_1/0/image.tif');
panImageName2 = strcat('../images/raw2/L0_1/0/image.tif');
pan1 = imread(panImageName1);
pan2 = imread(panImageName2);

% read the MSI bands produced using DTW
for b = 1:NUM_MSI_BANDS
    msi1(:, :, b) = imresize(imread(strcat('../images/raw1/L0_1/', num2str(b), '/image.tif')), 2);
    msi2(:, :, b) = imresize(imread(strcat('../images/raw2/L0_1/', num2str(b), '/image.tif')), 2);
end

% pansharp raw images
pansharp1 = pansharp_hcs(pan1, msi1);
pansharp2 = pansharp_hcs(pan2, msi2);

% write sharpened images
imwrite(uint16(pansharp1), strcat('../images/raw1/L0_1/pansharp_hcs.tif'));                            
imwrite(uint16(pansharp2), strcat('../images/raw2/L0_1/pansharp_hcs.tif')); 

% write thumbnails
imwrite(32 * imresize(uint16(pansharp1), 0.2), strcat('../images/raw1/L0_1/pansharp_hcs_thumbnail.tif'));
imwrite(32 * imresize(uint16(pansharp2), 0.2), strcat('../images/raw2/L0_1/pansharp_hcs_thumbnail.tif')); 