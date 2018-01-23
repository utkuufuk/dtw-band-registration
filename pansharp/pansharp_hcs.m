% HCS is developed for fusing eight spectral band of WorldView-2 satellite.
% Transformation from RGB color space to hyperspherical color space is based
% on transformation between n dimensional cartesian space and n dimensional
% hypersphere space.
%
% @author mustafa.teke
% @author ibrahim.acikgoz
% @author utku.ufuk

function fusedImage = pansharp_hcs(pan, msi)
    if (isa(msi, 'double') == 0)
        msi = double(msi);
    end

    if (isa(pan, 'double') == 0)
        pan = double(pan);
    end

    [rows, cols, bands] = size(msi);

    I2 = zeros(rows, cols);
    
    for i = 1:bands
        I2 = I2 + msi(:, :, i) .* msi(:, :, i);
    end
    
    for i = 1:bands - 1
        tempSum = zeros(rows, cols);

        for j = i + 1:bands
            tempSum = tempSum + msi(:, :, j) .* msi(:, :, j);
        end

        Fi(:, :, i) = atan(sqrt(tempSum) ./ msi(:, :, i));
    end
    h = fspecial('average', [7 7]);
    P2 = pan .* pan;

    Sigma1 = std2(P2);
    Sigma0 = std2(I2);
    Mu1 = mean2(P2);
    Mu0 = mean2(I2);

    P2 = (Sigma0 / Sigma1) * (P2 - Mu1 + Sigma1) + Mu0 - Sigma0;

    IAdj = real(sqrt(P2));

    cosTree = ones(rows, cols, bands);
    sinTree = ones(rows, cols, bands);

    for i = 1: bands - 1
        cosTree(:, :, i) =  cos(Fi(:, :, 1));
    end

    for i = 2:bands
        sinTree(:, :, i) =  sinTree(:, :, i - 1) .* sin(Fi(:, :, i - 1));
    end
    
    for i = 1:bands
        fusedImage(:, :, i) = IAdj .* sinTree(:, :, i) .* cosTree(:, :, i);
    end
end
