% The average performance for each band in processed image is calculated
% with the RMSE values of the images.
% Where  is the mean value,  is the band number and  is the  band of the
% processed image.
% Reference value is 0
%                
% @author ezgi.koc
% @author ezgi.san
% @author mustafa.teke
% @author ibrahim.acikgoz

function resultRase = Metric_RASE( MSImage,Pansharp )

summ = 0;
numBands = size(MSImage,3);

for i=1:numBands % Her bir bant icin RMSE degerinin karesi hesaplanir.
    square_sum = (MSImage(:,:,i) - Pansharp(:,:,i)).^2;
    intermediateSum = mean2(square_sum (square_sum> 0));
    summ = summ + intermediateSum;
end
summ  = sqrt(summ/numBands); %Her bandin RMSE'lerinin karesi toplami bant sayisina bolunu�r
clear square_sum
clear numBands
clear intermediateSum
ortRGB  = mean(MSImage(:));
resultRase   = summ*100/ortRGB;
end

