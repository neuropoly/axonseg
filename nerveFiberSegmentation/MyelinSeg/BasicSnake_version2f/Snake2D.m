function [P,J]=as_doubleSnake(I1,I2,P,equivDiameter,Options)
% This function SNAKE implements the basic snake segmentation. A snake is an 
% active (moving) contour, in which the points are attracted by edges and
% other boundaries. To keep the contour smooth, an membrame and thin plate
% energy is used as regularization.
%
% [O,J]=Snake2D(I,P,Options)
%  
% inputs,
%   I : An Image of type double preferable ranged [0..1]
%   P : List with coordinates descriping the rough contour N x 2
%   Options : A struct with all snake options
%   
% outputs,
%   O : List with coordinates of the final contour M x 2
%   J : Binary image with the segmented region
%
% options (general),
%  Option.Verbose : If true show important images, default false
%  Options.nPoints : Number of contour points, default 100
%  Options.Gamma : Time step, default 1
%  Options.Iterations : Number of iterations, default 100
%
% options (Image Edge Energy / Image force))
%  Options.Sigma1 : Sigma used to calculate image derivatives, default 10
%  Options.Wline : Attraction to lines, if negative to black lines otherwise white
%                    lines , default 0.04
%  Options.Wedge : Attraction to edges, default 2.0
%  Options.Wterm : Attraction to terminations of lines (end points) and
%                    corners, default 0.01
%  Options.Sigma2 : Sigma used to calculate the gradient of the edge energy
%                    image (which gives the image force), default 20
%
% options (Gradient Vector Flow)
%  Options.Mu : Trade of between real edge vectors, and noise vectors,
%                default 0.2. (Warning setting this to high >0.5 gives
%                an instable Vector Flow)
%  Options.GIterations : Number of GVF iterations, default 0
%  Options.Sigma3 : Sigma used to calculate the laplacian in GVF, default 1.0
%
% options (Snake)
%  Options.Alpha : Membrame energy  (first order), default 0.2
%  Options.Beta : Thin plate energy (second order), default 0.2
%  Options.Delta : Baloon force, default 0.1
%  Options.Kappa : Weight of external image force, default 2
%
%
% Literature:
%   - Michael Kass, Andrew Witkin and Demetri TerzoPoulos "Snakes : Active
%       Contour Models", 1987
%   - Jim Ivins amd John Porrill, "Everything you always wanted to know
%       about snakes (but wer afraid to ask)
%   - Chenyang Xu and Jerry L. Prince, "Gradient Vector Flow: A New
%       external force for Snakes
%
% Example, Basic:
%
%  % Read an image
%   I = imread('testimage.png');
%  % Convert the image to double data type
%   I = im2double(I); 
%  % Show the image and select some points with the mouse (at least 4)
%  %figure, imshow(I); [y,x] = getpts;
%   y=[182 233 251 205 169];
%   x=[163 166 207 248 210];
%  % Make an array with the clicked coordinates
%   P=[x(:) y(:)];
%  % Start Snake Process
%   Options=struct;
%   Options.Verbose=true;
%   Options.Iterations=300;
%   [O,J]=Snake2D(I,P,Options);
%  % Show the result
%   Irgb(:,:,1)=I;
%   Irgb(:,:,2)=I;
%   Irgb(:,:,3)=J;
%   figure, imshow(Irgb,[]); 
%   hold on; plot([O(:,2);O(1,2)],[O(:,1);O(1,1)]);
%  
% Example, GVF:
%   I=im2double(imread('testimage2.png'));
%   x=[96 51 98 202 272 280 182];
%   y=[63 147 242 262 211 97 59];
%   P=[x(:) y(:)];
%   Options=struct;
%   Options.Verbose=true;
%   Options.Iterations=400;
%   Options.Wedge=2;
%   Options.Wline=0;
%   Options.Wterm=0;
%   Options.Kappa=4;
%   Options.Sigma1=8;
%   Options.Sigma2=8;
%   Options.Alpha=0.1;
%   Options.Beta=0.1;
%   Options.Mu=0.2;
%   Options.Delta=-0.1;
%   Options.GIterations=600;
%   [O,J]=Snake2D(I,P,Options);
%   
% Function is written by D.Kroon University of Twente (July 2010)
% ======================================================================
% Process inputs
% ======================================================================
defaultoptions=struct('Verbose',false,'nPoints',100,'Wline',0.04,'Wedge',2,'Wterm',0.01,'Sigma1',10,'Sigma2',20,'Alpha',0.2,'Beta',0.2,'Delta',0.1,'Gamma',1,'Kappa',2,'Iterations',100,'GIterations',0,'Mu',0.2,'Sigma3',1,'khomo',0.5,'kfixinner',0.01);
if(~exist('Options','var')), 
    Options=defaultoptions; 
