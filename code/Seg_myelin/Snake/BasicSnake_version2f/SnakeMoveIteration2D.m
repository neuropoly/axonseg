function P=SnakeMoveIteration2D(P,Fext1,Fext2,gamma,equivDiameter,khomo,kfixinner)
% This function will calculate one iteration of contour Snake movement
%
% P=SnakeMoveIteration2D(S,P,Fext,gamma,kappa)
%
% inputs,
%   B : Internal force (smoothness) matrix
%   P : The contour points N x 2;
%   Fext : External vector field (from image)
%   gamma : Time step
%   kappa : External (image) field weight
%
% outputs,
%   P : The (moved) contour points N x 2;
%
% Function is written by D.Kroon University of Twente (July 2010)

length2=size(Fext1,2);
% Clamp contour to boundary
P(:,2)=min(max(P(:,2),1),length2);
P(:,3)=min(max(P(:,3),1),length2);

% ======================================================================
% COMPUTE FORCES
% ======================================================================
% Get image force on the contour points
Fext1=0.1*interp2(Fext1,P(:,2),P(:,1));
Fext2=0.1*interp2(Fext2,P(:,3),P(:,1));

% Interp2, can give nan's if contour close to border
Fext1(isnan(Fext1))=0;
Fext2(isnan(Fext2))=0;

% gratio regularisation
% Generate PDF field
xgratio=0:0.05:1.1;
gratio_field=diff(1./pdf('ev',xgratio,0.77,0.18)); gratio_field=[gratio_field gratio_field(end)*2];

gratio=equivDiameter./(2*(P(:,3)-P(:,2))+equivDiameter);
Fg=arrayfun(@(x) findgratioforce(x,xgratio,gratio_field), gratio);

%homogeneous thickness
meantkss=mean(P(:,3)-P(:,2));
Fh=(P(:,3)-P(:,2)-meantkss)/meantkss;

% don't move too much inner diameter
F_innerdiam=((P(:,2)-0.1*equivDiameter)/equivDiameter);


% ======================================================================
% MOVE SNAKE
% ======================================================================
Fext1=Fext1-0.01*Fg-kfixinner*F_innerdiam+khomo*Fh+0.05*[diff(P(:,2)); P(1,2)-P(end,2)]; % SNAKE N°1
Fext2=Fext2+0.01*Fg-khomo*Fh +0.05*[diff(P(:,3)); P(1,3)-P(end,3)];                     % SNAKE N°2

% Update contour positions
ssy1 = P(:,2) + gamma*Fext1;
ssy2 = max(ssy1+1,P(:,3) + gamma*Fext2);

P(:,2) = ssy1;
P(:,3) = ssy2;

% Clamp contour to boundary
P(:,2)=min(max(P(:,2),1),length2);
P(:,3)=min(max(P(:,3),1),length2);

function gForce=findgratioforce(gratio,xgratio,gratio_field)
[~,I]=min(abs(gratio-xgratio));
gForce=gratio_field(I);
