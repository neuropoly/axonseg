
if nargin==2

    AxonSeg_gray=im2double(AxonSeg_gray);

    Intensity_means=zeros(num,1);
    Intensity_std=zeros(num,1);
    
    for i=1:num        
        Gray_object_values = AxonSeg_gray(cc==i);
        Intensity_means(i,:)=mean(Gray_object_values);
        Intensity_std(i,:)=std(Gray_object_values); 
    end

    Stats_struct.Intensity_mean = Intensity_means;
    Stats_struct.Intensity_std = Intensity_std;

end

% Stats_struct.PerimFraction = (Perimeter_ConvexHull-Perimeter)./Perimeter;

% Get the parameters names for future use
var_names = fieldnames(Stats_struct);

end