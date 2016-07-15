function [mainTabHandle,tabCardHandles,tabHandles] = tabPanel(parent,tabLabels,varargin)
% tabPanel: Create a uipanel comprising labeled, tiered, and ranked tabbed cards.
%
%     tabPanel is different than some of the other submissions by the
%         same name in the degree of control it provides (flexibility), and
%         in its independence from the GUIDE environment. It also supports
%         TOP (default), BOTTOM, LEFT, and RIGHT tabs, with vertical
%         labels, and multiple-depth (tiered) panels. (See important REMARK
%         under description of TABLABELS for discussion of how tabPanel is
%         organized.)
%
% USAGE:
%
% [mainTabHandle,tabCardHandles,tabHandles] = tabPanel(parent,tabLabels,ParameterValuePairs)
%
% tabPanel(parent,tabLabels);
%     Creates a uipanel with tabbed labels specified by tabLabels, as a
%     child of a valid figure, uipanel, or uibuttongroup. (NOTE: This is
%     the minimum required set of arguments.)
%
% [mainTabHandle,tabCardHandles,tabHandles] = tabPanel(parent,tabLabels)
%     Returns the handle of the parent uipanel ("tab set"), of the
%     individual tab cards (which are themselves uipanels), and of the
%     individual tabs (which are pushbuttons).
%
% [mainTabHandle,tabCardHandles] = tabPanel(parent,tabLabels,PVPairs)
%     Provides additional support for control of the
%     overall tabPanel position, tab position (T,B,L,R), extent, height,
%     colors, and tab label properties.
%
% OUTPUT ARGUMENTS:
%
%     MAINTABHANDLE: Handle of the parent uipanel.
%
%     TABCARDHANDLES: A cell array of handles of the child uipanels.
%                    The structure of the cell array will reflect the
%                    manner in which the tabLabels were defined (and thus
%                    the tier of the cards. For instance, if tabLabels =
%                    {{'One','Two'},{'Three','Four'},{'Five'}}, the handles
%                    might be returned in a cell array like this:
%                    tabCardHandles = {{1 2},{3 4},{5}}.
%                    (See REMARK under TABLABELS for more discussion.)
%
%     TABHANDLES:    A cell array of handles of the labeled tabs
%                    themselves, which are uicontrol pushbuttons. NOTE that
%                    in the case of 'top' or 'bottom' tabs, the labels are
%                    captured in the 'string' property of the uicontrols,
%                    but for 'left' or 'right' tabs, the labels are stored
%                    in the 'cdata' property (this is a workaround for the
%                    inability to rotate text on pushbuttons), making them
%                    less convenient to modify after they are created.
%
% INPUT ARGUMENT:
%
%     PARENT:        Handle of the parent object (required). Must be a
%                    valid handle to a figure, a uipanel, or a uibuttongroup.
%
%     TABLABELS:     A cell array of text strings with which cards are labelled.
%
%                    EXAMPLE: tabLabels1 = {'One','Two'}
%                             tabLabels2 = {{'One','Two'}}
%                             tabLabels3 = {{'One','Two','Three'},{'Four','Five'}}
%
%                    REMARK:
%                    The structure of this input determines the creation of
%                    tab cards, the parsing of subsequent inputs, and
%                    format of the returned variables!
%
%                    TIERS: tabLabels must be a cell array, with all
%                    elements being strings, or with all elements being
%                    cell arrays of strings. Each sub-cell defines a new
%                    "TIER" of cards, displayed on a separate level. If all
%                    elements of tabLabels are strings, then a single TIER
%                    of tabs will be created. If all elements of tabLabels
%                    are cells, then each will define a new tier of tabbed
%                    cards. In the examples above, tabLabels1 and
%                    tabLabels2 are equivalent, and will produce a single
%                    TIER of cards. tabLabels3 will produce a three-TIERed
%                    set of cards, having two cards in each of the first
%                    two TIERs, and one card in the third TIER.
%
%                    tabRank: within each tier, cards have a "tabRank," which
%                    captures the order in which they were specified and
%                    created. For example, in tabLabels3, the cards labeled
%                    'One' and 'Four' will have tabRank 1, cards labeled 'Two'
%                    and 'Five' will have tabRank 2, and the card labeled
%                    'Three' will have tabRank 3.
%
%                    See TABCARDHANDLE description for a discussion of how
%                    handles will be mapped to corresponding positions in
%                    tabLabels.
%
%     PARAMETER-VALUE PAIRS:
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     PARAMETER      VALUE
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     TABPOS:        A (case-insensitive) string indicating the position of
%                    the tabs. Valid strings are:
%
%                    'Top' (or 'T'): Tabs along top. (DEFAULT)
%                    'Bottom' (or 'B'): Tabs along bottom.
%                    'Left' (or 'L'): Tabs along left.
%                    'Right' (or 'R'): Tabs along right.
%
%     PANELPOS:      The position (in normalized units) of the main panel
%                    within  the parent. (Default is [0 0 1 1], to occupy
%                    the entirety of the parent.)
%
%     TABEXTENT:     A scalar, or an nTiers x 1 vector of numbers that modify the portion of
%                    the parent spanned by the tab set. (Must be on the interval [0,
%                    1];). If a scalar is provide, it is used for all
%                    tiers. If a vector is provided, each element specifies
%                    the span of its corresponding tier. Example: for a
%                    3-tiered set of tabs, tabExtent = [1 1 0.5] would
%                    trigger tiers 1 and 2 to span the parent, and tier 1
%                    to span half the parent.DEFAULT = 1)
%
%     TABHEIGHT:     The height of the tab (in pixels), if it is top- or
%                    bottom-positioned, or the width of the tab, otherwise.
%                    (DEFAULT = 50 pixels.) (Note: different heights for
%                    different tiers is not supported; tabHeight must be a
%                    scalar.)
%
%     COLORS:        A totalTabs x 3 matrix of RGB colors for the tab cards.
%                    Default is a "boosted" JET colormap, defined by:
%                    colors = jet(totalTabs+1);
%                    colors = min(1,colors+0.25);
%                    (totalTabs is the overall number of tab labels
%                    provided.)
%
%     TABCARDPVS:    A cell array or structure of Parameter-Value pairs,
%                    which will be applied to all individual tab cards.
%                    (See uipanel properties for valid PVs.)
%
%     TABLABELPVS:   A cell array or structure of Parameter-Value pairs,
%                    which will be applied to all tab labels. This allows
%                    the user to apply non-default text parameters, such as
%                    fontsize, color, rotation, etc. (See text properties
%                    for valid PVs.)
%
%     HIGHLIGHTCOLOR:A triplet indicating the color in which the
%                    active panel (and corresponding button)
%                    should be displayed. (If not provided, no
%                    color change is implemented.)
%
% TO PROGRAMMATICALLY ACTIVATE A PRE-CONSTRUCTED TAB:
%     tabPanel(tabCardHandles,tabHandles{tier}(tabRank))
%
% TO PROGRAMMATICALLY DETERMINE WHICH TAB IS ACTIVE:
%     [currentTier,currentTabRank,tabName] = tabPanel(mainTabHandle);
%
% Examples:
%       tabLabels = {{'One','Two','Three'},{'Four','Five'}};
%
%       1) tabPanel(gcf,tabLabels);
%
%       2) tabPanel(gcf,tabLabels,'tabpos','r','panelpos',[0.2 0.2 0.6 0.6],...
%             'tabextent',0.8,'tabheight',80,'colors',cool(5))
%
%       3) tabPanel(gcf,{{1,2,3},{4},{5,6}},'tabpos','b','tabextent',3/4,...
%             'tabLabelPVs',{'fontweight','b','foregroundcolor','r'})
%
%       4) tabLabels = {{'January','February','March'},{'April','May','June'},...
%                {'July','August','September'},{'October','November','December'}};
%             tabPanelOpts.fontweight = 'bold';
%             tabPanelOpts.fontsize = 14;
%             [mth,tch,th] = tabPanel(gcf,tabLabels,'TabPos','Right','TabHeight',60,'Colors',cool(12),...
%                'TabCardPVs',{'bordertype','etchedin','title',''},...
%                'TabLabelPVs',tabPanelOpts,...
%                'TabExtent',[1, 0.8, 1, 0.8])
%
% NOTE ON TEXT ORIENTATION: Text is automatically set to be upright for Top and
%       Bottom tabs, and, by default, rotated 90 degrees for Left tabs, and
%       270 degrees for Right tabs. To modify the orientation, the user can
%       change the 'rotation' property using the optional TABLABELPVS input
%       argument. IMPORTANT: If ANY PVs are provided as inputs for a Left
%       or Right tabPanel, uicontrol defaults (rather than TABPANEL
%       defaults) will be used for unspecified parameters. (Thus, if you
%       want to specify the color of the text, you must also specify the
%       rotation if you want other something other than un-rotated text,
%       and the backgroundcolor, to match that of the pushbutton.) Also,
%       because MATLAB does not currently support rotated text in
%       uicontrol strings, labels for L or R tabs will be _images_ of
%       rotated text, generated using the function CREATEBUTTONLABEL.
%       Creation of Left or Right tabPanels therefore requires the download
%       and installation of CREATEBUTTONLABEL from the MATLAB Central File
%       Exchange. (Using L or R will briefly expose a temporary figure in
%       which the labels are generated.)
%
% NOTE ON PARAMETER VALUE PAIRS FOR TAB PANELS AND LABELS: After creation
%       of the tabpanel, use the mainTabHandle output to modify the parent
%       tab. (See uipanel properties for valid PV pairs.) Use output
%       tabCardHandles to modify the child cards, again with any PV pairs
%       valid for uipanels. And use tabHandles to modify the uicontrol
%       pushbuttons that comprise the active labels on the cards. (See
%       description of tabHandles for details of these handles.) If the
%       tabs are left- or right-oriented, use the createButtonLabel command
%       to re-generate cdata with different parameters.
%
% See also: createButtonLabel, sliderPanel

