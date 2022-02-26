function GL = gaglab_setup_load (GL, name)
% GAGLAB_SETUP_LOAD	Load a setup from a setup script
%
% GL = GAGLAB_SETUP_LOAD(GL, CFGNAME) first loads the default setup
% from the Default.m script in the GagLab setup directory.
% The Default.m script should be prepared by the
% computer administrator to match the computer hardware configuration.
% Then, the setup is customized by applying the
% settings specified in the CFGNAME.m script in the setup directory.
% This allows user to specify multiple setup customizations on the same
% computer. If CFGNAME is omitted, the default configuration is returned.

% First create a default configuration structure

GL.Experiment.Setup = 'Preset';

Setup.Screen.ScreenNumber = 1;
Setup.Screen.WidthMm = 250;
Setup.Screen.DistanceMm = 400;
Setup.Screen.Pixels = 0;
Setup.Screen.RefreshRate = 0;

Setup.Response.Device = 'Mouse';

Setup.Response.Serial.Port = 1;
Setup.Response.Serial.Key1 = 1;
Setup.Response.Serial.Key2 = 2;
Setup.Response.Serial.Key3 = 3;
Setup.Response.Serial.Key4 = 4;
Setup.Response.Serial.Key5 = 5;
Setup.Response.Serial.Key6 = 6;
Setup.Response.Serial.Key7 = 7;
Setup.Response.Serial.Key8 = 8;
Setup.Response.Serial.Key9 = 9;
Setup.Response.Serial.Key10 = 10;

Setup.Response.Mouse.Key1 = 'Left';
Setup.Response.Mouse.Key2 = 'Right';
Setup.Response.Mouse.Key3 = 'Middle';
Setup.Response.Mouse.Key4 = '';
Setup.Response.Mouse.Key5 = '';
Setup.Response.Mouse.Key6 = '';
Setup.Response.Mouse.Key7 = '';
Setup.Response.Mouse.Key8 = '';
Setup.Response.Mouse.Key9 = '';
Setup.Response.Mouse.Key10 = '';

Setup.Response.Keyboard.Key1 = 'K';
Setup.Response.Keyboard.Key2 = 'L';
Setup.Response.Keyboard.Key3 = 'A';
Setup.Response.Keyboard.Key4 = 'S';
Setup.Response.Keyboard.Key5 = 'D';
Setup.Response.Keyboard.Key6 = 'F';
Setup.Response.Keyboard.Key7 = 'G';
Setup.Response.Keyboard.Key8 = 'H';
Setup.Response.Keyboard.Key9 = 'J';
Setup.Response.Keyboard.Key10 = 'B';

Setup.Response.XID.Port = 0;
Setup.Response.XID.Key1 = 1;
Setup.Response.XID.Key2 = 2;
Setup.Response.XID.Key3 = 3;
Setup.Response.XID.Key4 = 4;
Setup.Response.XID.Key5 = 5;
Setup.Response.XID.Key6 = 6;
Setup.Response.XID.Key7 = 7;
Setup.Response.XID.Key8 = 8;
Setup.Response.XID.Key9 = 9;
Setup.Response.XID.Key10 = 10;

Setup.Response.StartKey = 'Space';
Setup.Response.StopKey = 'Escape';

Setup.Sync.UseSync = 0;
Setup.Sync.Port = 3;
Setup.Sync.NumSlices = 20;
Setup.Sync.StartVolumes = 0;
Setup.Sync.TRslices = 65;
Setup.Sync.TRvolumes = 0;

Setup.Trigger.UseUserPort = 0;
Setup.Trigger.Port = 0;
Setup.Trigger.Duration = 50;

Setup.Eye.Type = 'none';
Setup.Eye.Port = 2;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Now run the Default.m setup script

f = fullfile(GL.SetupPath, 'Default.m');
if exist(f, 'file')
	run(f);
	GL.Experiment.Setup = 'Default';
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Now run the optional setup customization script

if nargin && ~any(strcmpi(name, {'preset','default'}))
	[p,f] = fileparts(name);
	if isempty(p)
		p = GL.SetupPath;
	end
	name = fullfile(p, [f '.m']);
	if exist(name, 'file')
		run(name);
		GL.Experiment.Setup = f;
	else
		fprintf('Can''t find custom setup script "%s"\n', name);
	end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Now complete the structure with values that cannot be customized

Setup.Screen.Units = 'degrees';
Setup.Screen.Transparency = 0;
Setup.Screen.BackgroundColor = [0 0 0];
Setup.Screen.PenColor = [1 1 1];
Setup.Screen.PenWidth = 0;
Setup.Screen.FontName = 'Arial';
Setup.Screen.FontSize = 0;
Setup.Screen.Align = 'cc';
Setup.Mouse.UseMouse = 0;
Setup.TestMode = 0;
Setup.LogMode = 0;
Setup.DumpScreen = 0;
GL.Setup = Setup;

