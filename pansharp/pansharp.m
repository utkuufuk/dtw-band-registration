clc, clearvars

% number of test images
NUM_IMAGES = 10;

% number of multispectral image bands
NUM_MSI_BANDS = 3;

% image dimensions
NUM_ROWS_DTW = 8192;
NUM_ROWS_SIFT = 8128;
NUM_COLS = 8160;

% maximum shifted rows/cols 
ROW_MARGIN = 50;
COL_MARGIN = 10;

% number of reference rows & cols in each iteration
NUM_REF_ROWS_COLS = linspace(5, 45, 5);

% create blank images to store the msi bands
msiDtw = zeros(NUM_ROWS_DTW, NUM_COLS, NUM_MSI_BANDS);
msiSift = zeros(NUM_ROWS_SIFT, NUM_COLS, NUM_MSI_BANDS);

for i = 1:NUM_IMAGES
    % read L1 and L1R pan
    panL1 = imread(strcat('../images/', num2str(i), '/L1/0/image.tif'));
    panL1R = imread(strcat('../images/', num2str(i), '/L1R/0/image.tif'));

    for r = NUM_REF_ROWS_COLS
        dtwDir = strcat('../images/', num2str(i), '/DTW/', num2str(r), '_refs/');
        
        % read the MSI bands produced using DTW
        for b = 1:NUM_MSI_BANDS
            msiDtw(:, :, b) = imread(strcat(dtwDir, num2str(b), '.tif'));
        end
        
        % pansharp DTW output
        dtwHcs = pansharp_hcs(panL1(ROW_MARGIN + 1:end - ROW_MARGIN, COL_MARGIN + 1:end - COL_MARGIN), ...
                              msiDtw(ROW_MARGIN + 1:end - ROW_MARGIN, COL_MARGIN + 1:end - COL_MARGIN, :));

        % write output and its thumbnail
        imwrite(uint16(dtwHcs), strcat(dtwDir, 'dtw_hcs.tif'));
        imwrite(32 * imresize(uint16(dtwHcs), 0.2), strcat(dtwDir, 'dtw_hcs_thumbnail.tif'));
    end
    
    % read the MSI bands produced using SIFT
    for b = 1:NUM_MSI_BANDS
        msiSiftDir = strcat('../images/', num2str(i), '/L1R/');
        msiSift(:, :, b) = imresize(imread(strcat(msiSiftDir, num2str(b), '/image.tif')), 2);
    end
    
    % pansharp SIFT output and write sharpened image & thumbnail
    siftHcs = uint16(pansharp_hcs(panL1R, msiSift));
    imwrite(siftHcs, strcat(msiSiftDir, 'sift_hcs.tif'));
    imwrite(32 * imresize(siftHcs, 0.2), strcat(msiSiftDir, 'sift_hcs_thumbnail.tif'));
    
    fprintf('Pansharpening successful for image #%d.\n', i);
end