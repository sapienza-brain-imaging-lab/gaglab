function UsePixels (id)
% USEPIXELS	Specify pixels as the measurement units
%
% USEPIXELS, by itself, specifies pixels as the default
% measurement unit for all visual stimuli in the experiment.
% USEPIXELS(ID) specifies pixels as the current unit for
% stimulus ID. Use 0 to specify units for the backbuffer.

if nargin == 0
	gaglabcmd('Set', 'Screen', 'Units', 'pixels');
else
	gaglabcmd('Units', id, 'pixels');
end
