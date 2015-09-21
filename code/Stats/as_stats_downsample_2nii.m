function [stats_downsample, statsname]=as_stats_downsample_2nii(axonlist,matrixsize,PixelSize,resolution)
% [stats_downsample, statsname]=as_stats_downsample_2nii(axonlist,matrixsize,PixelSize (in µm),resolution (in µm))
% Create a folder "stats" in current directory and generate NIFTI with the
% different statistics
%
% EXAMPLE: as_stats_downsample_2nii(axonlist,size(img),PixelSize,150)

[stats_downsample, statsname]=as_stats_downsample(axonlist,matrixsize,PixelSize,resolution);
imagesc(stats_downsample(:,:,end),[3 6])
mkdir('stats')
save_nii_v2(make_nii(permute(stats_downsample,[1 2 4 3]),[150 150 1]),'stats/stats_downsample4D.nii');
for istat=1:length(statsname)
    save_nii_v2(make_nii(permute(stats_downsample(:,:,istat),[1 2 4 3]),[150 150 1]),['stats/' num2str(istat) '_' statsname{istat}]);
end
