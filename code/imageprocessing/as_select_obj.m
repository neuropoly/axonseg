function Obj=as_select_obj(BW)
%Obj=as_select_obj(BW)

[Label, numAxonObj]  = bwlabel(BW);

% figure, imshow(BW)
[c,r,~] = impixel;
selection=diag(Label(r,c));
Obj=Label==selection(1);