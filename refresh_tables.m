function refresh_tables(varargin)

handles = varargin{1} ;

if nargin == 2
    if varargin{2}
        handles.table_left.Data = {} ;
        handles.table_right.Data = {} ;
    end
end


[~, column_name] = ismember('Name', handles.table_left.ColumnName);
[~, column_color] = ismember('Color', handles.table_left.ColumnName);
[~, column_k] = ismember('k [N/m]', handles.table_left.ColumnName);


    
for i = 1:length(handles.forces)
    handles.table_left.Data{i,column_name} = handles.forces(i).obj.name ;
    html_str = row_color_html(handles.forces(i).color) ;
    html_str = html_str{1} ;
    handles.table_left.Data{i,column_color} = html_str ;
    handles.table_left.Data{i,column_k} = handles.forces(i).obj.header.SpringConstant ;
end

[~, column_name] = ismember('Name', handles.table_right.ColumnName);
[~, column_color] = ismember('Color', handles.table_right.ColumnName);
[~, column_N_n] = ismember('Nominal n [mM]', handles.table_right.ColumnName);
[~, column_T_C] = ismember('Temperature [C]', handles.table_right.ColumnName);

%{
[~, column_DL] = ismember('DL [nm]', handles.table_right.ColumnName);
[~, column_n] = ismember('n [mM]', handles.table_right.ColumnName);
[~, column_psi] = ismember('Psi_0 [mV]', handles.table_right.ColumnName);
[~, column_sigma] = ismember('Sigma [e/nm]', handles.table_right.ColumnName);
[~, column_A] = ismember('A [J]', handles.table_right.ColumnName);
%}

for i = 1:length(handles.groups)
    handles.table_right.Data{i,column_name} = handles.groups(i).obj.name ;
    html_str = row_color_html(handles.groups(i).color) ;
    html_str = html_str{1} ;
    handles.table_right.Data{i,column_color} = html_str ;

%{
    if isfield(handles.groups, 'fit_DH')
        if ~isempty(handles.groups(i).fit_DH)
            handles.table_right.Data{i,column_DL} = handles.groups(i).fit_DH.param_out.l_d ;
            handles.table_right.Data{i,column_n} = handles.groups(i).fit_DH.param_out.n ;
            handles.table_right.Data{i,column_psi} = handles.groups(i).fit_DH.param_out.psi_0 ;
            handles.table_right.Data{i,column_sigma} = handles.groups(i).fit_DH.param_out.sigma ;
            handles.table_right.Data{i,column_A} = handles.groups(i).fit_DH.param_out.A ;
        else
            handles.table_right.Data{i,column_DL} = '' ;
            handles.table_right.Data{i,column_n} = '' ;
            handles.table_right.Data{i,column_psi} = '' ;
            handles.table_right.Data{i,column_sigma} = '' ;
        end
    end
%}
    
    if isfield(handles.groups(i).obj.param, 'n')
        handles.table_right.Data{i,column_N_n} = handles.groups(i).obj.param.n ;
    end
    
    if isfield(handles.groups(i).obj.param, 'T_C') 
        handles.table_right.Data{i,column_T_C} = handles.groups(i).obj.param.T_C ;
    end
end

guidata(handles.figure_main, handles) ;