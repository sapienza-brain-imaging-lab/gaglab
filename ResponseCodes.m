function ResponseCodes (varargin)
% RESPONSECODES         Define response codes
%
% RESPONSECODES(R, VARNAME1, VALUE1, VARNAME2, VALUE2, ...) define variable
% names and corresponding values to be saved to the results file together
% with response R. The command can be invoked at any time after the
% definition of response R, and before the end of the experiment.
% Each defined variable will be saved into a different column in the
% results file.

gaglabcmd('ResponseCodes', varargin{:});
