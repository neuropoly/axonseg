function visualize_DiscrAnalysis(classifier,var_names)

X=classifier.X;
Y=classifier.Y;

figure;
gplotmatrix(X,X,Y);
xlabel(var_names);
ylabel(var_names);
% text([.08 .24 .43 .66 .83], repmat(-.1,1,5), var_names);
% text(repmat(-.12,1,5), [.86 .62 .41 .25 .02], var_names, 'FontSize',8, 'Rotation',90);



