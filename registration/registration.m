clearvars, clc

% maximum anticipated number of rows/cols to shift
SEARCH_RANGE = 60;

% start & end margins to search for reference rows/cols
REF_ROW_MARGIN = 200;

% sampling interval when selecting reference rows/cols
RESOLUTION = 10;

% number of reference rows & cols in each iteration
NUM_REF_ROWS_COLS = linspace(1, 25, 5);

% number of test images
NUM_IMAGES = 16;

% number of multispectral image bands
NUM_MSI_BANDS = 3;

% image level to work on
IMAGE_LEVEL = 'L1';

% output directory prefix
OUTPUT_DIR_PREFIX = '/enhanced_output_';

% initialize cell arrays
msi = cell(1, NUM_MSI_BANDS);
msiInputName = cell(1, NUM_MSI_BANDS);
msiOutputName = cell(1, NUM_MSI_BANDS);
msiRowsLow = cell(1, NUM_MSI_BANDS);
msiRowsHigh = cell(1, NUM_MSI_BANDS);
msiColsLow = cell(1, NUM_MSI_BANDS);
msiColsHigh = cell(1, NUM_MSI_BANDS);

for i = 1:NUM_IMAGES
    fprintf('\nProcessing image #%d:\n\n', i);

    % read pan image
    panImageName = strcat('images/', num2str(i), '/', IMAGE_LEVEL, '/0/image.tif');
    pan = imread(panImageName);
    numRows = size(pan, 1);
    numCols = size(pan, 2);

    % perform horizontal & vertical DWT
    [panRowsLow, panRowsHigh, panColsLow, panColsHigh] = dwt_2d(pan);

    % find the highest frequency rows & cols
    refRows = find_ref_rows(panRowsHigh, NUM_REF_ROWS_COLS(end), REF_ROW_MARGIN, RESOLUTION);
    refCols = find_ref_cols(panColsHigh, NUM_REF_ROWS_COLS(end), REF_ROW_MARGIN, RESOLUTION);
    fprintf('Reference Rows: %s\n', sprintf('%d ', refRows));
    fprintf('Reference Cols: %s\n', sprintf('%d ', refCols));
    
    for r = NUM_REF_ROWS_COLS
        fprintf('\nTaking the first %d reference rows & cols:\n', r);

        % create new directory for output images
        msiOutputDir = strcat('images/', num2str(i), '/', IMAGE_LEVEL, ... 
                              OUTPUT_DIR_PREFIX, num2str(r), '/');
        mkdir(msiOutputDir);

        for b = 1:NUM_MSI_BANDS
            fprintf('\nBand #%d:\n', b);
            
            % read the MSI band
            msiInputName{b} = strcat('images/', num2str(i), '/', IMAGE_LEVEL, '/', ...
                                     num2str(b), '/image.tif');
            msiOutputName{b} = strcat(msiOutputDir, num2str(b), '.tif');
            msi{b} = imread(char(msiInputName{b}));

            % upsample MSI using bicubic interpolation
            msi{b} = imresize(msi{b}, 2);

            % perform horizontal & vertical DWT
            [msiRowsLow{b}, msiRowsHigh{b}, msiColsLow{b}, msiColsHigh{b}] = dwt_2d(msi{b});

            % enhance contrast
            msiRowsLow{b} = msiRowsLow{b} * mean(panRowsLow(:)) / mean(msiRowsLow{b}(:));
            msiColsLow{b} = msiColsLow{b} * mean(panColsLow(:)) / mean(msiColsLow{b}(:));

            % shift MSI
            msi{b} = shift_image(panRowsLow, panColsLow, msiRowsLow{b}, msiColsLow{b}, ... 
                                 msi{b}, refRows(1:r), refCols(1:r), SEARCH_RANGE);

            % write output
            imwrite(uint16(msi{b}), char(msiOutputName{b}));
        end
    end
end