% Written by Brett Shoelson, PhD
% brett.shoelson@mathworks.com
% 01/21/07
%
% Copyright 2010-2013 The Mathworks Inc

% Modifications:
% 03/11/2013: Changed "highlight" behavior.
%             Added capability of determining programmatically which tab is
%                active, and note on how to do so.

if nargin == 1
    %Note: This just reuses output argument names; it doesn't overwrite
    %them in any meaninful sense.
    [mainTabHandle,tabCardHandles,tabHandles] = getCurrentTab(parent);
    return
end

if nargin == 2 &&...
        ~isa(tabLabels,'cell') && ...
        ishandle(tabLabels) && ...
        strcmp(get(tabLabels,'style'),'pushbutton')
    % PANEL ACTIVATION REQUESTED
    try
        highlightColor = [];
        tabCardHandles = parent;
        nTiers = size(tabCardHandles,2);
        changeTabOrder(tabLabels);
        return
    catch
        beep
        disp('Activation-by-tab-handle not working!');
        return
    end
end

% Determine color of parent
parentColor = getParentColor;

% Make sure tabLabels is valid
[nTiers, nTabs, tabCardHandles] = validateParseTabLabels;
totalTabs = sum(nTabs);

% CREATE/INITIALIZE TABCARDS
tabHandles = tabCardHandles;

