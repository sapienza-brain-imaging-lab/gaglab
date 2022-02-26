function ClearOnFlip (varargin)
% CLEARONFLIP	Specify whether the backbuffer must be cleared after a flip
%
% CLEARONFLIP(1) makes any screen flip result in the backbuffer being
% cleared to the default background color after the flip, so that it is
% ready for a complete new page to be drawn.
% CLEARONFLIP(0) cancels automatic backbuffer clearing, so that after each
% flip the backbuffer will contain what was visible on the screen before
% the flip.
% CLERONFLIP is ON by default.

gaglabcmd('ClearOnFlip', varargin{:});
