function siz = gaglab_vis_getsize (siz)

if ischar(siz)
	switch lower(siz)
		case {'d','default','a','auto'}
			siz = 'a';
		case {'s','screen'}
			siz = 's';
		otherwise
			error('Invalid size specification');
	end
elseif isequal(size(siz), [1 2]) == 0
	error('Invalid size specification');
end
