function s =  create_header_struct(header_cell)
    for i = 1:size(header_cell, 1)
        field_name = header_cell{i,1} ;
        if strcmp(field_name,'')
            continue
        end
        field_name = regexprep(field_name, '[^a-zA-Z0-9_]', '_');
        s.(field_name) = header_cell{i,2} ;
    end
        