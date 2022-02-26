function StartExperiment
% STARTEXPERIMENT         Start an experiment
%
% STARTEXPERIMENT initialises GagLab to run an experiment. This includes
% configuring the display, the sound system, the keyboard, the mouse, and
% the serial port, in the way specified by the current GagLab
% configuration. STARTEXPERIMENT will then raise the priority to high,
% will wait for an external slice pulse, or for the examiner to press the
% Start key, and will then reset the time counter.
%
% When used inside an experiment that is already running, STARTEXPERIMENT
% will suspend the experiment, save the results and log, and then start a
% new session by waiting for the start signal and resetting the time
% counter.

gaglabcmd('Start');
gaglabcmd('ShowLog');