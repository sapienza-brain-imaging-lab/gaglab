function obj = Trajectory (units)
	% TRAJECTORY              Define trajectories of moving objects
	%
	% T = TRAJECTORY creates a Trajectory object which defines the motion
	% paremeters for one or more objects moving during an animation. The
	% trajectory can be either in 2D, i.e., on the screen plane, or in 3D,
	% in which case the third (z) dimension is orthogonal to the screen
	% plane (which is defined at z=0), with the positive z axis directed far
	% away from the observer.
	%
	% A trajectory object defines a composite motion trajectory which
	% results from the (linear) combination of an arbitrary set of motion
	% components, each represented by a MotionComponent object. Components
	% can be defined invoking the appropriate methods on the Trajectory
	% object.
	%
	% Three types of components can be defined, each in either two or three
	% dimensions: linear motion components (translations), rotatory motion
	% components around an arbitrary center and axis (rotations), and
	% dilatatory components around an arbitrary expansion focus (dilation).
	% For each component, you can either specify the exact value of the
	% motion parameters or ranges of possible values. In the latter case,
	% new values are randomly assigned each time you call the T.Set method.
	%
	% The Trajectory object has the following properties:
	%    T.Units      spatial units ('degrees', 'mm', 'pixels')
	%    T.Component  (read-only) a vector of motion components
	%
	% The following methods can be used to append a motion component to the
	% Trajectory object. These methods return the MotionComponent object
	% describing the motion component:
	%    MC = T.AddTranslation(TSPEED, TDIR)        adds a translation component
	%    MC = T.AddRotation(RSPEED, RDIR, CENTER)   adds a rotation component
	% 	 MC = T.AddDilation(DSPEED, CENTER)         adds a dilation component
	% To remove a motion, component use T.Remove(MC).
	%
	% The following is an explanation of the motion parameters:
	%    TSPEED    [SP] translation speed in spatial units / sec, or
	%              [SPmin; SPmax] range of allowed translation speeds
	%    RSPEED    [SP] rotation speed in degrees / sec or [SPmin; SPmax]
	%              range of allowed rotation speeds
	%    DSPEED    [SP] dilation speed in spatial units / sec, or
	%              [SPmin; SPmax] range of allowed dilation speeds.
	%              Positive values denote expansion.
	%    TDIR      [TH, PHI] translation direction, or [THmin, PHImin;
	%              THmax, PHImax] range of allowed translation directions:
	%              TH is the counterclockwise angle (in degrees) in the xy
	%              (screen) plane measured from the x axis; PHI is the depth
	%              angle (in degrees: positive = away from the observer) from
	%              the screen plane. PHI is 0 and can be omitted for 2D
	%              motion.
	%    RDIR      [TH, PHI] direction of the rotation axis, or [THmin, PHImin;
	%              THmax, PHImax] range of allowed rotations: see TDIR for
	%              further explanations
	%    CENTER    [CX, CY, CZ] coordinates of the rotation/dilation
	%              center, or [CXmin, CYmin, CZmin; CXmax, CYmax, CZmax]
	%              range of allowed rotation/dilation centers. CZ is 0 and
	%              can be omitted for 2D motion. The CENTER parameter can
	%              be omitted altogether and defaults to [0, 0, 0]
	% Each parameter can be substituted by a cell array, to define multiple
	% discontinuous allowed ranges.In this case, each item in the cell
	% array must specify a valid set or range of parameters.
	
	if nargin == 0, units = 'degrees'; end
	T = struct( ...
		'units', units, ...
		'component', [] ...
		);
	clear units
	obj = objectreference;
		
	function v = get_Units %#ok<DEFNU>
		v = T.units;
	end

	function set_Units (v) %#ok<DEFNU>
		v = gaglab_vis_getunits(v);
		if strcmp(v,'a')
			error('Invalid screen units');
		end
		T.units = v;
	end
		
	function v = get_Component %#ok<DEFNU>
		v = T.component;
	end
	
	function M = method_AddTranslation (varargin) %#ok<DEFNU>
		M = pr_AddComponent(MotionComponent('translation', varargin{:}));
	end
	
	function M = method_AddRotation (varargin) %#ok<DEFNU>
		M = pr_AddComponent(MotionComponent('rotation', varargin{:}));
	end
	
	function M = method_AddDilation (varargin) %#ok<DEFNU>
		M = pr_AddComponent(MotionComponent('dilation', varargin{:}));
	end
		
	function M = pr_AddComponent (M)
		if isempty(T.component)
			T.component = M;
		else
			T.component(end+1) = M;
		end
	end
	
	function method_Remove (M) %#ok<DEFNU>
		c = T.component;
		if ~isempty(c)
			[tmp,j] = ismember([M.id], [c.id]);
			T.component(j(j~=0)) = [];
		end
	end
	
	function method_set %#ok<DEFNU>
		if ~isempty(T.component)
			T.component.set;
		end
	end
	
	function mat = method_getmatrix (t) %#ok<DEFNU>
		mat = eye(4);
		for i=1:length(T.component);
			mat = mat * T.component(i).getmatrix(t);
		end
	end
end

