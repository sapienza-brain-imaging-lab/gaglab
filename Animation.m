function obj = Animation (varargin)
	M = struct( ...
		'units', 'degrees', ...
		'dims', 2, ...
		'stimulus', [], ...      % 1-by-N IDs of stimuli to draw
		'stimsize', [], ...      % N-by-2 sizes of stimuli to draw
		'pos', [], ...           % N-by-2 or N-by-3 actual positions of stimuli in world coordinates
		'size', [], ...          % 1-by-2 or 1-by-3 world (scene) size
		'center', [0 0], ...     % 1-by-2 or 1-by-3 world world coordinate of rotation/dilatation center (relative to world center)
		'windowsize', [], ...    % 1-by-2 size of the observation window (viewport): default to the whole screen
		'windowcenter', [0 0], ...  % 1-by-2 screen coordinates of the window center
		'tspeedrange', [0 10], ...  % [min, max] translation speed (units / sec)
		'tdirrange', [0:359], ...   % vector of possible translation directions (deg)
		'rspeedrange', [0 3], ...   % [min, max] rotation speed (deg / sec)
		'rdirrange', [-1 1], ...    % vector of possible rotation directions (1 = counterclockwise; -1 = clockwise)
		'dspeedrange', [0 3], ...   % [min, max] dilatation speed (units / sec)
		'ddirrange', [-1 1], ...    % vector of possible dilatation directions (1 = expansion; -1 = contraction)
		'tspeed', 0, ...         % 1-by-N translation speed
		'tdir', 0, ...           % translation direction
		'rspeed', 0, ...         % 1-by-N rotation speed
		'rdir', 1, ...           % rotation direction
		'dspeed', 0, ...         % 1-by-N dilatation speed
		'ddir', 1, ...           % dilatation direction
		'scrambled', false, ...  % flag indicating whether each item has a different trajectory
		'lastt', 0, ...           % time of last update
		'move', [] ...          % N-by-6 moving parameters (internal use)
		);
	obj = objectreference;
	if nargin
		set(obj, varargin{:});
	end
	
	function v = get_units
		v = M.units;
	end
	
	function v = get_stimulus
		v = M.stimulus;
	end
	
	function v = get_pos
		v = M.pos;
	end
	
	function v = get_size
		v = M.size;
	end
	
	function v = get_center
		v = M.center;
	end
	
	function v = get_windowsize
		v = M.windowsize;
	end
	
	function v = get_windowcenter
		v = M.windowcenter;
	end
	
	function v = get_tspeedrange
		v = M.tspeedrange;
	end
	
	function v = get_tdirrange
		v = M.tdirrange;
	end
	
	function v = get_rspeedrange
		v = M.rspeedrange;
	end
	
	function v = get_rdirrange
		v = M.rdirrange;
	end
	
	function v = get_dspeedrange
		v = M.dspeedrange;
	end
	
	function v = get_ddirrange
		v = M.ddirrange;
	end
	
	function v = get_tspeed
		v = M.tspeed;
	end
	
	function v = get_tdir
		v = M.tdir;
	end
	
	function v = get_rspeed
		v = M.rspeed;
	end
	
	function v = get_rdir
		v = M.rdir;
	end
	
	function v = get_dspeed
		v = M.dspeed;
	end
	
	function v = get_ddir
		v = M.ddir;
	end

	function set_units (v)
		v = gaglab_vis_getunits(v);
		if strcmp(v,'a')
			error('Invalid screen units');
		end
	end

	function set_stimulus (v)
		if ~isnumeric(v) || ~isreal(v) || ndims(v)~=2 || numel(v)~=size(v,2) || any(v~=round(v)) || any(v<=0)
			error('The STIMULUS property must be a row vector of stimulus numbers.');
		end
		if length(v) < length(M.stimulus)
			M.pos(length(v)+1:end,:) = [];
			M.tspeed(length(v)+1:end) = [];
		end
	end

	function set_pos (v)
	end

	function set_size (v)
	end

	function set_center (v)
	end

	function set_windowsize (v)
	end

	function set_windowcenter (v)
	end

	function set_tspeedrange (v)
	end

	function set_tdirrange (v)
	end

	function set_rspeedrange (v)
	end

	function set_rdirrange (v)
	end

	function set_dspeedrange (v)
	end

	function set_ddirrange (v)
	end

	function set_tspeed (v)
	end

	function set_tdir (v)
	end

	function set_rspeed (v)
	end

	function set_rdir (v)
	end

	function set_dspeed (v)
	end

	function set_ddir (v)
	end

	function method_placerandom
		M.pos(:,1) = rand_range([-M.size(1)/2, M.size(1)/2], [numel(M.stimulus),1]);
		M.pos(:,2) = rand_range([-M.size(2)/2, M.size(2)/2], [numel(M.stimulus),1]);
	end

	function method_moverandom (scrambled)
		if ~nargin
			scrambled = false;
		elseif numel(scrambled)~=1 || (~islogical(scrambled) && ~isnumeric(scrambled))
			error('gaglab:animation:param', 'The first parameter must be either TRUE or FALSE.');
		end
		M.tspeed = rand_range(M.tspeed, [numel(M.stimulus), 1]);
		M.tdir = rand_select(M.tdir, [numel(M.stimulus), 1]);
		M.rspeed = rand_range(M.rspeed, [numel(M.stimulus), 1]);
		M.rdir = rand_select(M.tdir, [D.numdots 1]);, ...
			rand_range(M.dspeed, [D.numdots 1]) .* pi ./ 180 .* rand_select(M.ddir, [D.numdots 1])];

		M.pos(:,1) = rand_range([-M.size(1)/2, M.size(1)/2], [numel(M.stimulus),1]);
		M.pos(:,2) = rand_range([-M.size(2)/2, M.size(2)/2], [numel(M.stimulus),1]);
	end

	function pr_setmovingparameters
	end

	function method_move (M, onset, duration)
		method_start(M, onset);
		while time < onset + duration
			method_update(time);
		end
	end

	function method_start (M, t)
		% TRANS is a N by 4 matrix: [DX, DY, ROT, SCALE]
		tspeed = rand_range(M.tspeed, [D.numdots 1]);
		tdir = rand_select(M.tdir, [D.numdots 1]) .* pi ./ 180;
		D.move = [cos(tdir) .* tspeed, sin(tdir) .* tspeed, ...
			rand_range(M.rspeed, [D.numdots 1]) .* pi ./ 180 .* rand_select(M.tdir, [D.numdots 1]), ...
			rand_range(M.dspeed, [D.numdots 1]) .* pi ./ 180 .* rand_select(M.ddir, [D.numdots 1])];
		D.tstart = t;
	end

	function method_update (t)
		dt = (t - D.tstart) ./ 1000;
		if D.scrambled          % new rotdil for each dot
			moveparam = D.move(:,:) .* dt;
		else                  % all dots get same rotdil
			moveparam = D.move(1,:) .* dt;
		end
		sina = sin(moveparam(:,3));
		cosa = cos(moveparam(:,3));
		xy = [(1+moveparam(:,4)) .* (D.dot(:,1) .* cosa - D.dot(:,2) .* sina) + moveparam(:,1), ...  % x
			(1+moveparam(:,4)) .* (D.dot(:,1) .* sina + D.dot(:,2) .* cosa) + moveparam(:,2)];   % y

		incloud = xy(:,1) >= -D.cloudsize(1)/2 & xy(:,1) <= D.cloudsize(1)/2 ...
			& xy(:,2) >= -D.cloudsize(2)/2 & xy(:,2) <= D.cloudsize(2)/2;
		CopyStimulus(D.stimulus, 0, xy(incloud,:));
	end

end

function val = rand_range (rang, siz)
	val = rang(1) + rand(siz) .* (rang(2)-rang(1));
end

function val = rand_select (vect, siz)
	val = ceil(rand(siz) .* numel(vect));
	val(val == 0) = 1;
	val = reshape(vect(val), siz);
end

function x = validate_range (x, num)
	if isnumeric(x) && isreal(x) && ndims(x)==2 && size(x,1) == 1
		if size(x,2)==1
			x = [x, x];
			return;
		elseif size(x,2)==2
			return;
		end
	end
	error('mover:invalidrange', 'Argument %d is an invalid range.', num);
end

function x = validate_select (x, num)
	if isnumeric(x) && isreal(x) && ndims(x)==2 && size(x,1) == 1
		if size(x,2) > 0
			return;
		end
		error('mover:invalidselect', 'Argument %d is an invalid list of options.', num);
	end
end
