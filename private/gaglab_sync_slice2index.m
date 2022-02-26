function [i,t] = gaglab_sync_slice2index (SyncSetup, v, s)

i = 0;
if nargin < 3, s = 1; end
if s < 1 | s > SyncSetup.NumSlices, return; end

i = (v + SyncSetup.StartVolumes - 1) * SyncSetup.NumSlices + s;
t = (v - 1) * SyncSetup.TRvolumes + (s - 1) * SyncSetup.TRslices;
