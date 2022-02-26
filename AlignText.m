function AlignText (varargin)
% ALIGNTEXT	Set the text alignment mode
%
% ALIGNTEXT(ID, MODE) specifies the alignment mode for
% subsequent text operations for stimulus ID. MODE can be a string
% specifying the alignment mode. 'LEFT', 'CENTER', 'RIGHT' specify
% horizontal alignment mode, while 'TOP', 'MIDDLE', 'BOTTOM' specify
% vertical alignment mode.
% ALIGNTEXT(MODE) specifies the default alignment mode for all
% stimuli in the experiment.

if nargin == 1
	gaglabcmd('Set', 'Screen', 'Align', varargin{1});
else
	gaglabcmd('Align', varargin{1:2});
end
