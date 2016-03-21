function sensibility = test_axonsegfunction(axonsegfunction,list_axonslist)
% sensibility = test_axonsegfunction(@(x) axonInitialSegmentation(x,30),{'axonlist1_CAR.mat','axonlist2_CAR.mat'})



for i=1:length(list_axonslist)
load(list_axonslist{i})
bw_axonseg_GT=as_display_label(axonlist,size(img),'axonEquivDiameter','axon');
bw_axonseg = axonsegfunction(img);
for iaxon=1:length(axonlist)
    bw_axonseg(axonlist(iaxon).Centroid)==1;
end

end
