function PureTone(id, duration, frequency, varargin)
% PURETONE     Prepare a sound stimulus containing white noise
%
% PURETONE(ID, DURATION, FREQUENCY) creates a sound stimulus ID
% containing a sine wave of the specified duration (msec) and frequency (Hz).

basefreq = 44100;
x = 1:floor(basefreq * duration / 1000 );
matrix = sin(2*pi*frequency*x/basefreq);

gaglabcmd('preparesound', id, matrix', basefreq, varargin{:});
