data = [ 1;2;3;4;3;5;6;4;3;5;10;11;13;9];
species = [ 1;1;1;1;1;1;1;1;1;1;2;2;2;2];

linclass = ClassificationDiscriminant.fit(data,species);

test = [7;15;13];

result=predict(linclass,test);

quadclass = ClassificationDiscriminant.fit(data,species,'discrimType','quadratic');
result=predict(quadclass,test);



