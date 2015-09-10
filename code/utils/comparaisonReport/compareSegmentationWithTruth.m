function [cr, truthBW] = compareSegmentationWithTruth(inputBW, truthBW, im, distDiceThresh, distModHausThresh, sizeThresh)
% Comparaison with truthBW is based on the Dice distance (threshold) between
% the closest objects

%% Default parameters
if nargin < 3
    im = zeros(size(inputBW, 1),size(inputBW, 2));
end
if nargin < 4
    distDiceThresh = 0.85;
end
if nargin < 5
    distModHausThresh = 3;
end
if nargin < 6
    sizeThresh = [];
end

%% Init BW images
if size(inputBW, 3) == 1
    segBW = inputBW(:, :, 1);
    backBW = false(size(inputBW, 1), size(inputBW, 2));
elseif  size(inputBW, 3) == 2
    segBW = inputBW(:, :, 1);
    backBW = inputBW(:, :, 2);
end

%% TPs and FPs using segBW and truthBW
[truePosBW, falsePosBW, segAndTruthTruePosIdx, segAndTruthDistDice, segAndTruthDistModHaus] = ...
    compareSegAndTruth2truth(segBW, truthBW, distDiceThresh, distModHausThresh);

%% TNs and FNs using backBW and truthBW
[falseNegBW, trueNegBW, ~, ~, ~] = compareSegAndTruth2truth(backBW, truthBW, distDiceThresh, distModHausThresh);

% Missed axons and truth cleanUp
truthAndTruePosBW = bwFeatureAND(truthBW, truePosBW);
truthNotTruePosBW = xor(truthBW, truthAndTruePosBW);

if ~isempty(sizeThresh) % To be done only with the first CR
    truthNotTruePosBW = bwareaopen(truthNotTruePosBW, sizeThresh);
end

truthBW =  (truthAndTruePosBW | truthNotTruePosBW);
missedBW = truthNotTruePosBW;

%% Comparaison report
% Number of objects in binary images
[~, cr.numObjSeg] = bwlabel(segBW);
[~, cr.numObjTruePos] = bwlabel(truePosBW);
[~, cr.numObjFalsePos] = bwlabel(falsePosBW);
[~, cr.numObjMissed] = bwlabel(missedBW);
[~, cr.numObjBack] = bwlabel(backBW);
[~, cr.numObjTrueNeg] = bwlabel(trueNegBW);
[~, cr.numObjFalseNeg] = bwlabel(falseNegBW);

[~, cr.numObjTruth] = bwlabel(truthBW);

% http://en.wikipedia.org/wiki/Binary_classification
cr.sensitivity = cr.numObjTruePos/cr.numObjTruth;
cr.precision = cr.numObjTruePos/cr.numObjSeg;

% Distance based metrics
cr.truePosDistDiceAll = computeDistanceRef2Im(truePosBW, bwFeatureAND(truthBW, truePosBW), 'Dice');

cr.truePosDistDice = segAndTruthDistDice(segAndTruthTruePosIdx, 1);
cr.truePosDistDiceMed = median(cr.truePosDistDice);
cr.truePosDistModHaus = segAndTruthDistModHaus(segAndTruthTruePosIdx, 1);
cr.truePosDistModHausMed = median(cr.truePosDistModHaus);

cr.falsePosDistDice = segAndTruthDistDice(segAndTruthTruePosIdx==false, 1);
cr.falsePosDistDiceMed = median(cr.falsePosDistDice);
cr.falsePosDistModHaus = segAndTruthDistModHaus(segAndTruthTruePosIdx==false, 1);
cr.falsePosDistModHausMed = median(cr.falsePosDistModHaus);

% Binary images
cr.truePosBW = truePosBW;
cr.falsePosBW = falsePosBW;
cr.missedBW = missedBW;
cr.trueNegBW = trueNegBW;
cr.falseNegBW = falseNegBW;

% Composite image
cr.composite = sc(im) + sc(segBW, 'g', truePosBW, 'r', falsePosBW, 'b', missedBW, 'm', falseNegBW)*0.5;

printComparaisonReport(cr);

end

function [truePosBW, falsePosBW, truePosIdx, distDice, distModHaus] = compareSegAndTruth2truth(segBW, truthBW, distDiceThresh, distModHausThresh)
% segBW touching truthBW
segAndTruthBW = bwFeatureAND(segBW, truthBW);
[segAndTruthLabel, numObjSegAndTruth] = bwlabel(segAndTruthBW);
truthLabel = bwlabel(truthBW);

% Init
truePosBW = false(size(segBW));
falsePosBW = xor(segBW, segAndTruthBW);
truePosIdx = false(numObjSegAndTruth, 1);
distDice = zeros(numObjSegAndTruth, 1);
distModHaus = zeros(numObjSegAndTruth, 1);

if numObjSegAndTruth > 0
    for curSegAndTruthObjLabel=1:numObjSegAndTruth
        curSegObjBW = (segAndTruthLabel == curSegAndTruthObjLabel);
        
        curTruthObjLabel = truthLabel(segAndTruthLabel == curSegAndTruthObjLabel);
        curTruthObjLabel = mode(curTruthObjLabel(curTruthObjLabel > 0));
        curTruthObjBW = (truthLabel == curTruthObjLabel);
        
        % Dice distance
        distDice(curSegAndTruthObjLabel, 1) = computeDistanceRef2Im(curSegObjBW, curTruthObjBW, 'Dice');
        
        % Modified Hausdorff distance
        [curSegObjBWCoord,~] = bwboundaries(curSegObjBW,'noholes');
        [curTruthObjBWCoord,~] = bwboundaries(curTruthObjBW,'noholes');
        distModHaus(curSegAndTruthObjLabel, 1) = ModHausdorffDistMex(curSegObjBWCoord{1}, curTruthObjBWCoord{1});
        
        % Decide if the curSegObjBW is close enough to the truth to be a TP
        if (distDice(curSegAndTruthObjLabel, 1) >= distDiceThresh) || distModHaus(curSegAndTruthObjLabel, 1) < distModHausThresh
            truePosBW = truePosBW | curSegObjBW;
            truePosIdx(curSegAndTruthObjLabel) = true;
        else
            falsePosBW = falsePosBW | curSegObjBW;
        end
    end
end
end