function [J] = as_improc_cutFromRect( I , reducefactor)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
if ~exist('reducefactor','var'), reducefactor=1; end
h=getPosition(imrect)*reducefactor; h = round(h);
J=I(max(h(2),1):min(h(2)+h(4),end),max(h(1),1):min(h(1)+h(3),end),:);
end

