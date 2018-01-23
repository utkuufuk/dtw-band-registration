% HPF (High Pass Filtering) method is based on the principle to apply 
% panchromatic band obtained by applying a high-pass filtering to the all
% bands of MS image. In HPF method, sharpened bands are normalized with respect
% to original image to optimize the use of spatial information. The panchromatic
% band filter size is selected according to the spatial ratio between MS image 
% 
% @author mustafa.teke
% @author ezgi.san
% @author ibrahim.acikgoz
% @author utku.ufuk

function pansharp = pansharp_hpf(pan, msi, highPassWeight)
    if (isa(msi, 'double') == 0)
        msi = double(msi);
    end

    if (isa(pan, 'double') == 0)
        pan = double(pan);
    end

    % filter = padarray(2,[2 2]) - fspecial('gaussian' ,[5 5],2);
    r = 2;
    filter = -1 * ones (2 * r + 1, 2 * r + 1);
    filter(3, 3) = (2 * r + 1) * (2 * r + 1) - 1;

    sharpened = imfilter(pan, filter);
    sharpenedLayer = highPassWeight * double(sharpened);

    [rows, cols, bands] = size(msi);
    pansharp = zeros(rows, cols, bands);
    
    % add the sharpened image to MSI bands
    parfor b = 1:bands
        pansharp(:, :, b) =  msi(:, :, b) + sharpenedLayer;
    end
end