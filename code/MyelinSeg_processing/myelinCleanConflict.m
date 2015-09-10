function [myelinArray,myelinObjAboveThreshIdx] = myelinCleanConflict(myelinArray, im, conflictThresh)
verbose = false;
if nargin < 2
    conflictThresh = 0.1;
end

size(myelinArray);
nObj = size(myelinArray, 3);

% allConflictBW is TRUE only in the conflict area
allConflict = sum(myelinArray, 3);

conflictArray = zeros(nObj, 1);
numConflictAreaArray = zeros(nObj, 1);

if verbose
    sc(sc(sum(myelinArray,3),'copper')*1+sc(im))
end
%% Compute all conflict values
for currentObjIdx=1:nObj
    if verbose && mod(currentObjIdx, 50) == 0
        fprintf('myelinCleanConflict: processing object %i/%i\n', currentObjIdx, nObj);
    end
    curMyelinBW = myelinArray(:, :, currentObjIdx);

    [conflictArray(currentObjIdx), numConflictAreaArray(currentObjIdx)] = computeConflict(curMyelinBW, allConflict>1);

end

%% Clean up short list


% Myelin obj that might be removed
myelinObjAboveThreshIdx = find(conflictArray > conflictThresh);
if ~isempty(myelinObjAboveThreshIdx)
    myelinObjAboveThreshIdx = sortrows([myelinObjAboveThreshIdx conflictArray(myelinObjAboveThreshIdx) zeros(length(myelinObjAboveThreshIdx), 1)], -2);
    
    throwMyelinIdx = [];
    j=0;
    for curMyelinIdx=myelinObjAboveThreshIdx(:,1)'
        j=j+1;
        if verbose && (mod(curMyelinIdx, 50) == 0 || curMyelinIdx==1)
            fprintf('myelinCleanConflict - short list: processing object %i/%i\n', curMyelinIdx, size(myelinObjAboveThreshIdx, 1));
        end
        %     curMyelinIdx = myelinObjAboveThreshIdx(curMyelinIdx, 1);
        curMyelinBW = myelinArray(:, :, curMyelinIdx);
        
        if computeConflict(curMyelinBW, allConflict>1) > conflictThresh
            throwMyelinIdx(end+1) = curMyelinIdx;
            allConflict = allConflict - myelinArray(:,:,curMyelinIdx);
        end
        
    end
    
    myelinArray = myelinArray(:, :, setdiff(1:end,throwMyelinIdx));
end



end

function [conflictVal, numConflictArea] = computeConflict(objBW, allConflictBW)
    
    conflictBW = (objBW & allConflictBW);
    
    conflictVal = sum(conflictBW(:))/sum(objBW(:));
    
    if conflictVal > 0
        conflictCC = bwconncomp(conflictBW);
        numConflictArea = conflictCC.NumObjects;
    else
        numConflictArea = 0;
    end
end