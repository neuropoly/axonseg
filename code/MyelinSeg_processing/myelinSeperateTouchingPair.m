function [cleanMyelinBW, cleanAxonBW] = myelinSeperateTouchingPair(initialMyelinArray, im, verbose)

if nargin<3
    verbose = 0; % idx 702 for pair [344, 367]
end
assetsBaseName = '/Users/stevebegin/Documents/PhD/Publication/begin-2014/figures/figure_myelinSep/roi7-120f-med-touchingMyelinPair';

%% Init
if size(initialMyelinArray, 3) == 0
    cleanMyelinBW = false(size(initialMyelinArray, 1), size(initialMyelinArray, 2));
    cleanAxonBW = false(size(initialMyelinArray, 1), size(initialMyelinArray, 2));
    return;
end
seperatedMyelinBW = max(initialMyelinArray, [], 3);

%% Find all the pairs of connected myelin
% fprintf('\tFind pairs of touching myelin for separation\n');
uniqueTouchingPairList = myelinFindTouchingPair(initialMyelinArray);

%% Separate all the pairs of connected myelin
% fprintf('\tSeparate all the pairs of connected myelin\n');

if ~isempty(uniqueTouchingPairList)
    % Watershed
    watershedLines = false(size(initialMyelinArray, 1), size(initialMyelinArray, 2));
    
    for currentTouchingPairIdx=1:size(uniqueTouchingPairList, 1)
        myelin1BW = initialMyelinArray(:, :, uniqueTouchingPairList(currentTouchingPairIdx, 1));
        myelin2BW = initialMyelinArray(:, :, uniqueTouchingPairList(currentTouchingPairIdx, 2));
        touchingMyelinBW = myelin1BW | myelin2BW;
        % Use the axons as forground marker
        markerBW = (imfill(myelin1BW, 'holes')-myelin1BW) | (imfill(myelin2BW, 'holes')-myelin2BW);
        
        % TO SPEEED
        % Combine the obj conv hull to help with oversegmentation
        touchingMyelinConvHullBW = bwconvhull(myelin1BW) | bwconvhull(myelin2BW);
        % Euclidian distance transform
        touchingMyelinConvHullDist=-bwdist(~touchingMyelinConvHullBW);
        % Modify the distance image with the marker
        touchingMyelinConvHullDistMarker=imimposemin(touchingMyelinConvHullDist,markerBW);
        % Compute the watershed
        touchingMyelinWatershed = watershed(touchingMyelinConvHullDistMarker, 8);
        % Extract and massage the watershed lines
        touchingMyelinWatershedLines = (touchingMyelinWatershed==0);
        touchingMyelinWatershedLines = bwmorph(touchingMyelinWatershedLines, 'close');
        touchingMyelinWatershedLines = bwmorph(touchingMyelinWatershedLines, 'thin');
        % Extract the portion of the watershed lines used for the separation
        touchingMyelinSeparator = (touchingMyelinWatershedLines & touchingMyelinBW);
        
        % Append the current watershed line
        watershedLines = watershedLines | touchingMyelinSeparator;
        
        if verbose %== currentTouchingPairIdx
            baseName = [assetsBaseName num2str(currentTouchingPairIdx)];
            %% Touching pair
%             tmp = sc(im) + sc(touchingMyelinBW, 'c', touchingMyelinBW)*0.3;
%             sc(tmp);
%             %export_fig([baseName '-touchingMyelin.png']);

            %% Watershed line
            tmp = sc(im)+sc(touchingMyelinConvHullDist, 'k', touchingMyelinWatershedLines) + sc(markerBW, 'r', markerBW)*0.4;
            % tmp = sc(imcomplement(touchingMyelinConvHullDist), 'g', touchingMyelinWatershedLines) + sc(markerBW, 'r', markerBW)*0.4;
            figure(5); 
            sc(tmp); drawnow;
            %export_fig([baseName '-touchingMyelinConvHullDistMarker.png']);

            %% Seperated (see sc_generateFIgureBeginEtAl2014.m)
%             tmp = sc(im) + sc(seperatedMyelinBW, 'g', (seperatedMyelinLabel == 1), 'y', (seperatedMyelinLabel == 2))*0.6;
%             sc(tmp)
%             export_fig(tmp, [baseName '-seperatedMyelin.png']);
%             %             imwrite(tmp, [baseName '-seperatedMyelin.png']);
        end
        
    end
    
    seperatedMyelinBW(watershedLines) = 0;
end

[cleanMyelinBW, cleanAxonBW] = cleanUpWatershed(seperatedMyelinBW);

end

function uniquePairList = myelinFindTouchingPair(initialArray)

initialArray=reshape2D(initialArray,3);
[~,x]=find(initialArray);
C=unique(x);
bc=histc(x,C);
col=C(bc==2);
initialArray=initialArray(:,col);
initialArray=bsxfun(@times,initialArray,[1:size(initialArray,1)]');

xplusy=sum(initialArray,1);
initialArray(~initialArray)=nan; 
xmoinsy=round(sqrt(2)*nanstd(initialArray,0,1));


uniquePairList=[1/2* (xplusy+xmoinsy); 1/2* (xplusy-xmoinsy)]';
uniquePairList=unique(uniquePairList,'rows');
% 
% find(x==x(duplicate(1)) & y==y(duplicate(1)))
% for na=1:numObj
%     initialBW(initialArray(:,:,na))=na;
% end
% 
% initialCC = bwconncomp(logical(initialBW), 4);
% 
% uniquePairList = [];
% for currentObj=1:initialCC.NumObjects
%     touchingLabels = unique(initialBW(initialCC.PixelIdxList{currentObj}));
%     if numel(touchingLabels) > 1
%         touchingLabelCombination = nchoosek(touchingLabels, 2);
%         for i = 1:size(touchingLabelCombination, 1)
%             cc = bwconncomp(initialArray(:, :, [touchingLabelCombination(i, 1) touchingLabelCombination(i, 2)]),4);
%             if cc.NumObjects == 1
%                 uniquePairList = [uniquePairList; touchingLabelCombination(i, :)];
%             end
%         end
%     end
% end
% 
 end

function [cleanMyelinBW, cleanAxonBW] = cleanUpWatershed(initialMyelinBW)

% Check for bad watershed separation
[initialMyelinLabel, nLabel] = bwlabel(initialMyelinBW, 4);

cleanMyelinBW = false(size(initialMyelinBW));
cleanAxonBW = false(size(initialMyelinBW));

% initialMyelinBW = imclearborder(initialMyelinBW);
if nLabel > 0
    for curLabel=1:nLabel
        curMyelinObjBW = (initialMyelinLabel==curLabel);
        curAxonObjBW = xor(curMyelinObjBW, imfill(curMyelinObjBW, 'holes'));
        if max(curAxonObjBW(:)) == 1 % Good watershed
            cleanMyelinBW = cleanMyelinBW | curMyelinObjBW;
            cleanAxonBW = cleanAxonBW | curAxonObjBW;
        else
            % Bad watershed separation leaves an open myelin obj (w no hole)
        end
    end
end
end
