function im_array=as_improc_blockwising(fun,img,blocksize,overlap,sparsify)
% [im_out,AxSeg,thirdDim,im_out_gratio,AxStats]=croptest(fun,img,blocksize,overlap,sparsify)
% EXAMPLE:
% array=as_improc_blockwising(@(x) x, imread('X1Y1.png'),2000,10,0);
% for i=1:length(array(:)), imagesc(array{i}); axis image; drawnow; pause; end

if ~exist('sparsify','var'), sparsify=1; end

[m, n, p]=size(img);
n_blocki=length(1:(blocksize-overlap):m);
n_blockj=length(1:(blocksize-overlap):n);

disp(['loop over blocks of ' num2str(blocksize) ' pixels (' num2str(n_blocki*n_blockj) ' blocks in total) :'])
im_array=cell(n_blockj,n_blocki);

if isdeployed && license('checkout','Distrib_Computing_Toolbox') && n_blocki*n_blockj>10
    parpool
end

for block=1:n_blocki*n_blockj
    j=1+(blocksize-overlap)*(mod(block-1,n_blockj));
    i=1+(blocksize-overlap)*(block-mod(block-1,n_blockj)-1)/n_blockj;
    
    disp(['processing block #' num2str(block) ' over ' num2str(n_blocki*n_blockj) ' blocks'])
    
    if i+blocksize>m && j+blocksize>n
        block1=i:m;
        block2=j:n;
    elseif i+blocksize>m
        block1=i:m;
        block2=j:j+blocksize;
    elseif j+blocksize>n
        block1=i:i+blocksize;
        block2=j:n;
        
    else
        block1=i:i+blocksize;
        block2=j:j+blocksize;
    end
    
    if length(block1)>30 && length(block2)>30
        imgcrop=img(block1,block2,:);
        
        im_cropProc=fun(imgcrop);
        if sparsify, im_cropProc = sparcification(im_cropProc,imgcrop); end
        im_array{block}=im_cropProc;
    end
end


im_array=im_array';
j_progress('done..')

function patch=sparcification(im_cropProc,imgcrop)
        patch.seg=sparse(im_cropProc(:));
        patch.size=size(im_cropProc);
        patch.img=imgcrop;

    
    
