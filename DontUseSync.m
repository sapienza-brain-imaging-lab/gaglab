function DontUseSync
% DONTUSESYNC	Use if you want to ignore scanner sync signals

gaglabcmd('Set', 'Sync', 'UseSync', 0);
