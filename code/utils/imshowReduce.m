function imshowReduce(img)
reduced=max(1,floor(size(img,1)/1000));
imagesc(img(1:reduced:end,1:reduced:end))
colormap gray
axis image
