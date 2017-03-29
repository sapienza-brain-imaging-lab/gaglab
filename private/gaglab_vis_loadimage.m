function A = gaglab_vis_loadimage (imfile, doload)

if isstruct(imfile)
	A = imfile;
	imfile = A.Name;
else
	A.Name = imfile;
end

if nargin < 2 | doload
	try
		[A.Data,cmap,alpha] = imread(imfile);
	catch
		try
			[A.Data,cmap] = imread(imfile);
			alpha = [];
		catch
			error('Cannot read image %s', imfile);
		end
	end
	A.Data = permute(A.Data, [2 1 3]);
	if ndims(A.Data) == 2
		if isempty(cmap)
			A.Data = repmat(A.Data,[1 1 3]);
		else
			A.Data = reshape(cmap(double(A.Data)+1,:), [size(A.Data) 3]);
			%A.Data = uint8(round(A.Data * 255));
		end
	end
	A.Size = [size(A.Data,1), size(A.Data,2)];
	
	if ~isempty(alpha)
		alpha = repmat(permute(alpha, [2 1]), [1 1 3]);
		switch class(A.Data)
			case 'logical'
				A.Data = double(A.Data) .* double(alpha);
			case 'uint8'
				A.Data = double(A.Data) ./ 255 .* double(alpha) ./ 255;
			case 'uint16'
				A.Data = double(A.Data) ./ 65535 .* double(alpha) ./ 65535;
			otherwise
				A.Data = A.Data .* alpha;
		end
	end
else
	try
		info = imfinfo(imfile);
	catch
		error('Cannot read image %s', imfile);
	end
	A.Data = [];
	A.Size = [info.Width info.Height];
end
