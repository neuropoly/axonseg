function [im_out,AxStats]=as_display_label( axonlist,matrixsize,metric,displaytype, writeimg, verbose)
%[im_out,AxStats]=as_display_label(axonlist, matrixsize, metric);
%[im_out,AxStats]=as_display_label(axonlist, matrixsize, metric, displaytype, writeimg?);
% metric {'gRatio' | 'axonEquivDiameter' | 'myelinThickness' | 'axon number'}
% Units: gRatio in percents / axonEquivDiameter in  um x 10 /
% myelinThickness in um x 10
% displaytype {'axon' | 'myelin'} = 'myelin'
% writeimg {img,0} = 0
%
% EXAMPLE:
% bw_axonseg=as_display_label(axonlist,size(img),'axonEquivDiameter','axon');
% sc(sc(bw_axonseg,'hot')+sc(img))


dbstop error

% If no displaytype specified in argument, 'myelin' by default
if nargin<4; displaytype='myelin';end
% If writeimg not specified in input, false
if ~exist('writeimg','var'), writeimg=0; end
if ~exist('verbose','var'), verbose=1; end

% Init. output image
im_out=zeros(matrixsize,'uint8');

% Get number of axons contained in the axon list
Naxon=length(axonlist);

% Copy axonlist
AxStats=axonlist;

if verbose
    tic
    disp('Loop over axons...')
end
for i=Naxon:-1:1
    if ~mod(i,1000), disp(i); end
    if size(axonlist(i).data,1)>5
        index=round(axonlist(i).data);
        %     tmp=index(1)<matrixsize(:,1) | index(:,1)>matrixsize(1);
        %     index(find(tmp))=[];
        %     tmp=index(2)<matrixsize(:,2) | index(:,2)>matrixsize(2);
        %     index(find(tmp))=[];
        
        %   If 'axon' display type is specified, find axon index instead of
        %   myelin index
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
                    im_out(ind)=uint8(AxStats(i).myelinThickness(1)*10);
                case 'axon number'
                    im_out(ind)=i;
            end
            
        end
    end
end

if verbose
    disp('done')
    toc
end

if writeimg
    maxval=ceil(prctile(im_out(im_out>0),99));
    RGB = ind2rgb8(im_out,hot(maxval));
    imwrite(0.5*RGB(1:2:end,1:2:end,:)+0.5*repmat(writeimg(1:2:end,1:2:end),[1 1 3]),[metric '_0_' num2str(maxval) '.jpg'])
end