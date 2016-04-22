function varout = uigetvariables(prompts,intro,types,ndimensions)
%%
% uigetvariables   Open variable selection dialog box
%
% VARS = uigetvariables(PROMPTS) creates a dialog box that returns
% variables selected from the base workspace. PROMPTS is a cell array of
% strings, with one entry for each variable you would like the user to
% select.  VARS is a cell array containing the selected variables.  Each
% element of VARS corresponds with the selection for the same element of
% PROMPTS.
%
% If the user hits CANCEL or dismisses the dialog, VARS is an empty cell
% array. If the user does not select a variable for a given prompt, the
% value in VARS for that prompt is an empty array.
%
% VARS = uigetvariables(PROMPTS,INTRO) includes introductory text to guide the user
% of the dialog.  INTRO is a string. If INTRO is not specified, no
% introduction is included. The text in INTRO is wrapped automatically to
% fit in the dialog.
%
% VARS = uigetvariables(PROMPTS,INTRO,TYPES) restricts the types of the variables
% which can be selected for each prompt.  TYPES is a cell array of strings
% of the same length as PROMPTS, each entry specifies the allowable type of
% variables for each prompt. The elements of TYPES may be any of the
% following:
%     any        Any type. Use this if you don't care.
%     numeric    Any numeric type, as determined by isnumeric
%     logical    Logical
%     string     String or cell array of strings
%
% vars = uigetvariables(PROMPTS,INTRO,TYPES,NDIMENSIONS) also specifies required
% dimensionality of variables. NDIMENSIONS is a numeric array of length PROMPTS,
% with each element specifying the required dimensionality of the variables
% for the corresponding element of PROMPTS. NDIMENSIONS works a little
% different from ndims, in that it allows you to distinguish among scalars,
% vectors, and matrices.
% Allowable values are:
%
%      Value         Meaning
%      ------------  ----------
%      Inf           Any size.  Use this if you don't care, or want more than one allowable size
%      0             Scalar  (1x1)
%      1             Vector  (1xN or Nx1)
%      2             Matrix  (NxM)
%      3 or higher   Specified number of dimensions
%
% vars = uigetvariables(PROMPTS,INTRO,VALFCN) applies an arbitrary
% validation function to determine which variables are valid for each
% prompt.  VALFCN is either a single function handle, or a cell array of
% function handles of same length as PROMPTS.  If VALFCN is a single
% function handle, it is applied to every prompt.  Use a cell array of
% function handles to specify a unique validation function for each prompt.
% VALFCN must return true if a variable passes the validation or false if
% the variable does not.  Syntax of VALFCN must be 
%       TF = VALFCN(variable)
%
% Examples
%
% % Put some sample data in your base workspace:
% scalar1 = 1;
% str1 = 'a string';
% cellstr1 = {'a string';'in a cell'};cellstr2 = {'another','string','in','a','cell'};    
% cellstr3 = {'1','2';,'3','4'}
% vector1 = rand(1,10); vector2 = rand(5,1);
% array1  = rand(5,5); array2 = rand(5,5); array3 = rand(10,10);
% threed1 = rand(3,4,5);
% fourd1 = rand(1,2,3,4);
%
% % Select any two variables from entire workspace
% tvar = uigetvariables({'Please select any variable','And another'});
% 
% % Include introductory text
% tvar = uigetvariables({'Please select any variable','And another'},'Here are some very detailed directions about how you should use this dialog.  Pick one variable, then pick another variable.');
% 
% % Control type of variables
% tvar = uigetvariables({'Pick a number:','Pick a string:','Pick another number:'},[],{'numeric','string','numeric'});
% 
% % Control size of variables.
% tvar = uigetvariables({'Pick a scalar:','Pick a vector:','Pick a matrix:'},[],[],[0 1 2]);
% 
% % Control type and size of variables
% tvar = uigetvariables({'Pick a scalar:','Pick a string','Pick a 4D array'},[],{'numeric','string','numeric'},[0 Inf 4]);
% tvar = uigetvariables({'Pick a scalar:','Pick a string vector','Pick a 3D array'},[],{'numeric','string','numeric'},[0 1 3]);
% 
% % Advanced - use custom validation functions
% 
% % Custom validation functions
% tvar = uigetvariables({'Pick a number:','Any number:','One more, please:'},'Use a custom validation function to require every input to be numeric',@isnumeric);
% tvar = uigetvariables({'Pick a number:','Pick a cell string:','Pick a 3D array:'},[],{@isnumeric,@iscellstr,@(x) ndims(x)==3});
% 
% % No variable found
% tvar = uigetvariables('Pick a 6D numeric array:','What if there is no valid data?',@(x) isnumeric(x)&&ndims(x)==6);

