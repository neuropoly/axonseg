% script --> launch after loading myelin_sg_results
[imgcell, axonseg]=as_save_3dcell(axonlist, img, 500);
mkdir axons
cd axons

for ia=1:length(axonseg)
    if ~exist([num2str(ia) '_axonseg.nii.gz'],'file') && ~isempty(find(axonseg{ia}))
    save_nii_v2(make_nii(axonseg{ia}),[num2str(ia) '_axonseg.nii.gz'])
    save_nii_v2(make_nii(imgcell{ia}),[num2str(ia) '_imgcell.nii.gz'])
    end
end

a=dir('*axon*');
[~,index]=sort_nat({a.name});
a=a(index);
fsize=cat(1,a.bytes);
lid=find(fsize<2000);
for i=1:length(lid), unix(['rm ' num2str(lid(i)) '_*']); end