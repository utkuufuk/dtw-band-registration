% Each band of processed image and panchromatic band is filtered with a filter
% to demonstrate spatial similarities. This metric value is the average of the
% correlation coefficients for each band of the original MS image.
% Referance value is 1.
%
% @author mustafa.teke
% @author ezgi.san
% @author ibrahim.acikgoz
% @author utku.ufuk

function [spatialResult, spatialResultVector] = Metric_Spatial(Pansharp, Pan)
    Pansharp(isnan(Pansharp)) = 0;
    [rows, colums, bands] = size(Pansharp);
    mask = [-1, -1, -1; -1, 8, -1; -1, -1, -1];
    Pan = double(Pan);
    PanCon = conv2(Pan, mask, 'same');
    spatialSum = 0;
    FuseCon = zeros(rows, colums, bands);

    for i = 1:bands
        FuseCon(:, :, i) = conv2(Pansharp(:, :, i), mask, 'same');
        A=corrcoef(PanCon, FuseCon(:, :, i));
        spatialSum = spatialSum +A(1, 2);
        spatialResultVector(i) = A(1, 2);
    end
    spatialResult = abs(spatialSum / bands);
    abs(spatialResultVector());
end
