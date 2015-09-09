function [validateBW, axonValidateRejectBW, validateDist] = axonValidateSegmentation(axonInitialBW, distThrsh)
% Rejection rules:
% 	- objects with normalized properties distance > distThrsh
%       distThrsh = 11 keeps 95% as determined from ground truth
%       distThrsh = 30 keeps 100% as determined from ground truth

% Use normalised properties distance threshold
[validateBW, distList] = validateSegWithOptimalProp(axonInitialBW, distThrsh);

axonValidateRejectBW = xor(axonInitialBW, validateBW);

[validateLabel, n] = bwlabel(validateBW);

validateDist = zeros(size(validateBW));

for i=1:n
    validateDist(validateLabel == i) = distList(i);
end

