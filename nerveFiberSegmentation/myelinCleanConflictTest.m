function [AxConflictArray] = myelinCleanConflictTest(myelinArray)
nObj = size(myelinArray, 3);

% allConflictBW is TRUE only in the conflict area
allConflictBW = sum(myelinArray, 3);
allConflictBW = logical((allConflictBW>1));

[m n z]=size(myelinArray);

AxConflictArray=zeros(nObj,nObj);

%% Compute all conflict values


for currentObjIdx=1:nObj

    curMyelinBW = myelinArray(:, :, currentObjIdx);

    conflictBW = (curMyelinBW & allConflictBW);
    [a b]=find(conflictBW==1);
    [x y]=size(a);
    for k=1:x
     A=find(myelinArray(a(k), b(k), :)==1);
        
     AxConflictArray(currentObjIdx,A)=AxConflictArray(currentObjIdx,A)+1;
    end
    
AxConflictArray(currentObjIdx,:)=AxConflictArray(currentObjIdx,:)/sum(sum(myelinArray(:, :, currentObjIdx)));


end

for i=1:nObj
    AxConflictArray(i,i)=0;
end
