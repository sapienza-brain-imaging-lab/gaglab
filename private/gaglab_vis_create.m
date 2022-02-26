function [Screen, j] = gaglab_vis_create (Screen, id, varargin)
% GAGLAB_VIS_CREATE			Create a stimulus
%
% [S,J] = GAGLAB_VIS_CREATE(S, ID, UNITS, [X Y], [R G B]) creates an empty
% stimulus. ID is a number in the range 1-9999 that will be used to
% refer to this stimulus. UNITS specifies the measurement units to be
% used for this stimulus, and may be 'degrees', 'mm', or 'pixels'
% (defaults to the default measurement unit set for the experiment). [X
% Y] specifies the stimulus size in the specified units. By default,
% the stimulus is automatically sized based on its contents. [R G B]
% specifies the stimulus background color (defaults to the experiment
% background color).

if id < 0 | id > 9999
	error('Invalid stimulus ID');
end
j = find([Screen.Stimulus.ID] == id);
if ~isempty(j)
	error('This stimulus already exists');
end

units = gaglab_vis_getunits(gaglab_util_defaultarg('default', varargin, 1));
siz = gaglab_vis_getsize(gaglab_util_defaultarg('auto', varargin, 2));
color = gaglab_vis_getcolor(gaglab_util_defaultarg('default', varargin, 3));
	
Screen.Stimulus(end+1).ID = id;
Screen.Stimulus(end).Units = units;
Screen.Stimulus(end).Size = siz;
Screen.Stimulus(end).BackgroundColor = color;
Screen.Stimulus(end).Transparency = -1;
Screen.Stimulus(end).PenColor = gaglab_vis_getcolor('default');
Screen.Stimulus(end).PenWidth = 'a';
Screen.Stimulus(end).FontName = 'a';
Screen.Stimulus(end).FontSize = 'a';
Screen.Stimulus(end).Align = 'cb';
Screen.Stimulus(end).Command = {};
Screen.Stimulus(end).Arg = {};
j = length(Screen.Stimulus);
