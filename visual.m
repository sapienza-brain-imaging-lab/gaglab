function v = visual (id, x, y)
% VISUAL	Create a visual stimulus object
%
% V = VISUAL(ID) create a visual stimulus object for stimulus ID, to be
% used in the WAITUNTIL and PRESENT commands.
% V = VISUAL(ID, XY) and V = VISUAL(ID, X, Y) creates a visual stimulus
% object to be placed at the coordinates specified by X and Y for the
% PRESENT command.
% More than one stimulus can be specified by passing vectors of appropriate
% lengths.

if nargin < 1, id = 0; end
id = id(:);

if nargin < 2
	x = zeros(length(id),1);
elseif size(x,2) > 1
	if size(x,1) ~= length(id) & size(x,2) ~= 2
		error('Invalid X matrix');
	end
else
	x = x(:);
	if length(x) ~= length(id)
		error('Invalid X matrix');
	end
end

if size(x,2) == 1
	if nargin < 3
		x = [x, zeros(size(x,1),1)];
	else
		y = y(:);
		if length(y) ~= size(x,1)
			error('Invalid Y matrix');
		end
		x = [x y];
	end
end

j = find(id);
v = struct('type', 'V', 'what', [id(j,:), x(j,:)]);
