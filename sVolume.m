function [totalVolume] = sVolume(V,F)
FaceCentroidZ = ( V(F(:, 1), 3) + V(F(:, 2), 3) + V(F(:, 3), 3) ) /3; 
% Face normal vectors, with length equal to triangle area. 
FNdA = cross( (V(F(:, 2), :) - V(F(:, 1), :)), ... 
(V(F(:, 3), :) - V(F(:, 2), :)) , 2 ) / 2; 
% Volume from divergence theorem (using vector field along z). 
totalVolume = FaceCentroidZ' * FNdA(:, 3);