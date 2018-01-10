% input image names
PAN_NAME = 'image/pan.tif';
IN_RED_NAME = 'image/red.tif';
IN_GREEN_NAME = 'image/green.tif';
IN_BLUE_NAME = 'image/blue.tif';
% IN_IR_NAME = 'image/ir.tif';

% output image names
OUT_RED_NAME = 'image/red_resized_shifted.tif';
OUT_GREEN_NAME = 'image/green_resized_shifted.tif';
OUT_BLUE_NAME = 'image/blue_resized_shifted.tif';
% OUT_IR_NAME = 'image/ir_resized_shifted.tif';

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
refRowIdx = find_ref_rows(enhancedPan, 1);
refColIdx = find_ref_cols(enhancedPan, 1);

%% Shift Red
rowOffset = match_rows_adaptive(enhancedPan, enhancedRed, SEARCH_RANGE, refRowIdx);
red = circshift(red, -rowOffset, 1);
enhancedBand = circshift(enhancedBand, -rowOffset, 1);

colOffset = match_cols_adaptive(enhancedPan, enhancedRed, SEARCH_RANGE, refColIdx);
red = circshift(red, -colOffset, 2);

%% Shift Green
rowOffset = match_rows_adaptive(enhancedPan, enhancedGreen, SEARCH_RANGE, refRowIdx);
green = circshift(green, -rowOffset, 1);
enhancedBand = circshift(enhancedBand, -rowOffset, 1);

colOffset = match_cols_adaptive(enhancedPan, enhancedGreen, SEARCH_RANGE, refColIdx);
green = circshift(green, -colOffset, 2);

%% Shift Blue
rowOffset = match_rows_adaptive(enhancedPan, enhancedBlue, SEARCH_RANGE, refRowIdx);
blue = circshift(blue, -rowOffset, 1);
enhancedBand = circshift(enhancedBand, -rowOffset, 1);

colOffset = match_cols_adaptive(enhancedPan, enhancedBlue, SEARCH_RANGE, refColIdx);
blue = circshift(blue, -colOffset, 2);

%% Shift IR
rowOffset = match_rows_adaptive(enhancedPan, enhancedIr, SEARCH_RANGE, refRowIdx);
ir = circshift(ir, -rowOffset, 1);
enhancedBand = circshift(enhancedBand, -rowOffset, 1);

colOffset = match_cols_adaptive(enhancedPan, enhancedIr, SEARCH_RANGE, refColIdx);
ir = circshift(ir, -colOffset, 2);

%% Write Outputs
imwrite(uint16(red), OUT_RED_NAME);
imwrite(uint16(green), OUT_GREEN_NAME);
imwrite(uint16(blue), OUT_BLUE_NAME);
% imwrite(uint16(ir), OUT_IR_NAME);