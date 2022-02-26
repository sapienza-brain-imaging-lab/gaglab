function [T,Key] = WaitForKey (K, mint, maxt)
% WAITFORKEY         Waits for a key press
%
% WAITFORKEY waits until the subject presses any key.
% WAITFORKEY(KEYS) waits until the subject presses any of the key whose key
% codes are given in KEYS. Use WAITFORKEY('START') to wait for the start
% key.
% WAITFORKEY(KEYS, TMIN, TMAX) waits at least until TMIN and at most until
% TMAX msec from experiment start.
% [T, KEY] = WAITFORKEY(...) returns the code of the key that has
% been pressed by the subject, and the time of the key press. If no key was
% pressed before TMAX, 0 is returned in KEY.

if nargin < 1, K = []; end
K = keypress(K);
if nargin < 3
	T = gaglabcmd('WaitFor', K);
else
	T = gaglabcmd('WaitFor', [K time(mint)], time(maxt));
end
[Key,T] = gaglabcmd('GetLastKey', K);
gaglabcmd('ShowLog');
