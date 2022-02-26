function LoadSound (id, file)
% LOADSOUND    	Prepare a sound from a sound file to be played
%
% LOADSOUND(ID, FNAME) loads the sound from the sound file FNAME to
% sound stimulus ID.

gaglabcmd('preparesound', id, file);
