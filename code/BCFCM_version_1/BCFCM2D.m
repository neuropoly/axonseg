function [B,U]=BCFCM2D(Y,v,Options)
% This function BCFCM2D, segments (clusters) an image in object classes,
% and estimates the slow varying illumination artifact (bias field).
%
% It's an implementation of the paper of M.N. Ahmed et. al. "A Modified Fuzzy 
% C-Means Algorithm for Bias Field estimation and Segmentation of MRI Data"
% 20002, IEEE Transactions on medical imaging.
%
% [B,U]=BCFCM2D(Y,v,Options)
%
% Inputs,
%   Y : The 2D input image greyscale or color, of type double
%   v : Class prototypes. A vector with approximations of the greyscale
%       means of all image classes. It is also possible to set values
%       further away from the mean to allow better class separation.
%   Options : A struct with options
%   Options.epsilon : The function stops if difference between class means
%                   of two itterations is smaller than epsilon
%   Options.alpha : Scales the effect of neighbours, must be large if 
%                   it is a noisy image, default 1.
%   Options.maxit : Maximum number of function itterations
%   Options.sigma : Sigma of Gaussian smoothing of the bias field (slow
%                   varying non uniform illumination in CT or MRI scan).
%   Options.p : Norm constant FCM objective function, must be larger than one
%               defaults to 2.
% Outputs,
%   B : The estimated bias field
%   U : Fuzzy Partition matrix (Class membership)
%
% Example, "Bias Field" 
%
%  % Compile the c-code
%    mex BCFCM2D.c -v;
%  % Load test image
%    Y=im2double(imread('test_biasfield_noise.png'));
%  % Class prototypes (means)
%    v = [0.42;0.56;0.64];
%  % Do the fuzzy clustering
%    [B,U]=BCFCM2D(Y,v,struct('maxit',5,'epsilon',1e-5));
%  % Show results
%    figure, 
%    subplot(2,2,1), imshow(Y), title('input image');
%    subplot(2,2,2), imshow(U), title('Partition matrix');
%    subplot(2,2,3), imshow(B,[]), title('Estimated biasfield');
%    subplot(2,2,4), imshow(Y-B), title('Corrected image');
%
% Example, "Color Correction" 
%
%  % Compile the c-code
%    mex BCFCM2D.c -v;
%  % Load test image
%    Y=im2double(imread('flower.png'));
%    v = [ -0.2 -0.2 -0.2; % black;
%          0.39 0.23 0.70; % purple
%          0.98 0.63 0.03]; % yellow
%  % Do the fuzzy clustering
%    [B,U]=BCFCM2D(Y,v);
%  % Show results
%    figure, 
%    subplot(2,3,1), imshow(Y), title('input image');
%    subplot(2,3,2), imshow(U), title('Partition matrix');
%    subplot(2,3,3), imshow(B,[]), title('Estimated biasfield');
%    subplot(2,3,4), imshow(Y-B), title('Corrected image');
%    subplot(2,3,5), imshow(Y-repmat(mean(B,3),[1 1 3])), title('Only illumination');
%
% Example, "Color Correction"
%
% Function is written by D.Kroon University of Twente (November 2009)

% Process inputs
defaultoptions=struct('p',2,'alpha',1,'epsilon',0.01,'sigma',2,'maxit',10);
if(~exist('Options','var')),
    Options=defaultoptions;
else
    tags = fieldnames(defaultoptions);
    for i=1:length(tags)
        if(~isfield(Options,tags{i})),  Options.(tags{i})=defaultoptions.(tags{i}); end
    end
    if(length(tags)~=length(fieldnames(Options))),
        warning('BCFCM2D:unknownoption','unknown options found');
    end
end

% Step 1, intialization
if(~isa(Y,'double'))
     error('BCFCM2D:typecheck','Input image must be double');
end

% Constant in FCM objective function , must be larger than 1
p = Options.p;

% Effect of neighbors
alpha = Options.alpha;

