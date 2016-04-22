function rgb3=im3rgb(varargin)

%convert an image 


if size(varargin,2)==1
    im3=varargin{1};
    bw3= false(size(im3));    
    masktype='contour';
elseif size(varargin,2)==2
    im3=varargin{1};
    if isa(varargin{2},'char')
    masktype=varargin{2};
    bw3= false(size(im3));    
    else
    bw3=varargin{2};
    masktype='contour';
    end
elseif size(varargin,2)==3
    im3=varargin{1};
    bw3=varargin{2};
    masktype=varargin{3};
end 

im3=double(im3);

[x,y,z]=size(im3);

max_I=max(im3(:));
min_I=min(im3(:));
im3=(im3-min_I)./(max_I-min_I);

rgb3=zeros(x,y,z*3);

for ct=1:z
    %write channel 1 image
    rgb3(:,:,(ct-1)*3+1)=im3(:,:,ct);
    bw2=double(bw3(:,:,ct));
    
    %write channel 2 image 
    if masktype=='contour'
    bw2n=zeros(size(bw2));
    [c,r]=contour(bw2,[0 0]);
    
    NbContours=1;
    ct1=1;
    while ct1<size(c,2)
        NbPts=c(2,ct1);
        
        for ct2=1:NbPts
            cxy=c(:,(ct1+ct2));
            xx=cxy(1);
            yy=cxy(2);
            bw2n(round(yy),round(xx))=1;
        end
        
        ct1=ct1+NbPts+1;
        NbContours=NbContours+1;
    end
    rgb3(:,:,(ct-1)*3+2)=bw2n;
    
    elseif masktype=='overlay'
    rgb3(:,:,(ct-1)*3+2)=bw2;    
    end
end

 
