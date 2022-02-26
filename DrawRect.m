function DrawRect (id, varargin)
% DRAWRECT	Draw an empty rectangle
%
% DRAWRECT(ID, [X1 Y1 X2 Y2]) draws an empty rectangle at the given
% coordinates.

gaglabcmd('Rect', id, 'a', varargin{:});
