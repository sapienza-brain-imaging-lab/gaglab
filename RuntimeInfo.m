function RuntimeInfo (varargin)
% RUNTIMEINFO         Set experiment runtime information
%
% RUNTIMEINFO(SUB, STU, SER) stores information about subject name SUB,
% study number STU, and series number SER, for the
% next experiment to run.

if nargin > 0
	gaglabcmd('Subject', varargin{1});
end
if nargin > 1
	gaglabcmd('Study', varargin{2});
end
if nargin > 2
	gaglabcmd('Series', varargin{3});
end
