% This metric demonstrates the quality of a least squares fitting to the
% original data. Even a 1 percent difference is considerable for this metric
% and the difference should be minimized. .
% Reference value is 1.
%
% @author mustafa.teke
% @author ibrahim.acikgoz

function coc = Metric_CC( MSImage,Pansharp )

MSImage     = double (MSImage);
Pansharp    = double ( Pansharp );

[image_width, image_height, band]   = size(MSImage);

sumRGB   = MSImage/(image_width*image_height*band);
sumRGB   = sum(sumRGB(:));

matrixOnes  = ones(image_width,image_height,band);
meanRGB  = sumRGB*matrixOnes;
sumPansharp  = Pansharp/(image_width*image_height*band);
sumPansharp  = sum(sumPansharp(:));
meanPansharp    = sumPansharp*matrixOnes;

numerator_1   = MSImage-meanRGB;
numerator_2   = Pansharp-meanPansharp;
numerator     = numerator_1.*numerator_2;
numerator     = sum(numerator(:));
denominator_1  = numerator_1.*numerator_1;
denominator_2  = numerator_2.*numerator_2;
denominator_1  = sum(denominator_1(:));
denominator_2  = sum(denominator_2(:));
denominator   = sqrt(denominator_1)*sqrt(denominator_2);

coc     = numerator/denominator;
end

