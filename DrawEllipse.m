function DrawEllipse (id, varargin)
% DRAWELLIPSE	Draw a hollow ellipse
%
% DRAWELLIPSE(ID, [CX CY], [W H]) draws a hollow ellipse
% into stimulus ID, with center at [CX CY] and diameter [W H].

gaglabcmd('Ellipse', id, 'a', varargin{:});
