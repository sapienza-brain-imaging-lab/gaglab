function [v,s,t] = gaglab_sync_last (Events, SyncSetup)
% GAGLAB_SYNC_LAST		Returns the most recently acquired slice
%
% [V,S,T] = GAGLAB_SYNC_LAST(E, S) returns the volume and slice
% number and the acquisition time of the last acquired slice.

if SyncSetup.UseSync
	if isempty(Events.Slice)
		varargout{1} = 0;
		varargout{2} = 0;
		varargout{3} = 0;
	else
		[varargout{1}, varargout{2}] = gaglab_sync_index2slice(SyncSetup, Events.Slice(end,1));
		varargout{3} = Events.Slice(end,2);
	end
else
	t = gaglab_exp_time;
	varargout{1} = floor(t / SyncSetup.TRvolumes) + 1;
	varargout{2} = min(SyncSetup.NumSlices, ...
		floor((t - (varargout{1}-1) * SyncSetup.TRvolumes) / SyncSetup.TRslices) + 1);
end
