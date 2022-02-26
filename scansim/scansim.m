function varargout = scansim(varargin)
% SCANSIM M-file for scansim.fig
%      SCANSIM, by itself, creates a new SCANSIM or raises the existing
%      singleton*.
%
%      H = SCANSIM returns the handle to a new SCANSIM or the handle to
%      the existing singleton*.
%
%      SCANSIM('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SCANSIM.M with the given input arguments.
%
%      SCANSIM('Property','Value',...) creates a new SCANSIM or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before scansim_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to scansim_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help scansim

% Last Modified by GUIDE v2.5 06-Jul-2004 11:02:24

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @scansim_OpeningFcn, ...
                   'gui_OutputFcn',  @scansim_OutputFcn, ...
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

% --- Executes just before scansim is made visible.
function scansim_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to scansim (see VARARGIN)

% Choose default command line output for scansim
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

if strcmp(get(hObject,'Visible'),'off')
    initialize_gui(hObject, handles);
end

% UIWAIT makes scansim wait for user response (see UIRESUME)
% uiwait(handles.ScanSim);


% --- Outputs from this function are returned to the command line.
function varargout = scansim_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function initialize_gui(fig_handle, handles)

data = struct(...
	'Volumes', 100, ...
	'Slices', 30, ...
	'TRslices', 65, ...
	'TD', 0, ...
	'TRvolumes', 65*30 ...
);
set_gui_values(handles, data);
setappdata(handles.ScanSim, 'Running', 0);
cgloadlib;


function data = get_gui_values (handles)

data = getappdata(handles.ScanSim, 'data');


function set_gui_values(handles, data)

fn = fieldnames(data);
for f=fn'
	set(getfield(handles, f{1}), 'string', getfield(data, f{1}));
end
setappdata(handles.ScanSim, 'data', data);



% --- Executes during object creation, after setting all properties.
function Volumes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Volumes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function Volumes_Callback(hObject, eventdata, handles)
% hObject    handle to Volumes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Volumes as text
%        str2double(get(hObject,'String')) returns contents of Volumes as a double

data = get_gui_values(handles);
value = str2double(get(hObject,'String'));
if isfinite(value)
	value = max(floor(value),1);
	data.Volumes = value;
end
set_gui_values(handles, data);


% --- Executes during object creation, after setting all properties.
function Slices_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Slices (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function Slices_Callback(hObject, eventdata, handles)
% hObject    handle to Slices (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Slices as text
%        str2double(get(hObject,'String')) returns contents of Slices as a double

data = get_gui_values(handles);
value = str2double(get(hObject,'String'));
if isfinite(value)
	value = max(floor(value),1);
	data.Slices = value;
	data.TRvolumes = data.Slices * data.TRslices + data.TD;
end
set_gui_values(handles, data);


% --- Executes during object creation, after setting all properties.
function TRslices_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TRslices (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function TRslices_Callback(hObject, eventdata, handles)
% hObject    handle to TRslices (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of TRslices as text
%        str2double(get(hObject,'String')) returns contents of TRslices as a double

data = get_gui_values(handles);
value = str2double(get(hObject,'String'));
if isfinite(value)
	value = max(floor(value),65);
	data.TRslices = value;
	data.TRvolumes = data.Slices * data.TRslices + data.TD;
end
set_gui_values(handles, data);


% --- Executes during object creation, after setting all properties.
function TD_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function TD_Callback(hObject, eventdata, handles)
% hObject    handle to TD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of TD as text
%        str2double(get(hObject,'String')) returns contents of TD as a double

data = get_gui_values(handles);
value = str2double(get(hObject,'String'));
if isfinite(value)
	value = max(floor(value),0);
	data.TD = value;
	data.TRvolumes = data.Slices * data.TRslices + data.TD;
end
set_gui_values(handles, data);


% --- Executes during object creation, after setting all properties.
function TRvolumes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TRvolumes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function TRvolumes_Callback(hObject, eventdata, handles)
% hObject    handle to TRvolumes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of TRvolumes as text
%        str2double(get(hObject,'String')) returns contents of TRvolumes as a double

data = get_gui_values(handles);
value = str2double(get(hObject,'String'));
if isfinite(value)
	value = max(floor(value),65);
	data.Slices = min(floor(value / data.TRslices), data.Slices);
	data.TD = value - data.Slices * data.TRslices;
	data.TRvolumes = data.Slices * data.TRslices + data.TD;
end
set_gui_values(handles, data);


% --- Executes on button press in Close.
function Close_Callback(hObject, eventdata, handles)
% hObject    handle to Close (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if getappdata(handles.ScanSim, 'Running')
	return
end

delete(handles.ScanSim);


% --- Executes on button press in Run.
function Run_Callback(hObject, eventdata, handles)
% hObject    handle to Run (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if getappdata(handles.ScanSim, 'Running') == 1
	set(handles.Run, 'Enable', 'Off');
	setappdata(handles.ScanSim, 'Running', 2);
	return
elseif getappdata(handles.ScanSim, 'Running') == 2
	return
end

set(handles.Run, 'String', 'Stop');
setappdata(handles.ScanSim, 'Running', 1);
set([handles.Volumes, handles.Slices, handles.TRslices, handles.TD, handles.TRvolumes, handles.Close], 'Enable', 'Off');

fprintf('\n\n********** STARTING SCANNER SIMULATION **********\n');

data = get_gui_values(handles);

cgloadlib;

% Create a sound for the whole volume
load(fullfile(fileparts(which(mfilename)), mfilename));
volsound = zeros(1, round(data.TRvolumes * 11.025));
for i = 0:data.Slices-1
    j = round(i * data.TRslices * 11.025);
    volsound([1:length(sounddata)]+j) = sounddata;
end

% Initialize sounds and create sound buffer
cogsound('initialise')
sound = cogsound('create',length(volsound),'any',8,11025,1);
cogsound('setwave', sound, volsound);

% Initialize serial port
try
    serial = cogserial('open','com7');
catch
	serial = [];
	fprintf('WARNING: Serial port output not available\n');
end

% Set priority to high
priority = cogprocess('getpriority');
priorityclass = cogprocess('enumpriorities');
cogprocess('setpriority', priorityclass.high);

% Do the job
nsl = 1;
str = '';
cogstd('sgettime',0);
cogsound('play', sound, 1);
for v = 1:data.Volumes
	for s = 1:data.Slices
		if length(serial)
			cogserial('write', serial, [floor(nsl/256), mod(nsl,256)]);
		end
        fprintf(repmat(sprintf('\b'),1,length(str)));
        str = sprintf('Volume %d, slice %d (total %d)                  ', v, s, nsl);
        fprintf(str);
		nsl = nsl + 1;
		tnext = ((v-1)*data.TRvolumes + s*data.TRslices) / 1000;
		t = cogstd('sgettime', -1);
		while t < tnext
			t = cogstd('sgettime', -1);
		end
		drawnow;
		if getappdata(handles.ScanSim, 'Running') == 2
			break;
		end
	end
	if getappdata(handles.ScanSim, 'Running') == 2
		break;
	end

	if data.TD
		tnext = (v*data.TRvolumes) / 1000;
		t = cogstd('sgettime', -1);
		while t < tnext
			t = cogstd('sgettime', -1);
		end
	end
end
cogsound('stop', sound);

% Restore system
cogprocess('setpriority', priority);
cogsound('shutdown');
cogserial('close');

fprintf(repmat(sprintf('\b'),1,length(str)));
fprintf('Total %d volumes, %d slices                                     \n', v, nsl-1);
fprintf('**********  END OF SCANNER SIMULATION  **********\n\n');

setappdata(handles.ScanSim, 'Running', 0);
set(handles.Run, 'String', 'Run', 'Enable', 'On');
set([handles.Volumes, handles.Slices, handles.TRslices, handles.TD, handles.TRvolumes, handles.Close], 'Enable', 'On');
