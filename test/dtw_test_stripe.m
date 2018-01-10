%% Read input image and produce an additional 2D shifted image artificially
image = single(imread('lena.bmp'));
shifted = circshift(image, 10, 2);      % horizontal shift
shifted = circshift(shifted, 24, 1);    % vertical shift
imagesc(shifted);

%% Vertical Correction
verticalOffset = match_rows_stripe(image, shifted, 250, 1);
shifted = circshift(shifted, -verticalOffset, 1);
imagesc(shifted);

%% Horizontal Correction
horizontalOffset = match_cols_stripe(image, shifted, 250, 1);
shifted = circshift(shifted, -horizontalOffset, 2);
imagesc(shifted);

%% Check Result
isequal(image, shifted)