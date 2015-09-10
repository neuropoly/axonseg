function [S1_reg] =minimalpath_reg(S1, Min_gRatio ,Max_gRatio)
%[S1_reg] =minimalpath_reg(S1, Min_gRatio ,Max_gRatio)


[m,n]=size(S1);

Min_gRatio=round(Min_gRatio);
Max_gRatio=round(Max_gRatio);

for j=1:n;
    
    if ((j+Min_gRatio+Max_gRatio>=n) && (j+Min_gRatio<n))
        S1_reg(:,j)=min(S1(:,j+Min_gRatio:n),[],2);
    elseif j+Min_gRatio>=n
        S1_reg(:,j)=Inf;
    else
        S1_reg(:,j)=min(S1(:,j+Min_gRatio:j+Min_gRatio+Max_gRatio),[],2);
    end
end


end