% Scott Hirsch
% Scott.Hirsch@mathworks.com

% Copyright 2010-2013 The Mathworks Inc


% Allow for single prompt as string
if ~iscell(prompts)
    prompts = {prompts};
end

if nargin<2 || isempty(intro)
    intro = '';
end

nPrompts = length(prompts);

% Assume the user didn't specify validation function
specifiedValidationFcn = false;

%% 
if nargin==3 && ~isempty(types)  % See if I've got function handle
    % Grab the first value from cell to test type
    if iscell(types)
        test = types{1};
    else
        test = types;
    end
    
    switch class(test)
        case 'function_handle'
            % Put "types" input variable into valfcn
            % Replicate a single function handle into a cell array if necessary
            if ~iscell(types)
                valfcn = cell(nPrompts,1);
                valfcn = cellfun(@(f) types,valfcn,'UniformOutput',false);
            else
                valfcn = types;
            end
            specifiedValidationFcn = true;
    end
end

%% 
% If the user didn't specify the validation function, we will build it for
% them.  
if ~specifiedValidationFcn
    if nargin<3 || isempty(types)
        types = cellstr(repmat('any',nPrompts,1));
    elseif length(types)==1  % allow for single prompt with single type
        types = {types};
    end
    
    if nargin<4 || isempty(ndimensions)
        ndimensions = inf(1,nPrompts);
    end
        
    % Base validation functions to choose from:
    isscalarfcn = @(var) numel(var)==1;
    isvectorfcn = @(var) length(size(var))==2&&any(size(var)==1)&&~isscalarfcn(var);
    isndfcn     = @(var,dim) ndims(var)==dim && ~isscalar(var) && ~isvectorfcn(var);
    
    isanyfcn = @(var) true;                 % What an optimistic function! :)
    isnumericfcn = @(var) isnumeric(var);
    islogicalfcn = @(var) islogical(var);
    isstringfcn = @(var) ischar(var) | iscellstr(var);

    valfcn = cell(1,nPrompts);
    
    for ii=1:nPrompts
        
        switch types{ii}
            case 'any'
                valfcn{ii} = isanyfcn;
            case 'numeric'
                valfcn{ii} = isnumericfcn;
            case 'logical'
                valfcn{ii} = islogicalfcn;
            case 'string'
                valfcn{ii} = isstringfcn;
            otherwise
                valfcn{ii} = isanyfcn;
        end
                
        switch ndimensions(ii)
            case 0    % 0 - scalar
                valfcn{ii} = @(var) isscalarfcn(var) & valfcn{ii}(var);
            case 1    % 1 - vector
                valfcn{ii} = @(var) isvectorfcn(var) & valfcn{ii}(var);
            case Inf  % Inf - Any shape
                valfcn{ii} = @(var) isanyfcn(var) & valfcn{ii}(var);
            otherwise % ND
                valfcn{ii} = @(var) isndfcn(var,ndimensions(ii)) & valfcn{ii}(var);
        end
    end
end


%% Get list of variables in base workspace
allvars = evalin('base','whos');
nVars = length(allvars);
varnames = {allvars.name};
vartypes = {allvars.class};
varsizes = {allvars.size};


% Convert variable sizes from numbers:
% [N M], [N M P], ... etc
% to text:
% NxM, NxMxP
varsizes = cellfun(@mat2str,varsizes,'UniformOutput',false);
%too lazy for regexp.  Strip off brackets
varsizes = cellfun(@(s) s(2:end-1),varsizes,'UniformOutput',false);
% replace blank with x
varsizes = strrep(varsizes,' ','x');

