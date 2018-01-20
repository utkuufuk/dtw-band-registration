clearvars
clc

% maximum anticipated number of rows/cols to shift
SEARCH_RANGE = 50;

% start & end offsets to search for the reference rows/cols
REF_ROW_MARGIN = 200;

% sampling interval when selecting reference rows/cols
RESOLUTION = 10;

% number of reference rows & cols to measure dtw distance
NUM_REF_ROWS = 15;
NUM_REF_COLS = 15;

% number of test images
NUM_IMAGES = 16;

% number of multispectral image bands
NUM_MSI_BANDS = 4;

% image level to work on
IMAGE_LEVEL = 'L1';

for i = 1:NUM_IMAGES
    %% Process Pan
    % Read Pan
    panImageName = strcat('images/', num2str(i), '/', IMAGE_LEVEL, '/0/image.tif');
    pan = imread(panImageName);
    numRows = size(pan, 1);
    numCols = size(pan, 2);
    
    % Perform Horizontal & Vertical DWT
    [panRowsLow, panRowsHigh, panColsLow, panColsHigh] = dwt_2d(pan);
    
    % Enhance Contrast
    % panRowsLow = imadjust(panRowsLow);
    % panColsLow = imadjust(panColsLow);
    
    % Find Rows and Cols With Highest Frequency
    refRows = find_ref_rows(panRowsHigh, NUM_REF_ROWS, REF_ROW_MARGIN, RESOLUTION);
    refCols = find_ref_cols(panColsHigh, NUM_REF_COLS, REF_ROW_MARGIN, RESOLUTION);
    fprintf('Reference Rows: %s\n', sprintf('%d ', refRows));
    fprintf('Reference Cols: %s\n', sprintf('%d ', refCols));
    
    %% Process MSI    
    for b = 1:NUM_MSI_BANDS
        % Read MSI
        msiInputName{b} = strcat('images/', num2str(i), '/', IMAGE_LEVEL, '/', num2str(b), '/image.tif');
        msiOutputName{b} = strcat('images/', num2str(i), '/', IMAGE_LEVEL, '/output/', num2str(b), '.tif');
        msi{b} = imread(char(msiInputName{b}));
        
        % Upsample MSI
        msi{b} = imresize(msi{b}, 2);
        
        % Perform Horizontal & Vertical DWT
        [msiRowsLow{b}, msiRowsHigh{b}, msiColsLow{b}, msiColsHigh{b}] = dwt_2d(msi{b});
        
        % Enhance Contrast
        % msiRowsLow{b} = imadjust(msiRowsLow{b});
        % msiColsLow{b} = imadjust(msiColsLow{b});
        
        % Shift MSI
        msi{b} = shift_image(panRowsLow, panColsLow, msiRowsLow{b}, msiColsLow{b}, msi{b}, refRows, refCols, SEARCH_RANGE);
        
        % Write Outputs
        imwrite(uint16(msi{b}), char(msiOutputName{b}));
    end
end