% PARSE INPUT ARGUMENTS

[colors,highlightColor,panelPos,parent,tabCardPVs,tabExtent,tabHeight,tabLabelPVs,tabLabels,tabPos] = parseInputs(parent,tabLabels,varargin{:});

% Simplify tabPos expression
tabPos = lower(tabPos(1));
if ismember(tabPos,{'l','r'}) && exist('createButtonLabel','file') ~= 2
    beep;
    s1 = sprintf('\nNOTE:\nTo create left- or right-oriented tabPanels, you you must first download\nand install ');
    s2 = sprintf('<a href="matlab: web(''http://www.mathworks.com/matlabcentral/fileexchange/loadFile.do?objectId=15018&objectType=file'')">createButtonLabel</a> from the MATLAB Central File Exchange.\n\n');
    %error(['TABPANEL: Unsupported option.',s1,s2]);
    fprintf(['\nTABPANEL: Unsupported option.\n',s1,s2,'Using TOP-oriented labels instead.\n\n'])
    tabPos = 't';
end

tp = {'rightbottom','lefttop'};
tp = tp{(strcmp(tabPos,'b')||strcmp(tabPos,'r'))+1};

% Calculate tab positions
rectPosn = calculatePositions;

% CREATE UIPANEL AS PARENT (DEFAULT)
mainTabHandle = uipanel('parent',parent,'backgroundcolor',parentColor,'bordertype',...
    'none','units','normalized','pos',panelPos,'tag','mainTabPanel');

