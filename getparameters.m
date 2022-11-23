function [par] = getparameters(WaveNotes)

par_row = strsplit(WaveNotes,'\r') ;

for i = 1:length(par_row)
    [par{i,1}, par{i,2}] = strtok(par_row{1,i},':') ;
    par{i,2} = strtok(par{i,2}, ':');
end