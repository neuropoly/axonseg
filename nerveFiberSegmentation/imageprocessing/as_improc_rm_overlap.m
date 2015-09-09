function img=as_improc_rm_overlap(img,blocksize,overlap)
%as_improc_rm_overlap(img,seg,blocksize)
% overlap management
img(~img)=nan;
for i=blocksize:blocksize:size(img,1)
    if i+1+overlap<size(img,1)
        img(i-overlap:i,:)=nanmean(cat(3, img(i-overlap:i,:), img(i+1:i+1+overlap,:)),3);
    end
end
for j=blocksize:blocksize:size(img,2)
    if j+1+overlap<size(img,2)
        img(:,j-overlap:j)=nanmean(cat(3, img(:,j-overlap:j), img(:,j+1:j+1+overlap)),3);
    end
end
img(isnan(img))=0;


rm=[];
for j=blocksize+1:blocksize:size(img,1)
    if j+overlap>=size(img,1)
        rm=[rm, j:size(img,1)];
    else
        rm=[rm, j:j+overlap];
    end
end
img(rm,:)=[];

rm=[];
for j=blocksize+1:blocksize:size(img,2)
    if j+overlap>=size(img,2)
        rm=[rm, j:size(img,2)];
    else
        rm=[rm, j:j+overlap];
    end
end
img(:,rm)=[];