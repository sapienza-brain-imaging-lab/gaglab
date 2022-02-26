function [GL,T] = gaglab_exp_present (GL, cond, stim)
% GAGLAB_EXP_PRESENT		Present stimuli
%
% [E,T] = GAGLAB_EXP_PRESENT(E, COND, STIM) presents stimuli specified by the
% vector of stimulus object STIM when the condition set COND is
% satisfied. COND is a cell vector of condition sets (see GAGLAB_EXP_WAITFOR for
% details). T is the actual stimulus presentation time.
% Stimulus objects are created by the following functions:
%       VISUAL           flip the screen, thus showing what was
%                        prepared in the backbuffer
%       VISUAL(S)        copy stimulus S to the backbuffer and flip
%       VISUAL(S, X, Y)  same as above, but specifying where to put the
%                        stimulus S in backbuffer coordinates
%       AUDITORY(S)      play sound S
%       STOPSOUND(S)     stop sound S
%       TRIGGER(C)       send a trigger to channel C
%       SENDDATA(C, V)   send data V to channel C
%
% If any VISUAL stimulus is specified, the visual stimuli are copied to
% the backbuffer, and then the screen is flipped at presentation time.
% The backbuffer is then cleared to the default background color.
% If you want to simply flip the screen, without previously copying any
% prepared stimulus, specify VISUAL without additional arguments.
% If you do not want the backbuffer to be cleared, use CLEARONFLIP(0)
% before this call.

% The PRESENT command can be used during the preparation phase to show the
% initial visual stimulus. Other stimuli, and conditions, are ignored.
if GL.Running < 3
	stim = stim([stim.type] == 'V');
	cond = [];
	GL.Screen = gaglab_vis_start(GL);
	GL.Running = 2.5;
end

if isempty(stim)
	[GL, T] = gaglab_exp_waitfor(GL, cond);
	return
end

v = find([stim.type] == 'V');
A = find([stim.type] == 'A');
a = find([stim.type] == 'a');
e = find([stim.type] == 'E');
d = find([stim.type] == 'D');
trigdata = gaglab_trigger_prepare(GL.Trigger, [stim(e).what], [stim(d).what]);

for i=1:length(v)
	for j=1:size(stim(v(i)).what,1)
		GL.Screen = gaglab_vis_do(GL.Screen, 'Copy', stim(v(i)).what(j,1), 0, stim(v(i)).what(j,2:3));
	end
end

ts = struct('Visual', Inf, 'Audio', Inf, 'External', Inf);
if ~isempty(cond)
	if ~isempty(v)
		GL = gaglab_exp_waitfor(GL, cond, ~GL.Screen.ScreenMode(8));
	else
		GL = gaglab_exp_waitfor(GL, cond, 0);
	end
end
if ~isempty(v)
	ts.Visual = gaglab_vis_flip(GL.Screen);
end
if ~isempty(a)
	for i=1:length(a)
		gaglab_snd_play(GL.Sound, stim(a(i)).what, 1);
		ts.Audio(end+1) = gaglab_exp_time;
	end
end
if ~isempty(A)
	for i=1:length(A)
		gaglab_snd_play(GL.Sound, stim(A(i)).what, 0);
		ts.Audio(end+1) = gaglab_exp_time;
	end
end
if (~isempty(e) || ~isempty(d)) && ~isempty(GL.Trigger)
	[ts.External, GL.Trigger] = gaglab_trigger_send(GL.Trigger, trigdata);
end
if ~isempty(v)
	v = cat(1, stim(v).what);
	if isempty(v), v = 0; end
	GL.Events.Log = gaglab_exp_log(GL.Events.Log, 'V', ts.Visual, v(:,1));
	if GL.Screen.ClearOnFlip
		GL.Screen = gaglab_vis_do(GL.Screen, 'Clear', 0);
	end
end
if ~isempty(a)
	GL.Events.Log = gaglab_exp_log(GL.Events.Log, 'A', ts.Audio, stim(a(1)).what);
end
if ~isempty(e)
	GL.Events.Log = gaglab_exp_log(GL.Events.Log, 'T', ts.External, [stim(e).what]);
end
if ~isempty(d)
	GL.Events.Log = gaglab_exp_log(GL.Events.Log, 'D', ts.External, [(1+stim(d).what(1,:)).*stim(d).what(2,:)]);
end
T = min([ts.Visual, ts.Audio, ts.External]);
