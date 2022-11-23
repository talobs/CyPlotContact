function plot_groups( varargin )

handles = varargin{1} ;

if nargin == 2
    axes(varargin{2})
else
    axes(handles.axes_right)
end

if nargin >=3
    plots = varargin{3} ; % [ force average, moving average, aligned, fits,  original forces, function]
else
    plots = [handles.graphs_right_force_average.Value,...
        handles.graphs_right_move_average.Value,...
        handles.graphs_right_plot_aligned.Value,...
        handles.graphs_right_plot_fits.Value,...
        handles.graphs_right_original_forces.Value,...
        handles.func_show_axes_right] ;
end

handles.groups_fit_text.String = '' ;
fit_str = '' ;

cla() ;

x_min = [] ;
x_max = [] ;

        if handles.x_max_right_checkbox.Value
            x_max = str2num(handles.x_max_right_edit.String) ;
        end
        
        if isempty(x_max)
            manual_x_max = false ;
        else
            manual_x_max = true ;
        end
        
        if handles.x_min_right_checkbox.Value
            x_min = str2num(handles.x_min_right_edit.String) ;
        else
            x_min = 0 ;
        end
        
        if isempty(x_min)
            manual_x_min = false ;
        else
            manual_x_min = true ;
        end
y_min = [] ;
y_max = [] ;

        if handles.y_max_right_checkbox.Value
            y_max = str2num(handles.y_max_right_edit.String) ;
        end
        
        if isempty(y_max)
            manual_y_max= false ;
        else
            manual_y_max = true ;
        end
        
        if handles.y_min_right_checkbox.Value
            y_min = str2num(handles.y_min_right_edit.String) ;
        end
        
        if isempty(y_min)
            manual_y_min= false ;
        else
            manual_y_min = true ;
        end
        
