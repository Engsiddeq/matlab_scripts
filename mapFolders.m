% Get folder paths from user
main_proj_path ="C:\Users\akamalsi\Desktop\proj6147_stellantis_ram_rl_mbse - Copy\01_SRC\05_Components\COMP_THERMAL_MANAGEMENT";
template_path  ="C:\Users\akamalsi\Desktop\Template_Project";

% Create containers.Map object to store the mapping results
mapping_results = containers.Map;
% Loop through each folder in the main project folder
main_proj_folders = dir(main_proj_path);
for i = 3:length(main_proj_folders)
    main_folder_name = main_proj_folders(i).name;
    main_folder_path = fullfile(main_proj_folders(i).folder, main_folder_name);
    
    % Remove the number and underscore from the beginning of the folder name
    main_folder_name = main_folder_name(4:end);
    
    % Loop through each folder and subfolder in the template folder
    template_folders = dir(template_path);
    for j = 3:length(template_folders)
        template_folder_name = template_folders(j).name;
        template_folder_path = fullfile(template_folders(j).folder, template_folder_name);
        
        % Remove the number and underscore from the beginning of the folder name
        template_folder_name = template_folder_name(4:end);
        
        % Compare the main folder name and template folder name
        if strcmpi(main_folder_name, template_folder_name)
            % Map the folder in the main project to its corresponding folder in the template folder
            mapping_results(main_folder_path) = template_folder_path;
            break;
        else
            % Loop through each subfolder in the current template folder
            template_subfolders = dir(template_folder_path);
            for k = 3:length(template_subfolders)
                template_subfolder_name = template_subfolders(k).name;
                template_subfolder_path = fullfile(template_subfolders(k).folder, template_subfolder_name);
                
                % Remove the number and underscore from the beginning of the folder name
                template_subfolder_name = template_subfolder_name(4:end);
                
                % Compare the main folder name and template subfolder name
                if strcmpi(main_folder_name, template_subfolder_name)
                    % Map the folder in the main project to its corresponding folder in the template folder
                    mapping_results(main_folder_path) = template_subfolder_path;
                    break;
                end
            end
        end
    end
    
    % If no match is found, prompt the user to manually map the folder
    if ~isKey(mapping_results, main_folder_path)
        message = sprintf('Please select the template folder path for the main project folder:\n%s', main_folder_name);
        mapping_results(main_folder_path) = uigetdir('',message);

    end
end
% Create a cell array to store the mapping results
mapping_results_table = {'Main Project Folder', 'Template Folder'};
keys = mapping_results.keys;
values = mapping_results.values;
for i = 1:length(keys)
    main_folder_path = keys{i};
    template_folder_path = values{i};
    
    % Shorten the folder paths
    main_folder_path_short = shorten_path(main_folder_path, main_proj_path);
    template_folder_path_short = shorten_path(template_folder_path, template_path);
    
    mapping_results_table = [mapping_results_table; {main_folder_path_short, template_folder_path_short}];
end



% Create a GUI window to display the mapping results
fig = uifigure('Name','Folder Mapping Results','Position',[100 100 600 400]);

table = uitable(fig,'Data',mapping_results_table,...
    'Position',[10 10 580 380],'ColumnWidth',{260, 260},'ColumnName',{'Main Project Folder','Template Folder'},'ColumnEditable',[false false]);

% Set the font size of the table
table.FontSize = 12;

% Helper function to shorten folder path
function short_path = shorten_path(full_path, root_path)
    % Remove the root path from the beginning of the full path
    rel_path = full_path(length(root_path)+2:end);
    
    % Split the path into parts
    parts = split(rel_path, filesep);
    
    % Keep only the last two parts
    parts = parts(end-1:end);
    
    % Combine the parts into a shortened path
    short_path = fullfile('...', parts{1}, parts{2});
end
