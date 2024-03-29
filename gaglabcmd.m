function [varargout] = gaglabcmd (varargin)
% GAGLABCMD	Low level calls to the GagLab package
%
% GAGLABCMD is a multi-function script including the implementation of
% most features of the GagLab package.
%
% In normal conditions, experiment authors and users do not need to use
% this function directly.

persistent GL
if isempty(GL)
	GL = gaglab_startup;
end

command = gaglab_util_defaultarg('donothing', varargin, 1);
gaglab_exp_check_status(GL, command);

switch lower(command)

	case 'version'
		if nargout
			varargout{1} = GL.Version;
		else
			disp(GL.Version);
		end

	%case 'explibversion'
	%	if nargout
	%		varargout{1} = GL.ExperimentVersion;
	%	else
	%		disp(GL.ExperimentVersion);
	%	end
		
	case 'test'
		what = gaglab_util_defaultarg('nothing', varargin, 2);
		switch lower(what)
			case 'screen'
				E = GL.Experiment;
				RunExperiment(fullfile(fileparts(which(mfilename)), 'test', 'testscreen'));
				GL.Experiment = E;
			case 'graphics'
				gaglab_setup_graphics(GL.SetupPath, 'force');
			case 'sound'
				evalc('CogSound initialise');
				s = CogSound('load', fullfile(fileparts(which(mfilename)), 'cogentsetup.wav'));
				CogSound('play', s, 0);
				while CogSound('Playing', s), end;
				evalc('CogSound shutdown');
			case 'keys'
				Events = gaglab_evt_reset;
				Response = GL.Setup.Response;
				Response.UseMouse = GL.Setup.Mouse.UseMouse;
				Response = gaglab_resp_start(Response, GL.Setup.TestMode);
                disp('Test started');
				while isempty(Events.StopKey)
					Events = gaglab_resp_update(Events, Response, GL.Setup.Sync);
					Events.Log = gaglab_exp_showlog(Events.Log);
				end
				gaglab_resp_stop(Response);
			case 'eyetracker'
			case 'scanner'
				if GL.Setup.Sync.UseSync & GL.Setup.Sync.Port
					testscanner(GL.Setup.Sync.Port);
				elseif GL.Setup.Sync.UseSync & strcmpi(GL.Setup.Response.Device, 'xid')
					testscanner([GL.Setup.Response.XID.Port, 1]);
				else
					disp('Communication with the scanner not configured');
				end
		end

	case 'calibrate'
		lseye_calibrate;

	case 'setuplist'
		varargout{1} = gaglab_setup_list(GL);
		if nargout > 1, varargout{2} = GL.SetupPath; end

	case 'experimentlist'
		if nargout
			[varargout{1:nargout}] = gaglab_exp_list(GL);
		end

	case 'setup'
		GL = gaglab_setup_load(GL, varargin{2:end});

	case 'getinfo'
		varargout = {struct('Parameter', GL.Experiment.Parameter, ...
			'Subject', GL.Experiment.Subject, ...
			'Study', GL.Experiment.Study, ...
			'Series', GL.Experiment.Series)};

	case 'experiment'
		GL = gaglab_exp_load(GL, varargin{2});

	case 'parameters'
		GL.Experiment.Parameter = varargin{2};

	case 'subject'
		GL.Experiment.Subject = varargin{2};

	case 'study'
		GL.Experiment.Study = varargin{2};

	case 'series'
		GL.Experiment.Series = varargin{2};

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% GAGLABCMD('SET', 'VARIABLE', VALUE), or GAGLABCMD('SET',
	% 'GROUP', 'VARIABLE', VALUE) allows further customization of the
	% configuration from the experiment script.
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	case 'set'
		switch nargin
			case 3
				if isfield(GL.Setup, varargin{2})
					GL.Setup = setfield(GL.Setup, varargin{2}, varargin{3});
				end
			case 4
				if isfield(GL.Setup, varargin{2})
					tmp = getfield(GL.Setup, varargin{2});
					if isfield(tmp, varargin{3})
						tmp = setfield(tmp, varargin{3}, varargin{4});
						GL.Setup = setfield(GL.Setup, varargin{2}, tmp);
					end
				end
		end

	case 'getscreen'
		varargout{1} = gaglab_vis_resolution(GL);
		varargout{1}(end+1) = GL.Setup.Screen.DistanceMm;
		varargout{1}(end+1) = GL.Setup.Screen.WidthMm;

	case 'setscreen'
		for i=2:length(varargin)
			switch varargin{i}
				case {640,800,1024,1152,1280,1600}
					GL.Setup.Screen.Pixels = varargin{i};
				case {60,70,72,75,85,90,100,120}
					GL.Setup.Screen.RefreshRate = varargin{i};
				otherwise
					error('Invalid value for screen resolution/refresh rate');
			end
		end

	case 'restart'
		GL = gaglab_exp_stop(GL, 1);
		GL = gaglab_setup_load(GL, GL.Experiment.Setup);
		GL = gaglab_exp_load(GL);

	case 'run'
		if isempty(GL.Experiment.Name)
			error('No experiment loaded');
		end
		GL = gaglab_exp_init(GL);
		if GL.Setup.TestMode
			dbstop if warning
			dbstop if error
			if nargin(GL.Experiment.Name)
				feval(GL.Experiment.Name, GL.Experiment.Parameter);
			else
				feval(GL.Experiment.Name);
			end
			GL = gaglab_exp_stop(GL, 0);
		else
			dbclear all
			try
				if nargin(GL.Experiment.Name)
					feval(GL.Experiment.Name, GL.Experiment.Parameter);
				else
					feval(GL.Experiment.Name);
				end
				GL = gaglab_exp_stop(GL, 0);
			catch
				[msg,id] = lasterr;
				if strcmp(id, 'GagLab:Stop')
					fprintf('Stop key pressed\n');
				else
					GL = gaglab_exp_stop(GL, 1);
					fprintf('The experiment was stopped because of an error\ngenerated by MATLAB while executing the experiment script:\n\n');
					rethrow(lasterror);
				end
			end
		end

	case 'stop'
		if nargin > 1, GL = varargin{2}; end
		GL = gaglab_exp_stop(GL, 1);
		dbclear all
		error('GagLab:Stop', 'Experiment stopped');

	case 'clearonflip'
		GL.Screen.ClearOnFlip = varargin{2};

	case 'start'
		GL = gaglab_exp_start(GL);

	case 'log'
		if nargin > 2, varargin{2} = sprintf(varargin{2:end}); end
		t = gaglab_exp_time;
		fprintf('%7.0f: %s\n', t, varargin{2});
		GL.Events.Log = gaglab_exp_log(GL.Events.Log, 'S', t, varargin{2});

	case 'showlog'
		GL.Events.Log = gaglab_exp_showlog(GL.Events.Log);

	case 'defineresponse'
		[GL.Events.Response, varargout{1}] = gaglab_resp_define( ...
			GL.Events.Response, varargin{2:end});

	case 'responsecodes'
		GL.Events.Response = gaglab_resp_codes( ...
			GL.Events.Response, varargin{2:end});
	
	case 'getresponse'
		GL = gaglab_exp_update(GL);
		[varargout{1}, varargout{2}] = gaglab_resp_get(GL.Events.Response, varargin{2});
	
	case 'getkey'
		GL = gaglab_exp_update(GL);
		keys = gaglab_util_defaultarg([], varargin, 2);
		[GL, varargout{1}, varargout{2}] = gaglab_exp_getkey(GL, keys, 0);
	
	case 'getlastkey'
		GL = gaglab_exp_update(GL);
		keys = gaglab_util_defaultarg([], varargin, 2);
		[GL, varargout{1}, varargout{2}] = gaglab_exp_getkey(GL, keys, 1);
	
	case 'getlastslice'
		GL = gaglab_exp_update(GL);
		[varargout{1}, varargout{2}, varargout{3}] = gaglab_sync_last(GL.Events,	GL.Sync);
	
	case 'waitfor'
		cond = gaglab_exp_find_cond_stim(varargin{2:end});
		[GL, varargout{1}] = gaglab_exp_waitfor(GL, cond);
	
	case 'present'
		[cond, stim] = gaglab_exp_find_cond_stim(varargin{2:end});
		[GL, varargout{1}] = gaglab_exp_present(GL, cond, stim);
		
	case 'createstimulus'
		if GL.Running == 1, GL.Running = 2; end
		GL.Screen = gaglab_vis_create(GL.Screen, varargin{2:end});

	case 'resizestimulus'
		if GL.Running == 1, GL.Running = 2; end
		GL.Screen = gaglab_vis_do(GL.Screen, 'size', varargin{2:end});

	case {'backgroundcolor','transparency','pencolor','penwidth','units','align', ...
				'clear','point','line','rect','poly','ellipse','arc','font','text'}
		if GL.Running == 1, GL.Running = 2; end
		GL.Screen = gaglab_vis_do(GL.Screen, command, varargin{2:end});

	case 'loadimages'
		GL.Image = gaglab_vis_preloadimages(GL.Image, varargin{2:end});

	case 'image'
		if GL.Running == 1, GL.Running = 2; end
		if ischar(varargin{3})
			if ~isempty(GL.Image)
				j = find(strcmpi(varargin{3}, {GL.Image.Name}));
				if ~isempty(j)
					varargin{3} = GL.Image(j(1));
				end
			end
		end
		GL.Screen = gaglab_vis_do(GL.Screen, command, varargin{2:end});
		
	case 'copystimulus'
		if GL.Running < 3
			GL.Screen = gaglab_vis_start(GL);
			GL.Running = 2.5;
		end
		GL.Screen = gaglab_vis_do(GL.Screen, 'copy', varargin{2:end});

	case 'waitnextframe'
		varargout{1} = gaglab_exp_time(cgflip('V'));

	case 'loadsounds'
		GL.Sound = gaglab_snd_preloadsounds(GL.Sound, varargin{2:end});
		
	case 'preparesound'
		GL.Sound = gaglab_snd_prepare(GL.Sound, varargin{2:end});

	case 'setsound'
		GL.Sound = gaglab_snd_set(GL.Sound, varargin{2:end});
