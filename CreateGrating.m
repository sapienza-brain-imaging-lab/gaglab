function [varargout] = CreateGrating (stimulusNumber, tiltInDegrees, degreesPerPeriod, periodsCoveredByOneStandardDeviation, widthOfGrid, phase, mult)
% CREATEGRATING            Create a grating
%
% CREATEGRATING(STIMULUSNUMBER, TiltInDegrees, DegreesPerPeriod,
% periodsCoveredByOneStandardDeviation, widthOfGrid, phase, mult)
%
% TiltInDegrees = The tilt of the grating in degrees
% DegreesPerPeriod = How many degrees will each period/cycle occupy?
% PeriodsCoveredByOneStandardDeviation = the number of periods/cycles
% covered by one standard deviation of the radius of the gaussian mask
% WidthOfGrid = Dimension of the grating in degrees
% Phase = Phase of the grating in degrees
% Mult = Multiplication factor (1 = purely sinusoidal)

if nargin < 2
	tiltInDegrees = 0;
end
if nargin < 3
	degreesPerPeriod = 1;
end
if nargin < 4
	periodsCoveredByOneStandardDeviation = 1.5; %  controlla la grandedda del gabor
end
if nargin < 5
	widthOfGrid = 10;
end
if nargin < 6
	phase = 0;
end
if nargin < 7
	mult = 1;
end

X = CreateGabor(stimulusNumber, tiltInDegrees     , degreesPerPeriod, periodsCoveredByOneStandardDeviation, widthOfGrid, phase, mult);
Y = CreateGabor(stimulusNumber, tiltInDegrees + 90, degreesPerPeriod, periodsCoveredByOneStandardDeviation, widthOfGrid,     0, mult);
X = (X + Y) ./ 2;

if nargout
	varargout = {X};
else
	try %#ok<TRYNC>
		StimulusSize(stimulusNumber, [size(X,1), size(X,2)], 'pixels');
	end
	DrawImage(stimulusNumber, repmat(uint8(X * 255), [1, 1, 3]));
end
