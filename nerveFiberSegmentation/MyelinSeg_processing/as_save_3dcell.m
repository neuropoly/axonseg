function [imgcell, axonseg, myelinseg]=as_save_3dcell(Axonlist, img, blocksize)
% [myelinseg, axonseg]=as_save_3dnii(Axonlist, imgsize, blocksize)
imgsize=size(img);
centroid=cat(1,Axonlist.Centroid);
xcentre=centroid(:,1);
ycentre=centroid(:,2);
count=1;
nbB=length(1:blocksize:imgsize(1))*length(1:blocksize:imgsize(2));
myelinseg=cell(nbB,1); axonseg=cell(nbB,1); imgcell=cell(nbB,1);

for i=1:blocksize:imgsize(1) 
    for j=1:blocksize:imgsize(2)
        Id=find(xcentre>i & xcentre<i+blocksize-1 & ycentre>j & ycentre<j+blocksize-1);
        list=Axonlist(Id);
        
        for k=length(list):-1:1; list(k).data(:,1)=list(k).data(:,1)-i; end
        for k=length(list):-1:1; list(k).data(:,2)=list(k).data(:,2)-j; end
        
        
        if nargout>1
            AL=as_axonlist_changeorigin(Axonlist(Id),[-(i-1) -(j-1)]);
            axonseg{count}=as_display_label( AL,[blocksize blocksize],'axonEquivDiameter','axon'); 
        end
        
        if nargout>2, myelinseg{count}=as_display_label( AL,[blocksize blocksize],'axonEquivDiameter'); end
        
        blockBW=zeros(blocksize,blocksize,'uint8');
        tmp=img(i:min(imgsize(1),i+blocksize-1),j:min(imgsize(2),j+blocksize-1));
        blockBW(1:size(tmp,1),1:size(tmp,2))=tmp;
        imgcell{count}=blockBW;
        
        count=count+1;
    end
end