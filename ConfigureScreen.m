function ConfigureScreen (varargin)
% CONFIGURESCREEN		Specify explicit screen configuration
%
% CONFIGURESCREEN allows the experiment author to explicitly
% specify the resolution and refresh rate of the screen.
% CONFIGURESCREEN(PIXELS) sets the screen resolution by specifying the
% number of horizontal pixels. Valid values for PIXELS are: 640, 768, 1024,
% 1152, 1280, or 1600.
% CONFIGURESCREEN(HZ) sets the screen refresh rate in Hz. Valid values
% for HZ are: 60, 70, 72, 75, 85, 90, 100, or 120.
% CONFIGURESCREEN(PIXELS, HZ) sets both the screen resolution and the
% refresh rate.
% Note that your experiment will run only if the current system supports
% the modality you are specifying.

gaglabcmd('SetScreen', varargin{:});
