function gaglab_sync_stop (SyncSetup)

if SyncSetup.HPort
	CogSerial('close', SyncSetup.HPort);
end
