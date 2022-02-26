function gaglab_movie (where)
	if nargin == 0, where = pwd; end
	
	fps       = 25;
	name      = find_dumps(where);
	if length(name) < 2, return; end
	[name,t]  = compute_time(name, fps);
	[col,row] = compute_dim(name);
	
	fprintf('Creating movie... ');
	M           = VideoWriter([where, '.avi']);
	M.FrameRate = fps;
	M.Quality   = 100;
	open(M);
	for i=1:length(t)
		F = read_frame(name{i}, col, row);
		while t(i) > 100
			writeVideo(M, repmat(F, 1, 100));
			t(i) = t(i) - 100;
		end
		if t(i)
			writeVideo(M, repmat(F, 1, t(i)));
		end
	end
	close(M);
	fprintf('done\n');
end

function name = find_dumps (where)
	d = [dir(fullfile(where, 'dump_*.bmp')); dir(fullfile(where, 'dump_*.BMP'))];
	name = cellstr([repmat([where, filesep], length(d), 1), char({d.name})]);
end

function [col,row] = compute_dim (name)
	fprintf('Reading screen dumps... ');
	x = imread(name{1});
	delta = false(size(x,1), size(x,2));
	for i=2:length(name)
		y = imread(name{i});
		delta = delta | any(x ~= y, 3);
	end
	col = any(delta,1);
	row = any(delta,2);
	col = [find(col,1,'first'), find(col,1,'last')];
	row = [find(row,1,'first'), find(row,1,'last')];
	fprintf('done\n');
end

function x = read_frame (name, col, row)
	x = imread(name);
	 x = x(row(1):row(2),col(1):col(2),:,:);
	x = im2frame(x);
end

function [name, t] = compute_time (name, fps)
	t = regexp(name, 'dump_(\d+)', 'tokens');
	t = [t{:}];
	t = [t{:}];
	t = cellfun(@str2double, t);
	[t,j] = sort(t);
	name = name(j);
	t = round(t / 1000 * fps) + 1;
	t = [diff(t), fps];
	t(t==0) = 1;
end
