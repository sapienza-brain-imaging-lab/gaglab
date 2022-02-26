function [Screen, id, j] = gaglab_vis_get (Screen, varargin)
% GAGLAB_VIS_GET		Get a stimulus index
%
% [S, ID, J] = GAGLAB_VIS_GET(S, ID) checks if stimulus
% specified by ID exists, and if not, creates it.
% [S, ID, J] = GAGLAB_VIS_GET(S, ARGS, INDEX) checks if stimulus
% specified by ARGS{INDEX} exists, and if not, creates it.
% J is the index of the stimulus in the stimulus structure.

id = gaglab_util_defaultarg({}, varargin, 1);
if iscell(id)
	index = gaglab_util_defaultarg(2, varargin, 2);
	if length(id) < index
		error('Invalid stimulus ID');
	end
	id = id{index};
end
if id < 0 | id > 9999
	error('Invalid stimulus ID');
end
j = find([Screen.Stimulus.ID] == id);
if isempty(j)
	if Screen.IsOpen
		error('Stimulus %d does not exist!', id);
	end
	[Screen,j] = gaglab_vis_create(Screen, id);
end
