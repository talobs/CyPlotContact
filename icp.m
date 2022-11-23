function [ p_idx ] = icp( x, x_p )
%ICP Summary of this function goes here
%   Detailed explanation goes here
[~, p_idx] = min(abs(x-x_p)) ;

end

