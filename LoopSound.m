function LoopSound(id, mode)
% LOOPSOUND     Set the loop play mode of a sound
%
% LOOPSOUND(ID) or LOOPSOUND(ID, 1) sets sound ID to loop mode.
% LOOPSOUND(ID, 0) resets sound ID to normal play mode.

if nargin < 2, mode = 1; end
gaglabcmd('setsound', id, 'loop', mode);
