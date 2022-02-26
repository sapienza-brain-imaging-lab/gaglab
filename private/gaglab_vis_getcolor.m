function [color, name] = gaglab_vis_getcolor (color)

if ischar(color)
	switch lower(color)
		case {'d','default','a','auto'}
			color = 'a';
		case {'k','black'}
			color = [0 0 0];
		case {'r','red'}
			color = [1 0 0];
		case {'g','green'}
			color = [0 1 0];
		case {'b','blue'}
			color = [0 0 1];
		case {'y','yellow'}
			color = [1 1 0];
		case {'m','magenta'}
			color = [1 0 1];
		case {'c','cyan'}
			color = [0 1 1];
		case {'w','white'}
			color = [1 1 1];
		otherwise
			error('Invalid color specification');
	end
elseif isequal(size(color), [1 3]) == 0
	error('Invalid color specification');
end

name = '';

if ~ischar(color)
	defcolor = [0 0 0; 1 0 0; 0 1 0; 0 0 1; 1 1 0; 1 0 1; 0 1 1; 1 1 1];
	defname = 'nrgbymcw';
	for i=1:size(defcolor,1)
		if all(color == defcolor(i,:))
			name = defname(i);
			break
		end
	end
end


