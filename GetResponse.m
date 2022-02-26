function [RT,Key] = GetResponse (R)
% GETRESPONSE         Get the actual status of a response
%
% [RT, KEY] = GETRESPONSE(R) queries the actual status of the response
% whose ID is R. KEY is the code of the key that has been pressed by the
% experimental subject, and RT is the response time (in msec). If no
% response has been given, a value of 0 is returned for both KEY and RT if
% the response has already timed out, while a value of -1 is returned if
% the subject has still time to give the response.

[Key,RT] = gaglabcmd('GetResponse', R);
gaglabcmd('ShowLog');