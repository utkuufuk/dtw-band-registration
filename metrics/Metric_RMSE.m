% The RMSE (Root Mean Square Error) is defined as: Where  is the  band of the
% MS image,  is the  band of the processed image and  is the pixel. The
% denominator,  is the number of the rows,  is the number of columns and is
% the number of total bands.
% This quality metric measures error between two images. For spectral and 
% spatial quality this metric should converge to 0.
% 
% @author ezgi.koc
% @author mustafa.teke
% @author ibrahim.acikgoz

function [errors,intermediateSumBands] = Metric_RMSE(MSImage,Pansharp)

MSImageD = double(MSImage);
bandNum=size(MSImage,3);
PansharpD=double(Pansharp);
summ=0;
intermediateSumBands = zeros(2,4); %intermediateSumBands her bant icin RMSE degerini vermektedir.

for band=1:bandNum;
    kare = (MSImageD(:,:,band) - PansharpD(:,:,band)).^2;
    intermediateSum = mean2(kare (kare> 0));
    intermediateSumBands(band) = sqrt(intermediateSum);
    summ = summ + intermediateSum;
end

errors=sqrt(summ/bandNum);
intermediateSumBands();
end



