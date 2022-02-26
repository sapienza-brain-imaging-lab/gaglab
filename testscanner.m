function varargout = testscanner(varargin)
% TESTSCANNER M-file for testscanner.fig
%      TESTSCANNER, by itself, creates a new TESTSCANNER or raises the existing
%      singleton*.
%
%      H = TESTSCANNER returns the handle to a new TESTSCANNER or the handle to
%      the existing singleton*.
%
%      TESTSCANNER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TESTSCANNER.M with the given input arguments.
%
%      TESTSCANNER('Property','Value',...) creates a new TESTSCANNER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before testscanner_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to testscanner_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help testscanner

% Last Modified by GUIDE v2.5 18-Jan-2007 17:28:03

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @testscanner_OpeningFcn, ...
                   'gui_OutputFcn',  @testscanner_OutputFcn, ...
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

% --- Executes just before testscanner is made visible.
function testscanner_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to testscanner (see VARARGIN)

% Choose default command line output for testscanner
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

if strcmp(get(hObject,'Visible'),'off')
    initialize_gui(hObject, handles, varargin{:});
end

% UIWAIT makes testscanner wait for user response (see UIRESUME)
% uiwait(handles.ScannerTest);


% --- Outputs from this function are returned to the command line.
function varargout = testscanner_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function initialize_gui(fig_handle, handles, serialport)

if nargin < 3, serialport = 1; end
data = struct(...
	'Slices', 30, ...
	'AcqVolumes', 0, ...
	'AcqSlices', 0, ...
	'TRslices', 0, ...
	'TD', 0, ...
	'TRvolumes', 0 ...
);
set_gui_values(handles, data);
setappdata(handles.ScannerTest, 'SerialPort', serialport);
setappdata(handles.ScannerTest, 'Running', 0);
cgloadlib;


function data = get_gui_values (handles)

data = getappdata(handles.ScannerTest, 'data');


function set_gui_values(handles, data)

fn = fieldnames(data);
for f=fn'
	set(getfield(handles, f{1}), 'string', getfield(data, f{1}));
end
setappdata(handles.ScannerTest, 'data', data);



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
end
set_gui_values(handles, data);


