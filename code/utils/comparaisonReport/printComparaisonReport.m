function printComparaisonReport(cr)
%% Segmentation report
disp('');
fprintf('Segmentation report: \n')
fprintf('   Sensitivity: %0.2f (%i/%i)\n', cr.sensitivity, cr.numObjTruePos, cr.numObjTruth);
fprintf('   Precision: %0.2f (%i/%i)\n', cr.precision, cr.numObjTruePos, cr.numObjSeg);
fprintf('      Found %i objects: %i true positive (green) and %i false positive (red).\n', cr.numObjSeg, cr.numObjTruePos, cr.numObjFalsePos);
fprintf('      Missed %i objects (blue) out of %i.\n', cr.numObjMissed, cr.numObjTruth);
end