function [filterspec,extensions] = imgformats(augment)
% FILTERSPEC = IMGFORMATS(AUGMENT)
% Creates variable FILTERSPEC, comprising MATLAB-recognized image
% extenstions, in a format suitable for calling
% UIGETFILE(FILTERSPEC).
% 
% AUGMENT is an optional input argument that takes a binary 1 or
% 0. If 1, filterspec is augmented with non-listed, but
% recognized, image formats. (Notably, DICOM.) The default is 0.

% Written by Brett Shoelson, PhD
% brett.shoelson@mathworks.com
% 7/25/06
%
% Copyright 2006-2012 MathWorks, Inc.


if nargin < 1
	augment = 0;
elseif nargin > 1
	error('Too many input arguments in call to IMGFORMATS.');
else %nargin==1
	if ~ismember(augment,[0,1])
		error('AUGMENT must be either 0 or 1.');
	end
end

%Parse formats from IMFORMATS
formats = imformats;
nformats = length(formats);
desc = cell(nformats+1,1);
[desc{2:end}] = deal(formats.description);
ext = cell(nformats+1,1);
[ext{2:end}] = deal(formats.ext);
if augment
    % Add other formats that are not part of IMFORMATS
    desc{end+1} = 'Dicom (DCM)';
    ext{end+1} = {'dcm'};
    allext=[formats.ext,'dcm']; 
else
    allext = [formats.ext];
end

nformats = size(desc,1);
ext{1} = sprintf('*.%s;',allext{:});
desc{1} = 'All Image Formats';

filterspec = cell(nformats,2);
filterspec{1,1} = ext{1};
filterspec{1,2} = desc{1};
for ii = 2:nformats
	filterspec{ii,1} = sprintf('*.%s;',ext{ii}{:});
	filterspec{ii,2} = sprintf('%s',desc{ii});
end
if nargout > 1
    allext = [formats.ext];
    extensions = cell(numel(allext),1);
    for ii = 1:numel(allext)
        extensions{ii} = sprintf('*.%s',allext{ii});
    end
end
