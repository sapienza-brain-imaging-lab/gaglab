function SoundVolume(id, volume)
% SOUNDVOLUME     Set the volume of a sound
%
% SOUNDVOLUME(ID, VOLUME) sets the volume of sound ID
% in hundreths of decibels (0 to -10000)

gaglabcmd('setsound', id, 'volume', volume);
