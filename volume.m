function v = volume (v, s)
% VOLUME	Create a volume object
%
% V = VOLUME(J) create a volume object to be used in the
% WAITUNTIL and PRESENT commands, to wait for the acquistion of the first
% slice of volume J.
% V = VOLUME(J, K) can be used to specify the Kth slice of volume J.

if nargin < 1 | isempty(v), v = 1; end
v = v(:);
if length(v) == 1
	if nargin < 2
		v = [v; 1];
	else
		v = [v; s(1)];
	end
end
v = struct('type', 'S', 'what', v(1:2));
