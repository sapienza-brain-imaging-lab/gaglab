function FillArc (id, varargin)
% FILLARC	Draw a filled arc
%
% FILLARC(ID, [CX CY], [W H], [STARTANGLE ENDANGLE]) draws a filled arc
% into stimulus ID, with center at [CX CY], radius [W H], and start and end
% angle defined by [STARTANGLE ENDANGLE].

gaglabcmd('Arc', id, 'S', varargin{:});
