function [varargout] = gaglab_exp_list (GL)
% GAGLAB_EXP_LIST	List available experiment scripts

[explist1, menulist1] = gaglab_exp_dirlist(GL, GL.ExperimentPath);
if isempty(GL.ExperimentLib)
	varargout{1} = explist1';
	varargout{2} = menulist1;
else
	[explist2, menulist2] = gaglab_exp_dirlist(GL, GL.ExperimentLib);
	varargout{1} = [explist1, explist2]';
	if isempty(menulist1) || isempty(menulist2)
		varargout{2} = [menulist1; menulist2];
	else
		varargout{2} = [menulist1; {'', '-', ''}; menulist2];
	end
end


function [explist, menulist] = gaglab_exp_dirlist (GL, P)

explist = {};
menulist = {};
if isempty(P), return; end
d = dir(P);
for i=1:length(d)
	if d(i).name(1) ~= '.' && d(i).isdir && ~strcmpi(fullfile(P, d(i).name), GL.SetupPath)
		e = dir(fullfile(P, d(i).name, '*.m'));
		e([e.isdir]) = [];
		if any(strcmpi({e.name}, [d(i).name '.m']))
			explist{end+1} = d(i).name; %#ok<AGROW>
			menulist(end+1,:) = {d(i).name, d(i).name, fullfile(P, d(i).name, [d(i).name '.m'])}; %#ok<AGROW>
		elseif ~isempty(e)
			menulist(end+1,:) = {'', d(i).name, ''}; %#ok<AGROW>
			for j=1:length(e)
				expname = e(j).name(1:end-2);
				explist{end+1} = [d(i).name ' -> ' expname]; %#ok<AGROW>
				menulist(end+1,:) = {[d(i).name ' -> ' expname], ['>' expname], fullfile(P, d(i).name, [expname '.m'])}; %#ok<AGROW>
			end
		end
	end
end
