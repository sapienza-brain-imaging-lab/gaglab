function [R, ID] = gaglab_resp_define (R, T0, MaxRT, CorrectKey, ValidKeys, varargin)
% GAGLAB_RESP_DEFINE		Define a response
%
% [R,ID] = GAGLAB_RESP_DEFINE(R, T0, MAXRT, CORRECTKEY, VALIDKEYS, ...)
% defines a response which should be produced not more then MAXRT msec
% starting from stimulus time T0. VALIDKEYS is a vector of all valid
% keys. CORRECTKEY is the correct response. ID is the ID of the defined
% response. Optionally, MAXRT can be a vector of two items specifying
% minimum and maximum response times, respectively.
% Additional arguments are saved as extra columns to the results file.
	
R(end+1).T0 = T0;
if numel(MaxRT) == 1
    R(end).MinT = T0;
else
    R(end).MinT = T0 + MaxRT(1);
    MaxRT = MaxRT(2);
end
R(end).MaxT = T0 + MaxRT;
R(end).CorrectKey = CorrectKey;
if nargin < 5
	R(end).ValidKeys = [];
else
	R(end).ValidKeys = ValidKeys;
end
R(end).Key = -1;
R(end).RT = -1;
R(end).Correct = 0;
ID = length(R);
if nargin > 5
	R = gaglab_resp_codes(R, ID, varargin{:});
end
