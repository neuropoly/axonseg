function  img_array=as_blockwise_fun(fun,img_array,im_input, verbose)
% st=as_blockwise_fun(fun,img_array,im_input,verbose?)
dbstop if error
sparcity=issparse(img_array{1,1}.seg); % for sparse 3D blocks
disp('Loop over blocks.')
nb=size(img_array,1)*size(img_array,2);
tic
for i=1:nb
    disp(['Process block #' num2str(i) ' over ' num2str(nb)]);
        if issparse(img_array{i}.seg) % for sparse 3D blocks
            seg=as_improc_reshape_patch(img_array{i});
        else % for 2D segmentation blocks
            seg=img_array{i}.seg;
        end
        if verbose
            imshow(sum(seg,3)); drawnow;
        end
        %        if ~isempty(seg)
        if im_input
            seg=fun(seg,img_array{i}.img);
        else
            seg=fun(seg);
        end
        img_array{i}.size=size(seg);
        if sparcity && islogical(seg),
            img_array{i}.seg=sparse(seg(:));
        else img_array{i}.seg=seg;
        end
        %        end
end
toc
disp('Done.')