function GL = gaglab_exp_init (GL)
% GAGLAB_EXP_INIT		Initialize an experiment

if isempty(GL.Experiment.Name)
	error('No experiment loaded');
end
GL = gaglab_exp_stop(GL, 1);
GL.Runtime.OldPath = pwd;
cd(GL.Experiment.Path);
GL.Experiment.Path = pwd;
GL.Running = 1;
GL.Screen = gaglab_vis_init(GL);
GL.Sound = gaglab_snd_init;
GL.Trigger = gaglab_trigger_init(GL.Setup.Trigger);
GL.Eye = gaglab_eye_init(GL.Setup.Eye);
GL.Image = struct('Name', {}, 'Data', {}, 'Size', {});
GL.Sessions = {};

[p,f] = fileparts(GL.Experiment.Path);
GL.Runtime.ResultsPath = fullfile(GL.ResultsPath, f);
GL.Runtime.LogPath = fullfile(GL.LogPath, f);
gaglab_util_mkdir(GL.Runtime.ResultsPath);
gaglab_util_mkdir(GL.Runtime.LogPath);
