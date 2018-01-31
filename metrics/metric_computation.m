clc, clearvars
format long

% number of test images
NUM_IMAGES = 10;

NUM_LEVELS = 2;

% image dimensions
NUM_ROWS_DTW = 8192;
NUM_ROWS_SIFT = 8128;
NUM_COLS_L0 = 8192;
NUM_COLS_L1 = 8160;

% maximum shifted rows/cols 
MARGIN = 60;

% number of reference rows & cols in each iteration
NUM_REF_ROWS_COLS = linspace(1, 25, 5);

for i = 1:NUM_IMAGES
    fprintf('\nIMAGE #%d:\n------------------------------------------------------------', i);
    for level = 0:NUM_LEVELS - 1
        % read pan
        pan = imread(strcat('../images/', num2str(i), '/L', num2str(level), '/0/image.tif'));
        pansharpRaw = imread(strcat('../images/', num2str(i), '/L', num2str(level), '/pansharp_hcs.tif'));
        [rawMetricAvg, rawMetricVec] = compute_spatial_metric(pansharpRaw, pan);
        fprintf('\nL%d Raw Image:\nRed: %f\nGreen: %f\nBlue: %f\nAverage: %f\n\n', ...
                level, rawMetricVec(1), rawMetricVec(2), rawMetricVec(3), rawMetricAvg);

        for r = NUM_REF_ROWS_COLS
            fprintf('Number of reference rows/cols: %d\n\n', r);
            pansharpSimple = imread(strcat('../images/', num2str(i), '/L', num2str(level), ...
                                           '/output_', num2str(r), '/pansharp_hcs.tif'));
            pansharpEnhanced = imread(strcat('../images/', num2str(i), '/L', num2str(level), ...
                                             '/enhanced_output_', num2str(r), '/pansharp_hcs.tif'));

            [simpleMetricAvg, simpleMetricVec] = compute_spatial_metric(pansharpSimple, ...
                                                                        pan(MARGIN + 1:end - MARGIN, ...
                                                                            MARGIN + 1:end - MARGIN));
            [enhancedMetricAvg, enhancedMetricVec] = compute_spatial_metric(pansharpEnhanced, ...
                                                                            pan(MARGIN + 1:end - MARGIN, ...
                                                                                MARGIN + 1:end - MARGIN));
            
            fprintf('L%d Simply Regisered Image:\nRed: %f\nGreen: %f\nBlue: %f\nAverage: %f\n\n', ...
                    level, simpleMetricVec(1), simpleMetricVec(2), simpleMetricVec(3), simpleMetricAvg);
            fprintf('L%d Enhanced Regisered Image:\nRed: %f\nGreen: %f\nBlue: %f\nAverage: %f\n\n', ...
                    level, enhancedMetricVec(1), enhancedMetricVec(2), enhancedMetricVec(3), enhancedMetricAvg);
        end 
    end

    pan = imread(strcat('../images/', num2str(i), '/L1R/0/image.tif'));
    pansharpSift = imread(strcat('../images/', num2str(i), '/L1R/pansharp_hcs.tif'));
    
    % flip & crop in order to match the DTW output
    pan = flip(pan, 1);
    pan = flip(pan, 2);
    pan = pan(1:8072, 61:8100, :);
    pansharpSift = flip(pansharpSift, 1);
    pansharpSift = flip(pansharpSift, 2);
    pansharpSift = pansharpSift(1:8072, 61:8100, :);
    
    [siftMetricAvg, siftMetricVec] = compute_spatial_metric(pansharpSift, pan);
    fprintf('\nL1R Reference Image:\nRed: %f\nGreen: %f\nBlue: %f\nAverage: %f\n\n', ...
            siftMetricVec(1), siftMetricVec(2), siftMetricVec(3), siftMetricAvg);
end