function filelist = gaglab_util_filelist (pattern)

if nargin < 1, pattern = '*.*'; end
if any(pattern == '*') || any(pattern == '?')
	[p,f,e] = fileparts(pattern);
	if isempty(p)
		p = pwd;
	end
	filelist = gaglab_util_recursive(p, [f e])';
elseif exist(pattern, 'file')
	filelist = {pattern};
else
	filelist = {};
end


function filelist = gaglab_util_recursive (p, pattern)

d = dir(fullfile(p, pattern));
d(strncmp({d.name},'.',1)) = [];
d([d.isdir]) = [];
if isempty(d)
	filelist = {};
else
	filelist = cellstr([repmat([p, filesep], length(d), 1), char(sort({d.name}))])';
end

d = dir(p);
d(strncmp({d.name},'.',1)) = [];
d(~[d.isdir]) = [];
for i=1:length(d)
    filelist = [filelist, gaglab_util_recursive(fullfile(p, d(i).name), pattern)]; %#ok<AGROW>
end
