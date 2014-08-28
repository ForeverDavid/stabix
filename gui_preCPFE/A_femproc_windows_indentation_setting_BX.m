% Copyright 2013 Max-Planck-Institut f�r Eisenforschung GmbH
function gui_handle = A_femproc_windows_indentation_setting_BX(gui_bicrystal, varargin) %'A_femproc_windows_indentation_setting_BX(0, guidata(gcf))');
%% Setting of indentation inputs (tip radius, indentation depth...) + setting of the mesh for a
% bicrystal indentation experiment.
% gui_bicrystal: handle of the Bicrystal GUI

% authors: d.mercier@mpie.de / c.zambaldi@mpie.de

%% Set Matlab
gui.config_Matlab = load_YAML_config_file;

%% Window Coordinates Configuration
scrsize = screenSize;    % Get screen size
WX = 0.58 * scrsize(3);  % X Position (bottom)
WY = 0.30 * scrsize(4);  % Y Position (left)
WW = 0.40 * scrsize(3);  % Width
WH = 0.60 * scrsize(4);  % Height

%% Window setting
gui_BX.handles.gui_BX_win = figure(...
    'NumberTitle', 'off',...
    'Position', [WX WY WW WH],...
    'ToolBar', 'figure');

%% Set Matlab and CPFEM configurations
if nargin == 0   
    [gui_BX.config_Matlab] = load_YAML_config_file;
    
    gui_BX.config_map.Sample_IDs   = [];
    gui_BX.config_map.Sample_ID    = [];
    gui_BX.config_map.Material_IDs = [];
    gui_BX.config_map.Material_ID  = [];
    gui_BX.config_map.default_grain_file_type2 = 'random_GF2data.txt';
    gui_BX.config_map.default_reconstructed_boundaries_file = 'random_RBdata.txt';
    gui_BX.config_map.imported_YAML_GB_config_file = 'config_gui_BX_example.yaml';
    
    guidata(gcf, gui_BX);
    femproc_load_YAML_BX_config_file(gui_BX.config_map.imported_YAML_GB_config_file, 2);
    gui_BX = guidata(gcf); guidata(gcf, gui_BX);
    gui_BX.GB.active_data = 'BX';
    gui_BX.GB.activeGrain = gui_BX.GB.GrainA;
    gui_BX.handles.gui_BX_title = strcat('Setting of indentation for random bicrystal', ' - version_', num2str(gui.config_Matlab.version_toolbox));
    
else
    gui_BX.flag           = gui_bicrystal.flag;
    gui_BX.config_map     = gui_bicrystal.config_map;
    gui_BX.config_Matlab  = gui_bicrystal.config_Matlab;
    gui_BX.GB             = gui_bicrystal.GB;
    gui_BX.GB.active_data = 'BX';
    gui_BX.handles.gui_BX_title = strcat('Setting of indentation for bicrystal n�', num2str(gui_BX.GB.GB_Number), ' - version_', num2str(gui.config_Matlab.version_toolbox));
end
guidata(gcf, gui_BX);

set(gui_BX.handles.gui_BX_win, 'Name', gui_BX.handles.gui_BX_title);

%% Set path for documentation and initialization
format compact;

if ismac || isunix
    gui_BX.config_map.path_picture_BXind = '../doc/_pictures/Schemes_SlipTransmission/BX_indentation_mesh_example.png/';
else
    gui_BX.config_map.path_picture_BXind = '..\doc\_pictures\Schemes_SlipTransmission\BX_indentation_mesh_example.png';
end

%% Customized menu
femproc_custom_menu_BX;

%% Plot the mesh axis
gui_BX.handles.hax = axes('Units', 'normalized',...
    'position', [0.5 0.05 0.45 0.9],...
    'Visible', 'off');

