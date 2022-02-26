function Screen = gaglab_vis_init (GL)

cgshut;
Screen.ClearOnFlip = 1;
Screen.IsOpen = 0;


if GL.Setup.DumpScreen
	[p,f] = fileparts(GL.Experiment.Path);
	t = datetickstr(now);
	t = t{1};
	t(t==':') = '-';
	Screen.DumpPath = fullfile(GL.ScreenDumpPath, [f, ' ', t]);
	gaglab_util_mkdir(Screen.DumpPath);
else
	Screen.DumpPath = '';
end

Screen.Stimulus = [];
Screen.Stimulus.ID = 0;
Screen.Stimulus.RASkey = [];
Screen.Stimulus.Units = gaglab_vis_getunits('default');
Screen.Stimulus.Size = gaglab_vis_getsize('screen');
Screen.Stimulus.Transparency = 0;
Screen.Stimulus.BackgroundColor = gaglab_vis_getcolor('default');
Screen.Stimulus.PenColor = gaglab_vis_getcolor('default');
Screen.Stimulus.PenWidth = 'a';
Screen.Stimulus.FontName = gaglab_vis_getfont('default');
Screen.Stimulus.FontSize = 'a';
Screen.Stimulus.Align = gaglab_vis_getalign('cm');
Screen.Stimulus.Command = {};
Screen.Stimulus.Arg = {};
