function printAllComparaisonReport(seg)

if isfield(seg, 'cr')
    fn = fieldnames(seg.cr);
    for i=1:numel(fn)
        printComparaisonReport(seg.cr.(fn{i}))
    end
end
