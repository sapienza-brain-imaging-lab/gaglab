function t = trigger (id)
% TRIGGER	Create a trigger object
%
% T = TRIGGER(B) create a trigger object which sends a signal on bits B of
% the parallel port. The trigger object can be used in a PRESENT command.
% B should be a vector of bit numbers (from 0 to 15). The duration of the
% signal is constant and can be defined in the setup script by setting the
% variable Setup.Trigger.Duration (in msec).
%
% The TRIGGER command is useful to send synchronization signals to external
% devices. If you rather want to control LEDs or other stimulation devices
% which should be activated and deactivated at user-specified times, use
% the SENDDATA command instead.

if nargin < 1, id = 0; end
j = find(id < 0 & id > 15);
if length(j)
	error('Bit numbers must be in the range 0-15');
end
t = struct('type', 'E', 'what', id(:)');
