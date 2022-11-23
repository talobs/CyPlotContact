function varargout = CyPlotContact2(varargin)
% CYPLOTCONTACT2 MATLAB code for CyPlotContact2.fig
%      CYPLOTCONTACT2, by itself, creates a new CYPLOTCONTACT2 or raises the existing
%      singleton*.
%
%      H = CYPLOTCONTACT2 returns the handle to a new CYPLOTCONTACT2 or the handle to
%      the existing singleton*.
%
%      CYPLOTCONTACT2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CYPLOTCONTACT2.M with the given input arguments.
%
%      CYPLOTCONTACT2('Property','Value',...) creates a new CYPLOTCONTACT2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before CyPlotContact2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to CyPlotContact2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help CyPlotContact2

% Last Modified by GUIDE v2.5 23-Nov-2022 11:07:39

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @CyPlotContact2_OpeningFcn, ...
                   'gui_OutputFcn',  @CyPlotContact2_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
addpath('Utilities') ;
% End initialization code - DO NOT EDIT


% --- Executes just before CyPlotContact2 is made visible.
function CyPlotContact2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to CyPlotContact2 (see VARARGIN)

% Choose default command line output for CyPlotContact2
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% initialize all tables, axes, structs, etc.
initiate(handles);



% UIWAIT makes CyPlotContact2 wait for user response (see UIRESUME)
% uiwait(handles.figure_main);


