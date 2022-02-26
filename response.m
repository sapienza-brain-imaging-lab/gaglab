function r = response (id)
% RESPONSE	Create a response object
%
% R = RESPONSE(ID) create a response object for response ID, to be
% used in the WAITUNTIL and PRESENT commands.

if nargin < 1, id = []; end
r = struct('type', 'R', 'what', id);
