function a = auditory (id)
% AUDITORY	Create an auditory stimulus object
%
% A = AUDITORY(ID) create an auditory stimulus object for sound ID, to be
% used in the PRESENT command to start playing a sound.

if nargin < 1, id = []; end
a = struct('type', 'A', 'what', id);
