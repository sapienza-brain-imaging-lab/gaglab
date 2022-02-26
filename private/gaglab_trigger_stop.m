function gaglab_trigger_stop (Trigger)

if isempty(Trigger), return; end
switch Trigger.userport
	case 1
		for i=1:length(Trigger.port)
			outportb(Trigger.port(i), 0);
		end
	case 0
		putvalue(Trigger.dio, 0);
	case 2
		ActiveWire(Trigger.port, 'SetPort', zeros(1,16));
		ActiveWire('CloseAll');
end
