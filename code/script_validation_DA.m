% script_validation_DA


Comb=as_comb_parameters({'Area'}, {'Perimeter', 'EquivDiameter', 'Solidity', 'MajorAxisLength', 'MinorAxisLength','Eccentricity','ConvexArea','Orientation','Extent','FilledArea'});


img_path_1 = uigetimagefile;
initial = imread(img_path_1);

img_path_2 = uigetimagefile;
final = imread(img_path_2);

for i=1:size(Comb,1)
    
[~, Accepted_axons_img, classifier_final, Classification, ~, ~, parameters,ROC_values] = as_axonseg_validate(initial,final,Comb(i,:),type,1);

fig=figure;
as_plot_ROC_curve_DA(ROC_values);
print(fig,'ROC_curve_test','-dpng');

end






















