function gaglab_resp_stop (R)

CogInput('shutdown');
if strcmpi(R.Device, 'serial')
	CogSerial('close', R.Serial.HPort);
elseif strcmpi(R.Device, 'xid')
	gaglab_xid('clear');
end
