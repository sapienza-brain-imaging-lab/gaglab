function BackgroundColor (id, color)
% BACKGROUNDCOLOR	Specify background color for a stimulus
%
% BACKGROUNDCOLOR(ID, COLOR) specifies background color for stimulus ID.
% BACKGROUNDCOLOR(COLOR) specifies the default background color for all
% stimuli in the experiment.

if nargin == 1
	gaglabcmd('Set', 'Screen', 'BackgroundColor', id);
else
	gaglabcmd('BackgroundColor', id, color);
end
