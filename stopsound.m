function a = stopsound (id)
% STOPSOUND	      Create a sound-stop object
%
% STOPSOUND(ID) create an object to be used in the PRESENT
% command to stop playing sound ID.

if nargin < 1, id = []; end
a = struct('type', 'a', 'what', id);
