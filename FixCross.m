function FixCross (id, siz, pos)
% FIXCROSS	Draw a fixation cross
%
% FIXCROSS(ID, SIZE, [X Y]) draws a fixation cross of size SIZE at the
% coordinates given by [X Y] into stimulus ID.

if nargin < 2, siz = 1; end
if nargin < 3, pos = [0 0]; end

gaglabcmd('Line', id, [pos pos] + [-siz/2 0 siz/2 0]);
gaglabcmd('Line', id, [pos pos] + [0 -siz/2 0 siz/2]);

