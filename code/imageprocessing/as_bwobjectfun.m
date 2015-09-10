function BWout=as_bwobjectfun(fun,BW)
% BWout=as_bwobjectfun(function,BW)
% BWout=as_bwobjectfun(@as_smoothcontour,segBW);
[BWLabel, numLabel]  = bwlabel(BW); 

BWout = false(size(BW, 1),size(BW, 2));

j_progress('loop over axons...')
for currentLabel = 1:numLabel
    j_progress(currentLabel/numLabel)
    currentObjBW = (BWLabel == currentLabel);
    currentObjBWout = fun(currentObjBW);
    BWout = BWout | currentObjBWout;
end
j_progress('elapsed')
