function [posns, vals] = cellfind(z)
%[POSNS, VALS] = CELLFIND(Z) evaluates cell array Z and returns the positions and values of nonempty elements.

% Written by Brett Shoelson, PhD
% brett.shoelson@mathworks.com
% Copyright 2010-2013 The Mathworks Inc

if nargout == 0 | nargout == 1
	posns=[];
elseif nargout == 2
	posns=[];
	vals=[];
end

if ~strcmp(class(z),'cell')
   error('cellfind.m message: Option is valid only for cell arrays. Use ''find'' for non-cell arrays.');
end

nonzeros=cellfun('prodofsize',z)/2;
posns=find(nonzeros);
number_nonzero_elements=length(posns);
sum_of_lengths=sum(sum(nonzeros));
contval=questdlg('Compile matrix of nonzero elements? (This may take a few minutes.)','Compile Elements?','Continue','NO','NO');
if strcmp(contval,'Continue')
	h = waitbar(0,'Compiling nonempty elements....');
	x=1;
	y=length(posns);
	for i=x:y
		waitbar((i-x)/(y-x));          
		vals=[vals;z{posns(i)}];
	end
	close(h);
end