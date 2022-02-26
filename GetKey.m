function [Key,T] = GetKey (varargin)
% GETKEY         Query key presses
%
% [KEY, T] = GETKEY returns the code and time of the last key pressed
% (excluding keys that have been attributed to responses).
% [KEY, T] = GETKEY(KEYS) restricts the query to the key codes passed in
% KEYS. Use GETKEY('START') to query the start key.
% KEY and T are both zero if none of the specified keys have been pressed.
% Note that key presses associated to responses are ignored. To catch such
% key presses, use GETRESPONSE or WAITFORRESPONSE.

[Key,T] = gaglabcmd('GetKey', varargin{:});
gaglabcmd('ShowLog');