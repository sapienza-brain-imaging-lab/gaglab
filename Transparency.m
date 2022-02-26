function Transparency (varargin)
% TRANSPARENCY	Specify whether a stimulus is transparent
%
% TRANSPARENCY(ID, 'ON') specifies that pixels in stimulus ID with
% the color set to the stimulus background color should be treated as
% transparent when copied to the screen.
% TRANSPARENCY(ID, 'OFF') specifies that the stimulus is opaque.
% TRANSPARENCY ON and TRANSPARENCY OFF specifies the default transparency mode
% for all stimuli in the experiment.
% Transparency works only if the stimulus background color is 'black',
% 'white', 'red', 'green', 'blue'. An error is generated if you attempt to
% activate transparency for stimuli with other background colors.

if nargin > 1
	gaglabcmd('Transparency', varargin{1}, Transparency_getvalue(varargin{2:end}));
else
	gaglabcmd('Set', 'Screen', 'Transparency', Transparency_getvalue(varargin{:}));
end



function val = Transparency_getvalue (val)

if nargin < 1 | isempty(val), val = 'a'; end
if ischar(val), val = lower(val); end
switch val
	case {1, 'on'}
		val = 1;
	case {0, 'off'}
		val = 0;
	otherwise
		error('Invalid transparency value');
end