function PenColor (id, color)
% PENCOLOR	Specify pen color for graphics operations
%
% PENCOLOR(ID, COLOR) specifies pen color for stimulus ID.
% PENCOLOR(COLOR) specifies the default pen color for all
% stimuli in the experiment.

if nargin == 1
	gaglabcmd('Set', 'Screen', 'PenColor', id);
else
	gaglabcmd('PenColor', id, color);
end
