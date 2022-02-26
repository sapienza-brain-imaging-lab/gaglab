function GL = gaglab_exp_load (GL, expname)
% GAGLAB_EXP_LOAD		Load an experiment
%
% GL = GAGLAB_EXP_LOAD(GL, EXPNAME, ...) creates the experiment structure.

if nargin < 2
	expname = fullfile(GL.Experiment.Path, GL.Experiment.Name);
end

[p,f] = fileparts(expname);
if isempty(f)
	GL.Experiment.Path = '';
	GL.Experiment.Name = '';
	GL.Experiment.Category = '';
	return
end	
if exist(fullfile(p, [f '.m']))
	GL.Experiment.Path = p;
	GL.Experiment.Name = f;
	GL.Experiment.Category = f;
else
	if ~any(expname == filesep)
		expname = fullfile(expname, expname);
	end
	expname = fullfile(GL.ExperimentPath, [expname '.m']);
	if ~exist(expname, 'file')
		error('Cannot find experiment "%s"', expname);
	end
	[GL.Experiment.Path, GL.Experiment.Name] = fileparts(expname);
	GL.Experiment.Category = fileparts(GL.Experiment.Path);
end
