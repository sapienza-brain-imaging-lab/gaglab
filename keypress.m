function k = keypress (varargin)
% KEYPRESS	Create a keypress object
%
% K = KEYPRESS(...) create a keypress object to be used in the
% WAITUNTIL and PRESENT commands, to wait for a set of specific keypresses.
% K = KEYPRESS, by itself, represents any keypress.
% K = KEYPRESS(K1, K2, ...) represents only keypresses of keys K1 and K2.
% The arguments should be valid key codes, ranging from 1 to 10 for key
% down events, and from -1 to -10 for key up events. You can also specify
% the string 'start' to select a start key event.

k = [];
for i=1:nargin
	if ischar(varargin{i})
		switch lower(varargin{i})
			case 'start'
				k = [k; 11];
			otherwise
				error('Invalid key code');
		end
	else
		k = [k; varargin{i}(:)];
	end
end
k(k < -10 | k == 0 | k > 11) = [];
k = unique(k);
k = struct('type', 'K', 'what', k);