else
    tags = fieldnames(defaultoptions);
    for i=1:length(tags)
         if(~isfield(Options,tags{i})), Options.(tags{i})=defaultoptions.(tags{i}); end
    end
    if(length(tags)~=length(fieldnames(Options))), 
        warning('snake:unknownoption','unknown options found');
    end
end

% Convert input to double
I1 = double(I1);
I2 = double(I2);

% If color image convert to grayscale
if(size(I1,3)==3), I1=rgb2gray(I1); end
if(size(I2,3)==3), I2=rgb2gray(I2); end

% The contour must always be clockwise (because of the balloon force)
% P=MakeContourClockwise2D(P);
% 
% % Make an uniform sampled contour description
% P=InterpolateContourPoints2D(P,Options.nPoints);

% ======================================================================
% COMPUTE GRADIENT OF IMAGE
% ======================================================================
% Transform the Image into an External Energy Image
Eext1=-ImageDerivatives2D(I1,Options.Sigma1,'y');
Eext2=-ImageDerivatives2D(I2,Options.Sigma1,'y');

%normalize
Eext1=Eext1/max(max(Eext1));
Eext2=Eext2/max(max(Eext2));

% Make the external force (flow) field.
% Fy1=ImageDerivatives2D(Eext1,Options.Sigma2,'y');
% Fy2=ImageDerivatives2D(Eext2,Options.Sigma2,'y');

% Fext1=-Fy1*2*Options.Sigma2^2;
% Fext2=-Fy2*2*Options.Sigma2^2;

% Do Gradient vector flow, optimalization
% Fext1=GVFOptimizeImageForces2D(Fext1, Options.Mu, Options.GIterations, Options.Sigma3);
% Fext2=GVFOptimizeImageForces2D(Fext2, Options.Mu, Options.GIterations, Options.Sigma3);

% ======================================================================
% DISPLAY
% ======================================================================
% Show the image, contour and force field
if(Options.Verbose)
    h=figure(55); set(h,'render','opengl')
    hold off
     subplot(1,3,1), 
     resol=4;
      [x,y]=ndgrid(1:resol:size(Eext1,1),1:resol:size(Eext1,2));
      imshow(I1), hold on; quiver(y,x,Eext1(1:resol:end,1:resol:end),zeros(size(Eext1(1:resol:end,1:resol:end))));
      title('The external force field ')
      
          subplot(1,3,2), 
     resol=4;
      [x,y]=ndgrid(1:resol:size(Eext2,1),1:resol:size(Eext2,2));
      imshow(I1), hold on; quiver(y,x,Eext2(1:resol:end,1:resol:end),zeros(size(Eext2(1:resol:end,1:resol:end))));
      title('The external force field ')

     subplot(1,3,3), 
      imshow(I1), hold on; plot(P(:,2),P(:,1),'b'); 
      title('Snake movement ')
    drawnow
end


% ======================================================================
% MOVE SNAKE
% ======================================================================
% Make the interal force matrix, which constrains the moving points to a
% smooth contour
h=[];
g=[];
for i=1:Options.Iterations
     % Show current contour
    if(Options.Verbose)
        figure(44)
        hold on
        if(ishandle(h)), delete(h), end
        if(ishandle(g)), delete(g), end
        h=plot(P(:,2),P(:,1),'r'); drawnow
        g=plot(P(:,3),P(:,1),'g'); drawnow
        if i==1
            pause(0.5)
        end

%         c=i/Options.Iterations;
%         plot([P(:,2);P(1,2)],[P(:,1);P(1,1)],'-','Color',[c 1-c 0]);  drawnow
    end
    % ======================================================================
    % CORE OF THE CODE
    % ======================================================================
    P=SnakeMoveIteration2D(P,Eext1,Eext2,Options.Gamma,equivDiameter,Options.khomo,Options.kfixinner);
    % ======================================================================
    % ======================================================================

end

% ======================================================================
% DONE
% ======================================================================
if(nargout>1)
     J=DrawSegmentedArea2D(P,size(I));
end

