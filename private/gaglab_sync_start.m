function SyncSetup = gaglab_sync_start (SyncSetup)
% GAGLAB_SYNC_START		Initialize communication with the scanner

if SyncSetup.TRvolumes - SyncSetup.TRslices * SyncSetup.NumSlices < -1e-05
	SyncSetup.TRvolumes = SyncSetup.TRvolumes + SyncSetup.TRslices * SyncSetup.NumSlices;
end

SyncSetup.HPort = 0;
if SyncSetup.Port == 0, SyncSetup.UseSync = 0; end
if SyncSetup.UseSync == 0, return; end
try
	SyncSetup.HPort = CogSerial('open', sprintf('com%d', SyncSetup.Port));
	attr.Baud = 9600;
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
