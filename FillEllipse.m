function FillEllipse (id, varargin)
% FILLELLIPSE	Draw a filled ellipse
%
% FILLELLIPSE(ID, [CX CY], [W H]) draws a filled ellipse
% into stimulus ID, with center at [CX CY] and diameter [W H].

gaglabcmd('Ellipse', id, 'f', varargin{:});
