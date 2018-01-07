%% Read input image and produce an additional 2D shifted image artificially
image = single(imread('lena.bmp'));
shifted = circshift(image, 10, 2);      % horizontal shift
shifted = circshift(shifted, 24, 1);    % vertical shift
imagesc(shifted);

%% Vertical Correction
verticalOffset = find_vertical_offset(image, shifted, 250);
shifted = circshift(shifted, -verticalOffset, 1);
imagesc(shifted);

%% Horizontal Correction
horizontalOffset = find_horizontal_offset(image, shifted, 250);
shifted = circshift(shifted, -horizontalOffset, 2);
imagesc(shifted);

%% Check Result
isequal(image, shifted)