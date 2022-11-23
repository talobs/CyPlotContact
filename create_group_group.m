function handles = create_group_group(handles)
prompt = {'Group Name:'};
dlg_title = 'Create Group';
num_lines = 1;
defaultans = {strcat('Group_',num2str(length(handles.groups)+1))};
answer = inputdlg(prompt,dlg_title,num_lines,defaultans);

if isempty(answer)
    return ;
end

group_name = answer{1} ;

selected_groups = handles.selected_groups ;

forces_count = 0 ;
for i = 1:length(selected_groups)
    group_idx = selected_groups(i) ;
    for j = 1:length(handles.groups(group_idx).obj.forces)
        forces_count = forces_count + 1 ;
        sep_app{forces_count} = handles.groups(group_idx).obj.forces(j).obj.sep_app ;
        force_app{forces_count} = handles.groups(group_idx).obj.forces(j).obj.force_app ;
        abcd_idx_app{forces_count} = handles.groups(group_idx).obj.forces(j).obj.abcd_idx_app ;
        color(forces_count,:) = handles.groups(group_idx).color ;
    end
end

min_sep_app = min(cellfun(@min, sep_app)) ;
max_sep_app = max(cellfun(@max, sep_app)) ;

int_points_app = max(cellfun(@length, sep_app)) ;
sep_vec_app = linspace(min_sep_app, max_sep_app, int_points_app)' ;

[sep_app_unique, unique_idxs] = cellfun(@unique, sep_app, 'UniformOutput', false) ;

for j = 1:forces_count
    force_app_interp(:,j) = interp1(sep_app_unique{j}, force_app{j}(unique_idxs{j}), sep_vec_app) ;
end

force_avg =  nanmean(force_app_interp, 2) ;

x_min = [] ;
x_max = [] ;

for j = 1:length(abcd_idx_app)
    x_min = max([sep_app{j}(abcd_idx_app{j}(2)) ; x_min]) ;
    x_max = min([sep_app{j}(abcd_idx_app{j}(3)) ; x_max]) ;
end

[~, x_min_idx] = min(abs(sep_vec_app-x_min)) ;
[~, x_max_idx] = min(abs(sep_vec_app-x_max)) ;

y_min = min(force_avg(x_min_idx:x_max_idx)) ;
y_max = max(force_avg(x_min_idx:x_max_idx)) ;
y_min_idx = find(ismember(force_avg, y_min)) ;
y_max_idx = find(ismember(force_avg, y_max)) ;

group_id = length(handles.groups) + 1 ;
handles.groups(group_id).obj = force_group ;
handles.groups(group_id).obj.name = group_name ;
handles.groups(group_id).obj.sep_app = sep_vec_app ;
handles.groups(group_id).obj.force_app = force_avg ;
handles.groups(group_id).movemean.force_app = movmean(force_avg, 10) ;

forces_struct_fields_name = fieldnames(handles.forces) ;
non_obj_fields = ~ismember(forces_struct_fields_name, 'obj') ;
handles.groups(group_id).obj.forces = rmfield(handles.forces(selected_forces), forces_struct_fields_name(non_obj_fields)) ;

handles.groups(group_id).color = mean(color) ;

handles.groups(group_id).plot_prop.x_min_idx = x_min_idx ;
handles.groups(group_id).plot_prop.x_max_idx = x_max_idx ;
handles.groups(group_id).plot_prop.x_min = sep_vec_app(x_min_idx) ;
handles.groups(group_id).plot_prop.x_max = sep_vec_app(x_max_idx) ;
handles.groups(group_id).plot_prop.y_min_idx = y_min_idx ;
handles.groups(group_id).plot_prop.y_max_idx = y_max_idx ;
handles.groups(group_id).plot_prop.y_min = y_min ;
handles.groups(group_id).plot_prop.y_max = y_max ;

guidata(handles.figure_main, handles) ;