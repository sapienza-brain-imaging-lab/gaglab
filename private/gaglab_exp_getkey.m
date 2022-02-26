function [Experiment, key, t] = gaglab_exp_getkey (Experiment, keys, searchall)
% GAGLAB_EXP_GETKEY		Checks for key presses
%
% [E, KEY, T] = GAGLAB_EXP_GETKEY(E, KEY) returns whether one of the
% keys specified by KEY has been pressed since the last call to
% GAGLAB_EXP_GETKEY, and returns its code and time. KEY and T
% are both zero if none of the specified keys have been pressed.
%
% GAGLAB_EXP_GETKEY(E, KEY, 1) searches for all key presses, including those
% already reported by previous calls to GAGLAB_EXP_GETKEY.

key = 0;
t = 0;
if isempty(Experiment.Events.Key), return; end

if nargin < 2, keys = []; end
if nargin < 3, searchall = 0; end
if searchall
	ind = 1;
else
	ind = Experiment.Events.IKey;
end

if isstruct(keys), keys = keys.what; end
if isempty(keys), keys = [1:10]; end
for index = size(Experiment.Events.Key,1):-1:ind
	if ismember(Experiment.Events.Key(index,1), keys)
		key = Experiment.Events.Key(index,1);
		t = Experiment.Events.Key(index,2);
		if searchall == 0
			Experiment.Events.IKey = index + 1;
		end
		return
	end
end
Experiment.Events.IKey = size(Experiment.Events.Key,1) + 1;
