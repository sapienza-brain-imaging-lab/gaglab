function xy = gaglab_vis_convert2pixels (Screen, units, varargin)

xy = [0 0];
if nargin > 2
	switch units
		case 'a'
			units = Screen.Units;
	end
	switch units
		case 'd'
			xy = gaglab_vis_deg2real(varargin{1}, Screen.DistanceMm) .* Screen.Pixels(1) ./ Screen.WidthMm;
		case 'm'
			xy = varargin{1} .* Screen.Mm2Pix;
		case 'p'
			xy = varargin{1};
	end
end
