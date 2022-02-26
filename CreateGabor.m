function [varargout] = CreateGabor (stimulusNumber, tiltInDegrees, degreesPerPeriod, periodsCoveredByOneStandardDeviation, widthOfGrid, phase, mult)
% CREATEGABOR            Create a Gabor Patch
%
% CREATEGABOR(STIMULUSNUMBER, TiltInDegrees, DegreesPerPeriod,
% periodsCoveredByOneStandardDeviation, widthOfGrid, phase, mult)
%
% TiltInDegrees = The tilt of the grating in degrees
% DegreesPerPeriod = How many degrees will each period/cycle occupy?
% PeriodsCoveredByOneStandardDeviation = the number of periods/cycles
% covered by one standard deviation of the radius of the gaussian mask
% WidthOfGrid = Dimension of the grating in degrees
% Phase = Phase of the grating in degrees
% Mult = Multiplication factor (1 = purely sinusoidal)

	% *** To rotate the grating, set tiltInDegrees to a new value.
	if nargin < 2
		tiltInDegrees = 0; % The tilt of the grating in degrees. ------ GRADI DI ORIENTAMENTO DEL GABOR
	end

	% *** To lengthen the period of the grating, increase pixelsPerPeriod.
	if nargin < 3
		degreesPerPeriod = 1;
	end
	pixelsPerPeriod = Degrees2Pixels(degreesPerPeriod); % How many pixels will each period/cycle occupy? (grandezza del Gabor, scala il gabor)

	% *** To enlarge the gaussian mask, increase periodsCoveredByOneStandardDeviation.
	% The parameter "periodsCoveredByOneStandardDeviation" is approximately equal to
	% the number of periods/cycles covered by one standard deviation of the radius of
	% the gaussian mask.
	if nargin < 4
		periodsCoveredByOneStandardDeviation = 1.5; %  controlla la grandedda del gabor
	end

	% *** If the grating is clipped on the sides, increase widthOfGrid.
	if nargin < 5
		widthOfGrid = 10;
	end
	widthOfGrid = Degrees2Pixels(widthOfGrid); % finestra  in cui compare il gabor

	if nargin < 6
		phase = 0;
	else
		phase = phase/180*pi;
	end
	if nargin < 7
		mult = 1;
	end

	gray = 0.5;
	absoluteDifferenceBetweenWhiteAndGray = 0.5;

	tiltInRadians = tiltInDegrees * pi / 180; % The tilt of the grating in radian
	spatialFrequency = 1 / pixelsPerPeriod; % How many periods/cycles are there in a pixel? (frequenza del Gabor)
	radiansPerPixel = spatialFrequency * (2 * pi); % = (periods per pixel) * (2 pi radians per period) (frequenza del Gabor)
	% The parameter "gaussianSpaceConstant" is approximately equal to the
	% number of pixels covered by one standard deviation of the radius of
	% the gaussian mask.
	gaussianSpaceConstant = periodsCoveredByOneStandardDeviation  * pixelsPerPeriod;
	halfWidthOfGrid = widthOfGrid / 2;
	widthArray = (-halfWidthOfGrid) : halfWidthOfGrid;  % widthArray is used in creating the meshgrid.

	% ---------- Gabor Setup ----------
	% Stores the image in a two dimensional matrix.

	% Creates a two-dimensional square grid.  For each element i = i(x0, y0) of
	% the grid, x = x(x0, y0) corresponds to the x-coordinate of element "i"
	% and y = y(x0, y0) corresponds to the y-coordinate of element "i"
	[x y] = meshgrid(widthArray, widthArray);

	% Replaced original method of changing the orientation of the grating
	% (gradient = y - tan(tiltInRadians) .* x) with sine and cosine (adapted from DriftDemo).
	% Use of tangent was breakable because it is undefined for theta near pi/2 and the period
	% of the grating changed with change in theta.

	a=cos(tiltInRadians)*radiansPerPixel;
	b=sin(tiltInRadians)*radiansPerPixel;

	% Converts meshgrid into a sinusoidal grating, where elements
	% along a line with angle theta have the same value and where the
	% period of the sinusoid is equal to "pixelsPerPeriod" pixels.
	% Note that each entry of gratingMatrix varies between minus one and
	% one; -1 <= gratingMatrix(x0, y0)  <= 1
	phaseMatrix   = a*x + b*y + phase;
	gratingMatrix = sin(phaseMatrix);

	gratingMatrix = gratingMatrix .* mult;
	gratingMatrix(gratingMatrix < -1) = -1;
	gratingMatrix(gratingMatrix > 1)  = 1;

	% Creates a circular Gaussian mask centered at the origin, where the number
	% of pixels covered by one standard deviation of the radius is
	% approximately equal to "gaussianSpaceConstant."
	% For more information on circular and elliptical Gaussian distributions, please see
	% http://mathworld.wolfram.com/GaussianFunction.html
	% Note that since each entry of circularGaussianMaskMatrix is "e"
	% raised to a negative exponent, each entry of
	% circularGaussianMaskMatrix is one over "e" raised to a positive
	% exponent, which is always between zero and one;
	% 0 < circularGaussianMaskMatrix(x0, y0) <= 1
	circularGaussianMaskMatrix = exp(-((x .^ 2) + (y .^ 2)) / (gaussianSpaceConstant ^ 2));

	% Since each entry of gratingMatrix varies between minus one and one and each entry of
	% circularGaussianMaskMatrix vary between zero and one, each entry of
	% imageMatrix varies between minus one and one.
	% -1 <= imageMatrix(x0, y0) <= 1
	imageMatrix = gratingMatrix .* circularGaussianMaskMatrix;

	% Since each entry of imageMatrix is a fraction between minus one and
	% one, multiplying imageMatrix by absoluteDifferenceBetweenWhiteAndGray
	% and adding the gray CLUT color code baseline
	% converts each entry of imageMatrix into a shade of gray:
	% if an entry of "m" is minus one, then the corresponding pixel is black;
	% if an entry of "m" is zero, then the corresponding pixel is gray;
	% if an entry of "m" is one, then the corresponding pixel is white.
	grayscaleImageMatrix = gray + absoluteDifferenceBetweenWhiteAndGray * imageMatrix;
	
	switch nargout
		case 0
			try %#ok<TRYNC>
				StimulusSize(stimulusNumber, [widthOfGrid, widthOfGrid], 'pixels');
			end
			DrawImage(stimulusNumber, repmat(uint8(grayscaleImageMatrix * 255), [1, 1, 3]));
		case 1
			varargout = {grayscaleImageMatrix};
		otherwise
			varargout = {grayscaleImageMatrix, phaseMatrix};
	end
end