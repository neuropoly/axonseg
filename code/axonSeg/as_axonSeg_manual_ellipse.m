function manualBW=as_axonSeg_manual_ellipse
% manualBW=as_axonSeg_manual_ellipse
hellipse=imellipse;
wait(hellipse);
manualBW = createMask(hellipse);
hellipse.delete;
