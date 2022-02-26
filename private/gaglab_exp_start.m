function GL = gaglab_exp_start (GL)
% E = GAGLAB_EXP_START(E) waits for the examiner to press the Start key, or for the
% scanner to send the first sync signal, resets the time counter and starts
% an experimental session.
% If this is the first experimental session, GAGLAB_EXP_START first
% initializes GagLab to run experiment E. This includes
% configuring the display, the sound system, the keyboard, the mouse, and
% the serial port, in the way specified by the current Cogent
% configuration.
% If this is not the first experimental session, GAGLAB_EXP_START first save the
% results of the previous session.

switch GL.Running
	case {1,2,2.5}	% This is the first session: need to initialize
		GL = gaglab_exp_firststart(GL);
	case 4		% Running: need to save
		GL = gaglab_exp_savesession(GL, 0);
	otherwise	% This should not happen!
		error('Invalid runtime mode');
end
GL.Running = 3;

% Reset events
GL.Events = gaglab_evt_reset;
if GL.Setup.LogMode == 0
	GL.Events.Log = gaglab_exp_showlog(GL.Events.Log, 'Disable');
end

gaglab_exp_time('Start');

fprintf('\n **** READY TO START ****\n');
starttime = GL.Sync.StartVolumes * GL.Sync.TRvolumes;
fprintf('Waiting for the Start key...\n');
if GL.Sync.UseSync
	[GL, t0, cond] = gaglab_exp_waitfor(GL, {volume(-GL.Sync.StartVolumes+1), keypress('Start')});
	if cond.type == 'K'         % Start key pressed
    	GL.Events.Slice = [];
	else                        % Sync pulse acquired
    	GL.Events.Slice(:,2) = GL.Events.Slice(:,2) - t0 - starttime;
	end
else
	[GL, t0, cond] = gaglab_exp_waitfor(GL, {keypress('Start')});
end

gaglab_exp_time('Restart', t0 + starttime);
gaglab_eye_start(GL.Eye);
GL.Events.Key = [];
GL.Events.IKey = 1;
GL.Events.Response = [];
GL.Running = 4;

fprintf('Started\n\n');



function GL = gaglab_exp_firststart (GL)

GL.Runtime.OldPriority = CogProcess('getpriority');

% Initialise sync pulses
GL.Sync = gaglab_sync_start(GL.Setup.Sync);

% Initialise display
GL.Screen = gaglab_vis_start(GL);
if GL.Screen.IsOpen
	gaglab_vis_flip(GL.Screen);
end

% Initialise sound
GL.Sound = gaglab_snd_start(GL.Sound);

% Initialise responses
GL.Setup.Response.UseMouse = GL.Setup.Mouse.UseMouse;
try
	GL.Response = gaglab_resp_start(GL.Setup.Response, GL.Setup.TestMode);
catch
	gaglab_snd_stop(GL.Sound);
	gaglab_sync_stop(GL.Sync);
	gaglab_vis_stop(GL.Screen);
	rethrow(lasterror);
end

% If the XID device is Lumina and you specified to use sync but with a
% serial port = 0, then use the Lumina scanner input
if strcmpi(GL.Response.Device, 'xid') & GL.Setup.Sync.UseSync & ~GL.Sync.Port
	if isequal(gaglab_xid('model'), '0')
		GL.Sync.UseSync = 1;
	end
end

if GL.Setup.TestMode == 0
	priorityClass = CogProcess('enumpriorities');
	CogProcess('setpriority', priorityClass.high);
end
