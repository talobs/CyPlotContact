classdef force
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        name % file struct
        header % ibw header
        param % whatever you want
        channels %channels names in the same order as in the data matrices
        Zsnsr_app % approach channels data
        Zsnsr_ret % retract channels data
        Raw_app %
        Raw_ret %
        Defl_app %
        Defl_ret %
        sep_app % approach separation [m]
        sep_ret % retract separation [m]
        force_app % approach force [N]
        force_ret % retract force upon [N]
        abcd_idx_app % abcd points indices on approach curve
        abcd_idx_ret % abcd points indices on retract curve
        abcd_val_app
        abcd_val_ret
    end
    
    methods
    end
    
end

