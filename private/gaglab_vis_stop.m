function Screen = gaglab_vis_stop (Screen)
% GAGLAB_VIS_STOP	Close the experiment window.

if Screen.IsOpen
	cgshut;
	Screen.IsOpen = 0;
	if ~isempty(Screen.DumpPath)
		gaglab_movie(Screen.DumpPath);
	end
end
