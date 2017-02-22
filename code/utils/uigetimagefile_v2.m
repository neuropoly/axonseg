function [filename, userCanceled] = uigetimagefile_v2(varargin)
%   UIGETIMAGEFILE Open Image dialog box.
%
%   This is a private copy of IMGETFILE to be used by DAStudio. The file
%   filter in our case is fixed and much simpler than the one used by 
%   IMGETFILE. We are interested in common image types which are used by 
%   html browsers and word processing applications.
%
%   [FILENAME, USER_CANCELED] = UIGETIMAGEFILE displays the Open Image 
%   dialog box for the user to fill in and returns the full path to the 
%   file selected in FILENAME. If the user presses the Cancel button,
%   USER_CANCELED will be TRUE. Otherwise, USER_CANCELED will be FALSE.
%
%   [FILENAME, USER_CANCELED] = UIGETIMAGEFILE(..., Name, Value) specifies
%   additional name-value pairs described below:
%
%   'MultiSelect'    A boolean scalar or a string used to specify the
%                    selection mode.  The value of true or 'on' turns 
%                    multiple selection on, and value of false or 'off' 
%                    turns multiple selection off. If multiple selection is
%                    turned on, the output parameter FILENAME is a cell
%                    array of strings containing the full paths to the
%                    selected files.
%                   
%                    Default: false
%   
%   The Open Image dialog box is modal; it blocks the MATLAB command line
%   until the user responds. 
%   
%   Copyright 2013 The MathWorks, Inc.



    % Get filter spec for image formats
    filterSpec = createImageFilterSpec();
    
    useMultiSelect = parseInputs(varargin{:});
    
    % Form string 'Get Image' vs. 'Get Images' based on whether or not MultiSelect
    % is enabled.
    multiSelect = strcmp(useMultiSelect,'on');
    
    [fname, pathname,filterindex] = uigetfile(filterSpec,...
                                    'MultiSelect',useMultiSelect);

    % If user successfully chose file, cache the path so that we can open the
    % dialog in the same directory the next time imgetfile is called.
    userCanceled = (filterindex == 0);
    if ~userCanceled
        filename = fullfile(pathname, fname);
    else
        % If user cancelled, return empty {} or empty string depending on
        % MultiSelect state.
        if multiSelect
            filename = {};
        else
            filename = '';
        end
    end
end

%--------------------------------------------------------------------------
function filterSpec = createImageFilterSpec()
%   Creates filterSpec argument expected by uigetfile

%   Generate filterSpec cell array

    formats = {...
        '*.emf',                    'Windows Enhanced Metafile';...
        '*.wmf',                    'Windows Metafile';...
        '*.png',                    'Portable Network Graphics';...
        '*.bmp;*.dib;*.rle',        'Windows Bitmap';...
        '*jpg;*jpeg;*.jfif;*.jpe',  'JPEG File Interchange Format';...
        '*.gif;*.gfa',              'Graphics Interchange Format';...
        '*.emz',                    'Compressed Windows Enhanced Metafile';...
        '*.wmz',                    'Compressed Windows Metafile';...
        '*.pcz',                    'Compressed  Macintosh PICT';...
        '*.tif;*.tiff',             'Tag Image File Format';...
        '*.cgm',                    'Computer Graphics Metafile';...
        '*.eps',                    'Encapsulated PostScript';...
        '*.pct;*.pict',             'Macintosh PICT';...
        '*.wpg',                    'WordPerfect Graphics';...
        '*.svg',                    'Scalable Vector Graphics';...
    };

    nformats = length(formats);

    % Create "All Image Files" and "All Files" options
    filterSpec{ 1, 2 } = 'All Image Files';
    filterSpec{ nformats + 2, 1 } = '*.*';
    filterSpec{ nformats + 2, 2 } = 'All Files (*.*)';
    
    for i = 1:nformats
        extString = formats{i, 1};
        dscString = formats{i, 2};
        % Add current extension to "All Images" list
        if (i == 1)
            filterSpec{1,1} = extString;
        else
            filterSpec{1,1} = strcat(filterSpec{1,1}, ';', extString);
        end
        
        filterSpec{i+1,1} = extString;
        filterSpec{i+1,2} = strcat( dscString,' (', extString,')');
    end
end

%--------------------------------------------------------------------------
function useMultiSelect = parseInputs(varargin)
%   parameter parsing
    parser = inputParser;
    parser.addParamValue('MultiSelect', false, @checkMultiSelect);
    parser.parse(varargin{:});
    useMultiSelect = parser.Results.MultiSelect;

    if isnumeric(parser.Results.MultiSelect) || islogical(parser.Results.MultiSelect)
        if (parser.Results.MultiSelect)
            useMultiSelect = 'on';
        else
            useMultiSelect = 'off';
        end
    end
end

%--------------------------------------------------------------------------
function tf = checkMultiSelect(useMultiSelect)
    tf = true;
    validateattributes(useMultiSelect, {'logical', 'numeric', 'char'}, ...
        {'vector', 'nonsparse'}, ...
        mfilename, 'MultiSelect');
    if ischar(useMultiSelect)
        validatestring(useMultiSelect, {'on', 'off'}, mfilename, 'UseMultiSelect');
    else
        validateattributes(useMultiSelect, {'logical', 'numeric'}, {'scalar'}, ...
            mfilename, 'MultiSelect');
    end
end
