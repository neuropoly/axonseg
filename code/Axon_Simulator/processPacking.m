function x = processPacking(x0,R,gap,side,ITERmax)

N = length(R);
x = x0;

Kcenter0 = 0.01;                 % center step coeff for disks withOUT overlapping
Kcenter1 = 0;                    % center step coeff for disks with overlapping
KrepMULT = 1.5;
Krep = KrepMULT*Kcenter0;          % repulsion step coeff for disks with overlapping
PowerRep = 0.5;                    % repulsion power for disks with overlapping

for iter=1:ITERmax
    
    MyGrad = computeGrad(x, R+gap/2, side, Kcenter0, Kcenter1, Krep, PowerRep);
    x = x + MyGrad; 

end

end