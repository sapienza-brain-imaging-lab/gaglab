function [V,S,T] = GetLastSlice
% GETSLICE         Get info about the last acquired slice
%
% [V, S, T] = GETLASTSLICE returns the volume number V, the slice number S,
% and the acquisition time T of the last acquired slice.

[V,S,T] = gaglabcmd('GetLastSlice');
gaglabcmd('ShowLog');