end



function gaglab_exp_check_status (GL, command)
% GL.Running explained:
%   0     no experiment defined
%   1     experiment is being configured
%   2     experiment is being prepared, screen is closed
%   2.5   experiment is being prepared, screen is open
%   3     experiment is waiting to start
%   4     experiment is running

% This commands are special
switch lower(command)

	% These commands always work
	case {'getscreen', 'donothing', 'version'}
		return

	% These commands require that the experiment is not running
	case {'gui', 'test', 'calibrate', 'setuplist', 'experimentlist', 'setup', 'experiment', 'subject', 'parameters', 'study', 'series'}
		if GL.Running
			error('This command cannot be used during an experiment!');
		end
		return

	% These commands restart GagLab if they are called during an
	% experiment
	case {'restart', 'run'}
		if GL.Running
			fprintf('Aborting the current experiment and restarting GagLab...\n');
		end
		return

	% These commands require that the experiment is in phase 0 or 1
	case {'set','setscreen'}
		if GL.Running > 1
			error('Configuration commands must be used before preparing stimuli and starting the experiment');
		end
		return
end

% All the others require that the experiment is at least in phase 1
if GL.Running == 0
	error('You must run your experiment from the GagLab window or through the GAGLABCMD RUN command!');
end


switch lower(command)

	% The following commands require that the experiment is in phase 1
	case {'defaultbackgroundcolor'}
		if GL.Running > 1
			error('The %s command must be used during the configuration phase of the experiment', upper(command));
		end

	% The following commands require that the experiment is in phase 1 or 2
	case {'createstimulus','resizestimulus','transparency','loadimages','loadsounds'}
		if GL.Running > 2
			error('The %s command must be used during the preparation phase of the experiment', upper(command));
		end

	% The following commands require that the experiment is in phase 4
	case {'defineresponse','responsecodes','getresponse','getkey','getlastkey', ...
				'getlastslice','waitfor','waitnextframe'}
		if GL.Running < 4
			error('The %s command must be used during the execution phase of the experiment', upper(command));
		end
end
