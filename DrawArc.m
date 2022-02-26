function DrawArc (id, varargin)
% DRAWARC	Draw a hollow arc
%
% DRAWARC(ID, [CX CY], [W H], [STARTANGLE ENDANGLE]) draws a hollow arc
% into stimulus ID, with center at [CX CY], radius [W H], and start and end
% angle defined by [STARTANGLE ENDANGLE].

gaglabcmd('Arc', id, 'A', varargin{:});