% Find characters, convert to lower case
if ~isempty(tabLabelPVs) && iscell(tabLabelPVs)
    charpos = find(cellfun('isclass',tabLabelPVs,'char'));
    for ii = charpos
        tabLabelPVs{ii} = lower(tabLabelPVs{ii});
    end
end

setappdata(mainTabHandle,'tabLabels',tabLabels);
incr = 1;
for tier = 1:nTiers
    for tabRank = 1:nTabs(tier)
        %CHILD TAB PANELS (DEFAULT)
        if nTiers > 1
            currString = tabLabels{tier}(tabRank);
        else
            currString = tabLabels{tabRank};
        end
        if iscell(currString)
            currString = currString{1};
        end
        tabCardHandles{tier}(tabRank) = uipanel('parent',mainTabHandle,'units','normalized',...
            'pos',tabCardPosn,'backgroundcolor',colors(incr,:),'bordertype','none',...
            'titleposition',tp,'title',currString);
        applyPVs(tabCardHandles{tier}(tabRank),tabCardPVs);

        tabHandles{tier}(tabRank) = uicontrol('parent',mainTabHandle,'style','pushbutton','units','normalized',...
            'pos',rectPosn{tier}(tabRank,:),'backgroundcolor',colors(incr,:),...
            'horizontalalignment','l','fontsize',14,'fontweight','bold','callback',@changeTabOrder);
        if ismember(tabPos,{'t','b'})
            set(tabHandles{tier}(tabRank),'string',currString);
            applyPVs(tabHandles{tier}(tabRank),tabLabelPVs);
        else %'l' or 'r'
            rots = [90,270];% Left: 90; Right: 270
            if isempty(tabLabelPVs)
                %DEFAULTS FOR L,R
                tabLabelPVs = {'fontsize',14,'rotation',rots(strcmp(tabPos,'r')+1),'fontweight','b','backgroundcolor',colors(incr,:)};
            else
                tabLabelPVs = updateTabLabelPVs(tabLabelPVs,incr);
            end
            % BUTTONLABEL = CREATEBUTTONLABEL(STRING,PVs,FIGOPT);
            % For all but the last call to createButtonLabel, figOpt = 2
            % (for figure re-use); for creation of the last cdata label,
            % figOpt = 1, triggering deletion of temporary figure.
            buttonLabel = createButtonLabel(currString,...
                tabLabelPVs,...
                2-double(tier == nTiers && tabRank == nTabs(nTiers)));
            set(tabHandles{tier}(tabRank),'cdata',buttonLabel);
        end
        setappdata(tabHandles{tier}(tabRank),'tabRank',tabRank);
        setappdata(tabHandles{tier}(tabRank),'tier',tier);
        setappdata(tabHandles{tier}(tabRank),'origColor',colors(incr,:));
        incr = incr + 1;
    end
