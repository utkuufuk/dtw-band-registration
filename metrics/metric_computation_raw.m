clc, clearvars
format long

for i = 1:2
    pan = imread(strcat('../images/raw', num2str(i), '/L1/0/image.tif'));
    pansharp = imread(strcat('../images/raw', num2str(i), '/L1/pansharp_hcs.tif'));
    
    [avg, vec] = compute_spatial_metric(pansharp(77:8116,61:8132,:), pan(77:8116,61:8132,:));
    fprintf('\nL1 Raw Image:\nRed: %f\nGreen: %f\nBlue: %f\nAverage: %f\n\n', vec(1), vec(2), vec(3), avg);
end