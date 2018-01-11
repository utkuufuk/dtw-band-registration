%% Read input image and produce an additional 2D shifted image artificially
image = single(imread('image/test/lena.bmp'));
shifted = circshift(image, 10, 2);      % horizontal shift
shifted = circshift(shifted, 24, 1);    % vertical shift
imagesc(shifted);

%% Choose Reference Row(s) & Col(s)
refRows = [200 250];
refCols = [250 300 150];

%% Vertical Correction
verticalOffset = match_rows(image, shifted, refRows, 100);
shifted = circshift(shifted, -verticalOffset, 1);
imagesc(shifted);

%% Horizontal Correction
horizontalOffset = match_cols(image, shifted, refCols, 100);
shifted = circshift(shifted, -horizontalOffset, 2);
imagesc(shifted);

%% Check Result
isequal(image, shifted)