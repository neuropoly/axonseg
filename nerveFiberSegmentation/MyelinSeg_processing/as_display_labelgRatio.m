function [im_out,AxStats]=as_display_labelgRatio( im , pixelsize,metric,matrixsize)
%[im_out,AxStats]=labelgRatio(im_in, pixelsize, metric)
% metric = 'gRatio' | 'axonEquivDiameter' | 'myelnThickness'

if isstruct(im)
    im_out=zeros(matrixsize,'uint8');
else
    im_out=zeros(size(im,1), size(im,2));
end

if sum(size(im)>1)==3
    Naxon=size(im,3);
    AxStats=as_stats(im,pixelsize);
elseif sum(size(im)>1)==2
    im=bwlabel(im);
    Naxon=max(max(im));
elseif isstruct(im)
    Naxon=length(im);
    AxStats=im;
end

tic
disp('Loop over axons...')
for i=Naxon:-1:1
    if ~mod(i,1000), disp(i); end
    if isstruct(im)
        index=im(i).data; ind=sub2ind(matrixsize,index(:,1),index(:,2));
    elseif sum(size(im)>1)==3
        ind=find(im(:,:,i));
    elseif sum(size(im)>1)==2
        bw=im==i;
        AxStats(i)=as_stats(bw,pixelsize);
        ind=find(bw);
    end
    
    if ~isempty(AxStats(i))
        switch metric
            case 'gRatio'
                im_out(ind)=uint8(AxStats(i).gRatio(1)*100);
            case 'axonEquivDiameter'
                im_out(ind)=uint8(AxStats(i).axonEquivDiameter(1)*10);
            case 'myelnThickness'
                im_out(ind)=uint8(AxStats(i).myelnThickness(1)*10);
        end
        
    end
end
disp('done')
toc
    
    