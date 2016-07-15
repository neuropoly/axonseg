function MyGrad = computeGrad(x, R, side, Kcenter0, Kcenter1, Krep, PowerRep)
% author : Tom Mingasson

pts = reshape(x,2,length(x)/2);
N=size(pts,2);

% center
ptsCenter = side/2-pts;
center_norm = sqrt(ptsCenter(1,:).^2+ptsCenter(2,:).^2);
center_norm2 = center_norm; center_norm2(find(~center_norm)) = 1;
GradCenter = ptsCenter./repmat(center_norm2,[2,1]);

% repulsion
P = squareform(pdist(pts','euclidean'))+eye(N); 
Rsum = (repmat(R,1,N)' + repmat(R,1,N)).*(tril(ones(N,N),-1)+triu(ones(N,N),1));
L = (Rsum./P-1); % >0 if intersection
L(isinf(L))=10;
Linter = L.*(sign(L)>0); F = floor(linspace(1,N+1,2*N+1)); F=F(1:end-1); Linter2 = Linter(:,F);
LinterSum = sum(abs(Linter2),1); LinterSum(find(~LinterSum))=1; LinterSum = repmat(LinterSum,N,1);
LinterNorm = Linter2./LinterSum;
LinterWeight = abs(LinterNorm).^(PowerRep).*sign(LinterNorm); % repulsion coefficient ~ (L/sum(|L|))^p
U = repmat(x',N,1)-repmat(pts',1,N);
GradRepulsion = U.*LinterWeight;

% MyGrad
LinterBIN1 = repmat(sum(triu(sign(L)>0),2)',2,1);  % disks that overlap
LinterBIN0 = 1 - LinterBIN1;                       % disks that NOT overlap
MyGrad = reshape(Kcenter0.*GradCenter.*LinterBIN0 + Kcenter1.*GradCenter.*LinterBIN1,1,2*N)' + Krep.*sum(GradRepulsion,1)';


end

