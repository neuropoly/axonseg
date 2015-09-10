function img=as_submatfun(fun,img,Clustersize)
% img=as_submatfun(fun,img,Clustersize)

dim=size(img);
C=mat2cell(img,[ones(1,floor(dim(1)/Clustersize))*Clustersize dim(1)-floor(dim(1)/Clustersize)*Clustersize],[ones(1,floor(dim(2)/Clustersize))*Clustersize dim(2)-floor(dim(2)/Clustersize)*Clustersize]);
for ix=1:size(C,1)
    for iy=1:size(C,2)
        C{ix,iy}=fun(C{ix,iy});
    end
end
img=cell2mat(C);