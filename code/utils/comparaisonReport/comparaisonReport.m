function output = comparaisonReport(input)

if nargin == 0
    disp('Choose a segmentation result file (mat)')
    [fileName,pathName,~] = uigetfile('*.mat');
    input = fullfile(pathName, fileName);
end

if exist(input, 'dir')
    disp('Input is a folder')
    processDir(input);
    output = [];
elseif exist(input, 'file')
    disp('Input is a file')
    output = processFile(input);
else
    disp('input does not exist or is not a folder or a file')
    output = [];
    return;
end

end

function processDir(input)
fileList = dir([input '/*.mat']);
fileNameList = {fileList.name};
fprintf('%i images.\n', numel(fileNameList));
for fileNumber=1:numel(fileNameList)
    fileName = fileNameList{fileNumber};
    [~] = processFile(fileName);
end

end

function output = processFile(input)
[pathName, baseName, ext] = fileparts(input);
if strcmp(pathName, ['.' filesep]) || isempty(pathName)
    pathName = pwd;
end
fprintf('\tProcessing image: %s \n', [baseName ext]);

fileName = [fullfile(pathName, baseName) ext];
load(fileName)

if isfield(seg, 'cr')
    seg = rmfield(seg, 'cr');
end

output = main(seg);

saveResult(output);
saveImages(output);

disp('Done!')
end

function seg = main(seg)

if exist(strrep(seg.imInfo.Filename, '.tif', '-truth.tif'), 'file')
    seg.imInfo.truthFilename = strrep(seg.imInfo.Filename, '.tif', '-truth.tif');
    seg.im.truth = imclearborder(logical(imread(seg.imInfo.truthFilename)));
else
    return;
end

if isfield(seg, 'axon') && isfield(seg.axon, 'refineBW')
    [seg.cr.refine, seg.im.cleanTruth] = compareSegmentationWithTruth(seg.axon.refineBW, seg.im.truth, seg.im.original, seg.param.truthComparaison.distDiceThresh, seg.param.truthComparaison.distModHausThresh, seg.param.cleanUp.sizeThresh);
else
    return;
end

if isfield(seg, 'axon') && isfield(seg.axon, 'validateBW')
    segBW = cat(3, seg.axon.validateBW, seg.axon.backBW);
    seg.cr.validate = compareSegmentationWithTruth(segBW, seg.im.cleanTruth, seg.im.original, seg.param.truthComparaison.distDiceThresh, seg.param.truthComparaison.distModHausThresh);
end

if isfield(seg, 'results') && isfield(seg.results, 'axonBW')
    segBW = cat(3, seg.results.axonBW, seg.results.backBW);
    seg.cr.results = compareSegmentationWithTruth(segBW, seg.im.cleanTruth, seg.im.original, seg.param.truthComparaison.distDiceThresh, seg.param.truthComparaison.distModHausThresh);
    % Finds the false negative from the Myelin Clean Up
    seg.cr.results.composite = sc(seg.cr.results.composite) + sc(seg.results.myelinBW, 'c', seg.results.myelinBW)*0.4;
end


end

function saveResult(seg)
save(strrep(seg.imInfo.Filename, '.tif', '.mat'), 'seg')
end

function saveImages(seg)

if isfield(seg, 'cr')
    fn1 = fieldnames(seg.cr);
    for i=1:numel(fn1)
        fn2 = fieldnames(seg.cr.(fn1{i}));
        for j=1:numel(fn2)
            if strfind(fn2{j}, 'BW')
                imwrite(seg.cr.(fn1{i}).(fn2{j}), strrep(seg.imInfo.Filename, '.tif', ['-cr-' fn1{i} '-' fn2{j} '.tif']))
            end
            if ~isempty(strfind(fn2{j}, 'Composite')) || ~isempty(strfind(fn2{j}, 'composite'))
                imwrite(seg.cr.(fn1{i}).(fn2{j}), strrep(seg.imInfo.Filename, '.tif', ['-cr-' fn1{i} '-' fn2{j} '.png']))
            end
            
        end
    end
end

end