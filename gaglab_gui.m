function varargout =gaglab_gui(varargin)
% GAGLAB_GUI M-file forgaglab_gui.fig
%      GAGLAB_GUI, by itself, creates a new GAGLAB_GUI or raises the existing
%      singleton*.
%
%      H = GAGLAB_GUI returns the handle to a new GAGLAB_GUI or the handle to
%      the existing singleton*.
%
%      GAGLAB_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GAGLAB_GUI.M with the given input arguments.
%
%      GAGLAB_GUI('Property','Value',...) creates a new GAGLAB_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI beforegaglab_gui_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed togaglab_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to helpgaglab_gui

% Last Modified by GUIDE v2.5 07-Nov-2012 11:50:19

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gaglab_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @gaglab_gui_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin & isstr(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% --- Executes just beforegaglab_gui is made visible.
function gaglab_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments togaglab_gui (see VARARGIN)

% Choose default command line output forgaglab_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

if strcmp(get(hObject,'Visible'),'off')
    initialize_gui(hObject, handles);
end

% --- Outputs from this function are returned to the command line.
function varargout =gaglab_gui_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = [];


function initialize_gui(fig_handle, handles)

movegui(fig_handle, 'northeast');
set(handles.EditExperiment, 'accelerator', 'e');
set(handles.Restart(2), 'accelerator', 'z');
set(handles.Run(2), 'accelerator', 'r');
set(handles.Quit, 'accelerator', 'q');
set(fig_handle, 'name', gaglabcmd('version'));

Restart_Callback(handles.Restart, [], handles);


% --- Executes during object creation, after setting all properties.
function Setup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Setup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes during object creation, after setting all properties.
function Experiment_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Experiment (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on selection change in Setup.
function Setup_Callback(hObject, eventdata, handles)
% hObject    handle to Setup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns Setup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Setup
contents = get(hObject,'String');
gaglabcmd('Setup', contents{get(hObject,'Value')});

% --- Executes on button press in Experiment.
function Experiment_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to Experiment (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

units = get(handles.GagLabWindow, 'units');
set(handles.GagLabWindow, 'units', 'pixels');
pos = get(handles.GagLabWindow, 'CurrentPoint');
set(handles.GagLabWindow, 'units', units);
set(handles.ExperimentList, 'Position', pos, 'Visible', 'on');

% --- Executes on selection change in Experiment.
function Experiment_Callback(hObject, eventdata, handles)
% hObject    handle to Experiment (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isempty(get(hObject, 'children'))
	Experiment_Select(handles.Experiment, get(hObject,'UserData'), get(hObject,'Tag'));
end

% --- Executes on selection change in Experiment.
function Experiment_Select(textbox, label, tag)

set(textbox, 'string', ['  ' label], 'userdata', tag);
gaglabcmd('Experiment', tag);

function Subject_Callback(hObject, eventdata, handles)
% hObject    handle to Subject (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Subject as text
%        str2double(get(hObject,'String')) returns contents of Subject as a double
gaglabcmd('Subject', get(hObject, 'String'));

function Parameter_Callback(hObject, eventdata, handles)
% hObject    handle to Parameter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Parameter as text
%        str2double(get(hObject,'String')) returns contents of Parameter as a double
x = get(hObject,'String');
v = str2num(x);
if isempty(v)
	v = x;
end
gaglabcmd('Parameters', v);

function Study_Callback(hObject, eventdata, handles)
% hObject    handle to Study (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Study as text
%        str2double(get(hObject,'String')) returns contents of Study as a double
gaglabcmd('Study', get(hObject, 'String'));

function Series_Callback(hObject, eventdata, handles)
% hObject    handle to Series (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Series as text
%        str2double(get(hObject,'String')) returns contents of Series as a double
gaglabcmd('Series', get(hObject, 'String'));

% --- Executes on button press in TestMode.
function TestMode_Callback(hObject, eventdata, handles)
% hObject    handle to TestMode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of TestMode
gaglabcmd('Set', 'TestMode', get(hObject,'Value'));

% --- Executes on button press in LogMode.
function LogMode_Callback(hObject, eventdata, handles)
% hObject    handle to LogMode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of LogMode
gaglabcmd('Set', 'LogMode', get(hObject,'Value'));


% --- Executes on button press in DumpScreen.
function DumpScreen_Callback(hObject, eventdata, handles)
% hObject    handle to DumpScreen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of DumpScreen
gaglabcmd('Set', 'DumpScreen', get(hObject,'Value'));


% --- Executes on button press in Restart.
function Restart_Callback(hObject, eventdata, handles)
% hObject    handle to Restart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

gaglabcmd('Restart');

set(handles.Setup, 'String', gaglabcmd('SetupList'), 'Value', 1);
Setup_Callback(handles.Setup, eventdata, handles);

[l,m] = gaglabcmd('ExperimentList');
delete(get(handles.ExperimentList, 'children'));
if isempty(l)
	set(handles.Experiment, 'String', 'none available');
	set(handles.Run, 'enable', 'off');
else
	for i=1:size(m,1)
		if ~isempty(m{i,1})
			Experiment_Select(handles.Experiment, m{i,1}, m{i,3});
			break;
		end
	end
	cbk = repmat('gaglab_gui(''Experiment_Callback'',gcbo,[],guidata(gcbo))', size(m,1), 1);
	h = makemenu(handles.ExperimentList, char(m(:,2)), cbk, char(m(:,3)));
	m(find(strcmp(m(:,2),'-')),:) = [];
	for i=1:length(h)
		set(h(i), 'userdata', m{i,1});
	end
	set(handles.Run, 'enable', 'on');
end

Subject_Callback(handles.Subject, eventdata, handles);
Parameter_Callback(handles.Parameter, eventdata, handles);
Study_Callback(handles.Study, eventdata, handles);
Series_Callback(handles.Series, eventdata, handles);
TestMode_Callback(handles.TestMode, eventdata, handles);
LogMode_Callback(handles.LogMode, eventdata, handles);
DumpScreen_Callback(handles.DumpScreen, eventdata, handles);

% --- Executes on button press in Run.
function Run_Callback(hObject, eventdata, handles)
% hObject    handle to Run (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

gaglabcmd('Run');
%Restart_Callback(handles.Restart, eventdata, handles);


% --------------------------------------------------------------------
function EditExperiment_Callback(hObject, eventdata, handles)
% hObject    handle to editexperiment (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

edit(get(handles.Experiment, 'userdata'));


% --------------------------------------------------------------------
function EditSetupScript_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[tmp,d] = gaglabcmd('SetupList');
contents = get(handles.Setup,'String');
edit(fullfile(d, contents{get(handles.Setup,'Value')}));


% --------------------------------------------------------------------
function Quit_Callback(hObject, eventdata, handles)
% hObject    handle to Quit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

close(handles.GagLabWindow);


% --------------------------------------------------------------------
function Test_Callback(hObject, eventdata, handles)
% hObject    handle to Test (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function ResponseKeys_Callback(hObject, eventdata, handles)
% hObject    handle to ResponseKeys (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

gaglabcmd test keys


% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

gaglabcmd test scanner


% --------------------------------------------------------------------
function sound_Callback(hObject, eventdata, handles)
% hObject    handle to sound (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

gaglabcmd test sound


% --------------------------------------------------------------------
function graphics_Callback(hObject, eventdata, handles)
% hObject    handle to graphics (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

gaglabcmd test graphics


% --------------------------------------------------------------------
function screen_Callback(hObject, eventdata, handles)
% hObject    handle to screen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

gaglabcmd test screen


% --------------------------------------------------------------------
function Untitled_2_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

eval(['!' fullfile(fileparts(which('gaglabcmd')),'private','UserPort.exe')]);


% --------------------------------------------------------------------
function ManageLibrary_Callback(hObject, eventdata, handles)
% hObject    handle to ManageLibrary (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

explib;

