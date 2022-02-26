function PenWidth (id, w)
% PENWIDTH	Specify pen width for graphics operations
%
% PENWIDTH(ID, W) specifies pen width for stimulus ID.
% PENWIDTH(W) specifies the default pen width for all
% stimuli in the experiment.
% The width should be expressed in the current measurement units. Use a
% width of zero to obtain a single pixel width.

if nargin == 1
	gaglabcmd('Set', 'Screen', 'PenWidth', id);
else
	gaglabcmd('PenWidth', id, w);
end
