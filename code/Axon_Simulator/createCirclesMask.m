function mask = createCirclesMask(varargin)
% Create a binary mask from circle centers and radii

centers = varargin{1};
radi = varargin{2};
side = varargin{3};
M = varargin{4};

xc = centers(:,1);
yc = centers(:,2);

[xx,yy] = meshgrid(1:M,1:M);

mask = false(M,M);
for i = 1:numel(radi)
	mask = mask | hypot(xx - xc(i)*M/side, yy - yc(i)*M/side) <= radi(i)*M/side;
end