%% Initialization of variables
gui_BX.variables.coneAngle_init        = 90; % Angle of cono-spherical indenter (in �)
gui_BX.variables.tipRadius_init        = 1; % Radius of cono-spherical indenter (in �m)
gui_BX.variables.h_indent_init         = 0.3; % Depth of indentation (in �m)
gui_BX.variables.w_sample_init         = 4;
gui_BX.variables.h_sample_init         = 4;
gui_BX.variables.len_sample_init       = 6;
gui_BX.variables.inclination_init      = gui_BX.GB.GB_Inclination; % GB inclination (in �)
gui_BX.variables.ind_dist_init         = 1;
gui_BX.variables.box_elm_nx_init       = 6;
gui_BX.variables.box_elm_nz_init       = 6;
gui_BX.variables.box_elm_ny1_init      = 6;
gui_BX.variables.box_elm_ny2_fac_init  = 7;
gui_BX.variables.box_elm_ny3_init      = 6;
gui_BX.variables.box_bias_x_init       = 0.2;
gui_BX.variables.box_bias_z_init       = 0.25;
gui_BX.variables.box_bias_y1_init      = 0.3;
gui_BX.variables.box_bias_y2_init      = 0;
gui_BX.variables.box_bias_y3_init      = 0.3;
gui_BX.variables.mesh_quality_lvl_init = 1;

%% Creation of string boxes and edit boxes to set indenter and indentation properties
[gui_BX.handles.coneAngle_str, gui_BX.handles.coneAngle_val]        = femproc_set_inputs_boxes({'Full Angle of conical indenter (�)'}, [0.025 0.965 0.28 0.025],gui_BX.variables.coneAngle_init, 'femproc_indentation_setting_BX');
[gui_BX.handles.tipRadius_str, gui_BX.handles.tipRadius_val]        = femproc_set_inputs_boxes({'Tip radius of indenter (�m)'}, [0.025 0.935 0.28 0.025],gui_BX.variables.tipRadius_init, 'femproc_indentation_setting_BX');
[gui_BX.handles.h_indent_str, gui_BX.handles.h_indent_val]          = femproc_set_inputs_boxes({'abs(indentation depth) (�m)'}, [0.025 0.905 0.28 0.025],gui_BX.variables.h_indent_init, 'femproc_indentation_setting_BX');
[gui_BX.handles.w_sample_str, gui_BX.handles.w_sample_val]          = femproc_set_inputs_boxes({'w_sample (�m)'}, [0.025 0.875 0.28 0.025],gui_BX.variables.w_sample_init, 'femproc_indentation_setting_BX');
[gui_BX.handles.h_sample_str, gui_BX.handles.h_sample_val]          = femproc_set_inputs_boxes({'h_sample (�m)'}, [0.025 0.845 0.28 0.025],gui_BX.variables.h_sample_init, 'femproc_indentation_setting_BX');
[gui_BX.handles.len_sample_str, gui_BX.handles.len_sample_val]      = femproc_set_inputs_boxes({'len_sample (�m)'}, [0.025 0.815 0.28 0.025],gui_BX.variables.len_sample_init, 'femproc_indentation_setting_BX');
[gui_BX.handles.inclination_str, gui_BX.handles.inclination_val]    = femproc_set_inputs_boxes({'Inclination (�)'}, [0.025 0.785 0.28 0.025],gui_BX.variables.inclination_init, 'femproc_indentation_setting_BX');
[gui_BX.handles.ind_dist_str, gui_BX.handles.ind_dist_val]          = femproc_set_inputs_boxes({'Distance GB-indent (�m)'}, [0.025 0.755 0.28 0.025],gui_BX.variables.ind_dist_init, 'femproc_indentation_setting_BX');
% txt boxes for subdivision
[gui_BX.handles.box_elm_nx_str, gui_BX.handles.box_elm_nx_val]      = femproc_set_inputs_boxes({'box_elm_nx'}, [0.025 0.725 0.28 0.025],gui_BX.variables.box_elm_nx_init, 'femproc_indentation_setting_BX');
[gui_BX.handles.box_elm_nz_str, gui_BX.handles.box_elm_nz_val]      = femproc_set_inputs_boxes({'box_elm_nz'}, [0.025 0.695 0.28 0.025],gui_BX.variables.box_elm_nz_init, 'femproc_indentation_setting_BX');
[gui_BX.handles.box_elm_ny1_str, gui_BX.handles.box_elm_ny1_val]    = femproc_set_inputs_boxes({'box_elm_ny1'}, [0.025 0.665 0.28 0.025],gui_BX.variables.box_elm_ny1_init, 'femproc_indentation_setting_BX');
[gui_BX.handles.box_elm_ny2_fac_str, gui_BX.handles.box_elm_ny2_fac_val]    = femproc_set_inputs_boxes({'box_elm_ny2_fac'}, [0.025 0.635 0.28 0.025],gui_BX.variables.box_elm_ny2_fac_init, 'femproc_indentation_setting_BX');
[gui_BX.handles.box_elm_ny3_str, gui_BX.handles.box_elm_ny3_val]    = femproc_set_inputs_boxes({'box_elm_ny3'}, [0.025 0.605 0.28 0.025],gui_BX.variables.box_elm_ny3_init, 'femproc_indentation_setting_BX');
[gui_BX.handles.mesh_quality_lvl_str, gui_BX.handles.mesh_quality_lvl_val]  = femproc_set_inputs_boxes({'lvl (mesh quality)'}, [0.025 0.575 0.28 0.025],gui_BX.variables.mesh_quality_lvl_init, 'femproc_indentation_setting_BX');
% txt boxes for bias
[gui_BX.handles.box_bias_x1_str, gui_BX.handles.box_bias_x_val]     = femproc_set_inputs_boxes({'box_bias_x (-0.5 to 0.5)'}, [0.025 0.545 0.28 0.025],gui_BX.variables.box_bias_x_init, 'femproc_indentation_setting_BX');
[gui_BX.handles.box_bias_z1_str, gui_BX.handles.box_bias_z_val]     = femproc_set_inputs_boxes({'box_bias_z (-0.5 to 0.5)'}, [0.025 0.515 0.28 0.025],gui_BX.variables.box_bias_z_init, 'femproc_indentation_setting_BX');
[gui_BX.handles.box_bias_y1_str, gui_BX.handles.box_bias_y1_val]    = femproc_set_inputs_boxes({'box_bias_y1 (-0.5 to 0.5)'}, [0.025 0.485 0.28 0.025],gui_BX.variables.box_bias_y1_init, 'femproc_indentation_setting_BX');
[gui_BX.handles.box_bias_x2_str, gui_BX.handles.box_bias_y2_val]    = femproc_set_inputs_boxes({'box_bias_y2 (-0.5 to 0.5)'}, [0.025 0.455 0.28 0.025],gui_BX.variables.box_bias_y2_init, 'femproc_indentation_setting_BX');
[gui_BX.handles.box_bias_z3_str, gui_BX.handles.box_bias_y3_val]    = femproc_set_inputs_boxes({'box_bias_y3 (-0.5 to 0.5)'}, [0.025 0.425 0.28 0.025],gui_BX.variables.box_bias_y3_init, 'femproc_indentation_setting_BX');

