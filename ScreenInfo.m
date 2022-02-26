function [varargout] = ScreenInfo
% SCREENINFO		Obtain information on screen configuration
%
% [WIDTH, HEIGHT, HZ, COLORS] = SCREENINFO returns information on the
% configuration of the screen used to present visual stimuli. WIDTH and
% HEIGHT represent the numbers of pixels in the two dimensions, HZ the
% screen refresh rate in HZ, and COLORS the number of bits per pixel.

ScreenMode = gaglabcmd('GetScreen');
if nargout > 0, varargout{1} = ScreenMode(3); end
if nargout > 1, varargout{2} = ScreenMode(4); end
if nargout > 2, varargout{3} = ScreenMode(6); end
if nargout > 3, varargout{4} = ScreenMode(7); end