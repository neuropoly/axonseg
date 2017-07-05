function as_stitch_CorrectOutliers(configFileName,Dim_mosaic)
% as_stitch_CorrectOutliers(configFileName,Dim_mosaic)
% EXAMPLE: as_stitch_CorrectOutliers('TileConfiguration.registered.txt',[14 19])
[fname,ColPos,RowPos] = as_stitch_LoadTileConfiguration(configFileName);
N=Dim_mosaic;

plot(RowPos,ColPos,'+');

%% SORT
[fname,index] = sort_nat(fname);
RowPos=RowPos(index);
ColPos=ColPos(index);

%% Create A
[y,x]=meshgrid(1:N(2),1:N(1));
A=[x(:) y(:) ones(N(1)*N(2),1)];

%% Create Weighting matrix W
h=window(@tukeywin,N(1),.4);
hr=repmat(h,[1 N(2)]);
h=window(@tukeywin,N(2),.4);
hc=repmat(h',[N(1) 1]);
%imagesc(hc.*hr)
W=hc.*hr;


%% Find Coefficients
X= inv(A'*A) * A' * RowPos;

X2= inv(A'*A) * A' * ColPos   ;


%% Apply Weighting W

A_w= diag(W(:))*A;
RowPos_w= diag(W(:))*RowPos;
ColPos_w= diag(W(:))*ColPos;

%% Find coefficients using weighted least square method

Xw= inv(A_w'*A_w) * A_w' * RowPos_w;
X2w= inv(A_w'*A_w) * A_w' * ColPos_w;
RowPos_LS=A*Xw;
ColPos_LS=A*X2w;

%% detect outliers
errorRows = RowPos_LS-RowPos;
MAD = median(abs(errorRows-median(errorRows)));
outliers = errorRows<(median(errorRows)-3*MAD) | errorRows>(median(errorRows)+3*MAD);

errorCol = ColPos_LS-ColPos;
MAD = median(abs(errorCol-median(errorCol)));
outliers = outliers | errorCol<(median(errorCol)-3*MAD) | errorCol>(median(errorCol)+3*MAD);

N_outliers = sum(outliers)

%% Find coefficients without outliers
 Xw= inv(A_w'*A_w) * A_w' * RowPos_w;
X2w= inv(A_w'*A_w) * A_w' * ColPos_w;
RowPos_LS=A*Xw;
ColPos_LS=A*X2w;

W_no= W(~outliers);
A_no= diag(W_no)* A(~outliers,:);
RowPos_no= diag(W_no)* RowPos(~outliers);
ColPos_no= diag(W_no)* ColPos(~outliers);

X_no= inv(A_no'*A_no) * A_no' * RowPos_no;
X2_no= inv(A_no'*A_no) * A_no' * ColPos_no;

RowPos_LS=A*X_no;
ColPos_LS=A*X2_no;

%% Correct outliers
RowPos_cor=RowPos;
RowPos_cor(outliers)=RowPos_LS(outliers);

ColPos_cor=ColPos;
ColPos_cor(outliers)=ColPos_LS(outliers);


   
%% Diplay Results
plot(ColPos_cor,RowPos_cor,'gx','LineWidth',3)

hold on
plot(ColPos,RowPos,'bx','LineWidth',2,'MarkerSize',10)

hold on
plot(ColPos(outliers),RowPos(outliers),'r.','LineWidth',5)
hold off
axis equal
legend({'New Position','Initial Position','Outliers'})

as_stitch_WriteTileConfiguration(fname,ColPos_cor,RowPos_cor)
