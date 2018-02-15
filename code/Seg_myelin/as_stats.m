function AXstat =as_stats(myelinseg,pixelSize,myelin)
% AXstat=as_stats(myelinseg,pixelSize)
if ~exist('myelin','var'), myelin=1; end


myelinseg=reshape2D(myelinseg,1);
cc = bwconncomp(myelinseg, 8);
prop =regionprops(cc, {'Area', 'FilledArea'});

% Creation of a struct var for the stats
AXstat=struct('axonEquivDiameter',0,'gRatio',0,'myelinThickness',0);


if ~isempty(prop)
    % Area gives myelin area & FilledArea gives (myelin+axon) area
    area = [[prop.Area]' [prop.FilledArea]'-[prop.Area]'];
    % Calculate myelin area by using pixel size
    if myelin
        myelinArea = single(area(:, 1).*pixelSize^2);
    end
    % Calculate axon area by using pixel size
    if myelin
        axonArea = single(area(:, 2).*pixelSize^2);
    else
        axonArea = single(area(:, 1).*pixelSize^2);
    end
    % Myelin equiv. diameter = sqrt(4*TotalArea/pi)
    if myelin
        myelinEquivDiameter = single(sqrt(4*(myelinArea + axonArea)/pi));
    end
    % Axon equiv. diameter = sqrt(4*AxonArea/pi)
    AXstat.axonEquivDiameter = single(sqrt(4*axonArea/pi));
    % Calculate gRatio
    if myelin
        AXstat.gRatio = single(AXstat.axonEquivDiameter ./ myelinEquivDiameter);
        % Myelin thickness = (MyelinDiam - AxonDiam)/2
        AXstat.myelinThickness = single((myelinEquivDiameter - AXstat.axonEquivDiameter) / 2);
    end
    
    %     if nargout>0
    %         MorphoStat.circularity=;
    %     end
end


