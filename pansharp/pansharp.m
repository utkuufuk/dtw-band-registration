clc, clearvars

% number of test images
NUM_IMAGES = 16;

% number of multispectral image bands
NUM_MSI_BANDS = 3;

% image dimensions
NUM_ROWS_DTW = 8192;
NUM_ROWS_SIFT = 8128;
NUM_COLS_L0 = 8192;
NUM_COLS_L1 = 8160;

% maximum shifted rows/cols 
MARGIN = 60;

% number of reference rows & cols in each iteration
NUM_REF_ROWS_COLS = linspace(1, 25, 5);

% output directory prefix
OUTPUT_DIR_PREFIX = '/enhanced_output_';

% create blank images to store the msi bands
msiDtwSimpleL0 = zeros(NUM_ROWS_DTW, NUM_COLS_L0, NUM_MSI_BANDS);
msiDtwSimpleL1 = zeros(NUM_ROWS_DTW, NUM_COLS_L1, NUM_MSI_BANDS);
msiDtwEnhancedL0 = zeros(NUM_ROWS_DTW, NUM_COLS_L0, NUM_MSI_BANDS);
msiDtwEnhancedL1 = zeros(NUM_ROWS_DTW, NUM_COLS_L1, NUM_MSI_BANDS);
msiSift = zeros(NUM_ROWS_SIFT, NUM_COLS_L1, NUM_MSI_BANDS);

for i = 1:NUM_IMAGES
    % read L0, L1 and L1R pan images
    panImageNameL0 = strcat('../images/', num2str(i), '/L0/0/image.tif');
    panImageNameL1 = strcat('../images/', num2str(i), '/L1/0/image.tif');
    panImageNameL1R = strcat('../images/', num2str(i), '/L1R/0/image.tif');
    panL0 = imread(panImageNameL0);
    panL1 = imread(panImageNameL1);
    panL1R = imread(panImageNameL1R);

    for r = NUM_REF_ROWS_COLS
        simpleDirL0 = strcat('../images/', num2str(i), '/L0/output_', num2str(r), '/');
        simpleDirL1 = strcat('../images/', num2str(i), '/L1/output_', num2str(r), '/');
        enhancedDirL0 = strcat('../images/', num2str(i), '/L0/enhanced_output_', num2str(r), '/');
        enhancedDirL1 = strcat('../images/', num2str(i), '/L1/enhanced_output_', num2str(r), '/');

        % read the MSI bands produced using DTW
        for b = 1:NUM_MSI_BANDS
            msiDtwSimpleL0(:, :, b) = imread(strcat(simpleDirL0, num2str(b), '.tif'));
            msiDtwSimpleL1(:, :, b) = imread(strcat(simpleDirL1, num2str(b), '.tif'));
            msiDtwEnhancedL0(:, :, b) = imread(strcat(enhancedDirL0, num2str(b), '.tif'));
            msiDtwEnhancedL1(:, :, b) = imread(strcat(enhancedDirL1, num2str(b), '.tif'));
        end
        
        % pansharp DTW outputs
        dtwSimpleHcsL0 = pansharp_hcs(panL0(MARGIN + 1:end - MARGIN, MARGIN + 1:end - MARGIN), ...
                                      msiDtwSimpleL0(MARGIN + 1:end - MARGIN, MARGIN + 1:end - MARGIN, :));
        
        dtwSimpleHcsL1 = pansharp_hcs(panL1(MARGIN + 1:end - MARGIN, MARGIN + 1:end - MARGIN), ...
                                      msiDtwSimpleL1(MARGIN + 1:end - MARGIN, MARGIN + 1:end - MARGIN, :));
        
        dtwEnhancedHcsL0 = pansharp_hcs(panL0(MARGIN + 1:end - MARGIN, MARGIN + 1:end - MARGIN), ...
                                        msiDtwEnhancedL0(MARGIN + 1:end - MARGIN, MARGIN + 1:end - MARGIN, :));
        
        dtwEnhancedHcsL1 = pansharp_hcs(panL1(MARGIN + 1:end - MARGIN, MARGIN + 1:end - MARGIN), ...
                                        msiDtwEnhancedL1(MARGIN + 1:end - MARGIN, MARGIN + 1:end - MARGIN, :));
        
        % write sharpened images
        imwrite(uint16(dtwSimpleHcsL0), strcat(simpleDirL0, 'pansharp_hcs.tif'));                            
        imwrite(uint16(dtwSimpleHcsL1), strcat(simpleDirL1, 'pansharp_hcs.tif'));
        imwrite(uint16(dtwEnhancedHcsL0), strcat(enhancedDirL0, 'pansharp_hcs.tif'));
        imwrite(uint16(dtwEnhancedHcsL1), strcat(enhancedDirL1, 'pansharp_hcs.tif'));
        
        % write thumbnails
        imwrite(32 * imresize(uint16(dtwSimpleHcsL0), 0.2), strcat(simpleDirL0, 'pansharp_hcs_thumbnail.tif'));
        imwrite(32 * imresize(uint16(dtwSimpleHcsL1), 0.2), strcat(simpleDirL1, 'pansharp_hcs_thumbnail.tif'));
        imwrite(32 * imresize(uint16(dtwEnhancedHcsL0), 0.2), strcat(enhancedDirL0, 'pansharp_hcs_thumbnail.tif'));
        imwrite(32 * imresize(uint16(dtwEnhancedHcsL1), 0.2), strcat(enhancedDirL1, 'pansharp_hcs_thumbnail.tif'));
    end
    
    % read the MSI bands produced using SIFT
    for b = 1:NUM_MSI_BANDS
        msiSiftDir = strcat('../images/', num2str(i), '/L1R/');
        msiSift(:, :, b) = imresize(imread(strcat(msiSiftDir, num2str(b), '/image.tif')), 2);
    end
    
    % pansharp SIFT output and write sharpened image & thumbnail
    siftHcs = uint16(pansharp_hcs(panL1R, msiSift));
    imwrite(siftHcs, strcat(msiSiftDir, 'pansharp_hcs.tif'));
    imwrite(32 * imresize(siftHcs, 0.2), strcat(msiSiftDir, 'pansharp_hcs_thumbnail.tif'));
    
    fprintf('Pansharpening successful for image #%d.\n', i);
end