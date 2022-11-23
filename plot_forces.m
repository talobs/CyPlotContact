function plot_forces(handles)
axes(handles.axes_left)
cla() ;

x_min = [] ;
x_max = [] ;
y_min = [] ;
y_max = [] ;

channel_bg_selection = get(handles.left_axes_channel,'SelectedObject') ;
switch get(channel_bg_selection,'Tag') 
    case 'deflection'
        hold on
        for i = 1:length(handles.selected_forces)
            force_idx = handles.selected_forces(i) ;
            x = handles.forces(force_idx).obj.Zsnsr_app*1e9 ;
            y = handles.forces(force_idx).obj.Defl_app*1e9 ;
            x_min = min([x ; x_min]) ;
            x_max = max([x ; x_max]) ;
            y_min = min([y ; y_min]) ;
            y_max = max([y ; y_max]) ;
            plot(x, y,...
                'Color', handles.forces(force_idx).color,...
                            'LineStyle', 'none',...
                            'Marker', '.',...
                            'MarkerSize', 3);
        end
        hold off
        xlabel('Z [nm]')
        ylabel('Deflection [nm]')
        
            x_lims = [x_min x_max] ;
            y_lims = sort([y_min y_max]) ;
            
            if ~isempty(x_lims)
                xlim(x_lims) ;
            end
            
            if ~isempty(y_lims)
                ylim(y_lims)
            end
            
    case 'force'
        
        hold on
        x_min = 0 ;
        
        if handles.axes_left_x_lim_checkox.Value
            x_max = str2num(handles.axes_left_x_lim.String) ;
        end
        
        if isempty(x_max)
            manual_x_lim = false ;
        else
            manual_x_lim = true ;
        end
        
        if handles.y_lim_left_checkbox.Value
            y_max = str2num(handles.y_lim_left_edit.String) ;
        end
        
        if isempty(y_max)
            manual_y_lim = false ;
        else
            manual_y_lim = true ;
        end
        
        for i = 1:length(handles.selected_forces)
            
            if isempty(handles.forces(handles.selected_forces(i)).obj.sep_app) || isempty(handles.forces(handles.selected_forces(i)).obj.sep_app)
                continue ;
            end
            
            force_idx = handles.selected_forces(i) ;
            x = handles.forces(force_idx).obj.sep_app*1e9 ;
            y = handles.forces(force_idx).obj.force_app*1e9 ;
            abcd_idx = handles.forces(force_idx).obj.abcd_idx_app ;
            abcd_val = handles.forces(force_idx).obj.abcd_val_app*1e9 ;

            if manual_x_lim
                [~, sep_idx_at_x_min] = min(abs(x-x_min)) ;
                [~, sep_idx_at_x_max] = min(abs(x-x_max)) ;
                y_min = min([y(sep_idx_at_x_max:sep_idx_at_x_min) ; y_min]) ;
                if ~manual_y_lim
                    y_max = max([y(sep_idx_at_x_max:sep_idx_at_x_min) ; y_max]) ;
                end
            else
                x_max = max([x(1) ; x_max]) ;
                y_min = min([y(:) ; y_min]) ;
                if ~manual_y_lim
                    y_max = max([y(end) ; y_max]) ;
                end
            end
            
            plot(x, y,...
                'Color', handles.forces(force_idx).color,...
                            'LineStyle', 'none',...
                            'Marker', '.',...
                            'MarkerSize', 3);
        end
        
        hold off
        xlabel('Separation [nm]')
        ylabel('Force [nN]')

            x_lims = [x_min x_max] ;
            y_lims = sort([y_min y_max]) ;
            
            if size(x_lims) == [1 2] ;
                xlim(x_lims) ;
            end
            
            if size(y_lims) == [1 2] ;
                ylim(y_lims)
            end
end
    