end

%HIDE ALL BUT FIRST TAB
%toggleCardVisibility([tier,tabRank],visibility)
origState = get(tabHandles{1}(1));
toggleCardVisibility('all',[],'off');
toggleCardVisibility(1,1,'on');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% BEGIN NESTED FUNCTIONS

    function [colors,highlightColor,panelPos,parent,tabCardPVs,tabExtent,tabHeight,tabLabelPVs,tabLabels,tabPos] = parseInputs(parent,tabLabels,varargin)
        % DEFAULT Colors
        colors = jet(totalTabs+1);
        %Boost color base so tabs won't be too dark
        colors = min(1,colors+0.25);

        p = inputParser;
        p.addRequired('parent',@(x) ishandle(x) && ismember(get(x,'type'),{'figure','uipanel'}))
        p.addRequired('tabLabels',@(x)iscell(x) || ischar(x))
        p.addParamValue('tabPos', 't', ...
            @(x)any(strcmpi(x,{'t','top','b','bottom','l','left','r','right'}))); %Case insensitive (by default)
        p.addParamValue('panelPos', [0 0 1 1], ...
            @(x) numel(x)==4);
        p.addParamValue('tabExtent',1,@(x) all(x>0) && all(x<=1));
        p.addParamValue('tabHeight', 50,@(x) isscalar(x));
        p.addParamValue('colors',colors,@(x) size(x,1)>=totalTabs && size(x,2)==3 && all(x(:)>=0) && all(x(:)<=1));
        p.addParamValue('tabCardPVs',[]);
        p.addParamValue('tabLabelPVs',[]);
        p.addParamValue('highlightColor',[], @(x) ischar(x) || all(x>=0) && all(x<=1) && numel(x)==3);
        p.parse(parent,tabLabels,varargin{:});
        tmp = struct2cell(p.Results);
        %Distribute inputs in alphabetical order!
        [colors,highlightColor,panelPos,parent,tabCardPVs,tabExtent,tabHeight,tabLabelPVs,tabLabels,tabPos] = ...
            deal(tmp{:});
    end

% VALIDATE PARENT ARGUMENT
    function parentColor = getParentColor
        parentType = get(parent,'type');
        switch parentType
            case 'figure'
                parentColor = get(parent,'color');
            case {'uipanel','uibuttongroup'}
                parentColor = get(parent,'backgroundcolor');
        end
    end

