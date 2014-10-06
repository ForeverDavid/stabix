% Copyright 2013 Max-Planck-Institut f�r Eisenforschung GmbH
function gui_handle = A_femproc_windows_indentation_setting_SX(gui_bicrystal, activeGrain, varargin)
%% Setting of indentation inputs (tip radius, indentation depth...) + setting of the mesh for a
% single crystal indentation experiment.
% gui_bicrystal: Handle of the Bicrystal GUI
% activeGrain: Number of the active grain in the Bicrystal

% authors: d.mercier@mpie.de / c.zambaldi@mpie.de

%% Initialization
gui_SX = femproc_init;

x0 = 0.02;
hu = 0.05; % height unit
wu = 0.1; % width unit

%% Window setting
gui_SX.handles.gui_SX_win = figure(...
    'NumberTitle', 'off',...
    'Position', femproc_figure_position([.58, .30, .6, .9]), ... % [left, bottom, width, height/width]
    'ToolBar', 'figure');
guidata(gcf, gui_SX);

gui_SX.description = 'Indentation of a single crystal - ';

%% Set Matlab and CPFEM configurations
if nargin == 0  
    [gui_SX.config] = load_YAML_config_file;
    
    gui_SX.config_map.Sample_IDs   = [];
    gui_SX.config_map.Sample_ID    = [];
    gui_SX.config_map.Material_IDs = [];
    gui_SX.config_map.Material_ID  = [];
    gui_SX.config_map.default_grain_file_type2 = 'random_GF2data.txt';
    gui_SX.config_map.default_reconstructed_boundaries_file = 'random_RBdata.txt';
    gui_SX.config_map.imported_YAML_GB_config_file = 'config_gui_BX_default.yaml';
    
    guidata(gcf, gui_SX);
    femproc_load_YAML_BX_config_file(gui_SX.config_map.imported_YAML_GB_config_file, 1);
    gui_SX = guidata(gcf); guidata(gcf, gui_SX);
    gui_SX.GB.active_data = 'SX';
    gui_SX.title_str = set_gui_title(gui_SX, '');
    
else
    gui_SX.flag           = gui_bicrystal.flag;
    gui_SX.config_map     = gui_bicrystal.config_map;
    gui_SX.config         = gui_bicrystal.config;
    gui_SX.GB             = gui_bicrystal.GB;
    gui_SX.GB.active_data = 'SX';
    if activeGrain == 1
        gui_SX.GB.activeGrain     = gui_SX.GB.GrainA;
    elseif activeGrain == 2
        gui_SX.GB.activeGrain     = gui_SX.GB.GrainB;
    end
    gui_SX.title_str = set_gui_title(gui_SX, ['Crystal n�', num2str(gui_SX.GB.activeGrain)]);
end
guidata(gcf, gui_SX);

%% Customized menu
gui_SX.custom_menu = femproc_custom_menu(gui_SX.module_name);
femproc_custom_menu_SX(gui_SX.custom_menu);

%% Plot the mesh axis
gui_SX.handles.hax = axes('Units', 'normalized',...
    'position', [0.5 0.05 0.49 0.9],...
    'Visible', 'off');

%% Initialization of variables
gui_SX.defaults.variables = ReadYaml('config_mesh_SX_defaults.yaml');

%% Creation of string boxes and edit boxes to set indenter and indentation properties
gui_SX.handles.mesh = femproc_mesh_parameters_SX(gui_SX.defaults);

%% Pop-up menu to set the mesh quality
gui_SX.handles.pm_mesh_quality = uicontrol('Parent', gui_SX.handles.gui_SX_win,...
    'Units', 'normalized',...
    'Position', [x0 0.44 wu*2 hu],...
    'Style', 'popup',...
    'String', {'Free mesh'; 'Coarse mesh'; 'Fine mesh'; 'Very fine mesh'; 'Ultra fine mesh'},...
    'BackgroundColor', [0.9 0.9 0.9],...
    'FontWeight', 'bold',...
    'FontSize', 10,...
    'HorizontalAlignment', 'center',...
    'Value', 3,...
    'Callback', 'femproc_indentation_setting_SX');

