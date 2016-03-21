function Img_corrected=as_make_convex(BW)
% Selects an object in a binary image & converts it to a convex object by
% eliminating any concave region.

CH_total = bwconvhull(BW, 'objects', 8);

[Label, ~]  = bwlabel(CH_total);

figure;
imshow(BW);
[c,r,~] = impixel;

rm=diag(Label(r,c));
CH_others=~ismember(Label,[0;rm]);

CH_object=CH_total-CH_others;
Img_corrected=BW+CH_object;















