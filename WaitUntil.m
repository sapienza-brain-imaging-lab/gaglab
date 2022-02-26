function T = WaitUntil (varargin)
% WAITUNTIL         Waits until a specified time or until specific conditions are met
%
% WAITUNTIL(T) waits until time T (in msec from experiment start).
%
% WAITUNTIL(COND, COND, ..., COND) waits until *any* of the condition sets
% specified by each COND argument is satisfied.
% Each condition set COND may be either a scalar, indicating a time to wait for
% in msec from experiment start, or a condition object indicating a more
% complex condition. Condition objects are created by the
% following function calls:
%       TIME(T)           wait until time T
%       RESPONSE(R)       wait for the subject to respond to
%                         response R, or for response R to time out
%       KEYPRESS(K)       wait for any of the keys specified by K
%       KEYPRESS('start') wait for the start key
%       VOLUME(V)         wait for first slice of volume V
%       VOLUME(V,S)       wait for Sth slice of volume V%
%
% Each condition set COND may also be a vector of condition objects. In
% this case, the set is satisfied when *all* conditions in the set are.
% Thus, WAITUNTIL(COND1, COND2) waits until *either* COND1 *or* COND2 are
% satisfied, while WAITUNTIL([COND1 COND2]) waits until *both* COND1 *and*
% COND2 are satisfied.
% More complex syntaxes, such as WAITUNTIL([COND1 COND2], COND3) are also allowed.
% In general, the function returns when any of the condition sets
% specified by each function argument becomes true. Each condition
% sets, in turn, is satisfied when all its component conditions are.
%
% T = WAITUNTIL(...) returns the time at which the
% conditions are met, in milliseconds since experiment start.
%
% Examples:
%     WaitUntil(response(3), time(20000))
%        waits until subject responds to response 3 OR time is 20000
%     WaitUntil([response(3), time(18000)], time(20000))
%        waits until subject responds to response 3, but at least until
%        time 18000 and at most until time 20000

T = gaglabcmd('WaitFor', varargin{:});
gaglabcmd('ShowLog');
