function StimulusSize (varargin)
% STIMULUSSIZE	Set a stimulus size
%
% Stimuli are automatically based on their contents. However, you can set
% an explicit size to obtain a particular effect.
% STIMULUSSIZE(ID, [X Y], UNITS) makes the stimulus ID X units wide and Y units
% tall, where UNITS may be 'degrees', 'mm', or 'pixels'.
% STIMULUSSIZE(ID, 'SCREEN') makes the stimulus ID as big as the screen.
% STIMULUSSIZE(ID, 'AUTO') restores the default based on the stimulus content.

gaglabcmd('ResizeStimulus', varargin{:});
