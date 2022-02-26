function Log = gaglab_exp_log (Log, Type, Time, varargin)
% GAGLAB_EXP_LOG	    	Add an event to the experiment log
%
% L = GAGLAB_EXP_LOG(L, TYPE, TIME, ...) add the event specified by TYPE, TIME,
% and the additional optional arguments, to the log L.

if isempty(Log)
	Log = struct('Event', [], 'Index', 1, 'Enable', 1);
end
if isempty(Log.Event)
	Log.Event.Type = Type;
else
	Log.Event(end+1).Type = Type;
end
Log.Event(end).Time = Time;
Log.Event(end).Info = varargin;
