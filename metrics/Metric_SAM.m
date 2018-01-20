% The SAM (Spectral Angle Mapper) is a quality metric that demonstrates the
% spectral similarity between two spectral vectors.
% Where  is the number of the bands,  and  are two spectral vectors at the same
% pixel location of two different images. 
% By filtering two different images with a high pass filter the spectral
% resemblance can be evaluated. For spectral quality this metric should converge
% to 0.
%
% @author mustafa.teke
% @author ibrahim.acikgoz

function [angle] = Metric_SAM(MSImage,Pansharp)

dimension=size(Pansharp,3);
A = 0;
M = 0;
F = 0;
for i = 1:dimension   
    A = A+ MSImage(:,:,i).*Pansharp(:,:,i);%Resimlerin her bandinin carpimlari toplami
    M = M+MSImage(:,:,i).^2; %Multispektral resmin her bandinin kareleri toplami
    F = F+Pansharp(:,:,i).^2;
    %F = F+Pansharp(:,:,1:3).^2; %Pansharp resmin her bandinin kareleri toplami
end

total = double(A)./(sqrt(double(M.*F)));
angle = acosd(total);
angle(isnan(angle)) = 0;
angle = mean(angle(:));
end