%% Pop-up menu to set FEM software
gui_SX.handles.pm_FEM_interface = uicontrol('Parent', gui_SX.handles.gui_SX_win,...
    'Units', 'normalized',...
    'Position', [x0+2*wu 0.44 wu*2 hu],...
    'Style', 'popup',...
    'String', gui_SX.defaults.fem_solvers,...
    'BackgroundColor', [0.9 0.9 0.9],...
    'FontWeight', 'bold',...
    'FontSize', 10,...
    'HorizontalAlignment', 'center');

if isfield(gui_SX.defaults, 'fem_solver_used')
    femproc_set_cpfem_interface_pm(gui_SX.handles.pm_FEM_interface, gui_SX.defaults.fem_solvers, gui_SX.defaults.fem_solver_used);
else
    femproc_set_cpfem_interface_pm(gui_SX.handles.pm_FEM_interface, gui_SX.defaults.fem_solvers);
end

%% Button to give picture of the mesh with names of dimensions use to describe the sample and the mesh
gui_SX.handles.pb_mesh_example = uicontrol('Parent', gui_SX.handles.gui_SX_win,...
    'Units','normalized',...
    'Position', [x0 0.38 wu*2 hu],...
    'Style', 'pushbutton',...
    'String', 'Mesh layout',...
    'BackgroundColor', [0.9 0.9 0.9],...
    'FontWeight', 'bold',...
    'FontSize', 10,...
    'HorizontalAlignment', 'center',...
    'Callback', 'gui_SX = guidata(gcf); webbrowser(fullfile(gui_SX.config.doc_path_root, gui_SX.config.doc_path_SXind_png));');

%% Creation of string boxes and edit boxes for the calculation of the number of elements
gui_SX.handles.num_elem = uicontrol('Parent', gui_SX.handles.gui_SX_win,...
    'Units', 'normalized',...
    'Position', [x0 0.32 wu*3 hu],...
    'Style', 'text',...
    'String', '',...
    'BackgroundColor', [0.9 0.9 0.9],...
    'HorizontalAlignment', 'center',...
    'FontWeight', 'bold',...
    'FontSize', 10);

%% Creation of string boxes and edit boxes for the calculation of the transition depth
gui_SX.handles.trans_depth = uicontrol('Parent', gui_SX.handles.gui_SX_win,...
    'Units', 'normalized',...
    'Position', [x0 0.25 wu*3 hu],...
    'Style', 'text',...
    'String', 'Transition depth',...
    'BackgroundColor', [0.9 0.9 0.9],...
    'HorizontalAlignment', 'center',...
    'FontWeight', 'bold','FontSize', 10);

%% Button to validate the mesh and for the creation of procedure and material files
gui_SX.handles.pb_CPFEM_model = uicontrol('Parent', gui_SX.handles.gui_SX_win,...
    'Units', 'normalized',...
    'Position', [x0 hu*2 wu*3 hu],...
    'Style', 'pushbutton',...
    'String', 'CPFE  model',...
    'BackgroundColor', [0.2 0.8 0],...
    'FontWeight', 'bold',...
    'FontSize', 10,...
    'HorizontalAlignment', 'center',...
    'Callback', 'femproc_indentation_setting_SX');

%%
pythons = {gui_SX.config_CPFEM.python.location, gui_SX.config_CPFEM.python.which{:}};
gui_SX.handles.pm_Python = uicontrol( ...
    'Units', 'normalized',...
    'Position', [x0 hu*3 wu*3 hu],...
    'Style', 'popup', ...  'String', python.which{'Select python', 'python1', 'py2'},... % pythons should be found in femproc_init
    'String', pythons, ...
    'BackgroundColor', [0.9 0.9 0.9],...
    'FontWeight', 'bold',...
    'FontSize', 10,...
    'HorizontalAlignment', 'center', ...
    'Callback', 'femproc_python_select');

%% Set GUI handle encapsulation
guidata(gcf, gui_SX);

%% Run the plot of the meshing
femproc_indentation_setting_SX;
gui_SX = guidata(gcf); guidata(gcf, gui_SX);

gui_handle = gui_SX.handles.gui_SX_win;

end
