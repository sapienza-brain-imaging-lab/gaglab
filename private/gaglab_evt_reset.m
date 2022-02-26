function E = gaglab_evt_reset
% GAGLAB_EVT_RESET		Reset experiment events

% Reset events
E.StopKey = [];
E.Key = [];
E.Response = struct('T0', {}, 'MaxT', {}, 'ValidKeys', {}, 'CorrectKey', {}, 'Key', {}, 'RT', {}, 'Correct', {});
E.Slice = [];
E.SliceBuf = [];
E.Log = [];
E.IKey = 1;
E.StartTime = mod(datevec(now),100);
