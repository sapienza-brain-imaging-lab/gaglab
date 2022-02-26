function [t, Trigger] = gaglab_trigger_send (Trigger, value)

if isempty(value)
	t = [];
	return;
end

send_data_to_port(Trigger, value(1,:));

t = gaglab_exp_time;

if size(value,1) > 1
	while gaglab_exp_time < t + Trigger.duration, end;
	send_data_to_port(Trigger, value(2,:));
end

Trigger.data = value(end,:);



function send_data_to_port (Trigger, value)

switch Trigger.userport
	case 1
		outportb(Trigger.port(1), 2.^[0:7] * value(1:8)');
		if length(Trigger.port) > 1
			outportb(Trigger.port(2), 2.^[0:7] * value(9:16)');
		end
	case 0
		putvalue(Trigger.dio, 2.^[0:7] * value(1:8)');
	case 2
		ActiveWire(Trigger.port, 'SetPort', value);
end
