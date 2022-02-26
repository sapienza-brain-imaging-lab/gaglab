function DrawPoint (id, varargin)
% DRAWPOINT	Draw a point
%
% DRAWPOINT(ID, [X Y]) draws a point at [X Y] into stimulus ID.

gaglabcmd('Point', id, varargin{:});
