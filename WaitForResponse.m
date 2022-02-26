function [RT,Key] = WaitForResponse (R, mint, maxt)
% WAITFORRESPONSE         Waits for a subject's response
%
% WAITRESPONSE(R) waits until the subject gives the response whose ID is R,
% or until the response times out.
% WAITRESPONSE(R, TMIN, TMAX) waits at least until TMIN and at most until
% TMAX msec from experiment start.
% [RT, KEY] = WAITRESPONSE(R, ...) also returns the code of the key that has
% been pressed by the subject, and the response time of the key press. If no
% response has been given, a value of 0 is returned for both KEY and RT.

if nargin < 3
	T = gaglabcmd('WaitFor', response(R));
else
	T = gaglabcmd('WaitFor', [response(R) time(mint)], time(maxt));
end
[Key,RT] = gaglabcmd('GetResponse', R);
gaglabcmd('ShowLog');