%% Pop-up menu to set the mesh quality
gui_BX.handles.pm_mesh_quality = uicontrol('Parent', gui_BX.handles.gui_BX_win,...
    'Units', 'normalized',...
    'Position', [0.025 0.37 0.18 0.05],...
    'Style', 'popup',...
    'String', {'Free mesh'; 'Coarse mesh'; 'Fine mesh'; 'Very fine mesh'; 'Ultra fine mesh'},...
    'BackgroundColor', [0.9 0.9 0.9],...
    'FontWeight', 'bold',...
    'FontSize', 10,...
    'HorizontalAlignment', 'center',...
    'Value', 2,...
    'Callback', 'femproc_indentation_setting_BX');

%% Pop-up menu to set FEM software
gui_BX.handles.pm_FEM_interface = uicontrol('Parent', gui_BX.handles.gui_BX_win,...
    'Units', 'normalized',...
    'Position', [0.21 0.37 0.18 0.05],...
    'Style', 'popup',...
    'String', {'Mentat_2008'; 'Mentat_2010'; 'Mentat_2012'; 'Mentat_2013'; 'Mentat_2013.1'},...
    'BackgroundColor', [0.9 0.9 0.9],...
    'FontWeight', 'bold',...
    'FontSize', 10,...
    'HorizontalAlignment', 'center');

%% Checkbox to plot deformed indenter
gui_BX.handles.cb_indenter_post_indentation = uicontrol('Parent', gui_BX.handles.gui_BX_win,...
    'Units', 'normalized',...
    'Position', [0.025 0.31 0.32 0.05],...
    'Style', 'checkbox',...
    'String', 'Plot indenter after indentation',...
    'BackgroundColor', [0.9 0.9 0.9],...
    'FontWeight', 'bold',...
    'FontSize', 10,...
    'HorizontalAlignment', 'center',...
    'Callback', 'femproc_indentation_setting_BX');

