% support vector machine

SVMModel = fitcsvm(X,species);





[label,score] = predict(SVMModel,newX);

