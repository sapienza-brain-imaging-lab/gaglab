function GL = gaglab_exp_savesession (GL, immediate)
% GAGLAB_EXP_SAVESESSION	    	Save session status

GL = gaglab_exp_update(GL); 	% This ensures that all events have been properly caught

if immediate == 0 & ~isempty(GL.Events.Response)
	k = find([GL.Events.Response.RT] == -1);
	while ~isempty(k)
		GL = gaglab_exp_update(GL); 	% This gives enough time to the subject to respond
		k = find([GL.Events.Response.RT] == -1);
	end
end

GL.Events.EyeData = gaglab_eye_stop(GL.Eye);
GL.Sessions{end+1} = GL.Events;
