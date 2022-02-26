function CreateStimulus (varargin)
% CREATESTIMULUS	Create an empty stimulus
%
% Stimuli are automatically created when drawing into them. However, you can
% explicitly create an empty stimulus with CREATESTIMULUS.
% CREATESTIMULUS(ID, [X Y], UNITS) creates the stimulus ID X units wide and Y units
% tall, where UNITS may be 'degrees', 'mm', or 'pixels'.
% STIMULUSSIZE(ID, 'SCREEN') creates a stimulus as big as the screen.
% STIMULUSSIZE(ID, 'AUTO') creates a stimulus whose size is automatically
% determined based on the stimulus content.

gaglabcmd('CreateStimulus', varargin{:});
