function [ output ] = kappa( T_C, n_mM )
%KAPPA Summary of this function goes here
%   Detailed explanation goes here

load PhysConst

output = sqrt(2*e^2*Na*n_mM/(epsilon(T_C)*k_B*TC2K(T_C))) ;

end

