function ClearStimulus (id, varargin)
% CLEARSTIMULUS	Clear a stimulus
%
% CLEARSTIMULUS(ID) clears the stimulus ID. CLEARSTIMULUS(ID, [R G B])
% clears stimulus ID to the color specified by [R G B].

gaglabcmd('Clear', id, varargin{:});
