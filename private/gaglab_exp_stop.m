function GL = gaglab_exp_stop (GL, immediate)
% GAGLAB_EXP_STOP	Stop the current experiment

if GL.Running == 4		% Running: need to save
	GL = gaglab_exp_savesession(GL, immediate);
	GL = gaglab_exp_save(GL);
	GL.Running = 3;
end

if GL.Running > 2.5
	fprintf('EXPERIMENT STOPPED\n');

	CogProcess('setpriority', GL.Runtime.OldPriority);
	gaglab_eye_shut(GL.Eye);
	gaglab_trigger_stop(GL.Trigger);
	gaglab_snd_stop(GL.Sound);
	gaglab_resp_stop(GL.Response);
	gaglab_sync_stop(GL.Sync);
	gaglab_exp_time('Stop');
	gaglab_vis_stop(GL.Screen);
end

if GL.Running
	cd(GL.Runtime.OldPath);
end

GL.Running = 0;

fld = {'Runtime','Screen','Sound','Response','Sync','Image','Events','Sessions'};
for i=1:length(fld)
	if isfield(GL, fld{i})
		GL = rmfield(GL, fld{i});
	end
end