%% Button to give picture of the mesh with names of dimensions use to describe the sample and the mesh
gui_BX.handles.pb_mesh_example = uicontrol('Parent', gui_BX.handles.gui_BX_win,...
    'Units', 'normalized',...
    'Position', [0.1 0.25 0.18 0.05],...
    'Style', 'pushbutton',...
    'String', 'Mesh example',...
    'BackgroundColor',[0.9 0.9 0.9],...
    'FontWeight', 'bold',...
    'FontSize', 10,...
    'HorizontalAlignment', 'center',...
    'Callback', 'gui_BX = guidata(gcf); open_file_web(gui_BX.config_map.path_picture_BXind);');

%% Creation of string boxes and edit boxes for the calculation of the number of elements
gui_BX.handles.num_elem = uicontrol('Parent', gui_BX.handles.gui_BX_win,...
    'Units', 'normalized',...
    'Position', [0.05 0.19 0.28 0.04],...
    'Style', 'text',...
    'String', '',...
    'BackgroundColor', [0.9 0.9 0.9],...
    'HorizontalAlignment', 'center',...
    'FontWeight', 'bold',...
    'FontSize', 14);

%% Creation of string boxes and edit boxes for the calculation of the number of elements
gui_BX.handles.trans_depth = uicontrol('Parent', gui_BX.handles.gui_BX_win,...
    'Units', 'normalized',...
    'Position', [0.05 0.13 0.28 0.04],...
    'Style', 'text',...
    'String', '',...
    'BackgroundColor', [0.9 0.9 0.9],...
    'HorizontalAlignment', 'center',...
    'FontWeight', 'bold');

%% Button to validate the mesh and for the creation of procedure and material files
gui_BX.handles.pb_CPFEM_model = uicontrol('Parent', gui_BX.handles.gui_BX_win,...
    'Units', 'normalized',...
    'Position', [0.05 0.06 0.28 0.05],...
    'Style', 'pushbutton',...
    'String', 'CPFE  model',...
    'BackgroundColor', [0.2 0.8 0],...
    'FontWeight', 'bold',...
    'FontSize', 10,...
    'HorizontalAlignment', 'center',...
    'Callback', 'femproc_generate_indentation_model_BX');

%% Set the GUI with a YAML file
guidata(gcf, gui_BX);
config_CPFEM_YAML_file = sprintf('config_CPFEM_%s.yaml', gui_BX.config_Matlab.username);
femproc_load_YAML_CPFEM_config_file(config_CPFEM_YAML_file, 2);
gui_BX = guidata(gcf); guidata(gcf, gui_BX);

if isfield(gui_BX.config_CPFEM, 'fem_software')
    femproc_set_cpfem_interface_pm(gui_BX.handles.pm_FEM_interface, gui_BX.config_CPFEM.fem_software);
else
    femproc_set_cpfem_interface_pm(gui_BX.handles.pm_FEM_interface);
end

%% Pop-up menu to set the mesh quality
gui_BX.handles.pm_mesh_color_title = uicontrol('Parent', gui_BX.handles.gui_BX_win,...
    'Units', 'normalized',...
    'Position', [0.6 0.9525 0.2 0.035],...
    'Style', 'text',...
    'String', 'Color of the BX:',...
    'BackgroundColor', [0.9 0.9 0.9],...
    'HorizontalAlignment', 'center',...
    'FontWeight', 'bold');

gui_BX.handles.pm_mesh_color = uicontrol('Parent', gui_BX.handles.gui_BX_win,...
    'Units', 'normalized',...
    'Position', [0.8 0.94 0.18 0.05],...
    'Style', 'popup',...
    'String', {'Color'; 'Black and White'},...
    'BackgroundColor', [0.9 0.9 0.9],...
    'FontWeight', 'bold',...
    'FontSize', 10,...
    'HorizontalAlignment', 'center',...
    'Value', 1,...
    'Callback', 'femproc_indentation_setting_BX');

%% Set GUI handle encapsulation
guidata(gcf, gui_BX);

%% Run the plot of the meshing
femproc_indentation_setting_BX;
gui_BX = guidata(gcf); guidata(gcf, gui_BX);

gui_handle = gui_BX.handles.gui_BX_win;

end
