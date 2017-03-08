function gRatio=as_tools_manualgRatio(im_in)
% gRatio=as_tools_manualgRatio(im_in)
% Exemple: gRatio=as_tools_manualgRatio
if exist('im_in','var'), imshow(im_in); end
h1=imline;
position=h1.getPosition;

R=sqrt(((position(2,1)-position(1,1))+(position(2,2)-position(1,2)))^2);
disp(R)
h2=imline;
position=h2.getPosition;

r=sqrt(((position(2,1)-position(1,1))+(position(2,2)-position(1,2)))^2);
disp(r)

delete(h2)
delete(h1)

gRatio=r/R;


