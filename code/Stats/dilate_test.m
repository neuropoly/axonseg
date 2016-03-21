% dilate

img_path_1 = uigetimagefile;
img_BW_true = imread(img_path_1);
img_BW_true=im2bw(img_BW_true);

img_path_2 = uigetimagefile;
img_BW_false = imread(img_path_2);
img_BW_false=im2bw(img_BW_false);

img_path_3 = uigetimagefile;
img_gray = imread(img_path_3);

%%

se = strel('disk',1);

img_BW_dilated_true = imdilate(img_BW_true,se);
figure, imshow(imfuse(img_BW_true,img_BW_dilated_true));

img_diff_true = im2bw(img_BW_dilated_true-img_BW_true);
figure, imshow(img_diff_true);


img_BW_dilated_false = imdilate(img_BW_false,se);
figure, imshow(imfuse(img_BW_false,img_BW_dilated_false));

img_diff_false = im2bw(img_BW_dilated_false-img_BW_false);
figure, imshow(img_diff_false);



%%

[cc_initial,num1] = bwlabel(img_BW,8);
[cc_dilated,num2] = bwlabel(img_BW_dilated,8);

Intensity_boundary=zeros(num1,1);
    
    for i=1:num1        
        Gray_object_values = AxonSeg_gray(cc_initial==i);
        Intensity_boundary(i,:)=mean(Gray_object_values);
    end

Stats_struct.Intensity_mean = Intensity_boundary;





figure, imshow(cc_initial==1);





%% calculation

[cc_initial,num1] = bwlabel(img_BW,8);
se = strel('disk',2);

Intensity_mean=zeros(num1,2);
Intensity_std=zeros(num1,2);

Intensity_mean_axon=zeros(num1,2);
Intensity_std_axon=zeros(num1,2);

img_gray=im2double(img_gray);

for i=1:num1

    object_i=cc_initial==i;
    object_dilated_i=imdilate(object_i,se);
    diff_i=im2bw(object_dilated_i-object_i);
    
    Gray_object_i = img_gray(diff_i==1);
    
    Intensity_mean(i,1)=i;
    Intensity_std(i,1)=i;
    
    Intensity_mean(i,2)=mean(Gray_object_i);
    Intensity_std(i,2)=std(Gray_object_i);
    
    
    
    
    
    
    Gray_object_i_axon = img_gray(cc_initial==i);
    
    Intensity_mean_axon(i,1)=i;
    Intensity_std_axon(i,1)=i;
 
    Intensity_mean_axon(i,2)=mean(Gray_object_i_axon);
    Intensity_std_axon(i,2)=std(Gray_object_i_axon);

        
end



%% validation & stats

Contrast=zeros(num1,2);
Contrast(:,1)=Intensity_mean(:,1);
Contrast(:,2)=Intensity_mean(:,2)-Intensity_mean_axon(:,2);

Keep=Intensity_mean(Intensity_mean(:,2)>=0.7,:);

cc_copy=cc_initial;
STD_criterion=Intensity_std(:,2)<=0.2;
MEAN_criterion=Intensity_mean(:,2)>=0.25;
CONTRAST_criterion=Contrast(:,2)>=0.32;

STD_criterion_axon=Intensity_std_axon(:,2)<=0.1;
MEAN_criterion_axon=Intensity_mean_axon(:,2)<=0.3;


% STD_criterion=Intensity_std(:,2)<=0.2;
% MEAN_criterion=Intensity_mean(:,2)>=0.3;
% CONTRAST_criterion=Contrast(:,2)>=0.3;
% 
% STD_criterion_axon=Intensity_std_axon(:,2)<=0.1;
% MEAN_criterion_axon=Intensity_mean_axon(:,2)<=0.2;

% GRADIENT_criterion=


% Axons_to_keep=CONTRAST_criterion;
Axons_to_keep=STD_criterion&MEAN_criterion&CONTRAST_criterion&STD_criterion_axon&MEAN_criterion_axon;

for i=1:num1

if Axons_to_keep(i,:)==0
    cc_copy(cc_copy==i)=0;
end
        
end

result=im2bw(cc_copy);
figure, imshow(imfuse(result,img_gray));








%%


imshow(img_gray);                     % Display image
FF = fft2(img_gray);                   % Take FFT


F = fftshift(FF); % Center FFT

F = abs(F); % Get the magnitude
F = log(F+1); % Use log, for perceptual scaling, and +1 since log(0) is undefined
F = mat2gray(F); % Use mat2gray to scale the image between 0 and 1

figure, imshow(F); % Display the result







figure, imshow(FF);

IFF = ifft2(FF);                 % take IFFT
figure, imshow(IFF);

FINAL_IM = uint8(real(IFF));      % Take real part and convert back to UINT8

figure;
imshow(FINAL_IM);       % Get back original image.

















