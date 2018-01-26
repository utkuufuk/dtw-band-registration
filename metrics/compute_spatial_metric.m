% Each band of processed image and panchromatic band is filtered with a filter
% to demonstrate spatial similarities. This metric value is the average of the
% correlation coefficients for each band of the original MS image.
% Referance value is 1.
%
% @author mustafa.teke
% @author ezgi.san
% @author ibrahim.acikgoz
% @author utku.ufuk

function [spatialResult, spatialResultVector] = compute_spatial_metric(pansharp, pan)
    pansharp(isnan(pansharp)) = 0;
    [rows, colums, bands] = size(pansharp);
    mask = [-1, -1, -1; -1, 8, -1; -1, -1, -1];
    pan = double(pan);
    panCon = conv2(pan, mask, 'same');
    spatialSum = 0;
    fuseCon = zeros(rows, colums, bands);

    for i = 1:bands
        fuseCon(:, :, i) = conv2(pansharp(:, :, i), mask, 'same');
        A = corrcoef(panCon, fuseCon(:, :, i));
        spatialSum = spatialSum + A(1, 2);
        spatialResultVector(i) = A(1, 2);
    end
    spatialResult = abs(spatialSum / bands);
    abs(spatialResultVector());
end
