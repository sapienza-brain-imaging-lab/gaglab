function AcquisitionParameters (varargin)
% ACQUISITIONPARAMETERS	Set fMRI acquisition parameters.
%
% ACQUISITIONPARAMETERS(NSLICES, TRSLICES, TRVOLUMES) specifies
% the number of slices per volume (NSLICES) and the repetition time (TR).
% Usually, the TR is calculated from actual slice acquisition data.
% However, you should also set the TR in the case you use explicit
% synchronization instruction in your experiment script, and the scanner is
% not connected. TRSLICES is the time (msec) between slices; TRVOLUMES is
% the time (msec) between volumes, and should be >= NSLICES * TRSLICES,
% otherwise it will be interpreted as the extra time (msec) after the last
% slice of each volume.

if nargin > 0
	gaglabcmd('Set', 'Sync', 'NumSlices', varargin{1});
end
if nargin > 1
	gaglabcmd('Set', 'Sync', 'TRslices', varargin{2});
end
if nargin > 2
	gaglabcmd('Set', 'Sync', 'TRvolumes', varargin{3});
end
