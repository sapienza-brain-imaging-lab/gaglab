function MyExperiment

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PHASE 1: SET VALUES FOR EXPERIMENT SETTINGS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% If you use visual stimuli, you may want to set screen properties.
% If you don't, you will use a default screen resolution, with the maximum
% number of colors available and the fastest refresh rate. If you use
% degree units (default) or mm units to draw stimuli, you should not care
% about the exact screen properties you get and go with the defaults.

% ConfigureScreen(1024);		% Use this if you want to obtain a specific resolution
% ConfigureScreen(85);			% Use this if you want to obtain a specific refresh rate
% ConfigureScreen(1024,85);		% Use this if you want to obtain both

% UsePixels;					% Use this to specify coordinates in pixels
% UseMillimeters;				% Use this to specify coordinates in millimeters
% UseDegrees;					% Use this to specify coordinates in degrees (default)
% TransparentColor([1 1 1]);	% Use this to specify a default transparent color
% BackgroundColor([1 1 1]);		% Use this to specify a background color other than black
% PenColor([0 0 0]);			% Use this to specify a default pen color other than white

% RecordMousePosition;			% Use this if you want to use the mouse position
% DontUseSync;					% Use this to ignore scanner signals even if they are available

% You should set the number of slices, TR, etc.
AcquisitionParameters(20, 3, 65, 0);
% Set 20 slices, throw away first 3 volumes.
% TR between slices is 65 msec, with 0 msec added at the end of the volume.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PHASE 2: PREPARE AND LOAD STIMULI
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% It is now time to draw visual stimuli, load images and sounds.
% Prepare the starting visual screen into the backbuffer.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PHASE 3: MAKE YOUR EXPERIMENT RUN
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Now you are ready to start your experiment: the experiment will start
% when the first slice is read in, or the examiner presses the Start key
% (depending on the configuration).
% The time counter is reset as soon as the experiment starts, so time 0 is
% the experiment start time.
StartExperiment

% Then you should make your experiment run.
% This is obviously the hard part.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% END OF EXPERIMENT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% There is no need for extra code at the end of the experiment. If you
% wish, you can RETURN from this function at any time, and this will abort
% the experiment, and will save results (if any).
