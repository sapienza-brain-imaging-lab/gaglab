function R = gaglab_resp_start (R, TestMode)
% GAGLAB_RESP_START		Initialize the response device
%
% R = GAGLAB_RESP_START(R) initialize the response device following the
% indications given by structure R.
% DEVICE. DEVICE should be 'keyboard', 'mouse', or 'serial'. The keyboard
% is initialized in any case, since it is used by the examiner to start and
% stop the experiment. The variables needed to access the response device
% during the experiment are returned in the structure R.

% Initialise serial port for responses
if strcmpi(R.Device, 'serial')
	try
		R.Serial.HPort = CogSerial('open', sprintf('com%d', R.Serial.Port));
		attr.Baud = 9600;
		attr.Parity = 0;
		attr.StopBits = 0;
		attr.ByteSize = 8;
		CogSerial('setattr', R.Serial.HPort, attr);
	catch %#ok<CTCH>
		fprintf('Serial port not available for responses: using keyboard\n');
		R.Serial.HPort = 0;
		R.Device = 'keyboard';
	end
elseif strcmpi(R.Device, 'xid')
	try
		gaglab_xid('init', sprintf('com%d', R.XID.Port));
	catch %#ok<CTCH>
		error('XID response device is not working properly: try to reset.');
	end
end

% Initialise DirectInput
CogInput('Initialise');

% Initialise keyboard
if TestMode == 0
	Keyboard.Mode = 'exclusive';
	Keyboard.Resolution = 1;
else
	Keyboard.Mode = 'nonexclusive';
	Keyboard.Resolution = 10;
end
R.Keyboard.HKeyboard = CogInput('Create', 'keyboard', Keyboard.Mode, 100000);

% Build key maps
R.KeyboardMap = gaglab_resp_keymap('Keyboard', {R.Keyboard.Key1, ...
	R.Keyboard.Key2, R.Keyboard.Key3, R.Keyboard.Key4, ...
	R.Keyboard.Key5, R.Keyboard.Key6, R.Keyboard.Key7, ...
	R.Keyboard.Key8, R.Keyboard.Key9, R.Keyboard.Key10});
R.MouseMap = gaglab_resp_keymap('Mouse', {R.Mouse.Key1, ...
	R.Mouse.Key2, R.Mouse.Key3, R.Mouse.Key4, ...
	R.Mouse.Key5, R.Mouse.Key6, R.Mouse.Key7, ...
	R.Mouse.Key8, R.Mouse.Key9, R.Mouse.Key10});
if any(ismember([1 2], R.MouseMap))
	R.UseMouse = 1;
end
R.SerialMap = [R.Serial.Key1, ...
	R.Serial.Key2, R.Serial.Key3, R.Serial.Key4, ...
	R.Serial.Key5, R.Serial.Key6, R.Serial.Key7, ...
	R.Serial.Key8, R.Serial.Key9, R.Serial.Key10];
R.XIDMap = [R.XID.Key1, ...
	R.XID.Key2, R.XID.Key3, R.XID.Key4, ...
	R.XID.Key5, R.XID.Key6, R.XID.Key7, ...
	R.XID.Key8, R.XID.Key9, R.XID.Key10];
R.SpecialKeys = gaglab_resp_keymap('Keyboard', {R.StartKey, R.StopKey});
if any(R.SpecialKeys == 0)
	error('Start and Stop keys are not properly configured');
end

% Initialise mouse
R.Position = [0 0];
if TestMode == 0
	Mouse.Mode = 'exclusive';
	Mouse.Resolution = 1;
else
	Mouse.Mode = 'nonexclusive';
	Mouse.Resolution = 10;
end
R.Mouse.HMouse = CogInput('Create', 'mouse', Mouse.Mode);
if R.UseMouse
	CogInput('SetMask', R.Mouse.HMouse, 1:7);
else
	CogInput('SetMask', R.Mouse.HMouse, 4:7);
end

CogInput('Acquire', R.Keyboard.HKeyboard);
CogInput('StartPolling', R.Keyboard.HKeyboard, Keyboard.Resolution);

if isfield(R.Mouse, 'HMouse')
	CogInput('Acquire', R.Mouse.HMouse);
	CogInput('StartPolling', R.Mouse.HMouse, Mouse.Resolution);
end

if strcmpi(R.Device, 'serial')
	CogSerial('record', R.Serial.HPort, 100000);
elseif strcmpi(R.Device, 'xid')
	gaglab_xid('start');
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function out = gaglab_resp_keymap (device, key)
% GAGLAB_RESP_KEYMAP	    	Codes for keyboard keys and mouse buttons
%
% GAGLAB_RESP_KEYMAP('keyboard','A') returns the numeric code corresponding to key 'A'.
% GAGLAB_RESP_KEYMAP('keyboard',13) returns the name of key 13.
% GAGLAB_RESP_KEYMAP('mouse','Left') returns the numeric code corresponding to the left
% mouse button.
% GAGLAB_RESP_KEYMAP('mouse',3) returns the name of mouse button 3.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

switch lower(device)
	case 'keyboard'
		map  = {'A','B','R','D','E','F','G','H','I','J', ...
			'K','L','M','N','O','P','Q','R','S','T', ...
			'U','V','W','X','Y','Z','0','1','2','3', ...
			'4','5','6','7','8','9','F1','F2','F3','F4', ...
			'F5','F6','F7','F8','F9','F10','F11','F12','F13','F14', ...
			'F15','ESCAPE','''','ì','BACKSPACE','TAB','è','+','RETURN','LCTRL', ...
			'ò','à','ù','LSHIFT','\',',','.','-','RSHIFT','LALT', ...
			'SPACE','CAPSLOCK','NUMLOCK','SCROLL','PAD0','PAD1','PAD2','PAD3','PAD4','PAD5', ...
			'PAD6','PAD7','PAD8','PAD9','PAD-','PAD+','PAD/','PAD*','PAD.','ENTER', ...
			'RCTRL','RALT','PAUSE','HOME','UP','PGUP','LEFT','RIGHT','END','DOWN', ...
			'PGDN','INS','DEL'};
	case 'mouse'
		map = {'HMove','VMove','','Left','Right','Middle','Scroll'};
end

if ischar(key), key = cellstr(key); end
if iscell(key)
	map = [map, {''}];
	out = zeros(size(key));
	for i=1:numel(out)
		if ~isempty(key{i}) && key{i}(end) == '*'
			j = find(strcmpi(map, key{i}(1:end-1)));
			if ~isempty(j), j = -j; end
		else
			j = find(strcmpi(map, key{i}));
		end
		if isempty(j)
			error('Invalid key code "%s"', key{i});
		end
		out(i) = j(1);
	end
	out(out==length(map)) = 0;
else
	if any(key < 1 | key > length(map))
		error('Some key codes are out of range');
	end
	if numel(key) == 1
		out = map{key};
	else
		out = map(key);
	end
end
