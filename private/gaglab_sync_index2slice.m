function [v, s] = gaglab_sync_index2slice (SyncSetup, i)

v = 0;
s = 0;
if nargin < 2 | i < 1, return; end

v = floor((i-1) / SyncSetup.NumSlices) - SyncSetup.StartVolumes + 1;
s = mod(i-1, SyncSetup.NumSlices) + 1;
