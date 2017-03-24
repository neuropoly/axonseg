

function GUI_display(nbr_of_masks, reduced, transparency, img, seg1, opt1, seg2, opt2)

% example inputs: transparency=get(handles.Transparency,'Value'), img=handles.data.img,
% seg1=handles.display.seg1, opt1=handles.display.opt1, ...
img = img(1:reduced:end,1:reduced:end,:);
seg1=seg1(1:reduced:end,1:reduced:end,:);
img = imresize(img,[size(seg1,1),size(seg1,2)]);
img = imadjust(img);

if nbr_of_masks==1
    current_display=sc(transparency*sc(seg1,opt1,seg1)+sc(img));
else
    seg2= seg2(1:reduced:end,1:reduced:end,:);
    if islogical(seg1)
    current_display=sc(transparency*sc(seg1,opt1,seg1)+transparency*sc(seg2,opt2,seg2)+sc(img));
    else
        current_display=sc(transparency*sc(double(seg1),opt1)+transparency*sc(seg2,opt2,seg2)+sc(img));
    end
end

imshow(current_display);

end


