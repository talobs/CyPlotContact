function  handles = load_ibw(handles)

try
    [files_name,folder_path] = uigetfile(fullfile(handles.last_ibw_path, '*.ibw'),'MultiSelect','on') ;

catch
    [files_name,folder_path] = uigetfile(fullfile('*.ibw'),'MultiSelect','on') ;
end


if folder_path == 0
    return
end

handles.last_ibw_path = folder_path ;

if ~iscell(files_name)
    files_name = {files_name} ;
end

wait_bar = waitbar(0,'Loading files...');

exp_num = length(handles.forces) ;
for i=1:length(files_name)
    waitbar(i / length(files_name), wait_bar);
    full_path = [folder_path files_name{i}] ;
    [~ ,item_name, item_extension] = fileparts(full_path) ;
    if ~strcmp(item_extension, '.ibw')
        continue
    end
        try
            ibw_struct = IBWread(full_path) ;
        catch
            continue
        end
        exp_num = exp_num + 1 ;
        handles.forces(exp_num).obj = force ;
        handles.forces(exp_num).obj.name = item_name ;
        handles.forces(exp_num).obj.header =...
            create_header_struct(getparameters(ibw_struct.WaveNotes)) ;
        
        s = strsplit(handles.forces(exp_num).obj.header.Indexes, ',') ;
        ret_idx = str2num(s{2})+1;
        
        
        handles.forces(exp_num).obj.Defl_app = ibw_struct.y(1:ret_idx-1,2) ;
        handles.forces(exp_num).obj.Zsnsr_app = -ibw_struct.y(1:ret_idx-1,3) ;
        handles.forces(exp_num).obj.Defl_ret = ibw_struct.y(ret_idx:end,2) ;
        handles.forces(exp_num).obj.Zsnsr_ret = -ibw_struct.y(ret_idx:end,3) ;
        handles.forces(exp_num).color = [0 0 0] ;
end

delete(wait_bar)