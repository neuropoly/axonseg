function im_out=histeq(im_in,param)
paramProcess.histeq.flag = param;
paramProcess.histeq.distribution= 'uniform';
paramProcess.histeq.clipLimit= 0.0100;
paramProcess.histeq.tilesSize= 16;



numTilesH = floor(size(im_in, 2)/paramProcess.histeq.tilesSize);
if numTilesH < 2
    numTilesH = 2;
end

numTilesV = floor(size(im_in, 1)/paramProcess.histeq.tilesSize);
if numTilesV < 2
    numTilesV = 2;
end

im_out = adapthisteq(im_in);%, 'Distribution', paramProcess.histeq.distribution, 'ClipLimit', paramProcess.histeq.clipLimit, 'NumTiles', [numTilesV numTilesH]);

