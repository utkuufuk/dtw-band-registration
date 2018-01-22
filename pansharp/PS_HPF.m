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

function Pansharp = PS_HPF(Pan, MSImage, HighPassWeight)
    tic

    if (strcmp(class(MSImage), 'double') == 0)
        MSImage = double(MSImage);
    end

    if (strcmp( class(Pan),'double') == 0)
        Pan = double(Pan);
    end

    % H = padarray(2,[2 2]) - fspecial('gaussian' ,[5 5],2);
    r = 2;
    H = -1 * ones (2 * r + 1, 2 * r + 1);
    H(3, 3) = (2 * r + 1) * (2 * r + 1) - 1;

    % Pana elde edilen filtre uygulanir ve yuksek geciren elde edilir.
    sharpened = imfilter(Pan, H);
    % Elde edilen yuksek geciren, katsayi ile carpilir
    SharpenedLayer = HighPassWeight * double(sharpened);

    [rows, cols, bands] = size(MSImage);
    Pansharp = zeros(rows, cols, bands);
    
    % Olusturulan keskin goruntu tum bantlara eklenir.
    parfor band = 1:bands
        Pansharp(:, :, band) =  MSImage(:, :, band) + SharpenedLayer;
    end

    disp('HPF = ');
    toc
end