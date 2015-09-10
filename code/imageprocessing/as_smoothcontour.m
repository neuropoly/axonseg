function ObjBW_smooth=as_smoothcontour(ObjBW)
dbstop if error
 [ObjBoundary,~] = bwboundaries(ObjBW,'noholes');
    ObjBoundary = ObjBoundary{1}';    
    ObjBoundary(:, end) = [];
    
    repeatFactor = 3;
    ObjBoundaryRepeat = [];
    for i=1:repeatFactor
        ObjBoundaryRepeat = [ObjBoundaryRepeat ObjBoundary];
    end
    theta = pi*(0:2*repeatFactor/((repeatFactor*length(ObjBoundary)-1)):2*repeatFactor);
    
    ObjSpline = csaps(theta,ObjBoundaryRepeat, 0.99);
    
    ObjSmooth = ppval(ObjSpline, linspace(2*pi,4*pi,100))';
    ObjSmooth = [ObjSmooth; ObjSmooth(1, :)];
    
    ObjSmoothRange = range(ObjSmooth, 1);
    if ObjSmoothRange(1) == 0 || ObjSmoothRange(2) == 0
        ObjBW_smooth=false(size(ObjBW));
    else
        ObjBW_smooth=poly2mask(ObjSmooth(:,1),ObjSmooth(:,2),size(ObjBW,2),size(ObjBW,1))';
    end
    
    