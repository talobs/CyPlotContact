function handles = create_group(handles)
prompt = {'Group Name:'};
dlg_title = 'Create Group';
num_lines = 1;
defaultans = {strcat('Group_',num2str(length(handles.groups)+1))};
answer = inputdlg(prompt,dlg_title,num_lines,defaultans);

if isempty(answer)
    return ;
end

group_name = answer{1} ;

selected_forces = handles.selected_forces ;

for i = 1:length(selected_forces)
    sep_app{i} = handles.forces(selected_forces(i)).obj.sep_app ;
    force_app{i} = handles.forces(selected_forces(i)).obj.force_app ;
%     abcd_val_app{i} = handles.forces(selected_forces(i)).obj.abcd_val_app ;
    color(i,:) = handles.forces(selected_forces(i)).color ;
    
    if isempty(sep_app{i}) || isempty(force_app{i})
        warndlg('Force should be calculated for all measurements in the group')
        return ;
    end
end

min_sep_app = min(cellfun(@min, sep_app)) ;
max_sep_app = max(cellfun(@max, sep_app)) ;

interp_points_app = max(cellfun(@length, sep_app)) ;
sep_vec_app = linspace(min_sep_app, max_sep_app, interp_points_app)' ;

[sep_app_unique, unique_idxs] = cellfun(@unique, sep_app, 'UniformOutput', false) ;

for i = 1:length(selected_forces)
    force_app_interp(:,i) = interp1(sep_app_unique{i}, force_app{i}(unique_idxs{i}), sep_vec_app) ;
end

force_avg =  nanmean(force_app_interp, 2) ;

x_min = min_sep_app ;
x_max = max_sep_app ;

% for i = 1:length(sep_app)
%     x_min = max([sep_app{i} ; x_min]) ;
%     x_max = min([sep_app{i} ; x_max]) ;
% end

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