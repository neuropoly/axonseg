function [sR,sC,S] = minimalPath_axon(nC,factx, display)
% MINIMALPATH Recherche du chemin minimum de Haut vers le bas et de
% bas vers le haut tel que décrit par Luc Vincent 1998
% [sR,sC,S] = MinimalPath(I,factx)
%                                                     
%   I     : Image d'entrï¿½e dans laquelle on doit trouver le      
%           chemin minimal                                       
%   factx : Poids de linearite [1 10]                            
%                                                                
% Programme par : Ramnada Chav                                   
% Date : 22 février 2007                                         
% Modifié le 16 novembre 2007

if nargin < 3
    display = false;
end

if nargin==1
    factx=sqrt(2);
end

mm=max(max(nC));
% load MP
% nC=ModPlage(nC,-Inf,Inf,0,1);
nC = repmat(nC,3,1);
[m,n]=size(nC);
mask=isinf(nC);
nC(mask)=0;
cPixel = nC;
% cPixel=max(nC(:))-nC;
% cPixel(mask)=inf;
vect=2:n-1;
% factx=1.5;

J1=ones(m,n).*Inf;
J1(1,:)=0;
for row=2:m
    pJ=J1(row-1,:);
%     pP=cPixel(i-1,:);
    cP=cPixel(row,:);
    cPm=cPixel(row-1,:);
%     Iq=[pP(vect-1);pP(vect);pP(vect+1)];
    VI=[cP(vect);cP(vect);cP(vect)];
    VIm=[cPm(vect);cPm(vect);cPm(vect)];
%     VI=Ip;
    VI(1,:)=VI(1,:).*factx; VIm(1,:)=VIm(1,:).*factx;
    VI(3,:)=VI(3,:).*factx; VIm(3,:)=VIm(3,:).*factx;
    Jq=[pJ(vect-1);pJ(vect);pJ(vect+1)];
   % J1(row,2:end-1)=min(Jq+abs(VI-VIm)./VI-inten*VI/mm,[],1);
    J1(row,2:end-1)=min(Jq+VI,[],1);
%     J1(i,2:end-1)=min([J1(i,2:end-1);min(Jq+VI,[],1)],[],1);
end

J2=ones(m,n).*Inf;
J2(m,:)=0;
for row=m-1:-1:1
    pJ=J2(row+1,:);
%     pP=cPixel(i+1,:);
    cP=cPixel(row,:);
    cPm=cPixel(row+1,:);
%     Iq=[pP(vect-1);pP(vect);pP(vect+1)];
    VI=[cP(vect);cP(vect);cP(vect)];
    VIm=[cPm(vect);cPm(vect);cPm(vect)];
%     VI=Ip;
    VI(1,:)=VI(1,:).*factx; VIm(1,:)=VIm(1,:).*factx;
    VI(3,:)=VI(3,:).*factx; VIm(3,:)=VIm(3,:).*factx;    
    Jq=[pJ(vect-1);pJ(vect);pJ(vect+1)];
%     J2(row,2:end-1)=min(Jq+abs(VI-VIm)./(VI+1e-5)-inten*VI/mm,[],1);
    J2(row,2:end-1)=min(Jq+VI,[],1);
%     J2(i,2:end-1)=min([J2(i,2:end-1);min(Jq+VI,[],1)],[],1);
end

S=J1+J2;
S(isnan(S))=inf;
[mv1,mi1]=min(S,[],2);

% [mv2,mi2]=min(fliplr(S),[],2);]
sR=(73:144);
sC=round(mi1(73:144));

if display
    figure(76)
    imagesc(S,[prctile(S(:),0) prctile(S(:),10)]), axis image
    figure(77)
    imagesc(nC); colormap gray, axis image
    hold on
    plot(sC,sR,'r')
end