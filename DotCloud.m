classdef DotCloud < hgsetget
	%DOTCLOUD     Draw and animate a cloud of variable coherence moving dots
	%
	%The DOTCLOUD class draws and animate a set of moving dots within a
	%circular aperture. The dots have a limited lifetime and a variable
	%coeherence, e.g., a fraction of them moves in a user-defined
	%direction, and all the others in a random direction.
	%
	%Properties of the DOTCLOUD class determine the appearence, speed,
	%direction, and coherence of the cloud. Properties can be freely
	%changed during the animation.
	%
	%To animate a dot cloud, use the ANIMATE command repeatedly. For
	%example, this code produces a cloud animating for 1 second:
	%
	%    D = DotCloud;
	%    t = Present(onset, animate(D));
	%    while time <= t + 1000
	%        Present(animate(D));
	%    end
	%
	%Written by GaG for GagLab, based on VCRDM/OSXDots by Maria Mckinley
	%from the Shadlen lab (http://www.shadlen.org/Code/VCRDM)
	
	properties (GetAccess = public, SetAccess = private)
		stimulus = 0;
	end

	properties (Access = public)
		apertureCenter = [0 0];   % [x y] coordinates of aperture center
	end
	
	properties (Access = public, Dependent, Transient)
		apertureDiameter = 4;     % diameter of aperture center
	end
	
	properties (Access = public)
		coherence = 0.75;         % coherence (0 to 1)
		direction = 180;          % direction in degrees (0 is right, 90 is up)
		speed  = 5;               % speed (deg / s)
	end
	
	properties (Access = public, Dependent, Transient)
		density;                  % density of dots (dots per square deg / sec)
		maxDotsPerFrame;          % by trial and error.  Depends on graphics card
		nsets;                    % number of dot sets
	end
	
	properties (Access = public)
		backColor = NaN;
		dotColor = [1 1 1];
		dotSize = 0.1;
	end
	
	properties (Access = private)
		pr_apertureDiameter = 4;
		pr_density = 50;
		pr_maxDotsPerFrame = 150;
		pr_nsets = 3;
	end
	
	properties (Access = private, Transient)
		refreshRate = 60;
		ndots = 0;
		ss = [];
		loopi = 1;
	end

	methods (Static)
		function D = loadobj (D)
			[w,h, D.refreshRate] = ScreenInfo;
			start(D);
			if D.stimulus
				Transparency(D.stimulus, 'on');
			end
		end
	end
	
	methods
		function D = DotCloud (id)
			[w,h, D.refreshRate] = ScreenInfo;
			start(D);
			if nargin
				id = bil.validate.numeric(id, 'finite', 'scalar', 'integer', 'nonnegative');
				if id > 0
					Transparency(id, 'on');
					D.stimulus = id;
				end
			end
		end

		function set.apertureCenter (D, x)
			D.apertureCenter = bil.validate.numeric(x, 'finite', 'size', [1 2]);
		end
		
		function x = get.apertureDiameter (D)
			x = D.pr_apertureDiameter;
		end

		function set.apertureDiameter (D, x)
			D.pr_apertureDiameter = bil.validate.numeric(x, 'finite', 'positive', 'scalar');
			start(D);
		end
		
		function set.coherence (D, x)
			D.coherence = bil.validate.numeric(x, 'finite', 'scalar', '>=', 0, '<=', 1);
		end
		
		function set.direction (D, x)
			D.direction = bil.validate.numeric(x, 'finite', 'scalar', '>=', 0, '<=', 360);
		end
		
		function set.speed (D, x)
			D.speed = bil.validate.numeric(x, 'finite', 'scalar', 'positive');
		end
		
		function x = get.density (D)
			x = D.pr_density;
		end
		
		function set.density (D, x)
			D.pr_density = bil.validate.numeric(x, 'finite', 'scalar', 'positive');
			start(D);
		end
		
		function set.backColor (D, x)
			if isequaln(x, NaN)
				D.backColor = NaN;
			else
				D.backColor = bil.validate.numeric(x, 'finite', 'size', [1 3], '>=', 0, '<=', 1);
			end
		end
		
		function set.dotColor (D, x)
			D.dotColor = bil.validate.numeric(x, 'finite', 'size', [1 3], '>=', 0, '<=', 1);
		end
		
		function set.dotSize (D, x)
			D.dotSize = bil.validate.numeric(x, 'finite', 'scalar', 'positive');
		end
		
		function x = get.maxDotsPerFrame (D)
			x = D.pr_maxDotsPerFrame;
		end
	
		function set.maxDotsPerFrame (D, x)
			D.pr_maxDotsPerFrame = bil.validate.numeric(x, 'finite', 'scalar', 'positive', 'integer');
			start(D);
		end
		
		function x = get.nsets (D)
			x = D.pr_nsets;
		end
	
		function set.nsets (D, x)
			D.pr_nsets = bil.validate.numeric(x, 'finite', 'scalar', 'positive', 'integer');
			start(D);
		end
		
		function v = animate (D)
			% how dots are presented: 1 group of dots are shown in the first frame, a
			% second group are shown in the second frame, a third group shown in the
			% third frame, then in the next frame, some percentage of the dots from the
			% first frame are replotted according to the speed/direction and coherence,
			% the next frame the same is done for the second group, etc.
						
			% ss is the matrix with the 3 sets of dot positions, dots from the last 2 positions + current
			% this_s now has the dot positions from 3 frames ago, which is what is then moved in the current loop
			this_s = D.ss(:,:,D.loopi);
			
			% compute new locations, how many dots move coherently
			L = rand(D.ndots,1) < D.coherence;
			if sum(L) > 0	% these dots are moved coherently
				% dxdy gives jumpsize in units on 0..1
				%    	 deg/sec     * Ap-unit/deg  * sec/jump   =   unit/jump
				dxdy 	= D.speed / D.apertureDiameter * (D.pr_nsets/D.refreshRate) ...
					* [cos(pi*D.direction/180.0), sin(pi*D.direction/180.0)];
				this_s(L,:) = bsxfun(@plus, this_s(L,:), dxdy);	% offset the selected dots
			end
			if sum(~L) > 0	% these dots move in a random direction, but at the same speed
				direct = rand(sum(~L),1)*pi*2;
				this_s(~L,:) = this_s(~L,:) + D.speed / D.apertureDiameter * (D.pr_nsets/D.refreshRate) * [cos(direct), sin(direct)];	% offset the selected dots
				% this_s(~L,:) = rand(sum(~L),2);	    % get new random locations for the rest
			end
			
			% wrap around - check to see if any positions are greater than one or less than zero
			% which is out of the square aperture, and then replace with a dot along one
			% of the edges opposite from direction of motion.
			N = sum(this_s > 1 | this_s < 0, 2) ~= 0;
			if sum(N) > 0
				ydir = sin(pi*D.direction/180.0);
				xdir = cos(pi*D.direction/180.0);
				% flip a weighted coin to see which edge to put the replaced
				% dots
				if rand < abs(ydir)/(abs(ydir) + abs(xdir))
					this_s(N==1,:) = [rand(sum(N),1) (ydir < 0)*ones(sum(N),1)];
				else
					this_s(N==1,:) = [(xdir < 0)*ones(sum(N),1) rand(sum(N),1)];
				end
			end

			% In Cogent, we don't have blend function, so determine which
			% dots to show by calculating whether their center is within
			% the circular aperture
			whichdots = sum((this_s - 0.5) .^ 2, 2) <= 0.25;
			
			% convert to stuff we can actually plot
			% this assumes that zero is at the top left, but we want it to be
			% in the center, so shift the dots up and left, which just means
			% adding half of the aperture size to both the x and y direction.
			dot_show = bsxfun(@plus, (this_s - 0.5) * D.apertureDiameter, D.apertureCenter);

			% Drawing code for Cogent/GagLab
			if D.stimulus
				ClearStimulus(D.stimulus);
			end
			if ~isequaln(D.backColor, NaN)
				PenColor(D.stimulus, D.backColor);
				FillEllipse(D.stimulus, D.apertureCenter, [D.apertureDiameter, D.apertureDiameter]);
			end
			PenColor(D.stimulus, D.dotColor);
			%PenWidth(D.stimulus, D.dotSize);
			FillEllipse(D.stimulus, dot_show(whichdots,:), [D.dotSize D.dotSize]);
			
			% This is the original drawing code for PTB3
			%apRect = [D.apertureCenter - D.apertureDiameter/2, D.apertureCenter + D.apertureDiameter/2];
			
			% setup the mask - we will only be able to see a circular aperture,
			% although dots moving in a square aperture. Minimizes the edge
			% effects.
			%Screen('BlendFunction', curWindow, GL_ONE, GL_ZERO);
			
			% want targets to still show up
			%Screen('FillRect', curWindow, [0 0 0 255]);
			
			% square that dots do not show up in
			%Screen('FillRect', curWindow, [0 0 0 0], apRect);
			
			% circle that dots do show up in
			%Screen('FillOval', curWindow, [0 0 0 255], apRect);
			
			%Screen('BlendFunction', curWindow, GL_DST_ALPHA, GL_ONE_MINUS_DST_ALPHA);
			
			% now do actual drawing commands
			%Screen('DrawDots', curWindow, dot_show, D.dotSize, D.dotColor);

			% update the dot position array for the next loop
			D.ss(:,:,D.loopi) = this_s;
		
			% update the loop pointer
			D.loopi = D.loopi+1;
			if D.loopi == D.pr_nsets+1
				D.loopi = 1;
			end
			
			v = visual(D.stimulus);
		end
	end
	
	methods (Access = private)		
		function start (D)
			% ndots is the number of dots shown per video frame
			% we will place dots in a square the size of the aperture
			% - Size of aperture = Apd*Apd  sq deg
			% - Number of dots per video frame = 16.7 dots per sq.deg/sec,
			%   Round up, do not exceed the number of dots that can be
			%	plotted in a video frame (dotInfo.maxDotsPerFrame)
			tmpndots = min(D.pr_maxDotsPerFrame, ceil(D.pr_density .* D.pr_apertureDiameter .* D.pr_apertureDiameter ./ D.refreshRate));
			tmpndots = round(tmpndots / D.pr_nsets);
			if isempty(D.ss) || size(D.ss,3) ~= D.pr_nsets
				D.ss = rand(tmpndots, 2, D.pr_nsets);
			elseif tmpndots < D.ndots
				D.ss = D.ss(1:tmpndots,:,:);
			elseif tmpndots > D.ndots
				D.ss(D.ndots+1:tmpndots,:,:) = rand(tmpndots-D.ndots,2,D.pr_nsets);
			end
			D.ndots = tmpndots;
			D.loopi = 1;
		end
	end
end
