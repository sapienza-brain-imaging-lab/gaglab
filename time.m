function t = time (t)
% TIME	Current time in msec from experiment time
%
% T = TIME returns the current time, computed in milliseconds from the
% start of the current experimental session.

if nargin == 0
	t = gaglab_exp_time;
else
	t = struct('type', 'T', 'what', t);
end
