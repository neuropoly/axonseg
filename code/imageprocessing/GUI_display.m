

function GUI_display(nbr_of_masks, transparency, img, seg1, opt1, seg2, opt2)

% example inputs: transparency=get(handles.Transparency,'Value'), img=handles.data.img,
% seg1=handles.display.seg1, opt1=handles.display.opt1, ...

if nbr_of_masks==1
    current_display=sc(transparency*sc(seg1,opt1,seg1)+sc(img));
else
    current_display=sc(transparency*sc(seg1,opt1,seg1)+transparency*sc(seg2,opt2,seg2)+sc(img));
end

imshow(current_display);

end


