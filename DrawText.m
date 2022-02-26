function DrawText (id, varargin)
% DRAWTEXT	Draw text inside a stimulus
%
% DRAWTEXT(ID, STRING, [X Y]) draws text string STRING at the location
% given by [X Y].

gaglabcmd('Text', id, varargin{:});
