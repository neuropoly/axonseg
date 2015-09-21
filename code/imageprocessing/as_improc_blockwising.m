function im_array_sparse=as_improc_blockwising(fun,img,blocksize,overlap)
% [im_out,AxSeg,thirdDim,im_out_gratio,AxStats]=croptest(fun,img,blocksize,overlap)
%

[m, n]=size(img);
n_blocki=length(1:(blocksize-overlap):m);
n_blockj=length(1:(blocksize-overlap):n);

disp(['loop over blocks of ' num2str(blocksize) ' pixels (' num2str(n_blocki*n_blockj) ' blocks in total) :'])
im_array_sparse=cell(n_blockj,n_blocki);

if isdeployed && license('checkout','Distrib_Computing_Toolbox') && n_blocki*n_blockj>10
    parpool
end

parfor block=1:n_blocki*n_blockj
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
        im_array_sparse{block}=sparcification(im_cropProc,imgcrop);
    end
end


im_array_sparse=im_array_sparse';
j_progress('done..')

function patch=sparcification(im_cropProc,imgcrop)
        patch.seg=sparse(im_cropProc(:));
        patch.size=size(im_cropProc);
        patch.img=imgcrop;

    
    
