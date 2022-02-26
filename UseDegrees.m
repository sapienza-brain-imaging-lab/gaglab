function UseDegrees (id)
% USEDEGREES	Specify degrees as the measurement units
%
% USEDEGREES, by itself, specifies degrees of visual angle as the default
% measurement unit for all visual stimuli in the experiment.
% USEDEGREES(ID) specifies degrees of visual angle as the current unit for
% stimulus ID. Use 0 to specify units for the backbuffer.

if nargin == 0
	gaglabcmd('Set', 'Screen', 'Units', 'degrees');
else
	gaglabcmd('Units', id, 'degrees');
end
