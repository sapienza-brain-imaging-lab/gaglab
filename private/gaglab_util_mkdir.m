function gaglab_util_mkdir (destpath)

if ~exist(destpath, 'dir')
	[c,d,e] = fileparts(destpath);
	if isempty(c) | isempty(d)
		error(sprintf('Invalid destination path: %s', destpath));
	end
	status = mkdir(c, [d e]);
	if status == 0
		gaglab_util_mkdir(c);
		status = mkdir(c, [d e]);
	end
end
