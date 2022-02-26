function TextFont (id, varargin)
% TEXTFONT	Specify font name and size for a stimulus
%
% TEXTFONT(ID, NAME, SIZE) specifies the name and size of the font to be
% used for text operations in stimulus ID. SIZE should be given in the
% current measurement units.
% TEXTFONT(NAME, SIZE) specifies the default font name and size for all
% stimuli in the experiment.

if isnumeric(id)
	gaglabcmd('Font', id, varargin{:});
else
	gaglabcmd('Set', 'Screen', 'FontName', id);
	if nargin > 1
		gaglabcmd('Set', 'Screen', 'FontSize', varargin{1});
	end
end
