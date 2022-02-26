function LoadImages (varargin)
% LOADIMAGES	Load images into memory
%
% LOADIMAGES, by itself, preloads all the image files in the experiment
% directory and subdirectories into memory, so that they can be displayed
% more quickly during the experiment.
%
% LOADIMAGES(PATTERN) preloads all the image files corresponding to the
% given pattern, e.g., '*.jpg' or 'exp1\*.tif'. All file names and paths
% are relative to the experiment directory.
%
% LOADIMAGES(FNAME1, FNAME2) preloads the specified image files.

gaglabcmd('LoadImages', varargin{:});
