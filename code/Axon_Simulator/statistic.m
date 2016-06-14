function [ PHI, NUi, NUm, FR] = statistic( R, x, side, resolution)
% stat evaluate from the results of the simulation :
%       - PHI : the extra-axonal density
%       - NUi : the intra-axonal density
%       - NUm : the myelin density
%       - FR  : the fraction restricted


N = length(R);
pts = reshape(x,2,length(x)/2);
Ls = sqrt(sum(pi*R.^2));

% masks
mask = createCirclesMask(pts',R,side,resolution); mask=double(mask);

Xmin = round((mean(pts(1,:))-2 * Ls/5) * resolution/side); 
Xmax = round((mean(pts(1,:))+2*Ls/5)*resolution/side);
Ymin = round((mean(pts(2,:))-Ls/3)*resolution/side); 
Ymax = round((mean(pts(2,:))+Ls/3)*resolution/side);
mask_trunc = mask(Xmin:Xmax,Ymin:Ymax);

% display masks
% figure 
% subplot(211); imagesc(mask)
% title(['Moyenne des diamètres axonal : ',num2str(mean(R(:))),' (variance = 1)'],'FontSize',20,'FontWeight','bold');
% subplot(212); imagesc(mask_trunc)


% stats
g = 0.72;

% PHI
Lx = Xmax-Xmin;
Ly = Ymax-Ymin;
PHI = length(find(mask_trunc==1))/(Lx*Ly);

% NUi
NUi = g^2*PHI;

% NUm
NUm = (1-g^2)/g^2*NUi;

% FR
FR = NUi/(NUi+(1-PHI));

end

