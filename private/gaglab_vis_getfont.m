function name = gaglab_vis_getfont (name)

if ischar(name)
	switch lower(name)
		case {'d','default','a','auto'}
			name = 'a';
	end
else
	error('Invalid font name');
end
