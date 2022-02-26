function CopyStimulus (varargin)
% COPYSTIMULUS	Copy a stimulus
%
% COPYSTIMULUS(ID1, ID2) copies the stimulus ID1 to the centre of the
% area occupied by stimulus ID2.
% COPYSTIMULUS(ID1, ID2, [X Y]) copies the stimulus to the
% place specified, in the units of the offscreen area. The given
% coordinates always refer to the center of the stimulus.
% COPYSTIMULUS(ID1, ID2, [X1 Y1 X2 Y2], [X Y]) copies only the rectangle
% specified by [X1 Y1 X2 Y2] of stimulus ID2 onto stimulus ID2.

gaglabcmd('CopyStimulus', varargin{:});
