function units = gaglab_vis_getunits (units)

if ischar(units)
	switch lower(units)
		case {'p','pix','pixel','pixels'}
			units = 'p';
		case {'m','mm','millimiter','millimiters'}
			units = 'm';
		case {'d','deg','degree','degrees'}
			units = 'd';
		case {'default','a','auto'}
			units = 'a';
		otherwise
			error('Invalid screen units');
	end
else
	error('Invalid screen units');
end