% Store input image dimensions
imagesize=size(Y); if(length(imagesize)==2), imagesize(3)=1; end;

% Convert image to long array
Y=reshape(Y,[size(Y,1)*size(Y,2) size(Y,3)]);

% Stop if difference between current and previous class prototypes 
% is smaller than epsilon
epsilon = Options.epsilon;

% Bias field Gaussian smoothing sigma
sigma= Options.sigma;

% Maximun number of iterations
maxit = Options.maxit;

% Previous class prototypes (means)
v_old=zeros(size(v));
    
% Number of classes
c=length(v);

% Bias field estimate
B = ones(size(Y))*1e-4;

% Number of pixels
N=size(Y,1);

% Partition matrix
U = zeros([c N]);
Up = zeros([c N]);

% Distance to clusters
D = zeros(1,c);

% Neighbour coordinates of a pixel
Ne=[-1 -1; -1  0; -1  1; 0 -1;  0  1; 1 -1;  1  0;  1  1];

% Number of neighbours
Nr =8;

% Neighbour class influence
Gamma = zeros(1,c);

itt=0;
while((sum(sum((v-v_old).^2))>=epsilon)&&(itt<=maxit)), itt=itt+1;
    disp(['itteration ' num2str(itt)]);
    
    % Cluster update storage
    nom=zeros(c,imagesize(3)); den=zeros(c);
    
    % Loop through all pixels
    for k=1:N
        % Get neighbour pixel indices
        [x,y] = ind2sub(imagesize(1:2),k);
        x=min(max(x,2),imagesize(1)-1); y=min(max(y,2),imagesize(2)-1);
        Nx=repmat(x,[Nr 1])+Ne(:,1); Ny=repmat(y,[Nr 1])+Ne(:,2);
        Nind = sub2ind(imagesize(1:2),Nx,Ny);
        
        % Calculate distance to class means for each (bias corrected) pixel and neighbours
        for i=1:c
            Gamma(i)=sum(sum((Y(Nind,:)-B(Nind,:)-repmat(v(i,:),Nr,1)).^2));
            D(i) = sum( (Y(k,:)-B(k,:)-v(i,:)).^2 );
        end
        
        % step 3a, update the prototypes (means) of the clusters
        s = (Y(k,:)-B(k,:)) + (alpha / Nr)*sum(Y(Nind,:)-B(Nind,:));
        
        % step 2, Calculate robust partition matrix
        for i=1:c
            dent=0;
            a = D(i) + (alpha /Nr) * Gamma(i);
            for j=1:c
                b = D(j) + (alpha /Nr) * Gamma(j);
                if(abs(b)<eps), b=eps; end
                dent = dent + (a/b)^(1/(p-1));
            end
            if(abs(dent)<eps), dent=eps; end
            U(i,k) = 1 / dent; Up(i,k) = U(i,k).^p;
        
            % step 3b, update the prototypes (means) of the clusters
            nom(i,:)=nom(i,:)+Up(i,k)*s;
            den(i)=den(i)+Up(i,k);
        end
    end
 

    % Step 3c, update the prototypes (means) of the clusters
    v_old=v;
    for i=1:c
        if(abs(den(i))<eps), den(i)=eps; end
        v(i,:)=nom(i,:)/((1+alpha)*den(i));
    end

    % step 4, Estimate the (new) Bias-Field
    for k=1:N
        nomt=sum(repmat(Up(:,k),1,imagesize(3)).*v);
        dent=sum(Up(:,k));
        if(abs(dent)<eps), dent=eps; end
        B(k,:)=Y(k,:) - nomt/dent;
    end
     
    % Low-pass filter Bias-Field, as regularization
    B=imgaussian(reshape(B,imagesize),sigma); B=reshape(B,size(Y));

end

% Reshape Partition table to image
U=shiftdim(U,1);
U=squeeze(reshape(U,[imagesize(1:2) c]));

% Reshape bias field to image
B=reshape(B,imagesize);







