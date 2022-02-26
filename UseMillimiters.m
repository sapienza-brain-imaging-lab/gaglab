function UseMillimiters (id)
% USEMILLIMITERS	Specify millimiters as the measurement units
%
% USEMILLIMITERS, by itself, specifies millimiters as the default
% measurement unit for all visual stimuli in the experiment.
% USEMILLIMITERS(ID) specifies millimiters as the current unit for
% stimulus ID. Use 0 to specify units for the backbuffer.

if nargin == 0
	gaglabcmd('Set', 'Screen', 'Units', 'mm');
else
	gaglabcmd('Units', id, 'mm');
end
