function gaglab_vis_placeimage (id, A, xy, siz)

if isstruct(A)
	if isempty(A.Data)
		A = A.Name;
	else
		A = A.Data;
	end
end
if ischar(A)
	A = gaglab_vis_loadimage(A);
	A = A.Data;
end
imsize = size(A);
switch class(A)
	case 'logical'
		A = double(A);
	case 'uint8'
		A = double(A) ./ 255;
	case 'uint16'
		A = double(A) ./ 65535;
end
A = reshape(A, [prod(imsize(1:2)) 3]);

if id && all(xy == 0)
	if all(siz == 0)
		cgloadarray(id, imsize(1), imsize(2), A);
	else
		if isscalar(siz)
			siz(2) = siz(1) * imsize(2) / imsize(1);
		end
		cgloadarray(id, imsize(1), imsize(2), A, siz(1), siz(2));
	end
else
	if all(siz == 0)
		cgloadarray(10000, imsize(1), imsize(2), A);
	else
		if isscalar(siz)
			siz(2) = siz(1) * imsize(2) / imsize(1);
		end
		cgloadarray(10000, imsize(1), imsize(2), A, siz(1), siz(2));
	end
	cgalign('c','c');
	cgsetsprite(id);
	cgdrawsprite(10000, xy(1), xy(2));
	cgfreesprite(10000);
end