vardisplay = strcat(varnames,' (',varsizes,{' '},vartypes,')');

%% Build list of variables for each prompt
% Also include one that's prettied up a bit for display, which has an extra
% first entry saying '(select one)'.  This allows for no selection, for
% optional input arguments.
validVariables = cell(nPrompts,1);
validVariablesDisplay = cell(nPrompts,1);     

for ii=1:nPrompts
    % turn this into cellfun once I understand what I'm doing.
    assignin('base','validationfunction_',valfcn{ii})
    validVariables{ii} = cell(nVars,1);
    validVariablesDisplay{ii} = cell(nVars+1,1);
    t = false(nVars,1);
    for jj = 1:nVars
        t(jj) = evalin('base',['validationfunction_(' varnames{jj} ');']);
    end
    if any(t)   % Found at least one variable
        validVariables{ii} = varnames(t);
        validVariablesDisplay{ii} = vardisplay(t);
        validVariablesDisplay{ii}(2:end+1) = validVariablesDisplay{ii};
        validVariablesDisplay{ii}{1} = '(select one)';
    else
        validVariables{ii} = '(no valid variables)';
        validVariablesDisplay{ii} = '(no valid variables)';
    end
    
    evalin('base','clear validationfunction_')
end


%% Compute layout
offset = 1;
maxStringLength = max(cellfun(@(s) length(s),prompts));
componentWidth = max([maxStringLength, 50]);
componentHeight = 1;

% Buttons
buttonHeight = 1.77;
buttonWidth = 10.6;


% Wrap intro string.  Need to do this now to include height in dialog.
% Could use textwrap, which comes with MATLAB, instead of linewrap. This would just take a
% bit more shuffling around with the order I create and size things.
if ~isempty(intro)
    intro = linewrap(intro,componentWidth);
    introHeight = length(intro);    % Intro is now an Nx1 cell string
else
    introHeight = 0;
end


dialogWidth = componentWidth + 2*offset;
dialogHeight = 2*nPrompts*(componentHeight+offset) + buttonHeight + offset + introHeight;

% Component positions, starting from bottom of figure
popuppos = [offset 2*offset+buttonHeight componentWidth componentHeight];
textpos = popuppos; textpos(2) = popuppos(2)+componentHeight;

%% Build figure
% hFig = dialog('Units','Characters','WindowStyle','modal','Name','Select variable(s)','CloseRequestFcn',@nestedCloseReq);
hFig = dialog('Units','Characters','WindowStyle','normal','Name','Select variable(s)','CloseRequestFcn',@nestedCloseReq);
% set(hFig,'DefaultUicontrolFontSize',10)
% set(hFig,'DefaultUicontrolFontName','Arial')
 
pos = get(hFig,'Position');
set(hFig,'Position',[pos(1:2) dialogWidth dialogHeight])
uicontrol('Parent',hFig,'style','Pushbutton','Callback',@nestedCloseReq,'String','OK',    'Units','characters','Position',[dialogWidth-2*offset-2*buttonWidth .5*offset buttonWidth buttonHeight]);
uicontrol('Parent',hFig,'style','Pushbutton','Callback',@nestedCloseReq,'String','Cancel','Units','characters','Position',[dialogWidth-offset-buttonWidth  .5*offset buttonWidth buttonHeight]);


for ii=nPrompts:-1:1
    uicontrol('Parent',hFig,'Style','text',     'Units','char','Position',textpos, 'String',prompts{ii},'HorizontalAlignment','left');
    hPopup(ii) = uicontrol('Parent',hFig,'Style','popupmenu','Units','char','Position',popuppos,'String',validVariablesDisplay{ii},'UserData',validVariables{ii});
    
    % Set up positions for next go round
    popuppos(2) = popuppos(2) + 1.5*offset + 2*componentHeight;
    textpos(2) = textpos(2) + 1.5*offset + 2*componentHeight;
end

if ~isempty(intro)
    intropos = [offset dialogHeight-introHeight-1 componentWidth introHeight+.5];
    uicontrol('Parent',hFig,'Style','text','Units','Characters','Position',intropos, 'String',intro,'HorizontalAlignment','left');
end

