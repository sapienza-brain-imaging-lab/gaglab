function Screen = gaglab_vis_start (GL)
% GAGLAB_VIS_START		Open the experiment window
%
% GAGLAB_VIS_START opens the experiment window and prepares the
% stimuli which have been defined before the call to GAGLAB_VIS_START.

if GL.Screen.IsOpen
	Screen = GL.Screen;
	return;
end

Screen = GL.Setup.Screen;
fn = fieldnames(GL.Screen);
for i=1:length(fn)
	Screen.(fn{i}) = GL.Screen.(fn{i});
end

if length(GL.Screen.Stimulus) == 1 & isempty(GL.Screen.Stimulus(1).Command)	% screen not used
	return
end


% Open the screen
Screen.ScreenMode = gaglab_vis_resolution(GL);
t = evalc('cgopen(Screen.ScreenMode(2), 0, Screen.ScreenMode(5), Screen.ScreenMode(1));');
GPD = cggetdata('GPD');
Screen.Pixels = [GPD.PixWidth GPD.PixHeight];
Screen.BitsPerPixel = GPD.BitDepth;
if GPD.RefRate100
	Screen.RefreshRate = GPD.RefRate100 / 100;
else
	Screen.RefreshRate = Screen.ScreenMode(5);
end
%Screen.Mm2Pix = Screen.Pixels(1) / Screen.WidthMm;
%Screen.Deg2Pix = Screen.DistanceMm * pi / 180 * Screen.Mm2Pix;

% Adjust global default values
Screen.BackgroundColor = gaglab_vis_getcolor(Screen.BackgroundColor);
Screen.PenColor = gaglab_vis_getcolor(Screen.PenColor);
Screen.Units = gaglab_vis_getunits(Screen.Units);
Screen.FontName = gaglab_vis_getfont(Screen.FontName);
if ischar(Screen.BackgroundColor)
	switch Screen.BackgroundColor
		case 'a'
			Screen.BackgroundColor = [0 0 0];
	end
end
if ischar(Screen.PenColor)
	switch Screen.PenColor
		case 'a'
			Screen.PenColor = [1 1 1];
	end
end
switch Screen.Units
	case 'a'
		Screen.Units = 'd';
end
switch Screen.FontName
	case 'a'
		Screen.FontName = 'Arial';
end
Screen.Align(find(Screen.Align=='x')) = 'c';
Screen.PenWidth = gaglab_vis_convert2pixels(Screen, Screen.Units, Screen.PenWidth);
Screen.FontSize = gaglab_vis_convert2pixels(Screen, Screen.Units, Screen.FontSize);

% Adjust stimulus default values
 for i=1:length(Screen.Stimulus)
	if Screen.Stimulus(i).Transparency == -1
		Screen.Stimulus(i).Transparency = Screen.Transparency;
	end
	if isequal(Screen.Stimulus(i).BackgroundColor, 'a')
		Screen.Stimulus(i).BackgroundColor = Screen.BackgroundColor;
	end
	if isequal(Screen.Stimulus(i).PenColor, 'a')
		Screen.Stimulus(i).PenColor = Screen.PenColor;
	end
	if isequal(Screen.Stimulus(i).PenWidth, 'a')
		Screen.Stimulus(i).PenWidth = Screen.PenWidth;
	end
	if isequal(Screen.Stimulus(i).Units, 'a')
		Screen.Stimulus(i).Units = Screen.Units;
	end
	if iscell(Screen.Stimulus(i).Size)
		Screen.Stimulus(i).Size = gaglab_vis_convert2pixels(Screen, Screen.Stimulus(i).Size{2}, Screen.Stimulus(i).Size{1});
	elseif isequal(Screen.Stimulus(i).Size, 'a')
		Screen.Stimulus(i).Size = Screen.Pixels;	% To implement
	elseif isequal(Screen.Stimulus(i).Size, 's')
		Screen.Stimulus(i).Size = Screen.Pixels;
	end
	if isequal(Screen.Stimulus(i).FontName, 'a')
		Screen.Stimulus(i).FontName = Screen.FontName;
	end
	if isequal(Screen.Stimulus(i).FontSize, 'a')
		Screen.Stimulus(i).FontSize = Screen.FontSize;
	end
	j = find(Screen.Stimulus(i).Align == 'x');
	Screen.Stimulus(i).Align(j) = Screen.Align(j);
end

% Create and initialize stimuli
Screen.IsOpen = 1;
for i=1:length(Screen.Stimulus)
	if i==1
		cgsetsprite(0);
		cgpencol(Screen.Stimulus(i).BackgroundColor(1), Screen.Stimulus(i).BackgroundColor(2), Screen.Stimulus(i).BackgroundColor(3));
		cgrect;
		cgflip(Screen.Stimulus(i).BackgroundColor(1), Screen.Stimulus(i).BackgroundColor(2), Screen.Stimulus(i).BackgroundColor(3));
	else
		%fprintf('Creating stimulus %d...\n', Screen.Stimulus(i).ID);
		Screen.Stimulus(i).RASkey = cgmakesprite(Screen.Stimulus(i).ID, Screen.Stimulus(i).Size(1), Screen.Stimulus(i).Size(2), ...
			Screen.Stimulus(i).BackgroundColor(1), Screen.Stimulus(i).BackgroundColor(2), Screen.Stimulus(i).BackgroundColor(3));
	end
	for j=1:length(Screen.Stimulus(i).Command)
		Screen = gaglab_vis_do(Screen, Screen.Stimulus(i).Command{j}, Screen.Stimulus(i).ID, Screen.Stimulus(i).Arg{j}{:});
	end
end


function ScreenMode = gaglab_vis_bestresolution (GL, ScreenSetup)

j = find(GL.Resolutions(:,1) == ScreenSetup.ScreenNumber);
validres = GL.Resolutions(j,:);
if isempty(validres)
	error('The screen specified does not exist!');
end

if ScreenSetup.Pixels
	j = find(validres(:,3) == ScreenSetup.Pixels);
	if isempty(j)
		error('The requested screen resolution is not available');
	end
	validres = validres(j,:);
elseif GL.Setup.TestMode
	validres(find(validres(:,3) > 800),:) = [];
end

if ScreenSetup.RefreshRate
	j = find(validres(:,5) == ScreenSetup.RefreshRate);
	if isempty(j)
		error('The requested refresh rate is not available');
	end
	validres = validres(j,:);
end

j = find(validres(:,3) == max(validres(:,3)));
validres = validres(j,:);
j = find(validres(:,5) == max(validres(:,5)));
ScreenMode = validres(j(1),:);
