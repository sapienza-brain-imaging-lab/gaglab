% This script contains local defaults for GagLab setup
% and should be prepared by the computer
% administrator to customize the GagLab setup.

Setup.Screen.ScreenNumber = 1;					% Number of the screen to use for visual stimuli
Setup.Screen.WidthMm = 250;						% Width of the screen in mm
Setup.Screen.DistanceMm = 400;					% Distance of the subject from the screen
Setup.Screen.Pixels = 0;						% Default resolution of the screen in pixels:
												% valid settings are: 640, 800, 1024, 1152,
												% 1280, 1600 horizontal pixels; 0 indicates
												% maximum available
Setup.Screen.RefreshRate = 0;					% Default screen refresh rate in Hz;
												% 0 indicates maximum available

Setup.Response.Device = 'Mouse';				% Preferred response device: 'Serial', 'Mouse', 'Keyboard', 'XID'

Setup.Response.Serial.Port = 1;					% Serial port to be used for responses
Setup.Response.Serial.Key1 = 1;					% Serial byte corresponding to response key 1
Setup.Response.Serial.Key2 = 2;					% Serial byte corresponding to response key 2
Setup.Response.Serial.Key3 = 3;					% Serial byte corresponding to response key 3
Setup.Response.Serial.Key4 = 4;					% Serial byte corresponding to response key 4
Setup.Response.Serial.Key5 = 5;					% Serial byte corresponding to response key 5
Setup.Response.Serial.Key6 = 6;					% Serial byte corresponding to response key 6
Setup.Response.Serial.Key7 = 7;					% Serial byte corresponding to response key 7
Setup.Response.Serial.Key8 = 8;					% Serial byte corresponding to response key 8
Setup.Response.Serial.Key9 = 9;					% Serial byte corresponding to response key 9
Setup.Response.Serial.Key10 = 10;				% Serial byte corresponding to response key 10

Setup.Response.Mouse.Key1 = 'Left';				% Mouse button corresponding to response key 1
Setup.Response.Mouse.Key2 = 'Right';			% Mouse button corresponding to response key 2
Setup.Response.Mouse.Key3 = 'Middle';			% Mouse button corresponding to response key 3
Setup.Response.Mouse.Key4 = '';					% Mouse button corresponding to response key 4
Setup.Response.Mouse.Key5 = '';					% Mouse button corresponding to response key 5
Setup.Response.Mouse.Key6 = '';					% Mouse button corresponding to response key 6
Setup.Response.Mouse.Key7 = '';					% Mouse button corresponding to response key 7
Setup.Response.Mouse.Key8 = '';					% Mouse button corresponding to response key 8
Setup.Response.Mouse.Key9 = '';					% Mouse button corresponding to response key 9
Setup.Response.Mouse.Key10 = '';				% Mouse button corresponding to response key 10

Setup.Response.Keyboard.Key1 = 'A';				% Keyboard key corresponding to response key 1
Setup.Response.Keyboard.Key2 = 'L';				% Keyboard key corresponding to response key 2
Setup.Response.Keyboard.Key3 = 'S';				% Keyboard key corresponding to response key 3
Setup.Response.Keyboard.Key4 = 'D';				% Keyboard key corresponding to response key 4
Setup.Response.Keyboard.Key5 = 'F';				% Keyboard key corresponding to response key 5
Setup.Response.Keyboard.Key6 = 'G';				% Keyboard key corresponding to response key 6
Setup.Response.Keyboard.Key7 = 'H';				% Keyboard key corresponding to response key 7
Setup.Response.Keyboard.Key8 = 'J';				% Keyboard key corresponding to response key 8
Setup.Response.Keyboard.Key9 = 'K';				% Keyboard key corresponding to response key 9
Setup.Response.Keyboard.Key10 = 'M';			% Keyboard key corresponding to response key 10

Setup.Response.XID.Port = 3;
Setup.Response.XID.Key1 = 1;
Setup.Response.XID.Key2 = 2;
Setup.Response.XID.Key3 = 3;
Setup.Response.XID.Key4 = 4;
Setup.Response.XID.Key5 = 5;
Setup.Response.XID.Key6 = 6;
Setup.Response.XID.Key7 = 7;
Setup.Response.XID.Key8 = 8;
Setup.Response.XID.Key9 = 21;
Setup.Response.XID.Key10 = 11;

Setup.Sync.UseSync = 0;							% Set to zero to ignore external slice acquisition signals
Setup.Sync.Port = 3;							% Serial port to be used for receiving sync timing signals
Setup.Sync.NumSlices = 20;						% Default number of slices
Setup.Sync.StartVolumes = 0;					% Default number of initial volumes to wait for before starting
Setup.Sync.TRslices = 65;						% Default time (msec) between slices
Setup.Sync.TRvolumes = 0;						% Default time (msec) between volumes
												% (should be >= NumSlices * TRslices, otherwise it
												% will be interpreted as the extra time (msec)
												% after the last slice of each volume

Setup.Examiner.StartKey = 'Space';				% Keyboard key used to start sessions and trials
Setup.Examiner.StopKey = 'Escape';				% Keyboard key used to stop the experiments

Setup.Trigger.UseUserPort = 0;
Setup.Trigger.Port = 0;
Setup.Trigger.Duration = 50;

Setup.Eye.Type = 'none';
Setup.Eye.Port = 2;
