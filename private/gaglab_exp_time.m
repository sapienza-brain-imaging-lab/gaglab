function [varargout] = gaglab_exp_time (t, t0)
% GAGLAB_EXP_TIME		Current experiment time
%
% T = GAGLAB_EXP_TIME returns the number of msec elapsed from the start of the
% current experimental session. If no experimental session has been
% started, it returns zero.
% T = GAGLAB_EXP_TIME(T) converts a CogStd time value (in seconds) to a
% GagLab time value (msec from the start of the current experimental
% session).
% GAGLAB_EXP_TIME START resets timing from this moment.
% GAGLAB_EXP_TIME STOP stops timing (all time requests will now give zero).
% GAGLAB_EXP_TIME('RESTART', T) resets timing so that time T (in msec from
% current start) will be time 0.

persistent ZeroTime

if nargin == 0
	varargout{1} = gaglab_exp_converttime(cogstd('sGetTime',-1), ZeroTime);
elseif isnumeric(t)
	varargout{1} = gaglab_exp_converttime(t, ZeroTime);
else
	switch lower(t)
		case 'start'
			ZeroTime = floor(cogstd('sGetTime',-1) * 1000);
		case 'stop'
			ZeroTime = [];
		case 'restart'
			ZeroTime = ZeroTime + t0;
	end
end


function t = gaglab_exp_converttime (t, zerotime)

if isempty(zerotime)
	t(:) = 0;
else
	t = floor(t .* 1000) - zerotime;
end

