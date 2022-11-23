function html_str = row_color_html(color)
% changes the row color of the selected row to the color in the RGB vector
% 'color'

% format color as: #FFFFFF
color255 = color*255;
colorString = sprintf('rgb(%.0f,%.0f,%.0f)', color255);

% apply formatting to selected rows
html_str = strcat(...
    '<html><span style="background-color: ', colorString, ';">',...
    {'..........'},...
    '</span></html>');

