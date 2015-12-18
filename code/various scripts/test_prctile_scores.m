



circularity_test=Stats_1.Circularity;
circularity_test(:,2)=zeros(size(Stats_1.Circularity,1),1);

circ=prctile(circularity_test(:,1),[20 40 60 80]);


for i=1:size(Stats_1.Circularity,1)


if circularity_test(i,1)<=circ(1)
    circularity_test(i,2)=1;
    
elseif circularity_test(i,1)>circ(1)&&circularity_test(i,1)<=circ(2)
    circularity_test(i,2)=2;
    
elseif circularity_test(i,1)>circ(2)&&circularity_test(i,1)<=circ(3)
    circularity_test(i,2)=3;

elseif circularity_test(i,1)>circ(3)&&circularity_test(i,1)<=circ(4)
    circularity_test(i,2)=4;
    
elseif circularity_test(i,1)>circ(4)
    circularity_test(i,2)=5;

end

end