% VALIDATE TAB LABELS
    function [nTiers, nTabs, tabCardHandles] = validateParseTabLabels
        % tabLabels must be a cell array. The elements of tabLabel can
        % themselves be cell arrays of strings. Each element that is itself
        % a cell array increases the depth (number of tiers) of the panels.
        % For instance:
        % tabLabels = {{'One','Two'},{'Three','Four'},{'Five'}} will create
        % three tiers  of panels, with two labels in the first ('One' and
        % 'Two') and second ('Three' and 'Four') tiers, and one ('Five') in
        % the third tier.

        class1 = class(tabLabels{1});
        % All tab labels must be of the same class
        for ii = 2:numel(tabLabels)
            if ~strcmp(class(tabLabels{ii}),class1)
                error('TABPANEL: Mismatched tab label types.')
            end
        end

        if iscell(tabLabels{1})
            nTiers = numel(tabLabels);
            nTabs = cellfun('length',tabLabels);
        elseif ischar(tabLabels{1})
            nTiers = 1;
            nTabs = numel(tabLabels);
        else
            error('TABPANEL: tabLabels declaration appears to be invalid.');
        end
        % Initialize placeholders for tabCardHandles
        tabCardHandles = cell(1,nTiers);
        for tier = 1:nTiers
            tabCardHandles{tier} = zeros(nTabs(tier),1);
        end
    end

    function rectPosn = calculatePositions
        %Calculate positions
        tmp = get(0,'screensize');
        Wscr = tmp(3);
        Hscr = tmp(4);
        try
            tabLength = tabExtent./nTabs;
        catch
            error('TABPANEL: Inappropriate value or dimension for tabExtent.')
        end
        % POSITION = [x,y,W,H]
        rectPosn = cell(1,nTiers);
        for tier = 1:nTiers
            if strcmp(tabPos,'t')
                tabCardPosn = [0 0 1 1-nTiers*tabHeight/Hscr];
                rectPosn{tier} = repmat([0 1-tier*tabHeight/Hscr tabLength(tier) tabHeight/Hscr],nTabs(tier),1);
                rectPosn{tier}(:,1)=((1:nTabs(tier))-1)*tabLength(tier);
            elseif strcmp(tabPos,'b')
                tabCardPosn = [0 nTiers*tabHeight/Hscr 1 1-nTiers*tabHeight/Hscr];
                rectPosn{tier} = repmat([0 (tier-1)*tabHeight/Hscr tabLength(tier) tabHeight/Hscr],nTabs(tier),1);
                rectPosn{tier}(:,1)=((1:nTabs(tier))-1)*tabLength(tier);
            elseif strcmp(tabPos,'l')
                tabCardPosn = [nTiers*tabHeight/Wscr 0 1-nTiers*tabHeight/Wscr,1];
                rectPosn{tier} = repmat([(tier-1)*tabHeight/Wscr 0 tabHeight/Wscr tabLength(tier)],nTabs(tier),1);
                rectPosn{tier}(:,2)=(0:nTabs(tier)-1)*tabLength(tier);
            else %strcmp(tabPos,'r')
                tabCardPosn = [0 0 1-nTiers*tabHeight/Wscr 1];
                rectPosn{tier} = repmat([1-tier*tabHeight/Wscr 0 tabHeight/Wscr tabLength(tier)],nTabs(tier),1);
                rectPosn{tier}(:,2)=1-((1:nTabs(tier))*tabLength(tier));
            end
        end
    end

    function changeTabOrder(varargin)
        tier = getappdata(varargin{1},'tier');
        tabRank = getappdata(varargin{1},'tabRank');
        mth = ancestor(varargin{1},'uipanel');%findall(gcf,'tag','mainTabPanel');
        setappdata(mth,'currentTier',tier);
        setappdata(mth,'currentTabRank',tabRank)
        if ~isempty(highlightColor)
            reset = true;
        else
            reset = false;
        end
        toggleCardVisibility('all',[],'off',reset);
        toggleCardVisibility(tier,tabRank,'on',reset);
    end

    function toggleCardVisibility(tier,tabRank,visibility,varargin)
        if ischar(tier)% tier = 'all'
            for tier = 1:nTiers
                set(tabCardHandles{tier},'visible',visibility);
            end
            if nargin == 4 && varargin{1} && strcmp(visibility,'off')
                allHandles = [];
                for ii = 1:nTiers
                    allHandles = [allHandles;tabHandles{ii}];
                end
                for ii = 1:numel(allHandles)
                    origColor = getappdata(allHandles(ii),'origColor');
                    %set(allHandles(ii),'backgroundcolor',origColor);
                    %set(allHandles(ii),'fontangle',origFontAngle,'foregroundcolor',origForegroundColor)
                    set(allHandles(ii),'fontangle',origState.FontAngle,...
                        'fontweight',origState.FontWeight,...
                        'fontsize',origState.FontSize,...
                        'foregroundcolor',origState.ForegroundColor);
                end
            end
        else
            set(tabCardHandles{tier}(tabRank),'visible',visibility);
            if ~isempty(highlightColor) && ismember(tabPos,{'t','b'})
                if strcmp(visibility,'on')
                    % Note: tabHandles are uicontrol pushbuttons
                    %set(tabHandles{tier}(tabRank),'backgroundcolor',highlightColor);
                    set(tabHandles{tier}(tabRank),'fontangle','italic','foregroundcolor',highlightColor);
                    set(tabHandles{tier}(tabRank),...
                        'fontangle','italic',...
                        'fontweight','bold',...
                        'fontsize',origState.FontSize+1,...
                        'foregroundcolor',highlightColor);
                end
            end
        end
    end

    function applyPVs(obj,pvarray)
        if isempty(pvarray)
            return;
        end
        if isstruct(pvarray)
            set(obj,pvarray);
        else %Cell
            if ~isempty(pvarray)
                for ii = 1:2:numel(pvarray)
                    set(obj,pvarray{ii},pvarray{ii+1});
                end
            end
        end
    end

    function tabLabelPVs = updateTabLabelPVs(tabLabelPVs,incr)
        % USE DEFAULTS, FOR VALUES NOT EXPLICITLY DEFINED
        %DEFAULTS FOR L,R
        %tabLabelPVs = {'fontsize',14,'rotation',rots(strcmp(tabPos,'r')+1),'fontweight','b','backgroundcolor',colors(incr,:)};

        if iscell(tabLabelPVs)
            % FONTSIZE
            if ~any(strcmp(tabLabelPVs,'fontsize'))
                [tabLabelPVs{end+1},tabLabelPVs{end+2}] = deal('fontsize',14);
            end
            % ROTATION
            if ~any(strcmp(tabLabelPVs,'rotation'))
                [tabLabelPVs{end+1},tabLabelPVs{end+2}] = deal('rotation',rots(strcmp(tabPos,'r')+1));
            end
            % FONTWEIGHT
            if ~any(strcmp(tabLabelPVs,'fontweight'))
                [tabLabelPVs{end+1},tabLabelPVs{end+2}] = deal('fontweight','bold');
            end
            % BACKGROUNDCOLOR (NOTE: YOU CANNOT SPECIFY
            % ANYTHING OTHER THAN BACKGROUNDCOLOR OF
            % THE PARENT
            tmp = find(strcmp(tabLabelPVs,'backgroundcolor'));
            if ~isempty(tmp)
                tabLabelPVs{tmp+1} = colors(incr,:);
            else
                [tabLabelPVs{end+1},tabLabelPVs{end+2}] = deal('backgroundcolor',colors(incr,:));
            end
        elseif isstruct(tabLabelPVs)
            fn = fieldnames(tabLabelPVs);
            % FONTSIZE
            tmp = find(ismember(fn,{'Fontsize','FontSize','fontsize'}));
            if isempty(tmp)
                tabLabelPVs.fontsize = 14;
            end
            % ROTATION
            tmp = find(ismember(fn,{'Rotation','rotation'}));
            if isempty(tmp)
                tabLabelPVs.rotation = rots(strcmp(tabPos,'r')+1);
            end
            % FONTWEIGHT
            tmp = find(ismember(fn,{'Fontweight','FontWeight','fontweight'}));
            if isempty(tmp)
                tabLabelPVs.fontweight = 'bold';
            end
            % BACKGROUNDCOLOR
            tmp = find(ismember(fn,{'Backgroundcolor','BackgroundColor','backgroundcolor'}));
            if isempty(tmp)
                tabLabelPVs.backgroundcolor = colors(incr,:);
            else
                eval(['tabLabelPVs.' fn{tmp} '=colors(incr,:);']);
            end
        end
    end

    function [currentTier,currentTabRank,tabName] = getCurrentTab(varargin)
        currentTier = getappdata(varargin{1},'currentTier');
        currentTabRank = getappdata(varargin{1},'currentTabRank');
        if isempty(currentTier)
            currentTier = 1;currentTabRank = 1;
        end
        tabLabels = getappdata(varargin{1},'tabLabels');
        tabName = tabLabels{currentTier}(currentTabRank);
    end
end