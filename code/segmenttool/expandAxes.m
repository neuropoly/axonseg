function expandAxes(hndls,rotEnable)
% Sets all axes in the handle list to expand in a new figure on buttondown. 
%
% SYNTAX:
% expandAxes
%    Sets the current axes to expand on buttondown.
% 
% expandAxes(hndls)
%    Sets all axes in the input list of handles to expand on buttondown.
%
% expandAxes(hndls,rotEnable)
%    ...also automatically enables 3D rotation in expanded figure.
%    (Thanks to Eric LePage for the suggestion.)
% 
% NOTE: This function modifies the BUTTONDOWNFCN of axes in the input list,
%       and their children. However, it will not modify any object whose
%       buttondownfcn is nonempty. 
%
% USAGE:
% Allows you to click on any axes (or child thereof) in the list of input
% handles. LEFT-CLICKING will popup a new window in the position of the
% original, filled with the single axes and all its children. Clicking on
% that figure closes the popup window. (With the rotEnable option
% selected, you must use the red 'X' to close the new figure.)
% RIGHT-CLICKING restores non-expanding status to the axis and
% its children.) 
%
%
% EXAMPLES:
%    figure;
%    a=zeros(1,9);
%    t = 0:pi/64:4*pi;
%    for ii = 1:9
%        a(ii) = subplot(3,3,ii);
%        plot(t,ii*sin(ii*t));
%        title(sprintf('ii = %d',ii),'color','r');
%    end
%    expandAxes(a);
%
%    figure;
%    for ii = 1:9
%      a(ii) = subplot(3,3,ii);
%      surf(peaks);
%    end
%    expandAxes(a,1)
%
%   %NOTE: This example requires the Image Processing Toolbox
%    figure
%    h(1)=axes('pos',[0.1 0.1 0.3 0.3]);
%    imshow('cameraman.tif');
%    h(2)=axes('pos',[0.5 0.1 0.3 0.3]);
%    imshow('peppers.png');
%    expandaxes(h)
%
% MOTIVATION:
% In real estate, there's a saying: "Location, location, location." In
% computer graphics, the saying is (or ought to be): "Real estate, real
% estate, real estate." This function allows you to show a lot more plots,
% graphics, etc. in a single figure without sacrificing the ability to see
% larger versions of same.

% *********************
% The author is very grateful to John D'Errico for his constructive
% comments on this function prior to its posting.
% 
% Written by Brett Shoelson, PhD
% brett.shoelson@mathworks.com
% 12/18/2007
%
% Copyright 2007-2012 MathWorks, Inc.

% Modifications:
% 01/21/2008
%    1) Fix to correctly return parent figure if image axis is a child of a
%    uipanel.
%    2) Now ignores default docking status, uses that of parent.
% 02/24/2013
%    Now you can right-click on any expanded axes to export the image to
%    the base workspace!!
% 03/12/2013
%    Now requires verification before right-click canceling of expandAxes
%    capabilities.

% Opertate on current axes if no handle list is provided.
if nargin == 0
	hndls = gca;
end
if nargin < 2
    rotEnable = 0;
end
warning('off','MATLAB:gui:latexsup:UnableToInterpretTeXString');

for ii = 1:numel(hndls)
    % Ignore any handles that are not of type axes
    if strcmp(get(hndls(ii),'type'),'axes')
        % Create a structure of handles for each axes in the list
        clear hndlSet;
        % The axes itself:
        hndlSet.ax = hndls(ii);
        % The parent figure
        parType = '';
        tmp = hndls(ii);
        while ~strcmp(parType,'figure')
            tmp = get(tmp,'parent');
            parType = get(tmp,'type');
        end
        hndlSet.oldfig = tmp;
        allchildren = allchild(hndls(ii));
        % All children WITH EMPTY BUTTONDOWNFCNs
        validChildren = allchildren(cellfun(@isempty,get(allchildren,'buttondownfcn')));
        hndlSet.objectsOfInt = [hndlSet.ax;validChildren];
        % Modify buttondownfcns of all ("valid") axes and children
        set(hndlSet.objectsOfInt,'buttondownfcn',{@expandIt,hndlSet,rotEnable});
    end
end

    function expandIt(varargin)
        hndlSet = varargin{3};
        rotEnable = varargin{4};
        selType = get(gcf,'SelectionType');
        parentWindowStyle = get(gcf,'WindowStyle');
        switch selType
            % EXPAND
            case 'normal'
                new_fig = figure('numbertitle','off',...
                    'name','CLICK ON THE FIGURE TO CLOSE AND CONTINUE; RIGHT-CLICK TO SAVE IMAGE IN BASE WORKSPACE!!!...',...
                    'units',get(hndlSet.oldfig,'units'),'position',get(hndlSet.oldfig,'position'),...
                    'color',get(hndlSet.oldfig,'color'),'toolbar','figure','tag','new_fig',...
                    'colormap',get(hndlSet.oldfig,'colormap'),'menubar','none',...
                    'toolbar',get(hndlSet.oldfig,'toolbar'));
                % Ignore default docking status, use that of parent
                set(new_fig,'buttondownfcn',@figureClicked,...
                    'WindowStyle',parentWindowStyle);
                new_ax = copyobj(hndlSet.ax,new_fig);
                set(new_ax,'units','normalized','position',[0.1 0.1 0.8 0.8]);
                % Click anywhere in the new figure to close it
                set(findobj(new_fig),'buttondownfcn',@figureClicked);
                if rotEnable
                    rotate3d(new_fig);
                    set(new_fig,'name','Close by clicking the red ''X''')
                end
            case 'alt'
                % RESET
                tmp = questdlg('Disable expandAxes capabilities for this axes?','Disable Expansion?','DISABLE','Cancel','DISABLE');
                if strcmp(tmp,'DISABLE')
                    set(hndlSet.objectsOfInt,'buttondownfcn','');
                end
        end
    end

    function figureClicked(varargin)
        selType2 = get(gcf,'SelectionType');
        switch selType2
            case 'normal'
                closereq
            case 'alt'
                try
                    vn = genvarname('selectedImage',evalin('base','who'));
                    tmpimg = findall(gcf,'type','image');
                    cdat = get(tmpimg,'cdata');
                    
                    if isempty(cdat)
                        beep;
                        tmpimg = getframe(gca);
                        cdat = tmpimg.cdata;
                        fprintf('Current axes includes a non-image!\nExtracting and exporting a snapshot of your data with |GETFRAME|.\n')
                    end
                    assignin('base',vn,cdat);
                    fprintf('Selected image written as %s to base workspace!\n',vn);
                catch %#ok
                    beep
                    disp('Unable to axes data!')
                end
        end
    end

end