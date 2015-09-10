function featureA = bwFeatureAND(bwA, bwB, display)

if nargin < 3
    display = false;
end

bwA = logical(bwA);
bwB = logical(bwB);

featureA = false(size(bwA, 1), size(bwA, 2));
[labelA, nLabelA] = bwlabel(bwA);

for i=1:nLabelA
    tmp = bwB(labelA == i);
    if sum(tmp(:))
        featureA = featureA | (labelA == i);
    end
end

if display
    figure;
    sc(sc(bwA, 'g', featureA) + sc(bwB, 'r', bwB)*0.5)
end
