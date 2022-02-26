function LoadSounds (varargin)
% LOADSOUNDS	Load sounds into memory
%
% LOADSOUNDS, by itself, preloads all the sound files in the experiment
% directory and subdirectories into memory, so that they can be prepared
% more quickly during the experiment.
%
% LOADSOUNDS(PATTERN) preloads all the sounds files corresponding to the
% given pattern, e.g., 'snd0???.wav'. All file names and paths
% are relative to the experiment directory.
%
% LOADSOUNDS(FNAME1, FNAME2) preloads the specified sounds files.

gaglabcmd('LoadSounds', varargin{:});
