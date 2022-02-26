function DrawLine (id, varargin)
% DRAWLINE	Draw a line
%
% DRAWLINE(ID, [X1 Y1 X2 Y2]) draws a line from [X1 Y1] to [X2 Y2] into
% stimulus ID.

gaglabcmd('Line', id, varargin{:});
