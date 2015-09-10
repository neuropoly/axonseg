%% Clean important conflicts
myelin_seg_results=as_blockwise_fun(@(x,y) myelinCleanConflict(x,y,0.5),myelin_seg_results, 1,0);
save myelin_seg_conflict myelin_seg_results;
%% Separate myelin (optional)
myelin_seg_results=as_blockwise_fun(@myelinSeperateTouchingPair,myelin_seg_results,1,0);
seg=cell2mat(cellfun(@(x) max(x.seg,[],3), myelin_seg_results,'Uniformoutput',0));
img=cell2mat(cellfun(@(x) max(x.img,[],3), myelin_seg_results,'Uniformoutput',0));

%% create list of axons
[ axonlist ] = as_myelinseg_blocks_bw2list( myelin_seg_results, PixelSize, blocksize, overlap);
img=cell2mat(cellfun(@(x) x.img, myelin_seg_results,'Uniformoutput',0));
img=as_improc_rm_overlap(img,blocksize,overlap);
%seg=as_display_labelgRatio(axonlist,PixelSize,'gRatio',size(img));
%% 3D --> 2D (sum)
seg2D=as_blockwise_fun(@(x,y) sum(x,3),myelin_seg_results,1,0);
seg=int8(cell2mat(cellfun(@(x) x.seg, seg2D,'Uniformoutput',0)));
img=cell2mat(cellfun(@(x) x.img, myelin_seg_results,'Uniformoutput',0));

%% overlap management
% blocksize=1501;
% overlap=200;
[img]=as_improc_rm_overlap(img,blocksize,overlap);

%% Display the results
resol_div=1;
transparence=0.5;
sc(sc(img(1:resol_div:end,1:resol_div:end))+transparence*sc(seg(1:resol_div:end,1:resol_div:end),'hot'))
%sc(sc(img(6000:8000,6000:8000))+transparence*sc(seg(6000:8000,6000:8000),'copper'))

%% Get pixel size
scale=10; %µm : scale of the bar that appears in your image
h=imline;
pixelsize=scale/length(find(h.createMask));
h.delete;
%% stats 3D
%Pixelsize=?
stats_results=as_blockwise_fun(@(x) as_stats(x,pixelsize),myelin_seg_results, 0,1);
gRatio=cellfun(@(x) x.seg.gRatio, stats_results,'Uniformoutput',0); 
gRatio=cell2mat(gRatio(:));




%% stats 2D
Myelin_label=as_stats(seg,pixelsize);

%% Get axon seg
axonseg=as_blockwise_fun(@as_myelinseg_to_axonseg,myelin_seg_results, 0,0);
%imshow(cell2mat(cellfun(@(x) x.seg, axonseg,'UniformOutput',0)))

%% remove wrong axons
axonseg_cleaned=as_blockwise_fun(@as_obj_remove,axonseg,1,0);

%% color gRatio

%sc(sc(img)+sc(as_display_labelgRatio( seg , pixelsize),'hot'))
% seg=as_display_labelgRatio(axonlist,0.1,'gRatio',size(img));

out=as_blockwise_fun(@(x) as_display_labelgRatio(x,pixelsize),myelin_seg_results,0,0);
seg=cell2mat(cellfun(@(x) max(x.seg,[],3), out,'Uniformoutput',0));
img=cell2mat(cellfun(@(x) max(x.img,[],3), out,'Uniformoutput',0));

imwrite(seg,'gRatio.tif');
imwrite(img,'histo.tif');
RGB = ind2rgb8(gRatio_map,hot(100));
imwrite(0.5*RGB+0.5*repmat(img,[1 1 3]),'gratio_overlay.jpg')
imwrite(0.5*RGB+0.5*repmat(img,[1 1 3]),'gratio_overlay.tif')
rsetwrite('gratio_overlay.tif','gratio_overlay.rset')
imtool('gratio_overlay.rset','DisplayRange',[30 180],'Colormap',hot(255))
%% color diameter

%sc(sc(img)+sc(as_display_labelgRatio( seg , pixelsize),'hot'))

out=as_blockwise_fun(@(x) as_display_labelgRatio(x,pixelsize),myelin_seg_results,0,0);
seg=cell2mat(cellfun(@(x) max(x.seg,[],3), out,'Uniformoutput',0));
img=cell2mat(cellfun(@(x) max(x.img,[],3), out,'Uniformoutput',0));
imwrite(seg,'diameter.tif');
%imwrite(img,'histo.tif')
RGB = ind2rgb8(axonEquivDiameter_map,hot(80));
imwrite(0.5*RGB+0.5*repmat(img,[1 1 3]),'diameter_overlay2.tif')
rsetwrite('diameter_overlay.tif','diameter_overlay.rset')
imtool('diameter_overlay.rset','DisplayRange',[30 180],'Colormap',hot(255))

%% save nice plot (high memory usage)
% imwrite(sc(sc(img)+1*sc(seg,'hot')),'gRatio.tiff')


%% Roi Stats
seg=cell2mat(cellfun(@(x) max(x.seg,[],3), myelin_seg_results,'Uniformoutput',0));
img=cell2mat(cellfun(@(x) max(x.img,[],3), myelin_seg_results,'Uniformoutput',0));
[img,seg]=as_improc_rm_overlap(img,seg,blocksize,overlap);
maskroi=as_tools_getroi(seg);
stats=as_RoiStats(seg,maskroi,pixelSize);

%% Roi Stats Axon list
Stats=as_stats_Roi(img,axonlist);

%% downsample to MRI resolution
[stats_downsample, statsname]=as_stats_downsample(axonlist,size(img),PixelSize,150);
imagesc(stats_downsample(:,:,end),[3 6])
mkdir('stats')
save_nii_v2(make_nii(permute(stats_downsample,[1 2 4 3]),[150 150 1]),'stats/stats_downsample4D.nii');
for istat=1:length(statsname)
    save_nii_v2(make_nii(permute(stats_downsample(:,:,istat),[1 2 4 3]),[150 150 1]),['stats/' statsname{istat}]);
end

%% Register
data='AxCaliber.nii.gz';
nii=load_nii(data);
stats_downsample_reg=zeros([size(nii.img,1),size(nii.img,2),nii.dims(3),size(stats_downsample,3)]);

for iz=1:nii.dims(3)
    [tform{iz},MRIref]=as_reg_histo2mri(stats_downsample(:,:,end-1),nii.img(:,:,iz));
end
save transform tform
for iz=1:nii.dims(3)
    for istat=1:size(stats_downsample,3)
        stats_downsample_reg(:,:,iz,istat)=imwarp(stats_downsample(:,:,istat),tform{iz},'outputview',MRIref);
    end
end
save_nii_v2(stats_downsample_reg,'stats_downsample_reg.nii',data);