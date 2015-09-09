function rgb = bw2rgb(bw, cmap)
if nargin < 2
	cmap = 'winter';
end

[label, n] = bwlabel(bw, 4);

switch cmap
	case 'winter'
		map = [linspace(0, 0, n)' linspace(0, 1, n)' linspace(1, 0.5, n)']; % Winter colormap
	otherwise
		map = rand(n,3);
end

rgb = label2rgb(label, map, 'k', 'shuffle');
