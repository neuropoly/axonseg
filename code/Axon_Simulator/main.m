% author : Tom Mingasson

close all
clear variables
clc

% addpath(genpath( '/Users/toming/Documents/AxonsPacking/Matlab Scripts Optimized' ))

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% AXONS FEATURES 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
N = 50;                                 % number of axons
varTheo = 1; Lmv = length(varTheo);     % theoretical variance of axon diameters
meanTheo = 3;                           % theoretical mean
gapAxons = 0;                           % gap between axons
ITERmax = 5000;                         % ITERmax = 25000 ok pour N = 2000 //  ITERmax = 15000 ok pour N = 1000
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


meanExp = zeros(1,Lmv);
varExp =  zeros(1,Lmv);

for k=1:Lmv
    %% Process Packing
    % parameters for axons for log normale sampling
    axons.meanTheo{k}  = meanTheo(k);
    axons.varTheo{k}   = varTheo(k);
    axons.gapTheo{k}   = gapAxons;
    axons.threshold{k} = 10;           % no diameter above 10 micro metres
    axons.nbAxons{k}   = N;
    
    % dimension of the area
    sideCoeff = 4;
    side = sideCoeff*(meanTheo(k)+gapAxons(k))*sqrt(N);
    
    % axons diameters sampling and initialization of positions
    [R,x0] = axonsSetup(axons,side,k);
    
    meanExp(1,k) = mean(R(:));
    varExp(1,k) = std(R(:))^2;
    
    % packing optimization
    x = processPacking(x0,R,gapAxons(k),side,ITERmax);
    
    % results
    packing.radii{k}                  = R;
    packing.positions{k}              = reshape(x,2,length(x)/2);
    packing.side{k}                   = side;
    packing.sideCoeff{k}              = sideCoeff;
    
    optimization.initial_positions{k} = x0;
    optimization.ITERmax{k}           = ITERmax;
    
    %% Statistics from the packing
    resolution = 2048;
    [ PHI, NUi, NUm, FR ] = statistic( R, x, side,resolution)
    
    % results
    statistics.resolution{k} = resolution;
    statistics.PHI{k}= PHI;
    statistics.NUi{k}= NUi;
    statistics.NUm{k}= NUm;
    statistics.FR{k}= FR;
    
    %% Display  
    % display the packing with results annotations for Phi and Fr
    set( figure ,'WindowStyle','docked' ); clf
    pts = reshape(x,2,length(x)/2);
    t = 0:.1:2*pi+0.1;
    for i=1:N
        title(['Diameter Mean : ',num2str(mean(R(:))),' µm    ','Diameter Variance : ',num2str(var(R(:))),' µm    ','Gap : ',num2str(gapAxons(k)),' µm    '],'FontSize',10,'FontWeight','bold');
        patch(R(i)*cos(t) + pts(1,i), R(i)*sin(t) + pts(2,i), [.5 .5 1], 'FaceAlpha', 0.4, 'EdgeColor', [.2 .2 1]);
        xlim([0 side])
        ylim([0 side])
    end
    strPHI = [ 'Phi = ',num2str(roundn(PHI,-4) )];
    strFR = [ 'Fr = ',num2str(roundn(FR,-4))];
    str = {strPHI, strFR};
    annotation('textbox', [0.2,0.2,0.15,0.06],'String',str,'FontSize',10);
    drawnow
    
    
end


% save
% save_var  = num2str(varTheo); save_var(save_var == ' ') = '';
% save_mean = num2str(meanTheo); save_mean(save_mean == ' ') = '';
% save_gap  = num2str(gapAxons); save_gap(save_gap == ' ') = '';
% saveName  = ['Axons', num2str(N), '_Mean', save_mean, '_Var', save_var, '_Gap', save_gap, '_Sim', num2str(NbSim)]
% mkdir('/Users/toming/Documents/code projet 1 - packings /Results/Data', saveName)
% 
% cd(['/Users/toming/Documents/code projet 1 - packings /Results/Data/',saveName])
% save('axons.mat', '-struct', 'axons');
% save('packing.mat', '-struct', 'packing');
% save('optimization.mat', '-struct', 'optimization');
% save('statistics.mat', '-struct', 'statistics');