% --- Outputs from this function are returned to the command line.
function varargout = CyPlotContact2_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function file_Callback(hObject, eventdata, handles)
% hObject    handle to file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function load_files_Callback(hObject, eventdata, handles)
% hObject    handle to load_files (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in averages.
function averages_Callback(hObject, eventdata, handles)
% hObject    handle to averages (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of averages


% --- Executes on button press in originals.
function originals_Callback(hObject, eventdata, handles)
% hObject    handle to originals (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of originals
plot_groups(handles) ;


% --- Executes on button press in calculate_force.
function calculate_force_Callback(hObject, eventdata, handles)
% hObject    handle to calculate_force (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isempty(handles.selected_forces)
    return ;
end

channel_bg_selection = get(handles.left_axes_channel,'SelectedObject') ;
if ~strcmp(get(channel_bg_selection,'Tag'),'deflection') 
    set(handles.deflection, 'Value' ,1) ;
    set(handles.force, 'Value', 0) ;
    plot_forces(handles)
end

axes(handles.axes_left) ;

set(handles.axes_left_x_lim_checkox, 'Visible' , 'Off') ;
set(handles.axes_left_x_lim, 'Visible' , 'Off') ;

set(handles.y_lim_left_checkbox, 'Visible' , 'Off') ;
set(handles.y_lim_left_edit, 'Visible' , 'Off') ;

[x, ~] = ginput(4) ;
if length(x) ~= 4
    return ;
end

x = x*1e-9 ;

if handles.tilt_linear.Value
    p = 1 ;
else
    p = 2 ;
end


for i = 1:length(handles.selected_forces)
    force_idx = handles.selected_forces(i) ;
    [handles.forces(force_idx).obj.sep_app,...
        handles.forces(force_idx).obj.force_app,...
        handles.forces(force_idx).obj.abcd_idx_app,...
        handles.forces(force_idx).obj.abcd_val_app] = ...
        calculate_force(handles.forces(force_idx).obj.Zsnsr_app,...
        handles.forces(force_idx).obj.Defl_app,...
        str2num(handles.forces(force_idx).obj.header.SpringConstant), x, p) ;
end

guidata(handles.figure_main, handles) ;

set(handles.deflection, 'Value' ,0) ;
set(handles.force, 'Value', 1) ;

set(handles.axes_left_x_lim_checkox, 'Visible' , 'On') ;

if handles.axes_left_x_lim_checkox.Value
    set(handles.axes_left_x_lim, 'Visible' , 'On') ;
    if isempty(get(handles.axes_left_x_lim, 'String'))
        current_xlims = get(handles.axes_left, 'XLim') ;
        set(handles.axes_left_x_lim, 'String', num2str(current_xlims(2),'%.1f')) ;
    end
end

set(handles.y_lim_left_checkbox, 'Visible' , 'On') ;
if handles.y_lim_left_checkbox.Value
    set(handles.y_lim_left_edit, 'Visible' , 'On') ;
    if isempty(get(handles.y_lim_left_edit, 'String'))
        current_ylims = get(handles.axes_left, 'XLim') ;
        set(handles.y_lim_left_edit, 'String', num2str(current_ylims(2),'%.1f')) ;
    end
end

plot_forces(handles) ;



% --------------------------------------------------------------------
function load_ibw_Callback(hObject, eventdata, handles)
% hObject    handle to load_ibw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles = load_ibw(handles) ;
guidata(handles.figure_main, handles) ;
refresh_tables(handles) ;


% --- Executes when selected cell(s) is changed in table_left_menu.
function table_left_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to table_left_menu (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)
handles.selected_forces = unique(eventdata.Indices(:,1)) ;
plot_forces(handles) ;
guidata(handles.figure_main, handles);


% --- Executes when selected object is changed in left_axes_channel.
function left_axes_channel_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in left_axes_channel 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
switch eventdata.NewValue.Tag
    case 'deflection'
        set(handles.axes_left_x_lim, 'Visible' , 'Off') ;
        set(handles.axes_left_x_lim_checkox, 'Visible' , 'Off') ;
        set(handles.y_lim_left_checkbox, 'Visible' , 'Off') ;
        set(handles.y_lim_left_edit, 'Visible' , 'Off') ;
    case 'force'
        set(handles.axes_left_x_lim_checkox, 'Visible' , 'On') ;
        if get(handles.axes_left_x_lim_checkox, 'Value')
            set(handles.axes_left_x_lim, 'Visible' , 'On') ;
        end
        set(handles.y_lim_left_checkbox, 'Visible' , 'On') ;
        if get(handles.y_lim_left_checkbox,  'Value')
            set(handles.y_lim_left_edit, 'Visible' , 'On') ;
        end
end
plot_forces(handles)


% --------------------------------------------------------------------
function forces_change_color_Callback(hObject, eventdata, handles)
% hObject    handle to forces_change_color (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
color_choice = uisetcolor ;
if color_choice == 0
    return
end

for i = 1:length(handles.selected_forces)
    handles.forces(handles.selected_forces(i)).color = color_choice ;
end

guidata(handles.figure_main, handles) ;
refresh_tables(handles) ;
plot_forces(handles) ;


% --- Executes when selected object is changed in y_axis_left_bg.
function y_axis_left_bg_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in y_axis_left_bg 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


switch eventdata.NewValue.String
    case 'Linear'
        set(handles.axes_left, 'YScale', 'linear')
    case 'Logarithmic'
        set(handles.axes_left, 'YScale', 'log')
end


% --------------------------------------------------------------------
function forces_create_group_Callback(hObject, eventdata, handles)
% hObject    handle to forces_create_group (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = create_group(handles) ;
guidata(handles.figure_main, handles) ;
refresh_tables(handles) ;



% --------------------------------------------------------------------
function forces_delete_Callback(hObject, eventdata, handles)
% hObject    handle to forces_delete (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

to_leave = ~ismember(1:length(handles.forces), handles.selected_forces) ;
handles.forces = handles.forces(to_leave) ;
guidata(handles.figure_main, handles) ;
refresh_tables(handles,true) ;


% --- Executes on button press in axes_left_x_lim_checkox.
function axes_left_x_lim_checkox_Callback(hObject, eventdata, handles)
% hObject    handle to axes_left_x_lim_checkox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of axes_left_x_lim_checkox
if get(hObject,'Value')
    set(handles.axes_left_x_lim, 'Visible' , 'On') ;
    current_xlims = get(handles.axes_left, 'XLim') ;
    set(handles.axes_left_x_lim, 'String', num2str(current_xlims(2),'%.1f')) ;
else
    set(handles.axes_left_x_lim, 'Visible' , 'Off') ;
end
    



function axes_left_x_lim_Callback(hObject, eventdata, handles)
% hObject    handle to axes_left_x_lim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of axes_left_x_lim as text
%        str2double(get(hObject,'String')) returns contents of axes_left_x_lim as a double

plot_forces(handles)



% --- Executes during object creation, after setting all properties.
function axes_left_x_lim_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes_left_x_lim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on key press with focus on axes_left_x_lim and none of its controls.
function axes_left_x_lim_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to axes_left_x_lim (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
    


% --- Executes on button press in reset_plot_left.
function reset_plot_left_Callback(hObject, eventdata, handles)
% hObject    handle to reset_plot_left (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
plot_forces(handles) ;



% --- Executes when selected cell(s) is changed in table_right.
function table_right_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to table_right (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)
handles.selected_groups = unique(eventdata.Indices(:,1)) ;
plot_groups(handles) ;
guidata(handles.figure_main, handles);


% --- Executes on button press in x_max_right_checkbox.
function x_max_right_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to x_max_right_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of x_max_right_checkbox
if get(hObject,'Value')
    set(handles.x_max_right_edit, 'Visible' , 'On') ;
    current_xlims = get(handles.axes_right, 'XLim') ;
    set(handles.x_max_right_edit, 'String', num2str(current_xlims(2),'%.1f')) ;
else
    set(handles.x_max_right_edit, 'Visible' , 'Off') ;
end


function x_max_right_edit_Callback(hObject, eventdata, handles)
% hObject    handle to x_max_right_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of x_max_right_edit as text
%        str2double(get(hObject,'String')) returns contents of x_max_right_edit as a double

plot_groups(handles) ;


% --- Executes during object creation, after setting all properties.
function x_max_right_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to x_max_right_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when selected object is changed in plot_scale_right_bg.
function plot_scale_right_bg_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in plot_scale_right_bg 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

switch eventdata.NewValue.String
    case 'Linear'
        set(handles.axes_right, 'XScale', 'linear')
        set(handles.axes_right, 'YScale', 'linear')
    case 'Semilog (abs)'
        set(handles.axes_right, 'XScale', 'linear')
        set(handles.axes_right, 'YScale', 'log')
    case 'Log-Log (abs)'
        set(handles.axes_right, 'XScale', 'log')
        set(handles.axes_right, 'YScale', 'log')
end
plot_groups(handles) ;


% --- Executes when selected object is changed in graphs_right_bg.
function graphs_right_bg_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in graphs_right_bg 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

plot_groups(handles) ;


% --- Executes on button press in reset_plot_right.
function reset_plot_right_Callback(hObject, eventdata, handles)
% hObject    handle to reset_plot_right (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

plot_groups(handles) ;


% --------------------------------------------------------------------
function groups_change_color_Callback(hObject, eventdata, handles)
% hObject    handle to groups_change_color (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
color_choice = uisetcolor ;
if color_choice == 0
    return
end

for i = 1:length(handles.selected_groups)
    handles.groups(handles.selected_groups(i)).color = color_choice ;
end

guidata(handles.figure_main, handles) ;
refresh_tables(handles) ;
plot_groups(handles) ;

% --------------------------------------------------------------------
function group_delete_Callback(hObject, eventdata, handles)
% hObject    handle to group_delete (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
to_leave = ~ismember(1:length(handles.groups), handles.selected_groups) ;
handles.groups = handles.groups(to_leave) ;
guidata(handles.figure_main, handles) ;
refresh_tables(handles,true) ;

% --------------------------------------------------------------------
function table_right_menu_Callback(hObject, eventdata, handles)
% hObject    handle to table_right_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function groups_fit_DLVO_Callback(hObject, eventdata, handles)
% hObject    handle to groups_fit_DLVO (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

fit_DLVO(handles) ;

% --------------------------------------------------------------------
function groups_fit_DH_hide_Callback(hObject, eventdata, handles)
% hObject    handle to groups_fit_DH_hide (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function groups_fit_DLVO_delete_Callback(hObject, eventdata, handles)
% hObject    handle to groups_fit_DLVO_delete (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isfield(handles.groups, 'fit_DLVO')
    for i = 1:length(handles.selected_groups)
        handles.groups(handles.selected_groups(i)).fit_DLVO = [] ;
    end
end
guidata(handles.figure_main, handles) ;
plot_groups(handles) ;


% --- Executes on button press in y_max_right_checkbox.
function y_max_right_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to y_max_right_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of y_max_right_checkbox
if get(hObject,'Value')
    set(handles.y_max_right_edit, 'Visible' , 'On') ;
    current_ylims = get(handles.axes_right, 'YLim') ;
    set(handles.y_max_right_edit, 'String', num2str(current_ylims(2),'%.1f')) ;
else
    set(handles.y_max_right_edit, 'Visible' , 'Off') ;
end


function y_max_right_edit_Callback(hObject, eventdata, handles)
% hObject    handle to y_max_right_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of y_max_right_edit as text
%        str2double(get(hObject,'String')) returns contents of y_max_right_edit as a double
plot_groups(handles) ;


% --- Executes during object creation, after setting all properties.
function y_max_right_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to y_max_right_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in y_lim_left_checkbox.
function y_lim_left_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to y_lim_left_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of y_lim_left_checkbox
if get(hObject,'Value')
    set(handles.y_lim_left_edit, 'Visible' , 'On') ;
    current_ylims = get(handles.axes_left, 'YLim') ;
    set(handles.y_lim_left_edit, 'String', num2str(current_ylims(2),'%.1f')) ;
else
    set(handles.y_lim_left_edit, 'Visible' , 'Off') ;
end


function y_lim_left_edit_Callback(hObject, eventdata, handles)
% hObject    handle to y_lim_left_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of y_lim_left_edit as text
%        str2double(get(hObject,'String')) returns contents of y_lim_left_edit as a double
plot_forces(handles) ;

% --- Executes during object creation, after setting all properties.
function y_lim_left_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to y_lim_left_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function groups_rename_Callback(hObject, eventdata, handles)
% hObject    handle to groups_rename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selected_group = handles.selected_groups ;

if length(selected_group) ~= 1
        warndlg('Only one group can be renamed at once')
else
    prompt = 'New Name:';
    dlg_title = 'Rename Group';
    num_lines = 1;
    defaultans = {handles.groups(selected_group).obj.name} ;
    new_name = inputdlg(prompt, dlg_title, num_lines, defaultans) ;
    handles.groups(selected_group).obj.name = new_name{1} ;
end

guidata(handles.figure_main, handles) ;
refresh_tables(handles)


% --------------------------------------------------------------------
function groups_save_Callback(hObject, eventdata, handles)
% hObject    handle to groups_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName,PathName] = uiputfile('*.fgrp', 'Save Groups') ;

if ~PathName
    return ;
end

groups_struct = handles.groups(handles.selected_groups) ;
save(strcat(PathName, FileName), 'groups_struct', '-v7.3') ;

% --------------------------------------------------------------------
function load_force_group_Callback(hObject, eventdata, handles)
% hObject    handle to load_force_group (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[file_name, path_name] = uigetfile('*.fgrp', 'Load Force Groups');

full_path = strcat(path_name, file_name);

if isempty(full_path)
    return
end

wait_bar = waitbar(0,'Loading...'); 
load(full_path, '-mat');

global_groups_struct_length = length(handles.groups) ;


for i = 1:length(groups_struct)
    waitbar(i / length(groups_struct), wait_bar);
    handles.groups(global_groups_struct_length + i).obj = groups_struct(i).obj ;
    handles.groups(global_groups_struct_length + i).color = groups_struct(i).color ;
    handles.groups(global_groups_struct_length + i).plot_prop = groups_struct(i).plot_prop;
    try
        handles.groups(global_groups_struct_length + i).fit_DH = groups_struct(i).fit_DH ;
    catch
    end
    
    try
        handles.groups(global_groups_struct_length + i).movemean = groups_struct(i).movemean ;
    catch
        handles.groups(global_groups_struct_length + i).movemean.force_app = movmean(groups_struct(i).obj.force_app, 10) ;
    end
    
    try
        handles.groups(global_groups_struct_length + i).aligned = groups_struct(i).aligned ;
    catch
    end
end

delete(wait_bar)
guidata(handles.figure_main, handles) ;
refresh_tables(handles)

% --------------------------------------------------------------------
function groups_import_forces_Callback(hObject, eventdata, handles)
% hObject    handle to groups_import_forces (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selected_groups = handles.selected_groups ;

for i = 1:length(selected_groups)
    group_forces_struct = handles.groups(selected_groups(i)).obj.forces ;
    global_forces_struct_length = length(handles.forces) ;
    for j = 1:length(group_forces_struct)
        handles.forces(global_forces_struct_length + j).obj = group_forces_struct(j).obj ;
        handles.forces(global_forces_struct_length + j).color = handles.groups(selected_groups(i)).color ;
    end
end

guidata(handles.figure_main, handles) ;
refresh_tables(handles)


% --------------------------------------------------------------------
function save_session_Callback(hObject, eventdata, handles)
% hObject    handle to save_session (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[file_name, path_name] = uiputfile('session.ses', 'Save session to file...');
full_path = strcat(path_name, file_name);

if isempty(full_path)
    return
end

save(full_path);


% --------------------------------------------------------------------
function load_session_Callback(hObject, eventdata, handles)
% hObject    handle to load_session (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[file_name, path_name] = uigetfile('.ses', 'Load Session');

full_path = strcat(path_name, file_name);

if isempty(full_path)
    return
end

% close current program and restart using the chosen session file
close all
clc
load(full_path, '-mat');


% --------------------------------------------------------------------


% --------------------------------------------------------------------
function set_n_T_Callback(hObject, eventdata, handles)
% hObject    handle to set_n_T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
prompt = {'n [mM]', 'T [�C]'};
dlg_title = 'Assign salt concetration and temperature';
num_lines = 1 ;

def_n = '' ;
def_T = '' ;

selected_groups = handles.selected_groups ;

if length(selected_groups) == 1
    if isfield(handles.groups(selected_groups).obj.param, 'n')
        def_n = num2str(handles.groups(selected_groups).obj.param.n) ;
    end
    
    if isfield(handles.groups(selected_groups).obj.param, 'T_C')
        def_T = num2str(handles.groups(selected_groups).obj.param.T_C) ;
    end
end

defaultans = {def_n, def_T};
answer = inputdlg(prompt,dlg_title,num_lines,defaultans);

if isempty(answer) 
    return ;
end

n = str2num(answer{1}) ;
T = str2num(answer{2}) ;

for i = 1:length(selected_groups)
    if ~isempty(n)
        handles.groups(selected_groups(i)).obj.param.n = n ;
    end
    
    if ~isempty(T)
        handles.groups(selected_groups(i)).obj.param.T_C = T ;
    end
end

guidata(handles.figure_main, handles) ;
refresh_tables(handles)


% --- Executes on button press in button_debug.
function button_debug_Callback(hObject, eventdata, handles)
% hObject    handle to button_debug (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
display('Debug')


% --- Executes on button press in graphs_right_move_average.
function graphs_right_move_average_Callback(hObject, eventdata, handles)
% hObject    handle to graphs_right_move_average (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
plot_groups(handles) ;
% Hint: get(hObject,'Value') returns toggle state of graphs_right_move_average



% --- Executes on button press in graphs_right_original_forces.
function graphs_right_original_forces_Callback(hObject, eventdata, handles)
% hObject    handle to graphs_right_original_forces (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
plot_groups(handles) ;
% Hint: get(hObject,'Value') returns toggle state of graphs_right_original_forces


% --- Executes on button press in graphs_right_force_average.
function graphs_right_force_average_Callback(hObject, eventdata, handles)
% hObject    handle to graphs_right_force_average (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
plot_groups(handles) ;
% Hint: get(hObject,'Value') returns toggle state of graphs_right_force_average

% --------------------------------------------------------------------
function plot_function_axes_right_Callback(hObject, eventdata, handles)
% hObject    handle to plot_function_axes_right (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
x = 1:2 ;
func = handles.func_str_axes_right ;

while true
    func = replace(func, '.*', '*') ;
    func = replace(func, './', '/') ;
    func = replace(func, '.^', '^') ;
    
    in_func = inputdlg('Write a function of x', 'Plot Fuunction',[1 100], {func}) ;
    if size(in_func) == [1 1] 
           func = in_func{1} ;
    else
        return ;
    end
    
    func = replace(func, '*', '.*') ;
    func = replace(func, '/', './') ;
    func = replace(func, '^', '.^') ;
       
       if ~isempty(func) 
           try
               y = eval(func) ;
               handles.func_show_axes_right = 1 ;
               break ;
           catch
               %msgbox('This function cannot be executed') ;
           end
       else
           handles.func_show_axes_right = 0 ;
           break ;
       end           
end
    
handles.func_str_axes_right = func ;
guidata(handles.figure_main, handles) ;
plot_groups(handles) ;


% --------------------------------------------------------------------
function Axes_right_menu_Callback(hObject, eventdata, handles)
% hObject    handle to Axes_right_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function hide_function_axes_right_Callback(hObject, eventdata, handles)
% hObject    handle to hide_function_axes_right (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.func_show_axes_right = 0 ;
guidata(handles.figure_main, handles) ;
plot_groups(handles) ;


% --------------------------------------------------------------------
function export_plot_axes_right_Callback(hObject, eventdata, handles)
% hObject    handle to export_plot_axes_right (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
figure
temp_ax = axes ;
plot_groups(handles, temp_ax) ;


% --------------------------------------------------------------------
function axes_right_menu_Callback(hObject, eventdata, handles)
% hObject    handle to axes_right_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function groups_align_Callback(hObject, eventdata, handles)
% hObject    handle to groups_align (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    set(handles.graphs_right_force_average, 'Value', 0) ;
    set(handles.graphs_right_move_average, 'Value', 1) ;
    set(handles.graphs_right_plot_aligned, 'Value', 0) ;
    set(handles.graphs_right_plot_fits, 'Value', 0) ;
    set(handles.graphs_right_original_forces, 'Value', 0) ;
    
[x, ~] = ginput(1) ;
selected_groups = handles.selected_groups ;

sum = 0 ;

for i = 1:length(selected_groups)
    group_idx = selected_groups(i) ;
    
    if ~isfield(handles.groups, 'movemean')
        if isempty(handles.groups(group_idx).movemean.force_app)
            return ;
        end
    end
    
    [~, sep_idx(i)] = min(abs(handles.groups(group_idx).obj.sep_app*1e9-x)) ;
    sum = sum + handles.groups(group_idx).movemean.force_app(sep_idx(i)) ;
end

value = sum/length(selected_groups) ;

for i = 1:length(selected_groups)
    group_idx = selected_groups(i) ;
    handles.groups(group_idx).aligned.force_app = handles.groups(group_idx).movemean.force_app - handles.groups(group_idx).movemean.force_app(sep_idx(i)) + value ;
end

    set(handles.graphs_right_force_average, 'Value', 0) ;
    set(handles.graphs_right_move_average, 'Value', 0) ;
    set(handles.graphs_right_plot_aligned, 'Value', 1) ;
    set(handles.graphs_right_plot_fits, 'Value', 0) ;
    set(handles.graphs_right_original_forces, 'Value', 0) ;

guidata(handles.figure_main, handles) ;

plot_groups(handles) ;


% --- Executes on button press in graphs_right_plot_fits.
function graphs_right_plot_fits_Callback(hObject, eventdata, handles)
% hObject    handle to graphs_right_plot_fits (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
plot_groups(handles) ;
% Hint: get(hObject,'Value') returns toggle state of graphs_right_plot_fits


% --- Executes on button press in graphs_right_plot_aligned.
function graphs_right_plot_aligned_Callback(hObject, eventdata, handles)
% hObject    handle to graphs_right_plot_aligned (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
plot_groups(handles) ;
% Hint: get(hObject,'Value') returns toggle state of graphs_right_plot_aligned


% --- Executes on button press in y_min_right_checkbox.
function y_min_right_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to y_min_right_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(hObject,'Value')
    set(handles.y_min_right_edit, 'Visible' , 'On') ;
    current_ylims = get(handles.axes_right, 'YLim') ;
    set(handles.y_min_right_edit, 'String', num2str(current_ylims(1),'%.1f')) ;
else
    set(handles.y_min_right_edit, 'Visible' , 'Off') ;
end
% Hint: get(hObject,'Value') returns toggle state of y_min_right_checkbox



function y_min_right_edit_Callback(hObject, eventdata, handles)
% hObject    handle to y_min_right_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
plot_groups(handles) ;
% Hints: get(hObject,'String') returns contents of y_min_right_edit as text
%        str2double(get(hObject,'String')) returns contents of y_min_right_edit as a double


% --- Executes during object creation, after setting all properties.
function y_min_right_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to y_min_right_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function groups_fit_eve_Callback(hObject, eventdata, handles)
% hObject    handle to groups_fit_eve (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fit_eve(handles) ;


% --------------------------------------------------------------------
function groups_fit_eve_delete_Callback(hObject, eventdata, handles)
% hObject    handle to groups_fit_eve_delete (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isfield(handles.groups, 'fit_eve')
    for i = 1:length(handles.selected_groups)
        handles.groups(handles.selected_groups(i)).fit_eve = [] ;
    end
end
guidata(handles.figure_main, handles) ;
plot_groups(handles) ;



function x_min_right_edit_Callback(hObject, eventdata, handles)
% hObject    handle to x_min_right_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of x_min_right_edit as text
%        str2double(get(hObject,'String')) returns contents of x_min_right_edit as a double
plot_groups(handles) ;


% --- Executes during object creation, after setting all properties.
function x_min_right_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to x_min_right_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in x_min_right_checkbox.
function x_min_right_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to x_min_right_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of x_min_right_checkbox
if get(hObject,'Value')
    set(handles.x_min_right_edit, 'Visible' , 'On') ;
    current_xlims = get(handles.axes_right, 'XLim') ;
    set(handles.x_min_right_edit, 'String', num2str(current_xlims(1),'%.1f')) ;
else
    set(handles.x_min_right_edit, 'Visible' , 'Off') ;
end


% --------------------------------------------------------------------
function groups_create_group_Callback(hObject, eventdata, handles)
% hObject    handle to groups_create_group (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
create_group_group(handles)


% --------------------------------------------------------------------
function groups_cal_charge_Callback(hObject, eventdata, handles)
% hObject    handle to groups_cal_charge (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
calculate_charge(handles) ;


% --------------------------------------------------------------------
function groups_fit_exact_DLVO_Callback(hObject, eventdata, handles)
% hObject    handle to groups_fit_exact_DLVO (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
FitDLVOExact(handles) ;

% --------------------------------------------------------------------
function groups_fdelete_fit_exaxt_DLVO_Callback(hObject, eventdata, handles)
% hObject    handle to groups_fdelete_fit_exaxt_DLVO (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in groups_up.
function groups_up_Callback(hObject, eventdata, handles)
% hObject    handle to groups_up (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
grp_idx = handles.selected_groups ;
grps_num = length(handles.groups) ;

if ~grps_num
    return ;
end

if isempty(grp_idx)
    return ;
end

if ~(length(grp_idx) == 1)
    return ;
end

if ismember(1,grp_idx)
    return ;
end

fields = fieldnames(handles.groups) ;
if grp_idx == 2 
    if grps_num >= 3
        new_order = [2 1 3:grps_num] ;
    else
         new_order = [2 1] ;
    end
elseif grp_idx == grps_num
    new_order = [1:(grp_idx-2) grp_idx grp_idx-1] ;
else
    new_order = [1:(grp_idx-2) grp_idx grp_idx-1 (grp_idx+1):grps_num] ;
end

for i = 1:grps_num
    for j = 1:length(fields)
        new_groups(i).(fields{j}) = handles.groups(new_order(i)).(fields{j}) ;
    end
end

handles.groups = new_groups ;
guidata(handles.figure_main, handles) ;
refresh_tables(handles) ;


% --- Executes on button press in groups_down.
function groups_down_Callback(hObject, eventdata, handles)
% hObject    handle to groups_down (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
grp_idx = handles.selected_groups ;
grps_num = length(handles.groups) ;

if ~grps_num
    return ;
end

if isempty(grp_idx)
    return ;
end

if ~(length(grp_idx) == 1)
    return ;
end

if ismember(grps_num,grp_idx)
    return ;
end

fields = fieldnames(handles.groups) ;
if grp_idx == grps_num-1 
    if grps_num >= 3
        new_order = [1:(grp_idx-1) grps_num grp_idx] ;
    else
        new_order = [2 1] ;
    end
elseif grp_idx == 1
    new_order = [2 1 3:grps_num] ;
else
    new_order = [1:(grp_idx-1) grp_idx+1 grp_idx (grp_idx+2):grps_num] ;
end

for i = 1:grps_num
    for j = 1:length(fields)
        new_groups(i).(fields{j}) = handles.groups(new_order(i)).(fields{j}) ;
    end
end

handles.groups = new_groups ;
guidata(handles.figure_main, handles) ;
refresh_tables(handles) ;
