function align = gaglab_vis_getalign (varargin)

align = 'xx';

for i=1:length(varargin)
	if ischar(varargin{i})
		align = checkalign_one(align, lower(varargin{i}));
	else
		error('Invalid alignment mode');
	end
end

function a = checkalign_one (a, str)

if length(str) == 1
	j = find(str == 'lcrtmbx');
	if isempty(j), error('Invalid alignment mode'); end
end
switch str
	case {'l', 'left'}
		a(1) = 'l';
	case {'c', 'center'}
		a(1) = 'c';
	case {'r', 'right'}
		a(1) = 'r';
	case {'t', 'top'}
		a(2) = 't';
	case {'m', 'middle'}
		a(2) = 'c';
	case {'b', 'bottom'}
		a(2) = 'b';
	case {'x'}
	otherwise
		for j=1:length(str)
			a = checkalign_one(a, str(j));
		end
end
