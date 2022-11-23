function y = ySign_plotScale(handles, y)
if handles.plot_scale_right_log.Value || handles.plot_scale_right_loglog.Value
    y = abs(y) ;
end