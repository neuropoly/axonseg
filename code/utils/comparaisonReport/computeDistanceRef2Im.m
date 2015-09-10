function dist = computeDistanceRef2Im(ref, img, fcn, verbose)
% Function that call the correct distance function
%
%   ____________|   A =! B  | A ~= B   | A == B  |
%   Dice        :     0     :   >0.9   :   1     |
%   PSNR        :     0dB   :   >20dB  :   INF   |
%   Hausdorff   :     INF   :   <15    :   0     |
%   MSSD        :     INF   :   <5     :   0     |
%   ----------------------------------------------
if nargin < 4
    verbose = 0;
end

ref = logical(ref);
img = logical(img);

switch fcn
    case 'Dice'
        dist = dist_Dice(ref,img, verbose);
    case 'PSNR'
        dist = dist_PSNR(ref,img, verbose);
    case 'Hausdorff'
        dist = dist_Hausdorff(ref,img, verbose);
    case 'MSSD'
        dist = dist_MSSD(ref,img, verbose);
    otherwise
        disp(sprintf('Unknown distance function: %s', fcn));
        return;
end

if verbose
    disp(sprintf('\tdistance = %0.4f', dist))
end

function dist = dist_Dice(ref,img, verbose)
if verbose
    disp('Calculation of the Dice Coefficient')
end
idx_img = find(img == 1);
idx_ref = find(ref == 1);
idx_inter = find((img == 1) & (ref == 1));

dist = 2*length(idx_inter)/(length(idx_ref)+length(idx_img));

function dist = dist_PSNR(ref,img, verbose)
if verbose
    disp('Calculation of the PSNR')
end
[nrow, ncol] = size(ref);

idx1 = find((ref == 1)&(img == 0));
idx2 = find((ref == 0)&(img == 1));

dist = (length(idx1)+length(idx2))/(nrow*ncol);
dist = -10*log10(dist);

function dist = dist_Hausdorff(ref,img, verbose)
if verbose
    disp('Calculation of the Hausdorff distance')
end
% Create a distance function for the reference and result
phi_ref = bwdist(ref)+bwdist(1-ref);
phi_img = bwdist(img)+bwdist(1-img);

% Get the reference and image contour
se = strel('diamond',1);

contour_ref = ref - imerode(ref,se);
contour_img = img - imerode(img,se);

dist = max(max(phi_ref(contour_img == 1)), max(phi_img(contour_ref == 1)));

function dist = dist_MSSD(ref,img, verbose)
if verbose
    disp('Calculation of the Mean Sum of Square Distance')
end
% Create a distance function for the reference and result
phi_ref = bwdist(ref)+bwdist(1-ref);
phi_img = bwdist(img)+bwdist(1-img);

% Get the reference and image contour
se = strel('diamond',1);

contour_ref = ref - imerode(ref,se);
contour_img = img - imerode(img,se);

dist1 = sum(phi_ref(contour_img == 1).^2)/(sum(contour_img(:)) + eps);
dist2 = sum(phi_img(contour_ref == 1).^2)/(sum(contour_ref(:)) + eps);

dist = max(dist1,dist2);