function obj = MotionComponent (type, speed, a, b)
	
	M = struct (...
		'type', type, ...
		'speed', [], ...
		'dir', [], ...
		'center', [], ...
		'speedrange', {{}}, ...
		'dirrange', {{}}, ...
		'centerrange', {{}} ...
		);
	switch type
		case 'translation'
			error(nargchk(3,3,nargin,'struct'));
			set_speed(speed);
			set_dir(a);
		case 'rotation'
			error(nargchk(3,4,nargin,'struct'));
			if nargin < 4, b = [0 0 0]; end
			set_speed(speed);
			set_dir(a);
			set_center(b);
		case 'dilation'
			error(nargchk(2,3,nargin,'struct'));
			if nargin < 3, a = [0 0 0]; end
			set_speed(speed);
			set_center(a);
	end
	obj = objectreference;
		
	function mat = method_getmatrix (t) %#ok<DEFNU>
		switch type
			case 'translation'
				shift = M.speed*t/1000;
				dir = M.dir*pi/180;
				z = shift .* sin(dir(2));
				rcoselev = shift .* cos(dir(2));
				x = rcoselev .* cos(dir(1));
				y = rcoselev .* sin(dir(1));
				mat  =  [1 	0 	0 	x;
				         0 	1 	0 	y;
				         0 	0 	1 	z;
				         0 	0 	0 	1];

			case 'rotation'
				angle = M.speed*pi/180*t/1000;
				dir = M.dir*pi/180;
				z = sin(dir(2));
				rcoselev = cos(dir(2));
				x = rcoselev .* cos(dir(1));
				y = rcoselev .* sin(dir(1));
				S = [0 z -y; -z 0 x; y -x 0];
				c = cos(angle);
				mat = ([x;y;z]*[x,y,z]) .* (1 - c) + diag([c c c]) + sin(angle) .* S;
				mat = [[mat; 0 0 0], [0; 0; 0; 1]];
				T  =    [1 	0 	0 	M.center(1);
				         0 	1 	0 	M.center(2);
				         0 	0 	1 	M.center(3);
				         0 	0 	0 	1];
				mat = T * mat * inv(T);

			case 'dilation'
				amount = M.speed*t/1000;
				mat  =  [amount 0   	0    	-M.center(1);
				         0    	amount 	0    	-M.center(2);
				         0    	0    	amount 	-M.center(3);
				         0    	0    	0    	1];
		end
	end

	function v = get_type %#ok<DEFNU>
		v = M.type;
	end
	
	function v = get_speedrange %#ok<DEFNU>
		v = M.speedrange;
	end
	
	function v = get_dirrange %#ok<DEFNU>
		v = M.dirrange;
	end
	
	function v = get_centerrange %#ok<DEFNU>
		v = M.centerrange;
	end
	
	function v = get_speed %#ok<DEFNU>
		v = M.speed;
	end
	
	function v = get_dir %#ok<DEFNU>
		v = M.dir;
	end
	
	function v = get_center %#ok<DEFNU>
		v = M.center;
	end

	function set_speed (v)
		if ~iscell(v), v = {v}; end
		v = v(:)';
		for i=1:length(v)
			if ~isnumeric(v{i}) || ~isreal(v{i}) || ndims(v{i})~=2 || size(v{i},2)~=1 || ~any(size(v{i},1)==[1,2])
				error('galab:motioncomponent:speed', 'Invalid speed or speed range.');
			end
			if size(v{i},1)==1
				v{i} = repmat(v{i},2,1);
			else
				v{i} = [min(v{i}); max(v{i})];
			end
		end
		M.speedrange = v;
		pr_setspeed;
	end
	
	function set_dir (v)
		if strcmp(M.type, 'dilation')
			error('galab:motioncomponent:dir', 'You cannot set the direction of a dilation motion component.');
		end
		if ~iscell(v), v = {v}; end
		v = v(:)';
		for i=1:length(v)
			if ~isnumeric(v{i}) || ~isreal(v{i}) || ndims(v{i})~=2 || ~any(size(v{i},2)==[1,2]) || ~any(size(v{i},1)==[1,2])
				error('galab:motioncomponent:speed', 'Invalid speed or speed range.');
			end
			if size(v{i},2)==1
				v{i}(:,2) = 0;
			end
			if size(v{i},1)==1
				v{i} = repmat(v{i},2,1);
			else
				v{i} = [min(v{i}); max(v{i})];
			end
			v{i} = mod(v{i},360);
		end
		M.dirrange = v;
		pr_setdir;
	end

	function set_center (v)
		if strcmp(M.type, 'translation')
			error('galab:motioncomponent:center', 'You cannot set the center of a translation motion component.');
		end
		if ~iscell(v), v = {v}; end
		v = v(:)';
		for i=1:length(v)
			if ~isnumeric(v{i}) || ~isreal(v{i}) || ndims(v{i})~=2 || ~any(size(v{i},2)==[1,3]) || ~any(size(v{i},1)==[1,2])
				error('galab:motioncomponent:speed', 'Invalid speed or speed range.');
			end
			if size(v{i},2)==1
				v{i} = [zeros(size(v{i},1), 2), v{i}];
			end
			if size(v{i},1)==1
				v{i} = repmat(v{i},2,1);
			else
				v{i} = [min(v{i}); max(v{i})];
			end
		end
		M.centerrange = v;
		pr_setcenter;
	end

	function method_set %#ok<DEFNU>
		switch type
			case 'translation'
				pr_setspeed;
				pr_setdir;
			case 'rotation'
				pr_setspeed;
				pr_setdir;
				pr_setcenter;
			case 'dilation'
				pr_setspeed;
				pr_setcenter;
		end
	end
	
	function pr_setspeed
		M.speed = pr_rand_range(M.speedrange);
	end
	
	function pr_setdir
		M.dir = pr_rand_range(M.dirrange);
	end
	
	function pr_setcenter
		M.center = pr_rand_range(M.centerrange);
	end
	
	function val = pr_rand_range (rang)
		j = randperm(length(rang));
		rang = rang{j(1)};
		val = rang(1,:) + rand(1,size(rang,2)) .* diff(rang);
	end
end
