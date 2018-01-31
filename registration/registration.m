clearvars, clc

% maximum anticipated number of rows/cols to shift
ROW_SEARCH_RANGE = 50;
COL_SEARCH_RANGE = 10;

% start & end margins to search for reference rows/cols
REF_ROW_COL_MARGIN = 200;

% sampling interval when selecting reference rows/cols
RESOLUTION = 10;

% number of reference rows & cols in each iteration
NUM_REF_ROWS_COLS = linspace(5, 45, 5);

% number of test images
NUM_IMAGES = 10;

% number of multispectral image bands
NUM_MSI_BANDS = 3;

for i = 1:NUM_IMAGES
    fprintf('\nProcessing image #%d:\n\n', i);

    % read pan image
    panImageName = strcat('../images/', num2str(i), '/L1/0/image.tif');
    pan = imread(panImageName);
    numRows = size(pan, 1);
    numCols = size(pan, 2);

    % perform horizontal & vertical DWT
    [panRowsLow, panRowsHigh, panColsLow, panColsHigh] = dwt_2d(pan);

    % find the highest frequency rows & cols
    refRows = find_ref_rows(panRowsHigh, NUM_REF_ROWS_COLS(end), REF_ROW_COL_MARGIN, RESOLUTION);
    refCols = find_ref_cols(panColsHigh, NUM_REF_ROWS_COLS(end), REF_ROW_COL_MARGIN, RESOLUTION);
    fprintf('Reference Rows: %s\n', sprintf('%d ', refRows));
    fprintf('Reference Cols: %s\n', sprintf('%d ', refCols));
    
    for r = NUM_REF_ROWS_COLS
        fprintf('\nTaking the first %d reference rows & cols:\n', r);

        % create new directory for output images
        msiOutDir = strcat('../images/', num2str(i), '/DTW/', num2str(r), '_refs/');
        mkdir(msiOutDir);

        for b = 1:NUM_MSI_BANDS
            fprintf('\nBand #%d:\n', b);
            
            % read the MSI band
            msiInName = strcat('../images/', num2str(i), '/L1/', num2str(b), '/image.tif');
            msiOutName = strcat(msiOutDir, num2str(b), '.tif');
            msi = imread(msiInName);

            % upsample MSI using bicubic interpolation
            msi = imresize(msi, 2);

            % perform horizontal & vertical DWT
            [msiRowsLow, msiRowsHigh, msiColsLow, msiColsHigh] = dwt_2d(msi);

            % enhance contrast
            msiRowsLow = msiRowsLow * mean(panRowsLow(:)) / mean(msiRowsLow(:));
            msiColsLow = msiColsLow * mean(panColsLow(:)) / mean(msiColsLow(:));

            % shift MSI
            msi = shift_image(panRowsLow, panColsLow, msiRowsLow, msiColsLow, msi, ...
                              refRows(1:r), refCols(1:r), ROW_SEARCH_RANGE, COL_SEARCH_RANGE);

            % write output
            imwrite(uint16(msi), msiOutName);
        end
    end
end