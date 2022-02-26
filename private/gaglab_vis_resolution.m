function ScreenMode = gaglab_vis_resolution (GL)

if isfield(GL, 'Screen') && GL.Screen.IsOpen
	ScreenMode = GL.Screen.ScreenMode;
	ScreenMode(3:4) = GL.Screen.Pixels;
	ScreenMode(6) = GL.Screen.RefreshRate;
	return
end

if GL.Setup.TestMode
	ScreenMode = [0 1 640 480 0 60 0 1];
	return
end

j = find(GL.Resolutions(:,1) == GL.Setup.Screen.ScreenNumber);
validres = GL.Resolutions(j,:);
if isempty(validres)
	error('The screen specified does not exist!');
end

if GL.Setup.Screen.Pixels
	j = find(validres(:,3) == GL.Setup.Screen.Pixels);
	if isempty(j)
		error('The requested screen resolution is not available');
	end
	validres = validres(j,:);
elseif GL.Setup.TestMode
	validres(find(validres(:,3) > 800),:) = [];
end

if GL.Setup.Screen.RefreshRate
	j = find(validres(:,5) == GL.Setup.Screen.RefreshRate);
	if isempty(j)
		error('The requested refresh rate is not available');
	end
	validres = validres(j,:);
end

j = find(validres(:,3) == max(validres(:,3)));
validres = validres(j,:);
j = find(validres(:,5) == max(validres(:,5)));
ScreenMode = validres(j(1),:);
