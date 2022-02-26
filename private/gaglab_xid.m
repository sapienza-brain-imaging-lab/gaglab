function [varargout] = gaglab_xid (command, varargin)

% XID 	Manage communication with a XID device
%
% Usage:
%   xid Init COM3		initialize XID device on serial port COM3
%	xid Clear			clear XID device
%	xid Test			test XID device
%	xid Start			start collecting responses
%	xid Stop			stop collecting responses
%	xid ResetTimer		reset XID timer
%	[B, T] = xid('Get')	return codes B of the pressed/released buttons
%						since last call to xid('Get'), and the
%						corresponding time stamps T
%
% Time stamps are given in milliseconds from the last XID timer reset.
% Button values are as follows:
%	1-8		push buttons
%	11-16	lines on the accessory connector
%	21		voice key
%	31		scanner pulse
% Positive values indicate button presses.
% Negative values indicate button releases.

persistent XID
if nargin == 0, return, end

switch lower(command)
	
	case 'init'
		if ~isempty(XID)
			gaglab_xid('Clear');
		end
		if nargin < 2
			error('You must specify the serial port to open');
		end
		XID.PortHandle = xid_openserialport(varargin{1});
		XID.Port = varargin{1};
		XID.Started = 0;
		XID = findXID(XID);
		if isempty(XID)
			error(lasterr);
		end
		try
			XID.Model = xid_sendcommand(XID, '_d2', 1);		% Get the model code
			xid_sendcommand(XID, 'a10');					% Set the general purpose mode for accessory connector
			xid_sendcommand(XID, '_a1', '_a10');			% Verify AC mode
			xid_sendcommand(XID, 'a51');					% Set AC input lines as "default high"
			xid_sendcommand(XID, ['a4' char(63)]);			% Configure all AC lines as input
            t = now; while now < t + 4/864000, end;
			xid_sendcommand(XID, '_a4', ['_a4' char(63)]);	% Verify AC line configuration
			xid_sendcommand(XID, '_a5', '_a51');			% Verify AC input line configuration
		catch
			gaglab_xid('Clear');
            disp(lasterr);
			error(lasterr);
		end
		XID.Buffer = [];
		return
		
	case 'clear'
		if ~isempty(XID)
   			xid_sendcommand(XID, 'f7');					    % Reset to factory defaults
			CogSerial('Close', XID.PortHandle);
			XID = [];
		end
		return
end

if isempty(XID)
	error('XID device was not initialized');
end