selected_groups = handles.selected_groups ;
hold on
for i = 1:length(selected_groups)
    group_idx = selected_groups(i) ;
    x = handles.groups(group_idx).obj.sep_app*1e9 ;
    y = handles.groups(group_idx).obj.force_app*1e9 ;


    if manual_x_max
        [~, sep_idx_at_x_min] = min(abs(x-x_min)) ;
        [~, sep_idx_at_x_max] = min(abs(x-x_max)) ;
        if ~manual_y_max
            y_max = max([y(sep_idx_at_x_min:sep_idx_at_x_max) ; y_max]) ;
        end
        if ~manual_y_min
            y_min = min([y(sep_idx_at_x_min:sep_idx_at_x_max) ; y_min]) ;
        end
    else
        x_max = max([handles.groups(group_idx).plot_prop.x_max*1e9 ; x_max]) ;
        if ~manual_y_max
            y_max = max([handles.groups(group_idx).plot_prop.y_max*1e9 ; y_max]) ;
        end
        if ~manual_y_min
            y_min = min([handles.groups(group_idx).plot_prop.y_min*1e9 ; y_min]) ;
        end
    end

    if plots(1)
        y = ySign_plotScale(handles, y) ;
        plot(x, y,...
            'Color', handles.groups(group_idx).color,...
                        'LineStyle', '-',...
                        'Marker', '.',...
                        'MarkerSize', 3,...
                        'DisplayName', handles.groups(group_idx).obj.name);
    end

    if plots(2)
        if isfield(handles.groups, 'movemean')
            if ~isempty(handles.groups(group_idx).movemean)
                y = handles.groups(group_idx).movemean.force_app*1e9 ;
                y = ySign_plotScale(handles, y) ;
                h = plot(x, y,...
                    'Color', handles.groups(group_idx).color,...
                                'LineStyle', '-',...
                                'Marker', 'none',...
                                'MarkerSize', 3) ;
                h.Annotation.LegendInformation.IconDisplayStyle = 'off';
            end
        end
    end
    
    if plots(3)
        if isfield(handles.groups, 'aligned')
            if ~isempty(handles.groups(group_idx).aligned)
                y = handles.groups(group_idx).aligned.force_app*1e9 ;
                y = ySign_plotScale(handles, y) ;
                h = plot(x, y,...
                    'Color', handles.groups(group_idx).color,...
                                'LineStyle', '-',...
                                'Marker', 'none',...
                                'MarkerSize', 3) ;
                h.Annotation.LegendInformation.IconDisplayStyle = 'off';
            end
        end
    end
    
    if plots(4) %fits
        if isfield(handles.groups, 'fit_DLVOExact')
            if ~isempty(handles.groups(group_idx).fit_DLVOExact)
                y = handles.groups(group_idx).fit_DLVOExact.y ;
                y = ySign_plotScale(handles, y) ;
                    h =  plot(handles.groups(group_idx).fit_DLVOExact.x, y,...
                'Color', handles.groups(group_idx).color,...
                            'LineStyle', '-.',...
                            'Marker', 'none',...
                            'MarkerSize', 3) ;
                        h.Annotation.LegendInformation.IconDisplayStyle = 'off';
                if length(selected_groups) == 1 && isfield(handles.groups(group_idx).fit_DLVOExact, 'text')
                    fit_str =  [fit_str ; handles.groups(group_idx).fit_DLVOExact.text ; '-'] ;
                end
            end
        end
        
        if isfield(handles.groups, 'fit_DLVO')
            if ~isempty(handles.groups(group_idx).fit_DLVO)
                y = handles.groups(group_idx).fit_DLVO.y ;
                y = ySign_plotScale(handles, y) ;
                       h =  plot(handles.groups(group_idx).fit_DLVO.x, y,...
                'Color', handles.groups(group_idx).color,...
                            'LineStyle', '-.',...
                            'Marker', 'none',...
                            'MarkerSize', 3) ;
                        h.Annotation.LegendInformation.IconDisplayStyle = 'off';
                if length(selected_groups) == 1 && isfield(handles.groups(group_idx).fit_DLVO, 'text')
                    fit_str =  [fit_str ; handles.groups(group_idx).fit_DLVO.text ; '-'] ;
                end
            end
        end
        
        if isfield(handles.groups, 'fit_eve')
            if ~isempty(handles.groups(group_idx).fit_eve)
                y = handles.groups(group_idx).fit_eve.y ;
                y = ySign_plotScale(handles, y) ;
                       h =  plot(handles.groups(group_idx).fit_eve.x, y,...
                'Color', handles.groups(group_idx).color,...
                            'LineStyle', '--',...
                            'Marker', 'none',...
                            'MarkerSize', 3) ;
                        h.Annotation.LegendInformation.IconDisplayStyle = 'off';
                if length(selected_groups) == 1
                   fit_str = [fit_str ; handles.groups(group_idx).fit_eve.text; ''] ;
                end
            end
        end
    end


    if plots(5)
        for j = 1:length(handles.groups(group_idx).obj.forces)
            x = handles.groups(group_idx).obj.forces(j).obj.sep_app*1e9 ;
            y = handles.groups(group_idx).obj.forces(j).obj.force_app*1e9 ;
            y = ySign_plotScale(handles, y) ;
            h = plot(x, y,...
                'Color', handles.groups(group_idx).color,...
                            'LineStyle', 'none',...
                            'Marker', '.',...
                            'MarkerSize', 3) ;
            h.Annotation.LegendInformation.IconDisplayStyle = 'off';
        end

    end
end

    if length(handles.selected_groups) == 1 &&  isfield(handles.groups(group_idx), 'charge_cal')
        if ~isempty(handles.groups(group_idx).charge_cal)
            fit_str = [fit_str ; handles.groups(group_idx).charge_cal.text ; ''] ;
        end
    end
    
handles.groups_fit_text.String = fit_str ;
        
x_lims = [x_min x_max] ;
y_lims = sort([y_min y_max]) ;

if ~isempty(handles.func_str_axes_right) && plots(6)
    try
        x = linspace(x_min, x_max, 1000) ;
        y = eval(handles.func_str_axes_right) ;
        y = ySign_plotScale(handles, y) ;
        plot(x, y, 'color', [0 0 0], 'LineWidth', 2, 'DisplayName', 'Input Function')
    catch
    end
end

hold off

if size(x_lims) == [1 2] 
    xlim(x_lims) ;
end

if size(y_lims) == [1 2] 
    ylim(y_lims)
end

legend_obj = legend('show') ;
set(legend_obj, 'Interpreter', 'none')
set(legend_obj, 'FontSize', 10)
guidata(handles.figure_main, handles) ;