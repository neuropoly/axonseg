function axonseg_gif2(axonlist,img)


filename = 'axonseg_test.gif';

% initial histology sample

image_gif(:,:,:,1)=img;

bw_axonseg=as_display_label(axonlist,size(img),'axonEquivDiameter','axon'); 

for i=2:21
    
   image_gif(:,:,:,i)=sc(sc(bw_axonseg*((i-1)*0.05),'hot')+sc(img));


    
end


name_fields=fieldnames(image_gif);
nfields=length(name_fields);


for k = 1:nfields
    if k==1
        imwrite(image_gif.(name_fields{k}),filename,'gif','LoopCount',Inf,'DelayTime',1);
    else
        imwrite(image_gif.(name_fields{k}),filename,'gif','WriteMode','append','DelayTime',0.2);
    end

end
