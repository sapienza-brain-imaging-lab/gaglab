function a = endsound (id)
% ENDSOUND	      Create a sound-end object
%
% ENDSOUND(ID) create an object to be used in the WAITUNTIL and
% PRESENT commands to test for the end of playback of sound ID.

if nargin < 1, id = []; end
a = struct('type', '?', 'what', id);
