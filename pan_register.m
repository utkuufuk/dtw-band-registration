% input image names
PAN_NAME = 'image/input/pan.tif';
IN_RED_NAME = 'image/input/red.tif';
IN_GREEN_NAME = 'image/input/green.tif';
IN_BLUE_NAME = 'image/input/blue.tif';
% IN_IR_NAME = 'image/input/ir.tif';

% output image names
OUT_RED_NAME = 'image/output/red_resized_shifted.tif';
OUT_GREEN_NAME = 'image/output/green_resized_shifted.tif';
OUT_BLUE_NAME = 'image/output/blue_resized_shifted.tif';
% OUT_IR_NAME = 'image/output/ir_resized_shifted.tif';

% maximum anticipated number of rows/cols to shift
SEARCH_RANGE = 40;

%% Read Input Images
pan = imread(PAN_NAME);
red = imread(IN_RED_NAME);
green = imread(IN_GREEN_NAME);
blue = imread(IN_BLUE_NAME);
% ir = imread(IN_IR_NAME);

%% Upsample MSI
red = imresize(red, 2);
green = imresize(green, 2);
blue = imresize(blue, 2);
% ir = imresize(ir, 2);

%% Enhance Contrast
enhancedPan = single(imadjust(pan));
enhancedRed = single(imadjust(red));
enhancedGreen = single(imadjust(green));
enhancedBlue = single(imadjust(blue));
% enhancedIr = single(imadjust(ir));

%% Find Row(s) & Col(s) With Highest Frequency
refRows = find_ref_rows(enhancedPan, 3, SEARCH_RANGE);
refCols = find_ref_cols(enhancedPan, 3, SEARCH_RANGE);
fprintf('Reference Rows: %s\n', sprintf('%d ', refRows));
fprintf('Reference Cols: %s\n', sprintf('%d ', refCols));

%% Shift MSI
red = shift_image(enhancedPan, enhancedRed, red, refRows, refCols, SEARCH_RANGE);
green = shift_image(enhancedPan, enhancedGreen, green, refRows, refCols, SEARCH_RANGE);
blue = shift_image(enhancedPan, enhancedBlue, blue, refRows, refCols, SEARCH_RANGE);
% ir = shift_image(enhancedPan, enhancedIr, ir, refRows, refCols, SEARCH_RANGE);

%% Write Outputs
imwrite(uint16(red), OUT_RED_NAME);
imwrite(uint16(green), OUT_GREEN_NAME);
imwrite(uint16(blue), OUT_BLUE_NAME);
% imwrite(uint16(ir), OUT_IR_NAME);