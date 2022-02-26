function T = gaglab_trigger_init (Setup)

T = [];
if Setup.Port
	switch Setup.UseUserPort
		case 1   % UseUserPort = 1 means PARALLEL PORT USING USERPORT/OUTPORTB
			try
				for i=1:length(Setup.Port)
					%startportb(Setup.Port(i), 0);
					outportb(Setup.Port(i), 0);
				end
				T.port = Setup.Port;
			catch
				disp('Cannot use parallel ports: UserPort not installed');
			end
			
		case 0   % UseUserPort = 0 means PARALLEL PORT USING MATLAB DATA ACQUISITION TOOLBOX
			if isempty(which('digitalio'))
				disp('Cannot use parallel ports: Data Acquisition Toolbox not installed');
				T = [];
			else
				try
					T.dio = digitalio('parallel', Setup.Port);
					T.line = addline(T.dio, [0:7], 'out');
					putvalue(T.dio, 0);
				catch
					disp('Cannot use parallel port:')
					disp(lasterr);
					T = [];
				end
			end
			
		case 2   % UseUserPort = 2 means ACTIVEWIRE USB DEVICE
			try
				ActiveWire(Setup.Port, 'OpenDevice');
				ActiveWire(Setup.Port, 'SetDirection', ones(1,16));
				ActiveWire(Setup.Port, 'SetPort', zeros(1,16));
				T.port = Setup.Port;
			catch
				disp('Cannot use ActiveWire device:');
				disp(lasterr);
				T = [];
			end
			
		otherwise
			error('Invalid value for setup flag USEUSERPORT.');
	end

	if length(T)
		T.userport = Setup.UseUserPort;
		T.duration = Setup.Duration;
		T.data = zeros(1,16);
	end
end

