function A = gaglab_vis_loadimage (imfile, doload)

if isstruct(imfile)
	A = imfile;
	imfile = A.Name;
else
	A.Name = imfile;
end

if nargin < 2 | doload
	try
		[A.Data,cmap] = imread(imfile);
	catch
		error('Cannot read image %s', imfile);
	end
	A.Data = permute(A.Data, [2 1 3]);
	if ndims(A.Data) == 2
		if isempty(cmap)
			A.Data = repmat(A.Data,[1 1 3]);
		else
			A.Data = reshape(cmap(double(A.Data)+1,:), [size(A.Data) 3]);
			A.Data = uint8(round(A.Data * 255));
		end
	end
	A.Size = [size(A.Data,1), size(A.Data,2)];
else
	try
		info = imfinfo(imfile);
	catch
		error('Cannot read image %s', imfile);
	end
	A.Data = [];
	A.Size = [info.Width info.Height];
end
