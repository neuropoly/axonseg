
function im_in=RemoveBorder(im_in)
MaximalMyelinLength=25;
im_in(MaximalMyelinLength:end-MaximalMyelinLength,MaximalMyelinLength:end-MaximalMyelinLength)=...
    imclearborder(im_in(MaximalMyelinLength:end-MaximalMyelinLength,MaximalMyelinLength:end-MaximalMyelinLength),8);
im_in([1:MaximalMyelinLength],:)=false;
im_in(:,[1:MaximalMyelinLength])=false;
im_in([end-MaximalMyelinLength:end],:)=false;
im_in(:,[end-MaximalMyelinLength:end])=false;