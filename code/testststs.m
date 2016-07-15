


% image initiale vide
img_finale=zeros(1024,1280);
img_finale=logical(img_finale);

%%

for cnt=1:size(centroids_corr_seg_img,1)
    test_point_x = round(centroids_corr_seg_img(cnt,2));
    test_point_y = round(centroids_corr_seg_img(cnt,1));
    
    if (Auto_seg_img(test_point_x,test_point_y)~=0)
        label=cc_auto(test_point_x,test_point_y);
        
    % image axone à effacer
    to_erase_i=cc_auto==label;
    
    if mean(mean(img_finale))==0
        img_finale=to_erase_i;
        
    else
    img_finale=img_finale+to_erase_i;
    img_finale=logical(img_finale);
    
    end

    end  
end

img_false_final=Auto_seg_img-img_finale;
img_false_final=logical(img_false_final);





