function  [R,x0] = axonsSetup(axons,side,k)
% author : Tom Mingasson
% axonsSetup creates a randomly generated axon distribution.

% Radii distribution under a log-normale law
R = samplingHastingsMetropolis(axons,k);

% Random positions on a grid for the N axons
N = axons.nbAxons{k};
sqrt_N = round(sqrt(N))+1;

[Xgrid Ygrid] = meshgrid(0:side/sqrt_N:side,0:side/sqrt_N:side);
Xgrid =Xgrid(:);
Ygrid =Ygrid(:);

Permutations = randperm(sqrt_N^2);
for i=1:N
    x0(i,:) = [Xgrid(Permutations(i)) Ygrid(Permutations(i))];
end

x0 = reshape(x0',1,2*N)';
