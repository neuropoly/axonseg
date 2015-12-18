


Sensitivity4 = zeros(50,1);
Specificity4 = zeros(50,1);


for i=1:30

[Rejected_axons_img, Accepted_axons_img, Classification,Sensitivity4(i,1),Specificity4(i,1)] = as_axonseg_validate(axonSeg_step1,axonSeg_segCorrected,...
    {'EquivDiameter', 'Circularity'},'linear',i);
end

figure(10);
plot(1-Specificity4,Sensitivity4);


figure(10);
plot(Sensitivity2,1-Specificity2);



Sensitivity5 = zeros(20,1);
Specificity5 = zeros(20,1);


for i=1:20

[Rejected_axons_img, Accepted_axons_img, Classification,Sensitivity5(i,1),Specificity5(i,1)] = as_axonseg_validate(axonSeg_step1,axonSeg_segCorrected,...
    {'EquivDiameter', 'Circularity'},'quadratic',i);
end

figure(10);
plot(1-Specificity5,Sensitivity5);









