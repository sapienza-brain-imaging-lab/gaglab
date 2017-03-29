function GL = gaglab_exp_update (GL)
% GAGLAB_EXP_UPDATE	    	Update all events

GL.Events = gaglab_resp_update(GL.Events, GL.Response, GL.Sync);
GL.Events = gaglab_sync_update(GL.Events, GL.Sync);
GL.Events.EyeData.value = [GL.Events.EyeData.value; gaglab_eye_update(GL.Eye)];

% Stop the experiment if the Stop key was pressed
if ~isempty(GL.Events.StopKey)
	GL.Events.StopKey = [];
	gaglabcmd('stop', GL);
end