switch lower(command)
	
	case 'model'
		varargout{1} = XID.Model;
		
	case 'start'
		if XID.Started == 0
			gaglab_xid('ResetTimer');
			CogSerial('Record', XID.PortHandle, 100000);
			XID.Started = 1;
			XID.Buffer = [];
		end
		
	case 'stop'
		if XID.Started
			CogSerial('Stop', XID.PortHandle);
			XID.Started = 0;
		end
		
	case 'resettimer'
		if XID.Started
			error('Timer can not be reset while acquiring responses: use STOP first');
		end
		CogSerial('Write', XID.PortHandle, double('e1e5'));
		cogstd('sGetTime', gaglab_xid('gettime')/1000);
		
	case 'gettime'
		CogSerial('Write', XID.PortHandle, double('e3'));
		for j=1:6
			X(j) = CogSerial('Read', XID.PortHandle);
			if j==1, t = cogstd('sGetTime', -1); end
		end
		%if any(char(X(1:2)) ~= 'e3')
		%	error('Invalid test results returned by the XID device');
		%end
		varargout{1} = [X(3:6) * [1 256 65536 16777216]', t];
		
	case 'testtimer'
		priority.class = CogProcess( 'enumpriorities' );
		priority.old = CogProcess( 'getpriority' );
		CogProcess( 'setpriority', priority.class.high );
		gaglab_xid('ResetTimer');
		t = [0 0];
		%while t(end,2) < 60000
		%t(end+1,:) = gaglab_xid('gettime');
		%fprintf('%d %d\n', t(end,:));
		%end
		waituntil(20000);
		toc
		t = gaglab_xid('gettime')
		diff(t)
		%plot(diff(t'))
		%t = [t, -diff(t')']
		CogProcess('setpriority', priority.old);
		
	case 'testdelay'
		if XID.Started
			error('The TEST procedure works when the response acquisition is not active: use STOP first');
		end
		fprintf('Testing communication delay');
		gaglab_xid('ResetTimer');
		for i=1:10
			CogSerial('Write', XID.PortHandle, double('e4'));
			X = CogSerial('Read', XID.PortHandle);
			CogSerial('Write', XID.PortHandle, 88);
			for j=2:5
				X(j) = CogSerial('Read', XID.PortHandle);
			end
			if any(char(X(1:3)) ~= 'XPT')
				error('Invalid test results returned by the XID device');
			end
			delay(i) = X(4:5) * [1 256]';
			fprintf('.')
			wait(1000);
		end
		fprintf('\nMean communication delay: %.1f msec (max %.0f msec)\n', mean(delay), max(delay));
		
	case 'testkeys'
		if XID.Started
			error('The TEST procedure works when the response acquisition is not active: use STOP first');
		end
		fprintf('\n\n*** TEST STARTED (press Ctrl-C to stop) ***\n')
		gaglab_xid('ResetTimer');
		gaglab_xid('Start');
		%try
		while 1
			[v,at,pt] = gaglab_xid('Get');
			for i=1:length(v)
				if v(i) >= 0
					fprintf('Button %d pressed  at %d (arrived at %d)\n', v(i), pt(i), at(i));
				else
					fprintf('Button %d released at %d (arrived at %d)\n', -v(i), pt(i), at(i));
				end
			end
		end
		%end
		gaglab_xid('Stop');
		fprintf('*** TEST STOPPED ***\n\n')
		
	case 'get'
		if XID.Started == 0
			error('The GET command can be used only after a START command');
		end
		varargout{1} = [];
		varargout{2} = [];
		if nargout > 2, varargout{3} = []; end
		[v,t] = CogSerial('GetEvents', XID.PortHandle);
		XID.Buffer = [XID.Buffer; v, t];
		while size(XID.Buffer,1) >= 6
			if XID.Buffer(1,1) ~= 'k'
				fprintf('Invalid keypress returned by the XID device: %d\n', double(XID.Buffer(1,1)));
				XID.Buffer(:,:) = [];
				break;
			end
			keycode = bitshift(XID.Buffer(2,1), -5);
			switch bitand(XID.Buffer(2,1), 15)
				case 0      % Push buttons
					if isequal(XID.Model, '0') & keycode == 5	% Scanner input on Lumina
						keycode = 31;
					else
						keycode = keycode + 1;
					end
				case 1      % Accessory connector
					keycode = keycode + 10;
				case 2      % Voice key
					keycode = keycode + 20;
			end
			if ~bitand(XID.Buffer(2,1), 16)
				keycode = -keycode;
			end
			varargout{1}(end+1) = keycode;
			varargout{2}(end+1) = gaglab_exp_time(XID.Buffer(1,2));
			if nargout > 2,	varargout{3}(end+1) = XID.Buffer(3:6,1)' * [1 256 65536 16777216]'; end
			XID.Buffer(1:6,:) = [];
		end
		
	case 'wait'
		if nargin < 3, varargin{2} = Inf; end
		t0 = time;
		while time < t0 + varargin{2}
			[v, t] = gaglab_xid('get');
			if any(v == varargin{1})
				break;
			end
		end
end


function h = xid_openserialport (port)

cgloadlib;
try
	[tmp, h] = evalc('CogSerial(''Open'', port)');
catch
	error(['Can not open serial port ' port]);
end


function XID = findXID (XID)

baudrate = [115200, 9600, 19200, 38400, 57600];

found = 0;
for b = baudrate
	str = sprintf('Connecting to XID device at %d bps...', b);
	fprintf(str);
	CogSerial('SetAttr', XID.PortHandle, struct('Baud', b, 'Parity', 0, 'StopBits', 0, 'ByteSize', 8));
	try
		xid_sendcommand(XID, 'c10');					% Set the protocol to XID
		xid_sendcommand(XID, '_c1', '_xid0');			% Verify that protocol is XID
		found = 1;
		break;
	catch
		fprintf(repmat('\b', 1, length(str)));
	end
end
if found & b ~= 115200
	fprintf(repmat('\b', 1, length(str)));
	str = 'Setting XID device to 115200 bps...';
	fprintf(str);
	xid_sendcommand(XID, ['f1', char(4)]);				% Set communication speed to 115200
	CogSerial('Close', XID.PortHandle);
	XID.PortHandle = xid_openserialport(XID.Port);
	CogSerial('SetAttr', XID.PortHandle, struct('Baud', 115200, 'Parity', 0, 'StopBits', 0, 'ByteSize', 8));
	xid_sendcommand(XID, 'c10');					% Set the protocol to XID
	try
		xid_sendcommand(XID, '_c1', '_xid0');			% Verify that protocol is XID
	catch
		fprintf(' failed.\n');
		CogSerial('Close', XID.PortHandle);
		error(lasterr);
	end
end
if found
	fprintf(repmat('\b', 1, length(str)));
else
	CogSerial('Close', XID.PortHandle);
	XID = [];
end


function resp = xid_sendcommand (XID, what, responseBytes)

resp = [];

switch class(what)
	case 'char'
		what = double(what);
end

CogSerial('SetTimeout', XID.PortHandle, 0);
while CogSerial('Read', XID.PortHandle) ~= -1, end;
CogSerial('SetTimeout', XID.PortHandle, 2500);

CogSerial('Write', XID.PortHandle, what);

if nargin > 2
	if ischar(responseBytes)
		validresponse = responseBytes;
		responseBytes = length(validresponse);
	else
		validresponse = 0;
	end
	for i=1:responseBytes
		resp(i) = CogSerial('Read', XID.PortHandle);
		if resp(i) == -1
			if i==1
				error(['No response from XID device on port ' XID.Port]);
			else
				error(['Incomplete response from XID device: "' char(resp(1:i-1)) '"']);
			end
		end
	end
	resp = char(resp);
	if ischar(validresponse) & ~strcmp(validresponse, resp)
		error(['XID device shoudl respond "' validresponse '" but responded "' resp '"']);
	end
end

