function DrawPolygon (id, varargin)
% DRAWPOLYGON	Draw an empty polygon
%
% DRAWPOLYGON(ID, [X1 Y1; X2 Y2; X3 Y3]) draws an empty polygon with the
% specified vertex coordinates.

gaglabcmd('Poly', id, 'a', varargin{:});
