function Screen = gaglab_vis_do (Screen, command, varargin)

[Screen, id, j] = gaglab_vis_get(Screen, varargin{:});
Screen.Stimulus(j) = gaglab_vis_docommand(Screen, Screen.Stimulus(j), command, varargin{2:end});



function Stimulus = gaglab_vis_docommand (Screen, Stimulus, command, varargin)

switch lower(command)

	case 'size'
		siz = gaglab_vis_getsize(gaglab_util_defaultarg('auto', varargin, 1));
		units = gaglab_vis_getunits(gaglab_util_defaultarg('auto', varargin, 2));
		if isnumeric(siz)
			Stimulus.Size = {siz, units};
		else
			Stimulus.Size = siz;
		end

	case 'backgroundcolor'
		[color,name] = gaglab_vis_getcolor(gaglab_util_defaultarg('default', varargin, 1));
		if Screen.IsOpen
			Stimulus.BackgroundColor = color;
			pcol = Stimulus.PenColor;
			Stimulus.PenColor = Stimulus.BackgroundColor;
			Stimulus = gaglab_vis_docommand(Screen, Stimulus, 'rect', 'f');
			Stimulus.PenColor = pcol;
			%error('The stimulus background color cannot be changed after the stimulus has been created.');
		else
			Stimulus.BackgroundColor = color;
		end
		
	case 'transparency'
		if Stimulus.ID == 0
			error('You cannot specify transparency for the backbuffer');
		end
		flag = gaglab_util_defaultarg(1, varargin, 1);
		if Screen.IsOpen
			Stimulus.Transparency = flag;
		else
			Stimulus = gaglab_vis_storecommand(Stimulus, 'transparency', flag);
		end

	case 'pencolor'
		color = gaglab_vis_getcolor(gaglab_util_defaultarg('default', varargin, 1));
		if Screen.IsOpen
			if ischar(color)
				switch color
					case 'a'
						color = Screen.PenColor;
				end
			end
			Stimulus.PenColor = color;
		else
			Stimulus = gaglab_vis_storecommand(Stimulus, 'pencolor', color);
		end

	case 'penwidth'
		if Screen.IsOpen
			if varargin{1}
				varargin{1} = gaglab_vis_convert2pixels(Screen, Stimulus.Units, varargin{1});
			end
			Stimulus.PenWidth = varargin{1};
		else
			Stimulus = gaglab_vis_storecommand(Stimulus, 'penwidth', varargin{1});
		end

	case 'units'
		units = gaglab_vis_getunits(gaglab_util_defaultarg('default', varargin, 1));
		if Screen.IsOpen
			switch units
				case 'a'
					color = Screen.Units;
			end
			Stimulus.Units = units;
		else
			Stimulus = gaglab_vis_storecommand(Stimulus, 'units', units);
		end

	case 'align'
		if Screen.IsOpen
            align = gaglab_vis_getalign(gaglab_util_defaultarg('xx', varargin, 1));
			i = find(align~='x');
			Stimulus.Align(i) = align(i);
		else
			Stimulus = gaglab_vis_storecommand(Stimulus, 'align', varargin{:});
		end
		
	case 'clear'
		if Screen.IsOpen
			color = gaglab_vis_getcolor(gaglab_util_defaultarg(Stimulus.BackgroundColor, varargin, 1));
			cgsetsprite(Stimulus.ID);
			cgpencol(color(1), color(2), color(3));
			cgrect;
		else
			Stimulus = gaglab_vis_storecommand(Stimulus, 'clear', varargin{:});
		end

	case 'image'
		if Screen.IsOpen
			center = gaglab_vis_convert2pixels(Screen, Stimulus.Units, varargin{2:end});
			siz = gaglab_vis_convert2pixels(Screen, Stimulus.Units, varargin{3:end});
			gaglab_vis_placeimage(Stimulus.ID, varargin{1}, center, siz);
		else
			Stimulus = gaglab_vis_storecommand(Stimulus, 'image', varargin{:});
		end

	case 'point'
		if Screen.IsOpen
			xy = gaglab_vis_convert2pixels(Screen, Stimulus.Units, varargin{:});
			cgsetsprite(Stimulus.ID);
			cgpencol(Stimulus.PenColor(1), Stimulus.PenColor(2), Stimulus.PenColor(3));
			cgpenwid(Stimulus.PenWidth);
			cgdraw(xy(:,1), xy(:,2));
		else
			Stimulus = gaglab_vis_storecommand(Stimulus, 'point', varargin{:});
		end

	case 'line'
		if Screen.IsOpen
			xy = gaglab_vis_convert2pixels(Screen, Stimulus.Units, varargin{:});
			cgsetsprite(Stimulus.ID);
			cgpencol(Stimulus.PenColor(1), Stimulus.PenColor(2), Stimulus.PenColor(3));
			cgpenwid(Stimulus.PenWidth);
			cgdraw(xy(:,1), xy(:,2), xy(:,3), xy(:,4));
		else
			Stimulus = gaglab_vis_storecommand(Stimulus, 'line', varargin{:});
		end

	case 'rect'
		if Screen.IsOpen
			xy = gaglab_vis_convert2pixels(Screen, Stimulus.Units, varargin{2:end});
			cgsetsprite(Stimulus.ID);
			cgpencol(Stimulus.PenColor(1), Stimulus.PenColor(2), Stimulus.PenColor(3));
			cgpenwid(Stimulus.PenWidth);
			cgalign('l','b');
			if varargin{1}=='f'
				if nargin > 4
					for i=1:size(xy,1)
						xy(i,:) = [min(xy(i,[1 3])), min(xy(i,[2 4])), abs([xy(i,1)-xy(i,3), xy(i,2)-xy(i,4)])];
					end
					cgrect(xy(:,1), xy(:,2), xy(:,3), xy(:,4));
				else
					cgrect;
				end
			else
				xyl = [];
				for i=1:size(xy,1)
					xyl = [xyl; ...
							xy(i,1) xy(i,2) xy(i,1) xy(i,4); ...
							xy(i,1) xy(i,4) xy(i,3) xy(i,4); ...
							xy(i,3) xy(i,4) xy(i,3) xy(i,2); ...
							xy(i,3) xy(i,2) xy(i,1) xy(i,2)];
				end
				cgdraw(xyl(:,1), xyl(:,2), xyl(:,3), xyl(:,4));
			end
		else
			Stimulus = gaglab_vis_storecommand(Stimulus, 'rect', varargin{:});
		end

	case 'poly'
		if Screen.IsOpen
			xy = gaglab_vis_convert2pixels(Screen, Stimulus.Units, varargin{2:end});
			cgsetsprite(Stimulus.ID);
			cgpencol(Stimulus.PenColor(1), Stimulus.PenColor(2), Stimulus.PenColor(3));
			cgpenwid(Stimulus.PenWidth);
			if varargin{1}=='f'
				for i=1:size(xy,3)
					cgpolygon(xy(:,1,i), xy(:,2,i));
				end
			else
				xy(end+1,:,:) = xy(1,:,:);
				xy = cat(4, xy(1:end-1,1,:), xy(1:end-1,2,:), xy(2:end,1,:), xy(2:end,2,:));
				xy = reshape(xy, size(xy,1)*size(xy,3), 4);
				cgdraw(xy(:,1), xy(:,2), xy(:,3), xy(:,4));
			end
		else
			Stimulus = gaglab_vis_storecommand(Stimulus, 'poly', varargin{:});
		end

	case 'ellipse'
		if Screen.IsOpen
			center = gaglab_vis_convert2pixels(Screen, Stimulus.Units, varargin{2:end});
			siz = gaglab_vis_convert2pixels(Screen, Stimulus.Units, varargin{3:end});
			if size(siz,1) == 1
				siz = repmat(siz, size(center,1), 1);
			end
			cgsetsprite(Stimulus.ID);
			cgpencol(Stimulus.PenColor(1), Stimulus.PenColor(2), Stimulus.PenColor(3));
			cgpenwid(Stimulus.PenWidth);
			if varargin{1} == 'f'
				cgellipse(center(:,1), center(:,2), siz(:,1), siz(:,2), 'f');
			else
				cgellipse(center(:,1), center(:,2), siz(:,1), siz(:,2));
			end
		else
			Stimulus = gaglab_vis_storecommand(Stimulus, 'ellipse', varargin{:});
		end

	case 'arc'
		if Screen.IsOpen
			center = gaglab_vis_convert2pixels(Screen, Stimulus.Units, varargin{2:end});
			siz = gaglab_vis_convert2pixels(Screen, Stimulus.Units, varargin{3:end});
			cgsetsprite(Stimulus.ID);
			cgpencol(Stimulus.PenColor(1), Stimulus.PenColor(2), Stimulus.PenColor(3));
			cgpenwid(Stimulus.PenWidth);
			cgarc(center(:,1), center(:,2), siz(:,1), siz(:,2), ...
				varargin{4}(:,1), varargin{4}(:,2), varargin{1});
		else
			Stimulus = gaglab_vis_storecommand(Stimulus, 'arc', varargin{:});
		end
		
	case 'font'
		if Screen.IsOpen
			Stimulus.FontName = gaglab_util_defaultarg('default', varargin, 1);
			switch Stimulus.FontName
				case 'a'
					Stimulus.FontName = Screen.FontName;
			end
			Stimulus.FontSize = gaglab_util_defaultarg(0, varargin, 2);
			if Stimulus.FontSize
				Stimulus.FontSize = gaglab_vis_convert2pixels(Screen, Stimulus.Units, Stimulus.FontSize);
			else
				Stimulus.FontSize = 12;
			end
		else
			Stimulus = gaglab_vis_storecommand(Stimulus, 'font', varargin{:});
		end

	case 'text'
		if Screen.IsOpen
			xy = gaglab_vis_convert2pixels(Screen, Stimulus.Units, varargin{2:end});
			cgsetsprite(Stimulus.ID);
			cgpencol(Stimulus.PenColor(1), Stimulus.PenColor(2), Stimulus.PenColor(3));
			cgpenwid(Stimulus.PenWidth);
			cgalign(Stimulus.Align(1), Stimulus.Align(2));
			cgfont(Stimulus.FontName, Stimulus.FontSize);
			cgtext(varargin{1}, xy(1), xy(2));
		else
			Stimulus = gaglab_vis_storecommand(Stimulus, 'text', varargin{:});
		end

	case 'copy'
		if Stimulus.Transparency
			[color,name] = gaglab_vis_getcolor(Stimulus.BackgroundColor);
			if isempty(name)
				error('The current background color for stimulus %d does not support transparency.', Stimulus.ID);
			end
			cgtrncol(Stimulus.ID, name);
		else
			cgtrncol(Stimulus.ID);
		end

		[Screen, id, j] = gaglab_vis_get(Screen, varargin{1});
		if nargin > 5		% CopyStimulus(Screen, Stimulus, 'copy', id, rect, xy)
			rect = gaglab_vis_convert2pixels(Screen, Screen.Stimulus(j).Units, varargin{2:end});
			rectsize = rect(3:4) - rect(1:2);
			rectpos = rect(1:2) + rectsize/2;
			rect = gaglab_vis_convert2pixels(Screen, Screen.Stimulus(j).Units, varargin{3:end});
			if length(rect) == 4
				destsize = rect(3:4) - rect(1:2);
				destpos = rect(1:2) + destsize/2;
			else
				destsize = rectsize;
				destpos = rect;
			end
			cgalign('c','c');
			cgsetsprite(id);
			cgblitsprite(Stimulus.ID, rectpos(1), rectpos(2), rectsize(1), rectsize(2), destpos(1), destpos(2), destsize(1), destsize(2));
		else				% CopyStimulus(Screen, Stimulus, 'copy', id, xy)
			xy = gaglab_vis_convert2pixels(Screen, Screen.Stimulus(j).Units, varargin{2:end});
			cgalign('c','c');
			cgsetsprite(id);
			for i=1:size(xy,1)
				cgdrawsprite(Stimulus.ID, xy(i,1), xy(i,2));
			end
		end
end


function s = gaglab_vis_storecommand (s, command, varargin)

s.Command{end+1} = command;
s.Arg{end+1} = varargin;

