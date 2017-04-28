function SyncSetup = gaglab_sync_start (SyncSetup)
% GAGLAB_SYNC_START		Initialize communication with the scanner

if SyncSetup.TRvolumes - SyncSetup.TRslices * SyncSetup.NumSlices < -1e-05
	SyncSetup.TRvolumes = SyncSetup.TRvolumes + SyncSetup.TRslices * SyncSetup.NumSlices;
end

SyncSetup.HPort = 0;
if SyncSetup.Port == 0, SyncSetup.UseSync = 0; end
if SyncSetup.UseSync == 0, return; end

if ~isfield(SyncSetup, 'Mode')
	SyncSetup.Mode = 'allegra';
end

try
	SyncSetup.HPort = CogSerial('open', sprintf('com%d', SyncSetup.Port));
	switch SyncSetup.Mode
		case 'allegra'
			attr.Baud = 9600;
		case 'achieva'
			attr.Baud = 57600;
	end
	attr.Parity = 0;
	attr.StopBits = 0;
	attr.ByteSize = 8;
	CogSerial('setattr', SyncSetup.HPort, attr);
    CogSerial('record', SyncSetup.HPort, 100000);
	SyncSetup.UseSync = 1;
catch
	fprintf('Serial port not available for connection to the scanner: using internal timer\n');
	SyncSetup.HPort = 0;
	SyncSetup.UseSync = 0;
end
