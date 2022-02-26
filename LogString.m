function LogString (varargin)
% LOGSTRING	Add a text string to the experiment log
%
% LOGSTRING(STR) shows the text string STR to the command line together
% with the current time stamp, and adds STR to the experiment log.
% LOGSTRING(FMT, ...) work like FPRINTF, in that allows to specify a format
% string. See FPRINTF for details.

gaglabcmd('Log', varargin{:});
