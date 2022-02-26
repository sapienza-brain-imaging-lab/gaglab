function FillRect (id, varargin)
% FILLRECT	Draw a filled rectangle
%
% FILLRECT(ID, [X1 Y1 X2 Y2]) draws a filled rectangle at the given
% coordinates.

gaglabcmd('Rect', id, 'f', varargin{:});
