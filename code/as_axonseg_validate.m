function [Rejected_axons_img, Accepted_axons_img,classifier_final,Class_table_final,Sensitivity, Specificity, parameters,ROC_values] = as_axonseg_validate(axonSeg_step1,axonSeg_segCorrected,axonSeg_gray, parameters,type,val)
% OUTPUTS -----------------------------------------------------------------
% Rejected_axons_img (OUT) : binary image of rejected axons
% Accepted_axons_img (OUT) : binary image of accepted axons
% Class_table_final (OUT) : matrix indicating the number of axons (true &
% false) classified in each type
% INPUTS ------------------------------------------------------------------
% axonSeg_step1 (IN) : image of the initial axon segmentation (containing
% both false & true axons)
% axonSeg_segCorrected (IN) : image of the true axons only, obtained after
% manual correction with the SegmentationGUI
% parameters (IN) : cell array containing the names of the specified
% parameters (up to 9 can be chosen)
% type (IN) : string specifying the type of analysis ('linear' or
% 'quadratic')
%--------------------------------------------------------------------------
% Example : [Rejected_axons_img, Accepted_axons_img, classifier_final, Classification, Sensitivity, Specificity, parameters] = as_axonseg_validate(axonSeg_step1,axonSeg_segCorrected,{'Circularity','EquivDiameter'},'linear',0.9);

%--------------------------------------------------------------------------
% % 
% img_path_1 = uigetimagefile;
% axonSeg_step1 = imread(img_path_1);
% 
% img_path_2 = uigetimagefile;
% axonSeg_segCorrected = imread(img_path_2);

%--------------------------------------------------------------------------

% Validate both images are binary

AxonSeg_1_img = im2bw(axonSeg_step1);
AxonSeg_2_img = im2bw(axonSeg_segCorrected);

% Find removed objects (axons) from initial seg. to corrected seg.

False_axons_img = im2bw(AxonSeg_1_img-AxonSeg_2_img);
False_axons_img = bwmorph(False_axons_img,'clean');

% % False_axons_img = imfill(False_axons_img,'holes');

% False_axons_img = find_removed_axons(AxonSeg_1_img, AxonSeg_2_img);

True_axons_img = AxonSeg_2_img;
True_axons_img = bwmorph(True_axons_img,'clean');

% % True_axons_img = imfill(True_axons_img,'holes');
% % 
% % 
% % AxonSeg_1_img = imfill(AxonSeg_1_img,'holes');

% Compute stats (parameters of interest) for both groups

[Stats_1, names1] = as_stats_axons(False_axons_img,axonSeg_gray);
[Stats_2, names2] = as_stats_axons(True_axons_img,axonSeg_gray);
[Stats_3, names3] = as_stats_axons(AxonSeg_1_img,axonSeg_gray);

% Only keep parameters wanted for discrimination analysis

Stats_1_used = rmfield(Stats_1,setdiff(names1, parameters));
Stats_2_used = rmfield(Stats_2,setdiff(names2, parameters));
Stats_3_used = rmfield(Stats_3,setdiff(names3, parameters));


% Perform Discrimination Analysis once with default cost matrix

[classifier_init,~] = Discr_Analysis(Stats_1_used, Stats_2_used, [0, 1; 10, 0],type);

% Find cost needed to have more than 99% of true axons accepted

[cost,ROC_values] = find_cost(classifier_init,val);


[classifier_final,~] = Discr_Analysis(Stats_1_used, Stats_2_used, [0, 1; cost, 0],type);



Stats_3_used = table2array(struct2table(Stats_3_used));
[label,~,~] = predict(classifier_final,Stats_3_used);

% Recalculate Discrimination Analysis using the newly found cost value


% Class_table_init = confusionmat(classifier_init.Y,resubPredict(classifier_init));
Class_table_final = confusionmat(classifier_final.Y,resubPredict(classifier_final));


% probleme dans bwlabel du AxonSeg_1_img

index1=find(label==0);
Rejected_axons_img = ismember(bwlabel(AxonSeg_1_img),index1);

index2=find(label==1);
Accepted_axons_img = ismember(bwlabel(AxonSeg_1_img),index2);

% Calculate ROC stats for discriminant analysis

[ROC_stats] = ROC_calculate(Class_table_final);
Sensitivity=ROC_stats(1);
Specificity=ROC_stats(2);

% figure(1);
% subplot(221);
% imshow(Rejected_axons_img);
% title('Rejected axons');
% subplot(222);
% imshow(Accepted_axons_img);
% title('Accepted axons');
% subplot(223);
% imshow(False_axons_img);
% title('False axons');
% subplot(224);
% imshow(True_axons_img);
% title('True axons');

TP_img = Accepted_axons_img & True_axons_img;
TN_img = Rejected_axons_img & False_axons_img;
FP_img = Accepted_axons_img & False_axons_img;
FN_img = Rejected_axons_img & True_axons_img;

figure(2);
sc(sc(TP_img,[0 0.75 0],TP_img)+sc(TN_img,[0.7 0 0],TN_img)+sc(FP_img,[0.75 1 0.5],FP_img)+sc(FN_img,[1 0.5 0],FN_img));
legend('TP (dark green), TN (dark red), FP (light green) & FN (orange)');
title('DA result --> TP (dark green), TN (dark red), FP (light green) & FN (orange)');

% imshow(imfuse(imfuse(Rejected_axons_img,Accepted_axons_img),imfuse(False_axons_img,True_axons_img)));

% sc(sc(Rejected_axons_img,'r',Rejected_axons_img)+sc(Accepted_axons_img,'g',Accepted_axons_img)+sc(False_axons_img,'b',~~False_axons_img)+sc(True_axons_img,'y'));

% Plot discriminant (linear or quadratic) & classes scatters (false axons &
% true axons)

if length(parameters)==2
    figure(2);
    plot_data_DiscrAnalysis(classifier_final, Stats_1_used, Stats_2_used, parameters, type);
end


end


% Plot variables in matrix

% visualize_DiscrAnalysis(classifier_final,names3);





