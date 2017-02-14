function axonseg_gif(image_struct, filename)


filename = 'axonseg_test.gif';

name_fields=fieldnames(image_struct);
nfields=length(name_fields);

for k = 1:nfields
    if k==1
        imwrite(image_struct.(name_fields{k}),filename,'gif','LoopCount',Inf,'DelayTime',2);
    else
        imwrite(image_struct.(name_fields{k}),filename,'gif','WriteMode','append','DelayTime',2);
    end

end
