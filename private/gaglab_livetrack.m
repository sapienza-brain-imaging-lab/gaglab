function [varargout] = gaglab_livetrack (command, varargin)
	
	% LIVETRACK 	Manage communication with a LiveTrack FM eyetracker
	%
	% Usage:
	%   livetrack Init COM3		initialize LiveTrack device on serial port COM3
	%	livetrack Clear			clear LiveTrack device
	%	livetrack Start			start collecting responses
	%	livetrack Stop			stop collecting responses
	%	D = livetrack('Get')	return eye positions collected after last call
	%                           to Get
	%
	% D is a matrix with a row for each eye sample and 11 columns:
	%   1         time of the eye sample
	%   2         frame counter
	%   3         value of the external (trigger) signal
	%   4,5,6     XYZ position of left eye
	%   7         pupil area of left eye
	%   8,9,10    XYZ position of right eye
	%   11        pupil area of right eye
	
	persistent livetrack
	varargout = {};
	if nargin == 0, return, end
	
	switch lower(command)
		case 'init'
			if ~isempty(livetrack)
				gaglab_livetrack('Clear');
			end
			if nargin < 2
				error('You must specify the serial port to open');
			end
			livetrack.PortHandle = livetrack_openserialport(varargin{1});
			livetrack.Port = varargin{1};
			livetrack.Started = 0;
			livetrack.Buffer = [];
			livetrack_sendcommand(livetrack, 'Stop');
			productType = livetrack_sendcommand(livetrack, 'ProductType');
			productType = regexp(productType, '^\$ProductType;([^;]+)', 'tokens', 'once');
			livetrack.productType = productType{1};
			livetrack.numEyes = ~strcmp(productType{1}, 'LiveTrack-AV')+1;
			if livetrack.numEyes == 1
				fprintf('Connected to %s eye tracker (monocular)\n', livetrack.productType);
			else
				fprintf('Connected to %s eye tracker (binocular)\n', livetrack.productType);
			end
			
		case 'clear'
			if ~isempty(livetrack)
				CogSerial('Close', livetrack.PortHandle);
				livetrack = [];
			end
			
		case 'start'
			if ~isempty(livetrack) && ~livetrack.Started
				livetrack_sendcommand(livetrack, 'Calibrated');
				CogSerial('Record', livetrack.PortHandle, 100000);
				livetrack.Started = 1;
				livetrack.Buffer = [];
				varargout = {livetrack.numEyes};
			end
			
		case 'stop'
			if ~isempty(livetrack) && livetrack.Started
				CogSerial('Stop', livetrack.PortHandle);
				livetrack_sendcommand(livetrack, 'Stop');
				livetrack.Started = 0;
				livetrack.Buffer = [];
			end
			
		case 'get'
			[v,t] = CogSerial('GetEvents', livetrack.PortHandle);
			[varargout{1}, livetrack.Buffer] = livetrack_parse([livetrack.Buffer; v, t], livetrack.numEyes);
	end
end

function [events, buffer] = livetrack_parse (buffer, numEyes)
	if numEyes == 1
		[str,s,e] = regexp(char(buffer(:,1)'), 'Eye; +(\d+); +(\d); +([\d\.]+); +([\d\.]+); +([\d\.]+); +([\d\.]+); +([\d\.]+);\n', 'tokens', 'start', 'end');
	else
		[str,s,e] = regexp(char(buffer(:,1)'), 'leftEye; +(\d+); +(\d); +([\d\.]+); +([\d\.]+); +([\d\.]+); +([\d\.]+); +([\d\.]+);\n\r.rightEye; +\d+; +\d; +([\d\.]+); +([\d\.]+); +([\d\.]+); +([\d\.]+); +([\d\.]+);\n', 'tokens', 'start', 'end');
	end
	if isempty(s)
		events = [];
		return;
	end
	
	str = cat(1, str{:});
	val = cellfun(@str2double, str);
	t = gaglab_exp_time(buffer(s,2));
	
	buffer = buffer(e(end)+1:end,:);
	events = [t, val];
end

function [varargout] = livetrack_sendcommand (livetrack, command)
	CogSerial('SetTimeout', livetrack.PortHandle, 0);
	while CogSerial('Read', livetrack.PortHandle) ~= -1, end;
	CogSerial('SetTimeout', livetrack.PortHandle, 100);

	CogSerial('Write', livetrack.PortHandle, double(['$', command, 13]));
	if nargout
		resp = [];
		while true
			d = CogSerial('Read', livetrack.PortHandle);
			if d == -1
				break;
			else
				resp = [resp, d]; %#ok<AGROW>
			end
		end
		varargout = {char(resp)};
	end
end

function h = livetrack_openserialport (port)
	
	cgloadlib;
	try
		[tmp, h] = evalc('CogSerial(''Open'', port)'); %#ok<ASGLU>
	catch %#ok<CTCH>
		error(['Can not open serial port ' port]);
	end
	CogSerial('SetAttr', h, struct('Baud', 9600, 'Parity', 0, 'StopBits', 0, 'ByteSize', 8));
end
