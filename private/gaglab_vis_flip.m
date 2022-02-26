function t = gaglab_vis_flip (Screen)

if Screen.IsOpen
	if Screen.ScreenMode(8) == 0
		t = cgflip('V');
		t = gaglab_exp_time(t);
		if t
			while gaglab_exp_time - t < 4
			end
			t = t + round(1000 / Screen.RefreshRate);
			cgflip;
			while gaglab_exp_time < t
			end
		else
			cgflip;
		end
	else
		t = cgflip;
		t = gaglab_exp_time(t);
	end
else
	t = gaglab_exp_time;
end

if ~isempty(Screen.DumpPath)
	cgscrdmp(fullfile(Screen.DumpPath, 'dump_'), t);
	cgscrdmp;
	t2 = gaglab_exp_time;
	gaglab_exp_time('restart', t2 - t);
end
