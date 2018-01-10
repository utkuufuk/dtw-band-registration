IMAGE_NAME_A = 'red.tif';
IMAGE_NAME_B = 'blue.tif';
SHIFTED_IMAGE_NAME = strcat('blue_shifted.tif');
SEARCH_RANGE = 40;

%% Read Input Images
imageA = imread(IMAGE_NAME_A);
imageB = imread(IMAGE_NAME_B);

%% Enhance Contrast
enhancedImageA = single(imadjust(imageA));
enhancedImageB = single(imadjust(imageB));

%% Correct Vertically
verticalOffset = match_rows_stripe(enhancedImageA, enhancedImageB, SEARCH_RANGE, 1);
imageB = circshift(imageB, -verticalOffset, 1);
enhancedImageB = circshift(enhancedImageB, -verticalOffset, 1);

%% Correct Horizontally
horizontalOffset = match_cols_stripe(enhancedImageA, enhancedImageB, SEARCH_RANGE, 1);
imageB = circshift(imageB, -horizontalOffset, 2);

%% Write Output
imwrite(uint16(imageB), SHIFTED_IMAGE_NAME);
