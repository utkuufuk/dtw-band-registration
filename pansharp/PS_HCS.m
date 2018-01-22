% HCS is developed for fusing eight spectral band of WorldView-2 satellite.
% Transformation from RGB color space to hyperspherical color space is based
% on transformation between n dimensional cartesian space and n dimensional
% hypersphere space. After image is transmitted to HCS environment, it is
% possible to scaling intensity without any change of color value 
%
% @author mustafa.teke
% @author ibrahim.acikgoz
% @author utku.ufuk

function fusedimage = HCS(Pan, MSImage)
    tic
    
    if (strcmp(class(MSImage), 'double') == 0)
        MSImage = double(MSImage);
    end

    if (strcmp(class(Pan), 'double') == 0)
        Pan = double(Pan);
    end

    [rows, cols, bands] = size(MSImage);

    I2 = zeros(rows, cols);
    
    for i = 1:bands
        I2 = I2 + MSImage(:, :, i) .* MSImage(:, :, i);
    end
    
    for i = 1:bands - 1
        tempSum = zeros(rows, cols);

        for j = i + 1:bands
            tempSum = tempSum + MSImage(:, :, j) .* MSImage(:, :, j);
        end

        Fi(:, :, i) = atan(sqrt(tempSum) ./ MSImage(:, :, i));
    end
    h = fspecial('average', [7 7]);
    P2 = Pan .* Pan;

    Sigma1 = std2(P2);
    Sigma0 = std2(I2);
    Mu1 = mean2(P2);
    Mu0 = mean2(I2);

    P2 = (Sigma0/Sigma1)*(P2 - Mu1 + Sigma1) + Mu0 -Sigma0;

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
        fusedimage(:, :, i) = IAdj .* sinTree(:, :, i) .* cosTree(:, :, i);
    end

    disp('HCS = ');
    toc
end
