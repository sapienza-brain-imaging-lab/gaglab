function WhiteNoise(id, duration, frequency, varargin)
% WHITENOISE     Prepare a sound stimulus containing white noise
%
% WHITENOISE(ID, DURATION) creates a sound stimulus ID containing
% white noise for DURATION msec.
% WHITENOISE(ID, DURATION, FREQUENCY) allows to specify
% sound frequency (Hz).

if nargin < 3, frequency = 11025; end
n = floor(frequency * duration / 1000 ); 
matrix = 2*rand(n,1) - 1; 

gaglabcmd('preparesound', id, matrix, frequency, varargin{:});
