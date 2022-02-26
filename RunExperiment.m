function RunExperiment (expname, parameter)
% RUNEXPERIMENT         Run an experiment
%
% RUNEXPERIMENT EXPNAME runs the experiment EXPNAME.
%
% RUNEXPERIMENT(EXPNAME, PARAMETER) passes an additional argument to EXPNAME.M.

gaglabcmd('Experiment', expname);
if nargin > 1
	gaglabcmd('Parameters', parameter);
end
gaglabcmd('Run');