uiwait(hFig)


    function nestedCloseReq(obj,~)
        % How did I get here?
        % If pressed OK, get variables.  Otherwise, don't.
        
        if strcmp(get(obj,'type'),'uicontrol') && strcmp(get(obj,'String'),'OK')
            for ind=1:nPrompts
                str = get(hPopup(ind),'UserData');  % Store real variable name here
                val = get(hPopup(ind),'Value')-1;   % Remove offset to account for '(select one)' as initial entry
                
                if val==0 % User didn't select anything
                    varout{ind} = [];
                elseif strcmp(str,'(no valid variables)')
                    varout{ind} = [];
                else
                    varout{ind} = evalin('base',str{val});
                end
            end
        else  % Cancel - return empty
            varout = {};
        end
        
        delete(hFig)
        
    end
end




function c = linewrap(s, maxchars)
%LINEWRAP Separate a single string into multiple strings
%   C = LINEWRAP(S, MAXCHARS) separates a single string into multiple
%   strings by separating the input string, S, on word breaks.  S must be a
%   single-row char array. MAXCHARS is a nonnegative integer scalar
%   specifying the maximum length of the broken string.  C is a cell array
%   of strings.
%
%   C = LINEWRAP(S) is the same as C = LINEWRAP(S, 80).
%
%   Note: Words longer than MAXCHARS are not broken into separate lines.
%   This means that C may contain strings longer than MAXCHARS.
%
%   This implementation was inspired a blog posting about a Java line
%   wrapping function:
%   http://joust.kano.net/weblog/archives/000060.html
%   In particular, the regular expression used here is the one mentioned in
%   Jeremy Stein's comment.
%
%   Example
%       s = 'Image courtesy of Joe and Frank Hardy, MIT, 1993.'
%       c = linewrap(s, 40)
%
%   See also TEXTWRAP.

% Steven L. Eddins
% $Revision: 1.7 $  $Date: 2006/02/08 16:54:51 $

% http://www.mathworks.com/matlabcentral/fileexchange/9909-line-wrap-a-string
% Copyright (c) 2009, The MathWorks, Inc.
% All rights reserved.
% 
% Redistribution and use in source and binary forms, with or without 
% modification, are permitted provided that the following conditions are 
% met:
% 
%     * Redistributions of source code must retain the above copyright 
%       notice, this list of conditions and the following disclaimer.
%     * Redistributions in binary form must reproduce the above copyright 
%       notice, this list of conditions and the following disclaimer in 
%       the documentation and/or other materials provided with the distribution
%     * Neither the name of the The MathWorks, Inc. nor the names 
%       of its contributors may be used to endorse or promote products derived 
%       from this software without specific prior written permission.
%       
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
% AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
% IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
% ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE 
% LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
% CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
% SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
% INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
% CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
% ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
% POSSIBILITY OF SUCH DAMAGE.

narginchk(1, 2);

bad_s = ~ischar(s) || (ndims(s) > 2) || (size(s, 1) ~= 1);      %#ok<ISMAT>
if bad_s
   error('S must be a single-row char array.');
end

if nargin < 2
   % Default value for second input argument.
   maxchars = 80;
end

% Trim leading and trailing whitespace.
s = strtrim(s);

% Form the desired regular expression from maxchars.
exp = sprintf('(\\S\\S{%d,}|.{1,%d})(?:\\s+|$)', maxchars, maxchars);

% Interpretation of regular expression (for maxchars = 80):
% '(\\S\\S{80,}|.{1,80})(?:\\s+|$)'
%
% Match either a non-whitespace character followed by 80 or more
% non-whitespace characters, OR any sequence of between 1 and 80
% characters; all followed by either one or more whitespace characters OR
% end-of-line.

tokens = regexp(s, exp, 'tokens').';

% Each element if the cell array tokens is single-element cell array 
% containing a string.  Convert this to a cell array of strings.
get_contents = @(f) f{1};
c = cellfun(get_contents, tokens, 'UniformOutput', false);

% Remove trailing whitespace characters from strings in c.  This can happen
% if multiple whitespace characters separated the last word on a line from
% the first word on the following line.
c = deblank(c);

end
