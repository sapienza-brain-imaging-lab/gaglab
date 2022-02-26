function FillPolygon (id, varargin)
% FILLPOLYGON	Draw a filled polygon
%
% FILLPOLYGON(ID, [X1 Y1; X2 Y2; X3 Y3]) draws a filled polygon with the
% specified vertex coordinates.

gaglabcmd('Poly', id, 'f', varargin{:});
