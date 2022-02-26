function Images = gaglab_vis_preloadimages (Images, varargin)

if length(varargin) == 0
	f = imformats;
	f = cat(2, f.ext);
	for i=1:length(f)
		f{i} = ['*.' f{i}];
	end
	varargin{1} = f;
end

for i=1:length(varargin)
	if iscell(varargin{i})
		Images = gaglab_vis_preloadimages(Images, varargin{i}{:});
	else
		flist = gaglab_util_filelist(varargin{i});
		if ~isempty(flist)
			for j=1:length(flist)
				Images = [Images, gaglab_vis_loadimage(flist{j})];
			end
		end
	end
end
