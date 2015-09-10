function [im_out,AxStats]=as_display_label( axonlist,matrixsize,metric,displaytype)
%[im_out,AxStats]=labelgRatio(axonlist, matrixsize, metric, displaytype)
% metric = 'gRatio' | 'axonEquivDiameter' | 'myelinThickness' | 'axon number'
% displaytype = 'axon' | 'myelin'
%
% EXAMPLE:
% bw_axonseg=as_display_label(axonlist,size(img),'axonEquivDiameter','axon');
% sc(sc(bw_axonseg,'hot')+sc(img))
dbstop error 
if nargin<4; displaytype='myelin';end

im_out=zeros(matrixsize,'uint8');


Naxon=length(axonlist);
AxStats=axonlist;

tic
disp('Loop over axons...')
for i=Naxon:-1:1
    if ~mod(i,1000), disp(i); end
    index=axonlist(i).data; 
%     tmp=index(1)<matrixsize(:,1) | index(:,1)>matrixsize(1);
%     index(find(tmp))=[];
%     tmp=index(2)<matrixsize(:,2) | index(:,2)>matrixsize(2);
%     index(find(tmp))=[];
%     
    if strcmp(displaytype,'axon')
            index=as_myelin2axon(max(1,index));
    end
    ind=sub2ind(matrixsize,min(matrixsize(1),max(1,index(:,1))),min(matrixsize(2),max(1,index(:,2))));
    if ~isempty(AxStats(i))
        switch metric
            case 'gRatio'
                im_out(ind)=uint8(AxStats(i).gRatio(1)*100);
            case 'axonEquivDiameter'
                im_out(ind)=uint8(AxStats(i).axonEquivDiameter(1)*10);
            case 'myelinThickness'
                im_out(ind)=uint8(AxStats(i).myelnThickness(1)*10);
            case 'axon number'
                im_out(ind)=i;
        end
        
    end
end
disp('done')
toc
