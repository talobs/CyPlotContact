function [ output ] = epsilon( T_C )
%EPS Summary of this function goes here
%   Detailed explanation goes here

load PhysConst

eps_r = 87.740 - 0.4008*T_C + 9.398e-4*T_C^2 - 1.410e-6*T_C^3 ; % Malmberg, C. G., and A. A. Maryott. "Dielectric constant of water from 00 to 1000 C." Journal of research of the National Bureau of Standards 56.1 (1956): 1-8.
output = eps_0*eps_r ;

end

