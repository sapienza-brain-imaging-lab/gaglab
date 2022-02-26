function Events = gaglab_sync_update (Events, SyncSetup, xidsync)
% GAGLAB_SYNC_UPDATE         Read and store pending sync pulses from the scanner
%
% B = GAGLAB_SYNC_UPDATE(B, S) read data from the serial port S and interprets
% them in terms of sync pulses from the scanner, storing the appropriate
% volume/slice information into the buffer B, together with their timestamps.

% Get sync pulses
if SyncSetup.HPort
	[c, t] = CogSerial('GetEvents', SyncSetup.HPort);
	if isempty(c), return; end
	Events.SliceBuf = [Events.SliceBuf; c, t];

	% If I have at least 2 new bytes since last time I looked at the
	% buffer, I will now interpret buffer data as slices
	while size(Events.SliceBuf,1) >= 2
		dt = Events.SliceBuf(2,2) - Events.SliceBuf(1,2);
		% If the two bytes are spaced more than 10 msec, there is some
		% problem (may be a missing byte), so discard the first one and go on
		if dt > 0.01
			Events.SliceBuf(1,:) = [];
		else	% convert byte pairs into slice numbers
			c = Events.SliceBuf(1,1)*256 + Events.SliceBuf(2,1);
			t = gaglab_exp_time(Events.SliceBuf(1,2));
			Events.SliceBuf(1:2,:) = [];
			Events.Slice = [Events.Slice; [c, t]];
			[v, s] = gaglab_sync_index2slice(SyncSetup, c);
			Events.Log = gaglab_exp_log(Events.Log, 'S', t, v, s);
		end
	end
end