% --- Executes during object creation, after setting all properties.
function AcqVolumes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AcqVolumes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes during object creation, after setting all properties.
function AcqSlices_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AcqSlices (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes during object creation, after setting all properties.
function TRslices_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AcqSlices (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes during object creation, after setting all properties.
function TD_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AcqSlices (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes during object creation, after setting all properties.
function TRvolumes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AcqSlices (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on button press in Close.
function Close_Callback(hObject, eventdata, handles)
% hObject    handle to Close (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if getappdata(handles.ScannerTest, 'Running')
	return
end

delete(handles.ScannerTest);


% --- Executes on button press in Run.
function Run_Callback(hObject, eventdata, handles)
% hObject    handle to Run (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if getappdata(handles.ScannerTest, 'Running') == 1
	set(handles.Run, 'Enable', 'Off');
	setappdata(handles.ScannerTest, 'Running', 2);
	return
elseif getappdata(handles.ScannerTest, 'Running') == 2
	return
end
setappdata(handles.ScannerTest, 'Running', 1);
set(handles.Run, 'String', 'Stop');
set([handles.Slices, handles.Close], 'Enable', 'Off');

axes(handles.TRvolumes_plot);
cla;
axes(handles.TRslices_plot);
cla;

cgloadlib;

% Initialize serial port
serialport = getappdata(handles.ScannerTest, 'SerialPort');
try
	if numel(serialport) == 1
	    serial = CogSerial('open', sprintf('com%d', serialport(1)));
	    CogSerial('record', serial, 1000);
	else
		gaglab_xid('init', sprintf('com%d', serialport(1)));
		gaglab_xid('start');
	end
catch
	setappdata(handles.ScannerTest, 'Running', 0);
	set(handles.Run, 'String', 'Run');
	set([handles.Slices, handles.Close], 'Enable', 'On');
	errordlg('Serial port input not available', 'Scanner Test')
	return
end

data = get_gui_values(handles);
data = struct(...
	'Slices', data.Slices, ...
	'AcqVolumes', 0, ...
	'AcqSlices', 0, ...
	'TRslices', 0, ...
	'TD', 0, ...
	'TRvolumes', 0 ...
);
set_gui_values(handles, data);

% Set priority to high
priority = CogProcess('getpriority');
priorityclass = CogProcess('enumpriorities');
CogProcess('setpriority', priorityclass.high);

% Do the job
v = 0;
sl = [];
TRv = [];
TRs = [];
counter = 0;
gaglab_exp_time('start');
while 1
	if numel(serialport) == 1
		[value, tim] = Get_Next_Slices(handles, serial);
	else
		[value, tim, counter] = Get_Next_Slices_XID(handles, counter);
	end
   	if getappdata(handles.ScannerTest, 'Running') == 2, break; end
	sl = [sl; tim];
	set(handles.AcqSlices, 'string', value(end));
	if mod(value(end), data.Slices) == 0	% End of volume
		v = v + 1;
		set(handles.AcqVolumes, 'string', v);
        TRs = [TRs; diff(sl)];
        TRv = [TRv, sl(1)];
		if v > 1
			TRv_temp = round(mean(diff(TRv)));
			set(handles.TRvolumes, 'string', TRv_temp);
            axes(handles.TRvolumes_plot);
            plot(diff(TRv));
        end
        if data.Slices > 1
    		TRs_temp = round(mean(TRs));
		    set(handles.TRslices, 'string', TRs_temp);
            axes(handles.TRslices_plot);
            plot(TRs);
        elseif v > 1
            TRs_temp = TRv_temp;
		    set(handles.TRslices, 'string', TRs_temp);
            axes(handles.TRslices_plot);
            plot(diff(TRv));
        end
        if v > 1
			set(handles.TD, 'string', TRv_temp - TRs_temp * data.Slices);
		end
        sl = [];
	end
end
gaglab_exp_time('stop');

% Restore system
CogProcess('setpriority', priority);
if numel(serialport) == 1
	CogSerial('close');
else
	gaglab_xid('clear');
end

setappdata(handles.ScannerTest, 'Running', 0);
set(handles.Run, 'String', 'Run', 'Enable', 'on');
set([handles.Slices, handles.Close], 'Enable', 'on');

	
function [slices, times, counter] = Get_Next_Slices_XID (handles, counter)
	
slices = []; times = [];

while isempty(slices)
	[slices, times] = gaglab_xid('Get');
	j = find(slices == 31);
	slices = slices(j);
	times = times(j);
    drawnow; % hopefuly giving Ctrl-C more chance!
   	if getappdata(handles.ScannerTest, 'Running') == 2, return; end
end

slices = [1:length(slices)] + counter;
counter = slices(end);

	
function [slices, times] = Get_Next_Slices (handles, serialport)
	
slices=[]; ix = []; values = []; times = []; % OR this for the 'WILL WAIT for slice' version

while isempty( ix ) % MUST HAVE some closely spaced bytes 
    values0 = []; times0 = [];
    while length( values0 ) < 2 % MUST HAVE 2 bytes or more, to calculate their spacing
        values1 = []; times1 = [];
        while isempty( values1 ) % MUST HAVE some bytes to work with (please?)
            [ values1, times1 ] = CogSerial('GetEvents', serialport);
            drawnow; % hopefuly giving Ctrl-C more chance!
        	if getappdata(handles.ScannerTest, 'Running') == 2, return; end
        end % while isempty(values1)
        values0 = [values0; values1];
        times0 = [times0; times1];
    end % while length(values0)<2
    values = [values; values0];
    times = [times; times0];
    ix = find( diff( times ) < 0.010 ); % i.e. < 10ms
end % while isempty(ix)
% return values...

slices = ( values( ix )*256 + values( ix+1 ) ); % convert byte pairs into slice numbers
times = times( ix+1 ); % pick out one time stamp per byte pair
times = gaglab_exp_time(times); % convert from sec to ms
