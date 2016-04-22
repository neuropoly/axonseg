function [objpos,objdim] = distributeObjects(nobjects,startpos,endpos,gap,warnoff)
%[objpos, objdim] = distributeObjects(nobjects, startpos, endpos, gap, warnoff)
%
%Returns the proper positions and size for uniformly spaced GUI objects.
%
%Enter the number of objects (nobjects), the starting position (startpos),
%the end position (endpos), and the gap, and this function will return a
%vector of starting points (objpos) as well as a dimension for all
%uniformly sized, equally spaced objects (buttons, boxes, etc.).
%
%This works for horizontal OR vertical distribution of items, as long as
%startpos < endpos, and for normalized or any other kind of unit .
%
% E.g., To uniformly distributeObjects 4 buttons horizontally starting at 10
% pixels, ending at 100 pixels, and with a gap of 5 pixels, 
%     [objpos,objdim] = distributeObjects(4,10,100,5) returns
% objpos = [10.0000   33.7500   57.5000   81.2500],
% objdim = 18.7500
% Thus, your GUI buttons should be positioned at
% [objpos(1) y objdim height], [objpos(2) y objdim height],....
%
%Written by Brett Shoelson
%12/09/03
%shoelson@helix.nih.gov
%
% Copyright 2003 MathWorks, Inc.

if nargin<5
	warnoff = 0;
end

rev = 0;
if startpos > endpos
    rev = 1;
    tmp = endpos;
    endpos = startpos;
    startpos = tmp;
end
    
objdim = ((endpos-startpos)-(nobjects-1)*gap)/nobjects;
objpos = startpos:objdim+gap:endpos;
%Account for case of gap==0, which generates a starting point at the end of
%the object range. 
objpos = objpos(1:nobjects);

if rev
    objpos = objpos(end:-1:1);
end
if ~warnoff && (any(objpos < 0) || objdim < 0)
	warndlg('The parameters you entered result in a negative starting point or dimension. You may want to rethink that.');
end
