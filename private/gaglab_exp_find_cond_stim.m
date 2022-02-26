function [cond, stim] = gaglab_exp_find_cond_stim (varargin)
% GAGLAB_EXP_FIND_COND_STIM		Command-line utility
%
% [C, S] = GAGLAB_EXP_FIND_COND_STIM(...) finds condition objects and stimulus
% objects in the argument list and returns them in C and S. C is a cell
% vector of condition object vectors. S is a simple vector of stimulus
% objects.

cond = {};
stim = [];

for i=1:nargin
	if isstruct(varargin{i}) & isfield(varargin{i}, 'type')
		if all(ismember([varargin{i}.type], 'TKRS?'))
			cond = [cond, {varargin{i}}];
		elseif all(ismember([varargin{i}.type], 'VAaED'))
			stim = [stim; varargin{i}(:)];
		else
			error('Invalid condition / stimulus objects');
		end
	elseif isreal(varargin{i}) & prod(size(varargin{i})) == 1
		cond = [cond, {time(varargin{i})}];
	else
		error('Invalid condition / stimulus objects');
	end
end
