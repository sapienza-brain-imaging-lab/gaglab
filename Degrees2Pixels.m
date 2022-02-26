function xy = Degrees2Pixels (xy)
% DEGREES2PIXELS		Convert degrees of visual angle to pixels
%
% PIX = DEGREES2PIXELS(DEG) converts coordinates in degrees of visual angle
% into coordinates in pixels.

ScreenMode = gaglabcmd('GetScreen');
xy = gaglab_vis_deg2real(xy, ScreenMode(9)) .* ScreenMode(3) ./ ScreenMode(10);


