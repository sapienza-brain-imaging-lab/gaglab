function [varargout] = gaglab_exp_list (GL)
% GAGLAB_EXP_LIST	List available experiment scripts

[explist, menulist] = gaglab_exp_dirlist(GL, GL.ExperimentPath);
varargout{1} = explist';
varargout{2} = menulist;
return;

[explist1, menulist1] = gaglab_exp_dirlist(GL, GL.ExperimentPath);
[explist2, menulist2] = gaglab_exp_dirlist(GL, GL.ExperimentLib);
varargout{1} = [explist1, explist2]';
if isempty(menulist1) | isempty(menulist2)
	varargout{2} = [menulist1; menulist2];
else
	varargout{2} = [menulist1; {'', '-', ''}; menulist2];
end
return

explist = {};
menulist = {};
d = dir(GL.ExperimentPath);
for i=1:length(d)
	if d(i).name(1) ~= '.' & d(i).isdir & ~strcmpi(fullfile(GL.ExperimentPath, d(i).name), GL.SetupPath)
		e = dir(fullfile(GL.ExperimentPath, d(i).name, '*.m'));
		e(find([e.isdir])) = [];
		if any(strcmpi({e.name}, [d(i).name '.m']))
			explist{end+1} = d(i).name;
			menulist(end+1,:) = {d(i).name, d(i).name, fullfile(GL.ExperimentPath, d(i).name, [d(i).name '.m'])};
		elseif length(e)
			menulist(end+1,:) = {'', d(i).name, ''};
			for j=1:length(e)
				expname = e(j).name(1:end-2);
				explist{end+1} = [d(i).name ' -> ' expname];
				menulist(end+1,:) = {[d(i).name ' -> ' expname], ['>' expname], fullfile(GL.ExperimentPath, d(i).name, [expname '.m'])};
			end
		end
	end
end

if nargout > 0, varargout{1} = explist; end
if nargout > 1, varargout{2} = menulist; end


function [explist, menulist] = gaglab_exp_dirlist (GL, P)

explist = {};
menulist = {};
if isempty(P), return; end
d = dir(P);
for i=1:length(d)
	if d(i).name(1) ~= '.' & d(i).isdir & ~strcmpi(fullfile(P, d(i).name), GL.SetupPath)
		e = dir(fullfile(P, d(i).name, '*.m'));
		e(find([e.isdir])) = [];
		if any(strcmpi({e.name}, [d(i).name '.m']))
			explist{end+1} = d(i).name;
			menulist(end+1,:) = {d(i).name, d(i).name, fullfile(P, d(i).name, [d(i).name '.m'])};
		elseif length(e)
			menulist(end+1,:) = {'', d(i).name, ''};
			for j=1:length(e)
				expname = e(j).name(1:end-2);
				explist{end+1} = [d(i).name ' -> ' expname];
				menulist(end+1,:) = {[d(i).name ' -> ' expname], ['>' expname], fullfile(P, d(i).name, [expname '.m'])};
			end
		end
	end
end
