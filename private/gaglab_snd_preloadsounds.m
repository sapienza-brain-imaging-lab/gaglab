function Sound = gaglab_snd_preloadsounds (Sound, doload, varargin)

if length(varargin) == 0
	varargin{1} = '*.wav';
end

for i=1:length(varargin)
	if iscell(varargin{i})
		Sound = gaglab_snd_preloadsounds(Sound, varargin{i}{:});
	else
		flist = gaglab_util_filelist(varargin{i});
		if ~isempty(flist)
			for j=1:length(flist)
				Sound = gaglab_snd_load(Sound, flist{j}, doload);
			end
		end
	end
end
