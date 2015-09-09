function I_segmented = segmentationReconfiltMod(I, h, min_rad, logFact)
% SEGMENTATIONRECONFILTMOD a function to segment circular locally darker regions in a grayscale image.
% The size of the kernels used guides the range of sizes that are most
% enhanced. The sensitivity of the segmentation method is guided by the
% threshold.

% Required Inputs:
%       I          : Grayscale image
%       h          : Suppresses all minima in I whose depth is less than h.
%       min_rad    : Radius of minimum object to enhance (pixels)
%       min_rad    : Radius of maximum object to enhance (pixels)

%Example:
% I_segmented = segmentationReconfilt(I, 40, 1, 50);
% where I_segmented is the output segmented image, I is the input
% grayscale.

% Benjamin I 2013/05/17  ----
% Modified by Steve Begin 2013/10

I = double(I);

radList = min_rad.*2.^(0:logFact);

for i=1:numel(radList)
    rad = radList(i);
    % processing using every second kernel
    
    % generating circular kernel (could also use matlab built in: strel)
    B4b=circkern(rad);
    
    % Greyscale closing of the image and Image reconstruction
    JJ=imclose(I,B4b);
    %reconstructed image %using a 4 connected kernal in the dilation
    KK=imreconstruct(JJ.*-1,I.*-1,4).*-1;
    LL=KK-I; % difference image
    LL4D(:, :, 1, i) = LL; % Store the difference image in a 4D array
    
    % 	min_im=min(min(LL)); %minimum value in the image
    % 	max_im=max(max(LL)); %maximum value in the image
    
    % 20% of the difference between the minimum and maximum value
    % 	Thresh_recon=thresh_val*(max_im-min_im)+min_im;
    % 	LL_thresh=LL>=Thresh_recon; %Thresholded image
    
    % adding in the thresholds
    % 	I_segmented=I_segmented | LL_thresh;
    %     recon.LL_thresh4D(:, :, 1, it) = imcomplement(LL_thresh);
end
% figure;
% sc(recon.LL_thresh4D);
%

LLMax = max(LL4D, [], 4);

seg = imextendedmax(LLMax,h);
% seg = imextendedmax(imcomplement(I),h);

I_segmented = imfill(seg, 'holes');


%Storing last kernel processing for plotting
% recon.original=I; recon.close=JJ; recon.reconstruct=KK; recon.difference=LL;
end

%function to generate a circular kernel
function [B4b]=circkern(kkern)
B4b=zeros(2*kkern+1, 2*kkern+1);

for ii=1:2*kkern+1
    for jj=1:2*kkern+1
        B4b(ii,jj)=sqrt((ii-(kkern+1)).^2+(jj-(kkern+1)).^2)<=kkern;
    end
end

end
